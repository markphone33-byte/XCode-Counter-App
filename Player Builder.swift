import SwiftUI
import SwiftData

struct playerBuilder: View { 
    //Takes in the Entity to be used later in CounterBuilder
    @State var player : Entity
    //Gets the EntityList stored in memory and also makes a var for background color
    @Environment(\.modelContext) var context
    @Query(sort: [SortDescriptor(\Entity.id)]) var playerList : [Entity] = []
    @State var backgroundColor = Color(.clear)
    var body: some View {
        ZStack {
            //Background
            Color(backgroundColor)
            ScrollView (.horizontal) { 
                //Color Picker for background of the PlayerBuilder
                HStack(spacing: 50) {
                    ColorPicker("", selection: $backgroundColor)
                    //Makes a CounterBuilder for each counter in the Counter list of the Entity/Player
                    ForEach(player.counters.sorted(by: { c1, c2 in
                        //Sorts list so unhidden comes first then sorted by alphabetical
                        if(c1.hidden == c2.hidden) {
                            return c1.name < c2.name
                        }
                        else {
                            return !c1.hidden && c2.hidden
                        }
                    })) { counter in
                        counterBuilder(count: counter.count, playerName: player.id, counterName: counter.name, counterColor: counter.color, counterMax: counter.maxCount, counters: $player.counters, player: $player, counter: counter)
                    }
                    .offset(x: -50)
                }
            }
        }
    }
}
