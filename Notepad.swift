import SwiftUI

struct Notepad: View {
    //Notepad Contents
    @AppStorage("notes") private var notes = "Insert Notes"
    @State private var tempNotes = "Insert Notes"
    
    //Vars for notepad location and dragging logic
    @AppStorage("notesOffsetX") private var notesOffsetX = 0.0
    @AppStorage("notesOffsetY") private var notesOffsetY = 0.0
    @State private var currentNotesOffsetX = 0.0
    @State private var currentNotesOffsetY = 0.0
    @State private var dragStartX = 0.0
    @State private var dragStartY = 0.0
    var body: some View {
        ZStack {
            TextEditor(text: $tempNotes)
                .frame(width: 190, height: 290)
                .border(.black, width: 4)
                .offset(x: currentNotesOffsetX - 120, y: currentNotesOffsetY)
                //Notepad updates to get saved values when it appears
                .onAppear {
                    tempNotes = notes
                    
                    currentNotesOffsetX = notesOffsetX
                    currentNotesOffsetY = notesOffsetY
                    
                    dragStartX = notesOffsetX
                    dragStartY = notesOffsetY
                }
                //Saves notepad content when it disappears
                .onDisappear {
                    notes = tempNotes
                }
            //Arrows for dragging notepad
            Image("DRAG_VECTOR_ARROWS", bundle: .module)
                .resizable()
                //Background and border of image
                .background {
                    Circle()
                        .foregroundColor(.black)
                    Circle()
                        .foregroundColor(.white)
                        .frame(width: 37, height: 37)
                }
                .frame(width: 40, height: 40)
                //Positions based on vars and changing those vars based on a drag gesture
                .offset(x: currentNotesOffsetX, y: currentNotesOffsetY)
                .gesture(
                    DragGesture()
                        .onChanged({ gest in
                            currentNotesOffsetX = dragStartX + gest.translation.width
                            currentNotesOffsetY = dragStartY + gest.translation.height
                        })
                        .onEnded({ _ in
                            dragStartX = currentNotesOffsetX
                            dragStartY = currentNotesOffsetY
                            
                            notesOffsetX = currentNotesOffsetX
                            notesOffsetY = currentNotesOffsetY
                        })
                )
        }
        //End of ZStack
    }
}
