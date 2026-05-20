import SwiftUI
import SwiftData

struct InsertMenu: View {
    @Binding var newName : String
    @Binding var newCounter : String
    @Binding var newMaxCount : Float
    @Binding var newColor : String
    @Environment(\.modelContext) var context
    @Query(sort: [SortDescriptor(\Entity.id)]) var entities : [Entity] = []
    var body: some View {
        HStack{
            TextField("Enter entity name", text: $newName)
                .textFieldStyle(.roundedBorder)
            TextField("Enter counter name", text: $newCounter)
                .textFieldStyle(.roundedBorder)
            TextField("Enter Max Count", value: $newMaxCount, format: .number)
                .textFieldStyle(.roundedBorder)
            Button(action: {
                //Determines if added Entity/Counter is a new one or adding in to an existing one
                var addToExisting = false
                for i in entities.indices {
                    if(entities[i].id == newName) {
                        addToExisting = true
                        entities[i].counters.append(Counter(name: newCounter, color: newColor, max: newMaxCount))
                    }
                }
                if (addToExisting == false) {
                    context.insert(Entity(name: newName, counterName: newCounter, counterMax: newMaxCount))
                }
                newName = ""
                newCounter = ""
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
        //Picker for Color of slider and Save Button
        HStack (spacing: 30) {
            HStack (spacing: 0) {
                Text("Slider Color: ")
                Picker("idk", selection: $newColor, content: { 
                    Text("Blue").tag("Blue")
                    Text("Red").tag("Red")
                    Text("Purple").tag("Purple")
                })
                .tint(
                    newColor == "Red" ? .red : newColor == "Blue" ? .blue : .purple
                )
            }
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
            Button(action: {
                UserDefaults.standard.set(true, forKey: "goToMap")
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
    }
}
