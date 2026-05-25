import SwiftUI

struct Drawing: View {
    //For adding drawn objects to objectList
    let objectSize : Double
    @Environment(\.modelContext) var context
    @State private var tempPointList : [CustomCGPoint] = []
    
    //Vars determining when these views are active/when user is drawing
    @Binding var isSimpleDraw : Bool
    @Binding var isDrawing : Bool
    
    var body: some View {
        if (isDrawing) {
            //Covers screen in a transparent gray rectangle where user can draw
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundStyle(.gray)
                .opacity(0.5)
                .gesture(
                    DragGesture()
                        .onChanged({ gest in
                            tempPointList.append(CustomCGPoint(xVal: gest.location.x, yVal: gest.location.y))
                        })
                        .onEnded({ gest in
                            context.insert(Object(x: 0, y: 0, size: objectSize, isOutline: isSimpleDraw, pointList: tempPointList))
                            tempPointList.removeAll()
                            isDrawing = false
                            isSimpleDraw = false
                        })
                )
            
            //Previews for user what the drawing will look like as they draw
            if(!tempPointList.isEmpty) {
                //Outline of dots for Simple Draw
                if(isSimpleDraw){
                    ForEach(tempPointList, id: \.self) { point in
                        Circle()
                            .frame(width: objectSize/5, height: objectSize/5)
                            .position(point.toCGPoint())
                    }
                }
                
                //Organic shape made from connecting shapes for regular draw
                else{
                    Path { path in
                        let first = tempPointList.first
                        path.move(to: first!.toCGPoint())
                        for point in tempPointList.dropFirst() {
                            path.addLine(to: point.toCGPoint())
                        }
                    }
                }
            }
        }
    }
}

//Allows user to draw many Simple Draws which disappear after user is done drawing
struct TempDrawing: View {
    let objectSize : Double
    @State private var tempPathList : [[CustomCGPoint]] = []
    @State private var tempPointList : [CustomCGPoint] = []
    @Binding var tempDrawOn : Bool
    var body: some View {
        if (tempDrawOn) {
            //Covers screen in a transparent gray rectangle where user can draw
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundStyle(.gray)
                .opacity(0.5)
                .gesture(
                    DragGesture()
                        .onChanged({ gest in
                            tempPointList.append(CustomCGPoint(xVal: gest.location.x, yVal: gest.location.y))
                        })
                        .onEnded({ gest in
                            let points = tempPointList
                            tempPathList.append(points)
                            tempPointList.removeAll()
                        })
                )
                //Exits TempDraw when user double taps
                .onTapGesture(count: 2, perform: {
                    tempPathList.removeAll()
                    tempPointList.removeAll()
                    tempDrawOn = false
                })
            
            //Builds the Simple Draws
            ForEach(tempPathList, id: \.self) { pointList in
                if(!pointList.isEmpty) {
                    Path { path in
                        let first = pointList.first
                        path.move(to: first!.toCGPoint())
                        for point in pointList.dropFirst() {
                            path.addLine(to: point.toCGPoint())
                        }
                    }
                    .stroke(lineWidth: objectSize/5)
                }
            }
            
            //Previews for user what the drawing will look like as they draw
            if(!tempPointList.isEmpty) {
                ForEach(tempPointList, id: \.self) { point in
                    Circle()
                        .frame(width: objectSize/10, height: objectSize/10)
                        .position(point.toCGPoint())
                }
            }
        }
    }
}
