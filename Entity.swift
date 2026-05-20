import SwiftUI
import SwiftData

@Model
class Entity : Identifiable {
    var counters : [Counter]
    var id : String
    
    //Initializer defaults to making a Blue Mana and Red HP counter if no counter name is given
    init (name : String, counterName : String, counterMax : Float)
    {
        if(counterName.isEmpty) {
            counters = [Counter(name: "HP", color: "Red", max: counterMax), Counter(name: "Mana", color: "Blue", max: counterMax)]
            id = name
        }
        else {
            counters = [Counter(name: counterName, max: counterMax)]
            id = name
        }
    }
}
