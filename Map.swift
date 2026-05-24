import SwiftUI
import SwiftData
import PhotosUI

struct Map: View {
    @Environment(\.modelContext) var context
    @Query var objectList : [Object]
    @AppStorage("offsetWidth") var offsetWidth : Double = 0.0
    @AppStorage("offsetHeight") var offsetHeight : Double = 0.0
    @State var dragOffset : CGSize = .zero
    @State var size = 50000.0
    @State var item : PhotosPickerItem? = nil
    @AppStorage("scale") var scale : Double = 1.0
    @AppStorage("lastScale") var lastScale : Double = 1.0
    @State var objectSize = 100.0
    @State var isDrawing = false
    @State var objectType = ""
    @AppStorage("showObjectDelete") var showObjectDelete : Bool = true
    @AppStorage("showColorPicker") var showColorPicker : Bool = true
    @AppStorage("bottomBarSize") var bottomBarSize = 400.0
    @AppStorage("showWheel") var showWheel = false
    @State var isSimpleDraw = false
    @AppStorage("showCopyButton") var showCopyButton : Bool = true
    @State var tempDrawOn = false
    private var sortedObjects: [Object] {
        objectList.sorted { o1, o2 in
            if(o1.order != o2.order) {
                return o1.order < o2.order
            }
            if(o1.size >= 1000) {
                return o1.size > o2.size
            }
            return o1.points.isEmpty && !o2.points.isEmpty
        }
    }
    var body: some View {
        ZStack {
            RadialGradient(gradient: Gradient(colors: [.gray, .green, .orange, .red]), center: .center, startRadius: 0, endRadius: size/1.4)
                .overlay{
                    ForEach(sortedObjects) { object in
                        ObjectBuilder(object: object, type: $objectType)
                    }
                    Drawing(objectSize: $objectSize, isSimpleDraw: $isSimpleDraw, isDrawing: $isDrawing)
                    TempDrawing(objectSize: $objectSize, tempDrawOn: $tempDrawOn)
                }
                .modifier(screenDragGest(offsetWidth: $offsetWidth, offsetHeight: $offsetHeight, dragOffset: $dragOffset, size: size))
                .modifier(zoomGest(scale: scale, lastScale: lastScale))
            
            VStack{
                Spacer()
                Wheel()
                    .opacity(showWheel ? 1 : 0)
                    .offset(y: 50)
                Gauge(value: bottomBarSize, in: 300...1000, label: {
                })
                .overlay {
                    Slider(value: $bottomBarSize, in: 300...1000)
                        .scaleEffect(x: 1, y: 0.8)
                }
                .frame(width: 300, height: 0)
                .tint(.orange)
                
                
                BottomBar(objectSize: $objectSize, isDrawing: $isDrawing, objectType: $objectType, isSimpleDraw: $isSimpleDraw, tempDrawOn: $tempDrawOn)                            
                //End of Horiztonal ScrollView
            }
            .frame(width: bottomBarSize, height: 650)
            //End of Bottom Bar
        }
    }
}
