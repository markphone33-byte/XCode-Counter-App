import SwiftUI
import SwiftData
import PhotosUI

struct BottomBar: View {
    //Stores a Object List in memory
    @Environment(\.modelContext) var context
    @Query var objectList : [Object]
    
    //Vars used for determining where the screen is
    @AppStorage("offsetWidth") var offsetWidth : Double = 0.0
    @AppStorage("offsetHeight") var offsetHeight : Double = 0.0
    
    //Var for photo objects
    @State private var item : PhotosPickerItem? = nil
    
    //Values for new Objects user can adjust
    @Binding var objectSize : Double
    @Binding var isDrawing : Bool
    @Binding var objectType : String
    
    //Display settings
    @AppStorage("showObjectDelete") var showObjectDelete : Bool = true
    @AppStorage("showColorPicker") var showColorPicker : Bool = true
    @AppStorage("bottomBarSize") var bottomBarSize = 400.0
    @AppStorage("showWheel") var showWheel = false
    @AppStorage("showCopyButton") var showCopyButton : Bool = true
    
    //Vars determining when user is trying to draw a new object
    @Binding var isSimpleDraw : Bool
    @Binding var tempDrawOn : Bool
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack (spacing: 20) {
                
                //Input for size of new objects
                TextField("Input Size", value: $objectSize, format: .number)
                    .textFieldStyle(.roundedBorder)
                    .overlay { 
                        Text("Size")
                            .offset(y: -25)
                    }
                    .frame(width: 70, height: 70)
                
                //Input for name of new photo objects
                TextField("", text: $objectType)
                    .textFieldStyle(.roundedBorder)
                    .overlay { 
                        Text("Type")
                            .offset(y: -25)
                    }
                    .frame(width: CGFloat(8 * objectType.count) + 50, height: 70)
                
                //Adds a new object and positions it near the center of the screen
                Button(action: {
                    context.insert(Object(x: -offsetWidth, y: -offsetHeight, size: objectSize))
                    try? context.save()
                }, label: {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 105, height: 35)
                        .foregroundStyle(.white)
                        .overlay { 
                            Text("Add Object")
                                .foregroundStyle(.black)
                        }
                })
                .frame(width: 105, height: 35)
                
                //Adds a new photo object and positions it near the center of the screen
                PhotosPicker("Select Image", selection: $item, matching: .images)
                    .foregroundStyle(.black)
                    .frame(width: 120, height: 35)
                    .background{
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(.white)
                    }
                    .onChange(of: item) { oldItem, newItem in
                        Task { 
                            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                context.insert(Object(x: -offsetWidth, y: -offsetHeight, image: data, size: objectSize, type: objectType))
                                try? context.save()
                            }
                        }
                    }
                
                //Turns on Drawing view where user can draw a new object
                Button(action: {
                    isDrawing = true
                }, label: {
                    Text("Draw")
                        .font(.system(size: 18))
                        .foregroundStyle(.black)
                        .background{
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 80, height: 30)
                                .foregroundStyle(.white)
                        }
                        .frame(width: 80, height: 30)
                })
                
                //Turns on Drawing view where user can draw a new object where only the outline is filled in
                Button(action: {
                    isDrawing = true
                    isSimpleDraw = true
                }, label: {
                    Text("Simple Draw")
                        .font(.system(size: 18))
                        .foregroundStyle(.black)
                        .background{
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 120, height: 30)
                                .foregroundStyle(.white)
                        }
                        .frame(width: 120, height: 30)
                })
                
                //Turns on TempDrawing view where user can make simple drawings which disappear after leaving the TempDrawing view
                Button(action: {
                    tempDrawOn = true
                }, label: {
                    Text("Temp Draw")
                        .font(.system(size: 18))
                        .foregroundStyle(.black)
                        .background{
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 120, height: 30)
                                .foregroundStyle(.white)
                        }
                        .frame(width: 120, height: 30)
                })
                
                //Teleports all objects with the inputted name to near the center of the screen
                Button(action: {
                    let filteredList = objectList.filter { obj in
                        obj.cardType == objectType && objectType != ""
                    }
                    for obj in filteredList {         
                        obj.posY = -offsetHeight - 200
                        obj.posX = -offsetWidth
                    }
                }, label: {
                    Text("Get All")
                        .font(.system(size: 18))
                        .foregroundStyle(.black)
                        .background{
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 80, height: 30)
                                .foregroundStyle(.white)
                        }
                        .frame(width: 80, height: 30)
                })
                
                //Toggles for display settings
                Toggle(isOn: $showObjectDelete, label: {
                    Text("Object Delete:")
                })
                .frame(width: 125, height: 50)
                
                Toggle(isOn: $showColorPicker, label: {
                    Text("Color Picker:")
                })
                .frame(width: 125, height: 50)
                
                Toggle(isOn: $showCopyButton, label: {
                    Text("Copy Button:")
                })
                .frame(width: 125, height: 50)
                
                Toggle(isOn: $showWheel, label: {
                    Text("Wheel:")
                })
                .frame(width: 125, height: 50)
                
                Spacer()
            }
            //End of HStack
        }
        //End of ScrollView
    }
}
