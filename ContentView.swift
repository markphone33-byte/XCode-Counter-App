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
    //Vars used for notepad
    @AppStorage("notes") var notes = ""
    @AppStorage("notesPosX") var notesPosX = 0.0
    @AppStorage("notesPosY") var notesPosY = 0.0
    @AppStorage("showIncrementer") var showIncrementer = true
    @AppStorage("showTrashCan") var showTrashCan = true
    @AppStorage("goToMap") var goToMap = false
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    //Textfields and Button for adding a new Entity/Player
                    InsertMenu(newName: $newName, newCounter: $newCounter, newMaxCount: $newMaxCount, newColor: $newColor)
                    //Makes a Player using PlayerBuilder for each Entity in Entity List
                    VStack (spacing: 0) {
                        ForEach(entities) { entity in
                            playerBuilder(player: entity)
                        }
                        //Toggles for showing incrementer and trash can/delete button
                        VStack {
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
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .offset(x: 15)
                    }
                }
                //Moveable notepad
                Rectangle()
                    .overlay{
                        TextEditor(text: $notes)
                            .background(.clear)
                            .frame(width: 190, height: 290)
                    }
                    .frame(width: 200, height: 300)
                    .position(x: notesPosX, y: notesPosY)
                    .gesture(
                        DragGesture()
                            .onChanged({ gest in
                                UserDefaults.standard.set(gest.location.x, forKey: "notesPosX")
                                UserDefaults.standard.set(gest.location.y, forKey: "notesPosY")
                            })
                    )
            }
            //Background Color
            .background(Color(red: 0.3, green: 0.4, blue: 0.6, opacity: 0.3))
            .navigationDestination(isPresented: $goToMap) { 
                Map()
            }
        }
    }
}
