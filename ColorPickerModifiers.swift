import SwiftUI

//Used one of the ViewModifier
struct objectColorPicker: View {
    //Object the ColorPicker is attached to
    let object : Object
    
    //Vars for ColorPicker logic
    @State private var circleColor : UIColor = UIColor(Color(red: 0, green: 0, blue: 0))
    @State private var colorPick : Color = Color(red: 0, green: 0, blue: 0)
    @State private var r : CGFloat = 0
    @State private var g : CGFloat = 0
    @State private var b : CGFloat = 0
    @State private var a : CGFloat = 0

    var body: some View {
        ColorPicker("", selection: $colorPick)
            //ColorPicker shrinks with object size but does not grow
            .scaleEffect(object.size < 100 ? object.size * 0.01 : 1)
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

//ColorPicker for non-drawn objects
struct haveColorPicker: ViewModifier {
    //Object this is attached to
    let object : Object
    
    //Display setting for color picker
    @AppStorage("showColorPicker") var showColorPicker : Bool = true
    func body(content: Content) -> some View {
        content
            .foregroundStyle(Color(red: object.red, green: object.green, blue: object.blue, opacity: object.opacity))
            .overlay {
                //Positions ColorPicker at the middle right edge of circle objects
                if(showColorPicker && object.isCircle) {
                    objectColorPicker(object: object)
                        .position(object.getPos())
                        .offset(x: cbrt(object.size))
                    
                //Positions ColorPicker at the middle right edge of photo objects
                } else if (showColorPicker) {
                    objectColorPicker(object: object)
                }
            }
    }
}

//ColorPicker for drawn objects
struct pathHaveColorPicker: ViewModifier {
    let object : Object
    let mapSize : Double
    @State private var circleColor : UIColor = UIColor(Color(red: 0, green: 0, blue: 0))
    @State private var colorPick : Color = Color(red: 0, green: 0, blue: 0)
    @State private var r : CGFloat = 0
    @State private var g : CGFloat = 0
    @State private var b : CGFloat = 0
    @State private var a : CGFloat = 0
    @AppStorage("showColorPicker") var showColorPicker : Bool = true
    func body(content: Content) -> some View {
        content
            .foregroundStyle(Color(red: object.red, green: object.green, blue: object.blue, opacity: object.opacity))
            .overlay {
                if(showColorPicker) {
                    ColorPicker("", selection: $colorPick)
                        .position(object.getPos())
                        .offset(x: object.offsetX - (mapSize / 2) - object.size, y: object.offsetY)
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
