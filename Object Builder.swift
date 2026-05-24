import SwiftUI

struct ObjectBuilder: View {
    let object : Object
    @Binding var type : String
    private var objectPath: Path {
        Path { path in
            guard let first = object.points.first else { return }

            path.move(to: first.toCGPoint())

            for point in object.points.dropFirst() {
                path.addLine(to: point.toCGPoint())
            }
        }
    }
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
            if(object.isSimpleDraw){
                objectPath
                    .stroke(lineWidth: object.size/5)
                    .modifier(pathDragGest(object: object))
                    .modifier(pathHaveColorPicker(object: object))
                    .modifier(pathObjectDelete(object: object))
            }
            else {
                objectPath
                    .modifier(pathDragGest(object: object))
                    .modifier(pathHaveColorPicker(object: object))
                    .modifier(pathObjectDelete(object: object))
            }
        }
    }
}
