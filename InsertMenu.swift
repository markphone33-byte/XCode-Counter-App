import SwiftUI
import SwiftData

struct InsertMenu: View {
    //Vars for building new players
    @State private var newName : String = ""
    @State private var newCounter : String = ""
    @State private var newMaxCount : Float = 100.0
    @State private var newColor : String = "Red"
    
    //Stores Entity List in memory
    @Environment(\.modelContext) var context
    @Query(sort: [SortDescriptor(\Entity.id)]) var entities : [Entity] = []
    
    //Var determining when user goes to Map view
    @AppStorage("goToMap") var goToMap = false
    
    var body: some View {
        //HStack for Row 1
        HStack{
            //Gets input for a new entity
            TextField("Enter entity name", text: $newName)
                .textFieldStyle(.roundedBorder)
            TextField("Enter counter name", text: $newCounter)
                .textFieldStyle(.roundedBorder)
            TextField("Enter Max Count", value: $newMaxCount, format: .number)
                .textFieldStyle(.roundedBorder)
            
            //Button to add a new entity or add a new counter to an existing entity
            Button(action: {
                var addToExisting = false
                for i in entities.indices {
                    if(entities[i].id == newName) {
                        addToExisting = true
                        
                        //Adds counter to existing entity
                        entities[i].counters.append(Counter(name: newCounter, color: newColor, max: newMaxCount))
                    }
                }
                
                //Makes new entity
                if (addToExisting == false) {
                    context.insert(Entity(name: newName, counterName: newCounter, counterMax: newMaxCount))
                    try? context.save()
                }
                
                //Resets Textfields
                newName = ""
                newCounter = ""
                newMaxCount = 100

            }, label: {
                Text("Add")
                    .bold()
                    .background {
                        RoundedRectangle(cornerRadius: 25.0)
                            .foregroundStyle(.white)
                            .frame(width: 70, height: 30)
                    }
                    .frame(width: 70, height: 30)
            })
        }
        .padding(.horizontal)
        .padding(.top)
        //End of HStack for Row 1
        
        //HStack for Row 2
        HStack (spacing: 30) {
            
            //HStack for picking the color of a new slider/counter
            HStack (spacing: 0) {
                Text("Slider Color: ")
                Picker("", selection: $newColor, content: {
                    Text("Blue").tag("Blue")
                    Text("Red").tag("Red")
                    Text("Purple").tag("Purple")
                })
                .tint(
                    newColor == "Red" ? .red : newColor == "Blue" ? .blue : .purple
                )
            }
            //End of HStack for picking the color of a new slider/counter
            
            //Save Button for both Entity list and the Object list used in the Map
            Button(action: {
                try? context.save()
            }, label: {
                Text("Save")
                    .foregroundStyle(.white)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .background { 
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundStyle(.teal)
                            .frame(width: 100, height: 40)
                    }
                    .frame(width: 100, height: 40)
            })
            
            //Button to go to Map screen
            Button(action: {
                goToMap = true
            }, label: {
                Text(">>")
                    .font(.system(size: 20, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                    .background{
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: 70, height: 30)
                    }
                    .frame(width: 70, height: 30)
            })
        }
        //End of HStack for Row 2
    }
}
