import SwiftUI

struct Drawing: View {
    @Binding var objectSize : Double
    @Binding var isSimpleDraw : Bool
    @Binding var isDrawing : Bool
    @Environment(\.modelContext) var context
    @State var tempPointList : [CustomCGPoint] = []
    var body: some View {
        if (isDrawing) {
            Rectangle()
                .frame(width: .infinity, height: .infinity)
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
            if(!tempPointList.isEmpty) {
                if(isSimpleDraw){
                    ForEach(tempPointList, id: \.self) { point in
                        Circle()
                            .frame(width: objectSize/5, height: objectSize/5)
                            .position(point.toCGPoint())
                    }
                }
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

struct TempDrawing: View {
    @Binding var objectSize : Double
    @Binding var tempDrawOn : Bool
    @State var tempPathList : [[CustomCGPoint]] = []
    @State var tempPointList : [CustomCGPoint] = []
    var body: some View {
        if (tempDrawOn) {
            Rectangle()
                .frame(width: .infinity, height: .infinity)
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
                .onTapGesture(count: 2, perform: {
                    tempPathList.removeAll()
                    tempPointList.removeAll()
                    tempDrawOn = false
                })
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
