import SwiftUI

struct ObjectBuilder: View {
    let mapSize : Double

    //Object being built
    let object : Object
    
    //Name of the object if it is a photo object
    @Binding var type : String
    
    //Computed variable if it is a drawn object
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
        //Regular circle object
        if(object.isCircle) {
            Circle()
                .modifier(frameAndPosition(object: object))
                .modifier(haveColorPicker(object: object))
                .modifier(objectDelete(object: object))
                .modifier(dragGest(object: object))
        }
        
        //Image object
        else if(object.points.isEmpty){
            if let data = object.image, let image = UIImage(data: data) {
                Image(uiImage: image)
                    .resizable()
                    //Is circular if object size is under 400. Becomes rectangular, for use as a mini-map, if size is above 400
                    .clipShape(object.size < 400 ? RoundedRectangle(cornerRadius: object.size) : RoundedRectangle(cornerRadius: 0))
                    .overlay(content: {
                        //If object is small, the object's color affects a circle overlaid on top
                        if(object.size < 400) {
                            Circle()
                                .modifier(haveColorPicker(object: object))
                                .frame(width: object.size * 1.1, height: object.size * 1.1)
                        }
                    })
                    //If object is small, it has a border
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
        
        //Drawn object
        else{
            Group {
                if(object.isSimpleDraw) {
                    objectPath.stroke(lineWidth: object.size / 5)
                } else {
                    objectPath
                }
            }
            .modifier(pathDragGest(object: object))
            .modifier(pathHaveColorPicker(object: object, mapSize: mapSize))
            .modifier(pathObjectDelete(object: object))
        }
    }
}
