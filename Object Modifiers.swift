import SwiftUI
import SwiftData

//Used for non-drawn objects. Adds a trash can button that deletes the object and a button which toggles draggability
struct objectDelete: ViewModifier {
    @Environment(\.modelContext) var context
    @Query var objectList : [Object]
    let object : Object
    @AppStorage("showObjectDelete") var showMod : Bool = true
    func body(content: Content) -> some View {
        content
            .overlay{
                //Delete Button
                if(showMod && object.draggable) {
                    Button(action: {
                        context.delete(object)
                        try? context.save()
                    }, label: {
                        Image(systemName: "trash.fill")
                            .resizable()
                            .frame(width: object.size * 0.33, height: object.size * 0.33)
                    })
                    .position(x: object.posX, y: object.posY)
                }
                
                //Drag Toggle Button
                if(showMod){
                    Button(action: {
                        object.draggable.toggle()
                        try? context.save()
                    }, label: {
                        Text("Toggle Drag")
                            .font(.system(size: object.size * 0.08, weight: .bold))
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .foregroundStyle(.white)
                                    .frame(width: object.size * 0.55, height: object.size * 0.15)

                            )
                    })
                    .position(CGPoint(x: object.posX, y: object.posY + object.size * 0.4))
                }
            }
    }
}

//Used for non-drawn objects. Allows drag movement
struct dragGest: ViewModifier {
    let object: Object
    @State private var dragStartX = 0.0
    @State private var dragStartY = 0.0
    func body(content: Content) -> some View {
        content
            .offset(x: object.offsetX, y: object.offsetY)
            .gesture(object.draggable ? DragGesture()
                    .onChanged({ gest in
                        object.offsetX = dragStartX + gest.translation.width
                        object.offsetY = dragStartY + gest.translation.height
                    })
                    .onEnded({ _ in
                        dragStartX = object.offsetX
                        dragStartY = object.offsetY
                    })
                : nil
            )
            .onAppear {
                dragStartX = object.offsetX
                dragStartY = object.offsetY
            }

    }
}

struct frameAndPosition: ViewModifier {
    let object: Object
    func body(content: Content) -> some View {
        content
            .position(CGPoint(x: object.posX, y: object.posY))
            .frame(width: object.size, height: object.size)
    }
}

//Adds a button to photo objects which makes a copy of them. Also adds incrementers and decrementers for an object's order value and size. Also adds a label to the bottom with the object's type/name.
struct PhotoCopyButton: ViewModifier {
    @Environment(\.modelContext) var context
    @Query var objectList : [Object]
    let object : Object
    @AppStorage("showObjectDelete") var showObjectDelete : Bool = true
    @AppStorage("showCopyButton") var showCopyButton : Bool = true
    let type : String
    func body(content: Content) -> some View {
        content
            .overlay{
                if(!showObjectDelete && showCopyButton && object.draggable) {
                    //Copy Button
                    Button(action: {
                        let newObj = Object(x: object.posX, y: object.posY+50, image: object.image, size: object.size, type: object.cardType)
                        newObj.blue = object.blue
                        newObj.red = object.red
                        newObj.green = object.green
                        newObj.opacity = object.opacity
                        context.insert(newObj)
                        try? context.save()
                    }, label: {
                        RoundedRectangle(cornerRadius: object.size/10)
                            .foregroundStyle(.gray)
                            .overlay{
                                Text("Copy")
                                    .font(.system(size: object.size * 0.15))
                                    .foregroundStyle(.white)
                                    .bold()
                            }
                    })
                    .frame(width: object.size * 0.5, height: object.size * 0.5)
                    .position(x: object.posX, y: object.posY)
                    
                    //Size Incrementer
                    VStack(spacing: 0) {
                        Button(action: {
                            object.size += 5
                        }, label: {
                            Image(systemName: "plus.circle")
                                .resizable()
                                .foregroundStyle(.black)
                                .background{
                                    Circle()
                                        .foregroundStyle(.green)
                                }
                                .gesture(
                                    DragGesture(minimumDistance: 20)
                                        .onChanged({ _ in
                                            object.size *= 1.01
                                        })
                                )
                                .frame(width: object.size * 0.15, height: object.size * 0.15)
                        })
                        
                        Text("\(Int(object.size))")
                            .font(.system(size: object.size * 0.15, weight: .bold))
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                        
                        //Size Decrementer
                        Button(action: {
                            object.size -= 5
                        }, label: {
                            Image(systemName: "minus.circle")
                                .resizable()
                                .foregroundStyle(.black)
                                .background{
                                    Circle()
                                        .foregroundStyle(.red)
                                }
                                .gesture(
                                    DragGesture(minimumDistance: 20)
                                        .onChanged({ _ in
                                            object.size /= 1.01
                                        })
                                )
                                .frame(width: object.size * 0.15, height: object.size * 0.15)
                        })
                    }
                    .position(CGPoint(x: object.posX + object.size * 0.75, y: object.posY))
                    
                    //Order Incrementer
                    VStack(spacing: 5) {
                        Button(action: {
                            object.order += 1
                        }, label: {
                            Image(systemName: "plus.circle")
                                .resizable()
                                .foregroundStyle(.black)
                                .background{
                                    Circle()
                                        .foregroundStyle(.green)
                                }
                                .frame(width: object.size * 0.15, height: object.size * 0.15)
                        })
                        
                        //Order Value Displayed
                        Text("\(object.order)")
                            .font(.system(size: object.size * 0.15, weight: .bold))
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                        
                        //Order Decrementer
                        Button(action: {
                            object.order -= 1
                        }, label: {
                            Image(systemName: "minus.circle")
                                .resizable()
                                .foregroundStyle(.black)
                                .background{
                                    Circle()
                                        .foregroundStyle(.red)
                                }
                                .frame(width: object.size * 0.15, height: object.size * 0.15)
                        })
                    }
                    .position(CGPoint(x: object.posX + object.size * -0.75, y: object.posY))
                }
                
                //Name of the object
                Text("\(object.cardType)")
                    .font(.system(size: object.size * 0.1, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: object.size * Double(object.cardType.count) / 2)
                    .position(CGPoint(x: object.posX, y: object.posY + object.size * 0.65))
                
            }
    }
}
