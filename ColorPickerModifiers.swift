//
//  ColorPickerModifiers.swift
//  Counter
//
//  Created by Mark Nguyen on 5/23/26.
//
import SwiftUI

struct objectColorPicker: View {
    let object : Object
    @State var circleColor : UIColor = UIColor(Color(red: 0, green: 0, blue: 0))
    @State var colorPick : Color = Color(red: 0, green: 0, blue: 0)
    @State var r : CGFloat = 0
    @State var g : CGFloat = 0
    @State var b : CGFloat = 0
    @State var a : CGFloat = 0
    @AppStorage("showColorPicker") var showColorPicker : Bool = true
    var body: some View {
        ColorPicker("", selection: $colorPick)
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


struct haveColorPicker: ViewModifier {
    let object : Object
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
                if(showColorPicker && object.isCircle) {
                    objectColorPicker(object: object)
                        .position(object.getPos())
                        .offset(x: cbrt(object.size))
                } else if (showColorPicker) {
                    objectColorPicker(object: object)
                }
            }
    }
}
