import SwiftUI
import SwiftData
import PhotosUI

struct BottomBar: View {
    @Environment(\.modelContext) var context
    @Query var objectList : [Object]
    @AppStorage("offsetWidth") var offsetWidth : Double = 0.0
    @AppStorage("offsetHeight") var offsetHeight : Double = 0.0
    @State var item : PhotosPickerItem? = nil
    @Binding var objectSize : Double
    @Binding var isDrawing : Bool
    @Binding var objectType : String
    @AppStorage("showObjectDelete") var showObjectDelete : Bool = true
    @AppStorage("showColorPicker") var showColorPicker : Bool = true
    @AppStorage("bottomBarSize") var bottomBarSize = 400.0
    @AppStorage("showWheel") var showWheel = false
    @Binding var isSimpleDraw : Bool
    @Binding var tempDrawOn : Bool
    @AppStorage("showCopyButton") var showCopyButton : Bool = true
    var body: some View {
        ScrollView(.horizontal){
            HStack (spacing: 20){
                TextField("Input Size", value: $objectSize, format: .number)
                    .textFieldStyle(.roundedBorder)
                    .overlay { 
                        Text("Size")
                            .offset(y: -25)
                    }
                    .frame(width: 70, height: 70)
                
                TextField("", text: $objectType)
                    .textFieldStyle(.roundedBorder)
                    .overlay { 
                        Text("Type")
                            .offset(y: -25)
                    }
                    .frame(width: CGFloat(8 * objectType.count) + 50, height: 70)
                
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
                
                Toggle(isOn: $showObjectDelete, label: {
                    Text("Object Delete:")
                })
                .frame(width: 115, height: 50)
                
                Toggle(isOn: $showColorPicker, label: {
                    Text("Color Picker:")
                })
                .frame(width: 115, height: 50)
                
                Toggle(isOn: $showWheel, label: {
                    Text("Wheel:")
                })
                .frame(width: 115, height: 50)
                
                Toggle(isOn: $showCopyButton, label: {
                    Text("Copy Button:")
                })
                .frame(width: 125, height: 50)
                
                Spacer()
            }
            //End of HStack
        }
    }
}
