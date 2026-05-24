import SwiftUI

struct screenDragGest: ViewModifier {
    @Binding var offsetWidth : Double
    @Binding var offsetHeight : Double
    @Binding var dragOffset : CGSize
    @State var size : Double
    func body(content: Content) -> some View {
        content
            .frame(width: size, height: size)
            .offset(x: offsetWidth + dragOffset.width,
                    y: offsetHeight + dragOffset.height)
            .gesture(
                DragGesture()
                    .onChanged({ gest in
                        dragOffset = gest.translation
                    })
                    .onEnded({ gest in
                        offsetWidth += gest.translation.width
                        offsetHeight += gest.translation.height
                        dragOffset = .zero
                    })
            )
    }
}

struct zoomGest: ViewModifier {
    @AppStorage("scale") var scale : Double = 0.0
    @AppStorage("lastScale") var lastScale : Double = 1.0
    func body(content: Content) -> some View {
        content
            .scaleEffect(scale)
            .gesture(
                MagnificationGesture()
                    .onChanged({ val in
                        scale = lastScale * val
                    })
                    .onEnded({ val in
                        if(scale < 0.01) {
                            scale = 0.01
                        }
                        UserDefaults.standard.set(scale, forKey: "lastScale")
                    })
            )
            .animation(.easeInOut(duration: 0.2), value: scale)
    }
}
