import SwiftUI
import SwiftData

struct ContentView: View {
    //Stores Entity List in memory
    @Environment(\.modelContext) var context
    @Query(sort: [SortDescriptor(\Entity.id)]) var entities : [Entity] = []
    //Var determining when user goes to Map view
    @AppStorage("goToMap") var goToMap = false
    var body: some View {
        //Allows navigation to Map view and back
        NavigationStack {
            //Allows scrolling up and down
            ScrollView {
                //Players and UI
                LazyVStack {
                    //Textfields and Button for adding a new Entity/Player
                    InsertMenu()
                    
                    //Makes a Player using PlayerBuilder for each Entity in Entity List
                    ForEach(entities) { entity in
                        PlayerBuilder(player: entity)
                    }
                        
                        //Toggles for showing incrementer and trash can/delete button
                    VStack {
                        Toggles()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .offset(x: 20)
                    }
                    
                }
                //End of VStack creating players and UI
                
                //Moveable notepad
                Notepad()
            }
            //Background Color
            .background(Color(red: 0.3, green: 0.4, blue: 0.6, opacity: 0.3))
            //When goToMap is true navigates to Map view
            .navigationDestination(isPresented: $goToMap) {
                Map()
                    .onDisappear {
                        try? context.save()
                    }
            }
        }
    }
}



struct Toggles: View {
    //Vars tracking incrementer and trash can settings
    @AppStorage("showIncrementer") private var showIncrementer = true
    @AppStorage("showTrashCan") private var showTrashCan = true
    var body: some View {
        Toggle(isOn: $showIncrementer, label: {
            Text("Show Incrementer:")
                .bold()
        })
        .frame(width: 220, height: 30, alignment: .leading)
        
        Toggle(isOn: $showTrashCan, label: {
            Text("Show Trash Can:")
                .bold()
        })
        .frame(width: 220, height: 30, alignment: .trailing)
    }
}
