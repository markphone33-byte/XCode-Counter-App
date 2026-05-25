import SwiftUI
import SwiftData

struct PlayerBuilder: View {
    @Bindable var player : Entity
    
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
                    ColorPicker("", selection: $backgroundColor)
                    ForEach(sortedCounters) { counter in
                        CounterBuilder(player: player, counter: counter)
                    }
                    .offset(x: -50)
                }
                //End of HStack
            }
            //End of ScrollView
        }
    }
}
