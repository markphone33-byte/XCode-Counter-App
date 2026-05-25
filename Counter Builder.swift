import SwiftUI
import SwiftData

struct CounterBuilder: View {
    //Vars used for deleting counters and entities
    let player : Entity
    @Bindable var counter : Counter
    @Environment(\.modelContext) var context
    
    //Vars for when to show certain buttons
    @AppStorage("showIncrementer") var showIncrementer = true
    @AppStorage("showTrashCan") var showTrashCan = true
    
    var body: some View {
        VStack (spacing: 0) {
            HStack {
                
                //Pencil Button toggling custom name
                Button(action: {
                    counter.showCustomName.toggle()
                }, label: {
                    Image(systemName: "pencil")
                })
                if(counter.showCustomName) {
                    HStack (spacing: 0) {
                        ZStack {
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
                
                //Pre-built name
                else {
                    Text("\(player.id)'s \(counter.name): \(Int(counter.count))")
                        .bold()
                        .onLongPressGesture(minimumDuration: 0.7) { 
                            counter.hidden.toggle()
                        }
                }
                
                //Trash Can Button to remove counter and removes Entity from Entity List if all counters are gone
                if(showTrashCan) {
                    Button(action: {
                        player.counters.removeAll { deleteCounter in
                            deleteCounter.name == counter.name
                        }
                        if(player.counters.isEmpty) {
                            context.delete(player)
                        }
                        try? context.save()
                    }, label: {
                        Image(systemName: "trash.fill")
                    })
                }
                
                //Incrementer and Decrementer
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
            .offset(y: 10)
            //End of HStack
            
            //Gauge with a slider
            Gauge(value: counter.count, in: 0...counter.maxCount) {
                //No Label
            }
                .overlay {
                    Slider(value: $counter.count, in: 0...counter.maxCount)
                        .scaleEffect(x: 1, y: 0.8)
                }
                //Alters slider color based on counter's color
                .tint(
                    counter.hidden ? .gray : counter.color == "Red" ? .red : counter.color == "Blue" ? .blue : .purple
                )
                .scaleEffect(x: 1, y: 2)
                .frame(width: 250, height: 80)
                .padding(.leading)
        }
        .frame(height: 120)
        //End of VStack
    }
}
