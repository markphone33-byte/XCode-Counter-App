import SwiftUI

//Lets user navigate around the map by dragging
struct screenDragGest: ViewModifier {
    @AppStorage("offsetWidth") var offsetWidth : Double = 0.0
    @AppStorage("offsetHeight") var offsetHeight : Double = 0.0
    @State var dragOffset : CGSize = .zero
    let mapSize : Double
    func body(content: Content) -> some View {
        content
            .frame(width: mapSize, height: mapSize)
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

//Lets user zoom in and out of the map
struct zoomGest: ViewModifier {
    @AppStorage("scale") var scale : Double = 1.0
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
