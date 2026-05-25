import SwiftUI
import SwiftData

@Model
class Counter {
    var count : Float
    var maxCount : Float = 100
    var name : String
    var color : String
    
    //Whether or not the counter will be grayed out
    var hidden = false
    
    var customName = ""
    var showCustomName = false
    
    //Default color is red
    init (name : String, max : Float)
    {
        self.name = name
        count = max
        color = "Red"
        maxCount = max
    }
    
    init (name : String, color: String, max : Float)
    {
        self.name = name
        count = max
        self.color = color
        maxCount = max
    }
}
