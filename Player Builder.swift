import SwiftUI
import SwiftData

struct PlayerBuilder: View {
    //Takes in the Entity to be used later in CounterBuilder
    @State var player : Entity
    //Makes a var for background color
    @State var backgroundColor = Color(.clear)
    //Computed property for a sorted list where unhidden comes first then sorted by alphabetical
    private var sortedCounters: [Counter] {
        player.counters.sorted { c1, c2 in
            if c1.hidden == c2.hidden {
                return c1.name < c2.name
            } else {
                return !c1.hidden && c2.hidden
            }
        }
    }
    var body: some View {
        ZStack {
            //Background Color
            Color(backgroundColor)
            
            ScrollView (.horizontal) {
                HStack(spacing: 50) {
                    
                    //Color Picker for background of the PlayerBuilder
                    ColorPicker("", selection: $backgroundColor)
                    
                    //Makes a CounterBuilder for each counter in the Counter list of the Entity/Player
                    ForEach(sortedCounters) { counter in
                        CounterBuilder(count: counter.count, playerName: player.id, counterName: counter.name, counterColor: counter.color, counterMax: counter.maxCount, counters: $player.counters, player: $player, counter: counter)
                    }
                    .offset(x: -50)
                    //End of ForEach loop
                }
                //End of HStack
            }
            //End of ScrollView
        }
    }
}
