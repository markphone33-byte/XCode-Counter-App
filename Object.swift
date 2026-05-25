import SwiftUI
import SwiftData

@Model
class Object {
    var id = UUID()
    var size : Double
    var draggable = true
    
    //Inital Position
    var posX : Double
    var posY : Double
    
    //Used for when user drags objects
    var offsetX : Double = 0.0
    var offsetY : Double = 0.0
    
    //Color of object
    var red : Double = 0.0
    var green : Double = 0.0
    var blue : Double = 0.0
    var opacity : Double = 0.5
    
    //Determines type of object
    var image : Data?
    var isCircle : Bool
    var points : [CustomCGPoint] = []
    var isSimpleDraw : Bool = false
    
    //Display name for photo objects
    var cardType : String = ""
    
    //Higher orders values appear on top when objects overlap
    var order : Int = 0
    
    //Initializer for a regular circle object
    init(x : Double, y: Double, size: Double) {
        posX = x
        posY = y
        image = nil
        isCircle = true
        self.size = size
        opacity = 1.0
    }
    
    //Initializer for a drawn object
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
    
    //Initializer for a photo object
    init(x : Double, y: Double, image: Data?, size: Double, type: String) {
        posX = x
        posY = y
        self.image = image
        isCircle = false
        self.size = size
        opacity = 0.0
        cardType = type
    }
    
    //Returns the center of the object, or approximate center for drawn objects
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
