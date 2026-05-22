//
//  Notepad.swift
//  Counter
//
//  Created by Mark Nguyen on 5/21/26.
//

import SwiftUI

struct Notepad: View {
    @AppStorage("notes") var notes = ""
    @State private var tempNotes = ""
    @AppStorage("notesOffsetX") var notesOffsetX = 250.0
    @AppStorage("notesOffsetY") var notesOffsetY = 250.0
    @State var currentNotesOffsetX = 0.0
    @State var currentNotesOffsetY = 0.0
    var body: some View {
        ZStack {
            TextEditor(text: $tempNotes)
                .frame(width: 190, height: 290)
                .border(.black, width: 4)
                .offset(x: currentNotesOffsetX - 120, y: currentNotesOffsetY)
                .onAppear {
                    tempNotes = notes
                    currentNotesOffsetX = notesOffsetX
                    currentNotesOffsetY = notesOffsetY
                }
                .onDisappear {
                    notes = tempNotes
                }
            //Arrows allowing for dragging notepad
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
                            currentNotesOffsetX = gest.location.x
                            currentNotesOffsetY = gest.location.y
                        })
                        .onEnded({ _ in
                            notesOffsetX = currentNotesOffsetX
                            notesOffsetY = currentNotesOffsetY
                        })
                )
        }
    }
}
