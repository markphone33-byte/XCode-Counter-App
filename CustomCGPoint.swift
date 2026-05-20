import SwiftUI

struct CustomCGPoint : Hashable, Codable {
    var x : Double
    var y : Double
    
    init(xVal : Double, yVal : Double) {
        x = xVal
        y = yVal
    }
    
    func toCGPoint() -> CGPoint {
        return CGPoint(x: x, y: y)
    }
}
