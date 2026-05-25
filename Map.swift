import SwiftUI
import SwiftData
import PhotosUI

struct Map: View {
    @State private var mapSize : Double = 50000

    //Used to make photo objects
    @State private var item : PhotosPickerItem? = nil
    
    //User-controlled values
    @AppStorage("showWheel") var showWheel = false
    @State private var objectSize = 100.0
    @State private var objectType = ""
    
    //Vars determining if user is drawing and which type of drawing
    @State private var tempDrawOn = false
    @State private var isSimpleDraw = false
    @State private var isDrawing = false
    
    //Computed variable which sorts objects based on order value then size then non-drawing objects then drawn objects
    @Environment(\.modelContext) var context
    @Query var objectList : [Object]
    private var sortedObjects: [Object] {
        objectList.sorted { o1, o2 in
            if(o1.order != o2.order) {
                return o1.order < o2.order
            }
            else if(o1.size >= 1000) {
                return o1.size > o2.size
            }
            return o1.points.isEmpty && !o2.points.isEmpty
        }
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                //Background
                Rectangle()
                    .foregroundStyle(Color(red: 0.3, green: 0.5, blue: 0.8))
                    .overlay {
                        //Building objects then drawing modes
                        ForEach(sortedObjects) { object in
                            ObjectBuilder(mapSize: mapSize, object: object, type: $objectType)
                        }
                        Drawing(objectSize: objectSize, isSimpleDraw: $isSimpleDraw, isDrawing: $isDrawing)
                        TempDrawing(objectSize: objectSize, tempDrawOn: $tempDrawOn)
                    }
                    .modifier(screenDragGest(mapSize: mapSize))
                    .modifier(zoomGest())
                    .position(x: geo.size.width / 2, y: geo.size.height / 2)
                
                VStack {
                    Wheel()
                        .opacity(showWheel ? 1 : 0)
                        .offset(y: geo.size.height * 0.15)
                    
                    BottomBar(objectSize: $objectSize, isDrawing: $isDrawing, objectType: $objectType, isSimpleDraw: $isSimpleDraw, tempDrawOn: $tempDrawOn)
                    //End of Horiztonal ScrollView
                }
                .frame(width: geo.size.width * 0.9, height: geo.size.height)
                .position(x: geo.size.width * 0.5, y: geo.size.height * 0.5)
                //End of Bottom Bar
            }
        }
    }
}
