import SwiftUI
import SwiftData

struct objectDelete: ViewModifier {
    @Environment(\.modelContext) var context
    @Query var objectList : [Object]
    let object : Object
    @AppStorage("showObjectDelete") var showMod : Bool = true
    func body(content: Content) -> some View {
        content
            .overlay{
                if(showMod && object.draggable) {
                    Button(action: {
                        context.delete(object)
                        try? context.save()
                    }, label: {
                        Image(systemName: "trash.fill")
                    })
                    .scaleEffect(object.size * 0.02)
                    .position(x: object.posX, y: object.posY)
                }
                if(showMod){
                    Button(action: {
                        object.draggable.toggle()
                        try? context.save()
                    }, label: {
                        Text("Toggle Drag")
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .foregroundStyle(.white)
                                    .frame(width: 100, height: 35)
                            )
                    })
                    .frame(width: 100, height: 30)
                    .scaleEffect(object.size * 0.005)
                    .position(CGPoint(x: object.posX, y: object.posY + object.size * 0.4))
                }
            }
    }
}

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
                    Button(action: {
                        let newObj = Object(x: object.posX, y: object.posY+50, image: object.image, size: object.size, type: object.cardType)
                        print(newObj.size)
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
                                    .font(.system(size: object.size * 0.3))
                                    .foregroundStyle(.white)
                            }
                    })
                    .scaleEffect(0.5)
                    .position(x: object.posX, y: object.posY)
                    
                    //Size Incrementer
                    VStack(spacing: 0) {
                        Button(action: {
                            object.size += 5
                        }, label: {
                            Image(systemName: "plus.circle")
                                .font(.system(size: 20))
                                .foregroundStyle(.black)
                                .background{
                                    Circle()
                                        .foregroundStyle(.green)
                                        .frame(width: 20, height: 20)
                                }
                                .gesture(
                                    DragGesture(minimumDistance: 20)
                                        .onChanged({ _ in
                                            object.size *= 1.01
                                        })
                                )
                        })
                        
                        Text("\(Int(object.size))")
                            .bold()
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                        
                        Button(action: {
                            object.size -= 5
                        }, label: {
                            Image(systemName: "minus.circle")
                                .font(.system(size: 20))
                                .foregroundStyle(.black)
                                .background{
                                    Circle()
                                        .foregroundStyle(.red)
                                        .frame(width: 20, height: 20)
                                }
                                .gesture(
                                    DragGesture(minimumDistance: 20)
                                        .onChanged({ _ in
                                            object.size /= 1.01
                                        })
                                )
                        })
                    }
                    .scaleEffect(object.size / 150)
                    .position(CGPoint(x: object.posX + object.size * 0.75, y: object.posY))
                    
                    //Order Incrementer
                    VStack(spacing: 0) {
                        Button(action: {
                            object.order += 1
                        }, label: {
                            Image(systemName: "plus.circle")
                                .font(.system(size: 20))
                                .foregroundStyle(.black)
                                .background{
                                    Circle()
                                        .foregroundStyle(.green)
                                        .frame(width: 20, height: 20)
                                }
                        })
                        
                        Text("\(object.order)")
                            .bold()
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                        
                        Button(action: {
                            object.order -= 1
                        }, label: {
                            Image(systemName: "minus.circle")
                                .font(.system(size: 20))
                                .foregroundStyle(.black)
                                .background{
                                    Circle()
                                        .foregroundStyle(.red)
                                        .frame(width: 20, height: 20)
                                }
                        })
                    }
                    .scaleEffect(object.size / 150)
                    .position(CGPoint(x: object.posX + object.size * -0.75, y: object.posY))
                }
                
                Text("\(object.cardType)")
                    .scaleEffect(object.size / 150)
                    .bold()
                    .foregroundStyle(.white)
                    .frame(width: object.size * Double(object.cardType.count) / 2)
                    .position(CGPoint(x: object.posX, y: object.posY + object.size * 0.65))
                
            }
    }
}
