import SwiftUI
import SwiftData

@Model
class Counter {
    var count : Float
    var maxCount : Float = 100
    var name : String
    var color : String
    var hidden = false
    var customName = ""
    var showCustomName = false
    
    init (name : String, max : Float)
    {
        self.name = name
        count = 100
        color = "Red"
        maxCount = max
    }
    init (name : String, color: String, max : Float)
    {
        self.name = name
        count = 100
        self.color = color
        maxCount = max
    }
}
