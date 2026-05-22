import SwiftUI
import SwiftData

struct CounterBuilder: View {
    //Various vars used for displaying counter
    @State var count : Float
    @State var playerName : String
    @State var counterName : String
    @State var counterColor : String
    @State var counterMax : Float
    //Vars used for deleting counters and entities when needed
    @Binding var counters : [Counter]
    @Binding var player : Entity
    @State var counter : Counter
    //Gets Entity List from memory
    @Environment(\.modelContext) var context
    @Query(sort: [SortDescriptor(\Entity.id)]) var playerList : [Entity] = []
    //vars for showing certain buttons
    @AppStorage("showIncrementer") var showIncrementer = true
    @AppStorage("showTrashCan") var showTrashCan = true
    var body: some View {
        VStack (spacing: 0) {
            HStack {
                //Pencil Button toggling pre-built or custom name
                Button(action: {
                    counter.showCustomName.toggle()
                }, label: {
                    Image(systemName: "pencil")
                })
                if(counter.showCustomName) {
                    HStack (spacing: 0) {
                        ZStack {
                            Text(counter.customName.isEmpty ? " " : counter.customName)
                                .opacity(0)
                            TextField("Enter name", text: $counter.customName)
                                .multilineTextAlignment(.center)
                                .bold()
                        }
                        .fixedSize()
                        Text(": \(Int(count))")
                            .bold()
                            .frame(alignment: .leading)
                    }
                }
                //Pre-built name that if held hides/unhides counter
                else {
                    Text("\(playerName)'s \(counterName): \(Int(count))")
                        .bold()
                        .onLongPressGesture(minimumDuration: 0.7) { 
                            counter.hidden.toggle()
                        }
                    
                }
                //Trash Can Button to remove counter and removes Entity from Entity List if all counters are gone
                if(showTrashCan) {
                    Button(action: {
                        counters.removeAll { deleteCounter in
                            deleteCounter.name == counterName
                        }
                        if(counters.isEmpty) {
                            context.delete(player)
                        }
                    }, label: {
                        Image(systemName: "trash.fill")
                    })
                }
                //Incrementer and decrementer
                if(showIncrementer) {
                    Button(action: {
                        if (counterMax >= 100000) {
                            count += 1000
                        }
                        else if(counterMax >= 10000) {
                            count += 100
                        }
                        else {
                            count += 1
                        }
                    }, label: {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 20))
                            .foregroundStyle(.black)
                            .background{
                                Circle()
                                    .foregroundStyle(.green)
                                    .frame(width: 20, height: 20)
                            }
                    })
                    Button(action: {
                        if (counterMax >= 100000) {
                            count -= 1000
                        }
                        else if(counterMax >= 10000) {
                            count -= 100
                        }
                        else {
                            count -= 1
                        }
                    }, label: {
                        Image(systemName: "minus.circle")
                            .font(.system(size: 20))
                            .foregroundStyle(.black)
                            .background{
                                Circle()
                                    .foregroundStyle(.red)
                                    .frame(width: 20, height: 20)
                            }
                    })
                }
            }
            .frame(height: 0)
            //Gauge with a slider on top
            Gauge(value: count, in: 0...counterMax, label: {
            })
            .overlay {
                Slider(value: $count, in: 0...counterMax)
                    .onChange(of: count) { oldValue, newValue in
                        counter.count = count
                    }
                    .scaleEffect(x: 1, y: 0.8)
            }
            //Alters color based on picked color
            .tint(
                counter.hidden ? .gray : counterColor == "Red" ? .red : counterColor == "Blue" ? .blue : .purple
            )
            .scaleEffect(x: 1, y: 2)
            .frame(width: 250, height: 80)
            .padding(.leading)
        }
        .frame(height: 120)
    }
}
