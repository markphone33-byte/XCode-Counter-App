import SwiftUI
import SwiftData

struct pathObjectDelete: ViewModifier {
    @Environment(\.modelContext) var context
    @Query var objectList : [Object]
    @State var object : Object
    @AppStorage("showObjectDelete") var showObjectDelete : Bool = true
    @AppStorage("showCopyButton") var showCopyButton : Bool = true
    func body(content: Content) -> some View {
        content
            .overlay{
                if(showObjectDelete && object.draggable) {
                    Button(action: {
                        context.delete(object)
                        try? context.save()
                    }, label: {
                        Image(systemName: "trash.fill")
                    })
                    .scaleEffect(object.size * 0.02)
                    .position(object.getPos())
                    .offset(x: object.offsetX, y: object.offsetY)
                }
                if(showObjectDelete){
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
                    .position(CGPoint(x: object.getPos().x, y: object.getPos().y + object.size * 0.4))
                    .offset(x: object.offsetX, y: object.offsetY)
                }
                
                //Order Incrementer
                if(!showObjectDelete && showCopyButton && object.draggable) {
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
                        
                        Text("Order:\n\(object.order)")
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
                    .scaleEffect(object.size / 50)
                    .position(object.getPos())
                    .offset(x: object.offsetX - object.size * 2, y: object.offsetY)
                }
            }
    }
}

struct pathDragGest: ViewModifier {
    @State var object: Object
    @State var dragOffsetX : Double = 0.0
    @State var dragOffsetY : Double = 0.0
    func body(content: Content) -> some View {
        content
            .offset(x: object.offsetX + dragOffsetX, y: object.offsetY + dragOffsetY)
            .gesture(object.draggable ?
                     DragGesture()
                .onChanged({ gest in
                    dragOffsetX = gest.translation.width
                    dragOffsetY = gest.translation.height
                })
                    .onEnded({ gest in
                        object.offsetX += dragOffsetX
                        object.offsetY += dragOffsetY
                        dragOffsetX = 0
                        dragOffsetY = 0
                    })
                     : nil
            )
    }
}

struct pathHaveColorPicker: ViewModifier {
    @State var object : Object
    @State var circleColor : UIColor = UIColor(Color(red: 0, green: 0, blue: 0))
    @State var colorPick : Color = Color(red: 0, green: 0, blue: 0)
    @State var r : CGFloat = 0
    @State var g : CGFloat = 0
    @State var b : CGFloat = 0
    @State var a : CGFloat = 0
    @AppStorage("showColorPicker") var showColorPicker : Bool = true
    func body(content: Content) -> some View {
        content
            .foregroundStyle(Color(red: object.red, green: object.green, blue: object.blue, opacity: object.opacity))
            .overlay {
                if(showColorPicker) {
                    ColorPicker("", selection: $colorPick)
                        .position(object.getPos())
                        .offset(x: object.offsetX - 25000 - object.size, y: object.offsetY)
                        .onChange(of: colorPick) { oldValue, newValue in
                            circleColor = UIColor(colorPick)
                            if circleColor.getRed(&r, green: &g, blue: &b, alpha: &a) {
                                object.red = r
                                object.green = g
                                object.blue = b
                                object.opacity = a
                            }
                        }
                }
            }
    }
}
