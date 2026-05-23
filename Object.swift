import SwiftUI
import SwiftData

@Model
class Object {
    var id = UUID()
    var posX : Double
    var posY : Double
    var image : Data?
    var isCircle : Bool
    var size : Double
    var draggable = true
    var red : Double = 0.0
    var green : Double = 0.0
    var blue : Double = 0.0
    var opacity : Double = 0.5
    var points : [CustomCGPoint] = []
    var offsetX : Double = 0.0
    var offsetY : Double = 0.0
    var isSimpleDraw : Bool = false
    var cardType : String = ""
    var order : Int = 0
    
    init(x : Double, y: Double, size: Double) {
        posX = x
        posY = y
        image = nil
        isCircle = true
        self.size = size
        opacity = 1.0
    }
    
    init(x : Double, y: Double, size: Double, isOutline: Bool, pointList : [CustomCGPoint]) {
        posX = x
        posY = y
        image = nil
        isCircle = false
        self.size = size
        points = pointList
        isSimpleDraw = isOutline
        opacity = 1.0
    }
    
    init(x : Double, y: Double, image: Data?, size: Double, type: String) {
        posX = x
        posY = y
        self.image = image
        isCircle = false
        self.size = size
        opacity = 0.0
        cardType = type
    }
    
    func getPos() -> CGPoint {
        if(points.isEmpty) {
            return CGPoint(x: posX, y: posY)
        }
        var tempPath = Path()
        tempPath.move(to: points.first!.toCGPoint())
        for point in points.dropFirst() {
            tempPath.addLine(to: point.toCGPoint())
        }
        let boundingBox = tempPath.boundingRect
        let center = CGPoint(x: boundingBox.midX, y: boundingBox.midY)
        return center
    }
}
