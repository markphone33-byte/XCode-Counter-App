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
    @AppStorage("notesPosX") var notesPosX = 250.0
    @AppStorage("notesPosY") var notesPosY = 250.0
    @State var currentNotesPos = CGPointMake(0, 0)
    var body: some View {
        ZStack {
            TextEditor(text: $tempNotes)
                .frame(width: 190, height: 290)
                .border(.black, width: 4)
                .position(currentNotesPos.y == 0 && currentNotesPos.x == 0 ? CGPointMake(notesPosX, notesPosY) : currentNotesPos)
                .offset(x: -120)
                .onAppear {
                    tempNotes = notes
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
                .position(currentNotesPos.y == 0 && currentNotesPos.x == 0 ? CGPointMake(notesPosX, notesPosY) : currentNotesPos)
                .gesture(
                    DragGesture()
                        .onChanged({ gest in
                            currentNotesPos = gest.location
                        })
                        .onEnded({ _ in
                            notesPosX = currentNotesPos.x
                            notesPosY = currentNotesPos.y
                        })
                )
        }
    }
}
