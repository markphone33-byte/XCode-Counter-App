import SwiftUI
import SwiftData

struct CounterBuilder: View {
    //Vars used for deleting counters and entities when needed
    @Binding var counters : [Counter]
    @Bindable var player : Entity
    @Bindable var counter : Counter
    @Environment(\.modelContext) var context
    //Vars for when to show certain buttons
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
                        Text(": \(Int(counter.count))")
                            .bold()
                            .frame(alignment: .leading)
                    }
                }
                //Pre-built name that if held hides/unhides counter
                else {
                    Text(String("\(player.id)'s \(counter.name): \(Int(counter.count))"))
                        .bold()
                        .onLongPressGesture(minimumDuration: 0.7) { 
                            counter.hidden.toggle()
                        }
                    
                }
                //Trash Can Button to remove counter and removes Entity from Entity List if all counters are gone
                if(showTrashCan) {
                    Button(action: {
                        counters.removeAll { deleteCounter in
                            deleteCounter.name == counter.name
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
                        if (counter.maxCount >= 100000) {
                            counter.count += 1000
                        }
                        else if(counter.maxCount >= 10000) {
                            counter.count += 100
                        }
                        else {
                            counter.count += 1
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
                        if (counter.maxCount >= 100000) {
                            counter.count -= 1000
                        }
                        else if(counter.maxCount >= 10000) {
                            counter.count -= 100
                        }
                        else {
                            counter.count -= 1
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
            Gauge(value: counter.count, in: 0...counter.maxCount, label: {
            })
            .overlay {
                Slider(value: $counter.count, in: 0...counter.maxCount)
                    .scaleEffect(x: 1, y: 0.8)
            }
            //Alters color based on picked color
            .tint(
                counter.hidden ? .gray : counter.color == "Red" ? .red : counter.color == "Blue" ? .blue : .purple
            )
            .scaleEffect(x: 1, y: 2)
            .frame(width: 250, height: 80)
            .padding(.leading)
        }
        .frame(height: 120)
    }
}
