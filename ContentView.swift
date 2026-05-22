import SwiftUI
import SwiftData

struct ContentView: View {
    //Stores Entity List in memory
    @Environment(\.modelContext) var context
    @Query(sort: [SortDescriptor(\Entity.id)]) var entities : [Entity] = []
    //Vars used to make new Entity/Player
    @State var newName = ""
    @State var newCounter = ""
    @State var newColor = "Red"
    @State var newMaxCount : Float = 100.0
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
                    InsertMenu(newName: $newName, newCounter: $newCounter, newMaxCount: $newMaxCount, newColor: $newColor)
                    
                    //Makes a Player using PlayerBuilder for each Entity in Entity List
                        ForEach(entities) { entity in
                            playerBuilder(player: entity)
                        }
                        
                        //Toggles for showing incrementer and trash can/delete button
                        Toggles()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .offset(x: 20)
                    
                }
                //End of VStack creating players and UI
                
                //Moveable notepad
                Notepad()
            }
            //Background Color
            .background(Color(red: 0.3, green: 0.4, blue: 0.6, opacity: 0.3))
            //When goToMap is true navigates to Map view
            .navigationDestination(isPresented: $goToMap) {
                LazyVStack {
                    Map()
                }
            }
        }
    }
}



struct Toggles: View {
    //Vars tracking incrementer and trash can settings
    @AppStorage("showIncrementer") var showIncrementer = true
    @AppStorage("showTrashCan") var showTrashCan = true
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
