import SwiftUI

//Each individual triangle making up the wheel
struct Triangle : View {
    let center : CGPoint
    let diameter : Double
    let numberOfSegments : Int
    var body: some View {
        let num = Double(numberOfSegments)/1.6
        Path { path in
            let diameter = diameter
            path.move(to: center)
            path.addLine(to: CGPoint(x: center.x + diameter/num, y: center.y + diameter/2))
            path.addLine(to: CGPoint(x: center.x - diameter/num, y: center.y + diameter/2))
            path.closeSubpath()
        }
        .stroke(lineWidth: 2)
        .foregroundStyle(.black)
    }
}

struct Wheel: View {
    @State var center = CGPoint(x: 200, y: 20) 
    @State var diameter : Double = 300
    @State var spinRotation = 0

    //Number of segments can be adjusted in code and wheel will still work as intended. Though diameter will likely need to be made bigger for readability if number of segments exceeds 30
    @State var numberOfSegments : Int = 20
    var body: some View {
        ZStack{
            //Wheel border and triangles making up the wheel
            Circle()
                .frame(width: diameter, height: diameter)
                .position(center)
                .foregroundStyle(.blue)
            ForEach(1...numberOfSegments, id: \.self) { num in
                let rotation = (360*num)/numberOfSegments
                ZStack{
                    Triangle(center: center, diameter: diameter, numberOfSegments: numberOfSegments)
                    Text("\(num)")
                        .offset(y: diameter/2.5)
                        .bold()
                        .foregroundStyle(.white)
                        .underline(true, pattern: .solid, color: .white)
                }
                .rotationEffect(.degrees(Double(rotation)))
            }
            .frame(width: 2*center.x, height: 2*center.y)
            .rotationEffect(.degrees(Double(spinRotation)))
            .animation(.easeInOut(duration: 2), value: spinRotation)
            .position(center)
            
            //Wheel arrow
            Text("v")
                .foregroundStyle(.red)
                .position(center)
                .offset(y: -diameter/2 - 15)
                .font(.system(size: 30, weight: .bold, design: .rounded))
            
            //Spin Button
            Button(action: {
                spinRotation += Int.random(in: 1800...2160)
            }, label: {
                Text("SPIN")
                    .foregroundStyle(.red)
                    .font(.system(size: 14, weight: .black, design: .rounded))
                    .background{
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 40, height: 40)
                            .foregroundStyle(.blue)
                            .border(Color.black, width: 3)
                    }
            })
            .position(center)
        }
    }
}
