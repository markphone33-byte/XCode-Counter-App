import SwiftUI

struct ObjectBuilder: View {
    @State var object : Object
    @Binding var type : String
    var body: some View {
        if(object.isCircle) {
            Circle()
                .modifier(frameAndPosition(object: object))
                .modifier(haveColorPicker(object: object))
                .modifier(objectDelete(object: object))
                .modifier(dragGest(object: object))
            
        }
        else if(object.points.isEmpty){
            if let data = object.image, let image = UIImage(data: data) {
                Image(uiImage: image)
                    .resizable()
                    .clipShape(object.size < 400 ? RoundedRectangle(cornerRadius: object.size) : RoundedRectangle(cornerRadius: 0))
                    .overlay(content: { 
                        if(object.size < 400) {
                            Circle()
                                .modifier(haveColorPicker(object: object))
                                .frame(width: object.size * 1.1, height: object.size * 1.1)
                        }
                    })
                    .background{
                        if(object.size < 400) {
                            Circle()
                                .frame(width: object.size * 1.1, height: object.size * 1.1)
                        }
                    }
                    .modifier(frameAndPosition(object: object))
                    .modifier(objectDelete(object: object))
                    .modifier(PhotoCopyButton(object: object, type: type))
                    .modifier(dragGest(object: object))
            }
        }
        else{
            if(!object.isSimpleDraw){
                Path { path in
                    let first = object.points.first
                    path.move(to: first!.toCGPoint())
                    for point in object.points.dropFirst() {
                        path.addLine(to: point.toCGPoint())
                    }
                }
                .modifier(pathDragGest(object: object))
                .modifier(pathHaveColorPicker(object: object))
                .modifier(pathObjectDelete(object: object))
            }
            else {
                Path { path in
                    let first = object.points.first
                    path.move(to: first!.toCGPoint())
                    for point in object.points.dropFirst() {
                        path.addLine(to: point.toCGPoint())
                    }
                }
                .stroke(lineWidth: object.size/5)
                .modifier(pathDragGest(object: object))
                .modifier(pathHaveColorPicker(object: object))
                .modifier(pathObjectDelete(object: object))
            }
        }
    }
}
