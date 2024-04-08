//
//  ChordView.swift
//  GuitarTime
//
//  Created by Caroline Viana on 24/08/23.
//

import SwiftUI

struct ChordView: View {
    @State var chordToShow: ChordType {
        didSet {
            changeHandler?(chordToShow)
        }
    }
    
    let stringNames = [6,5,4,3,2,1]
    
    
    let isEditMode: Bool
    let changeHandler: ((_ : ChordType) -> Void)?
    @State var selectedFinger = 4
    
    var body: some View {
        GeometryReader { g in
            VStack {
                if isEditMode {
                    editFunctionality(g.size)
                }
                
                ZStack(alignment: .top) {
                    
                    // Frets and chord marks
                    fretsAndChordMarks(g.size)
                    
                    // Strings
                    drawStrings(g.size)
                    
                    // Circles
                    drawCircles(g.size)
                    
                }
            }
            .position(x:g.frame(in: .local).midX, y: g.frame(in: .local).midY)
        }
    }
    
    func shouldHideCircle(for pos: (Int, Int)) -> Bool {
        guard pos.0 >= 0 else { return true }
        
        let correctedPos = (stringNames[pos.0], pos.1)
        switch correctedPos {
        case (chordToShow.finger1.0, chordToShow.finger1.1): return false
        case (chordToShow.finger2.0, chordToShow.finger2.1): return false
        case (chordToShow.finger3.0, chordToShow.finger3.1): return false
        case (chordToShow.finger4.0, chordToShow.finger4.1): return false
        default: return true
        }
    }
    
    func setCircleOpacity(for pos: (Int, Int)) -> Double {
        guard pos.0 >= 0 else { return 0 }
        
        let correctedPos = (stringNames[pos.0], pos.1)
        switch correctedPos {
        case (chordToShow.finger1.0, chordToShow.finger1.1): return 1
        case (chordToShow.finger2.0, chordToShow.finger2.1): return 1
        case (chordToShow.finger3.0, chordToShow.finger3.1): return 1
        case (chordToShow.finger4.0, chordToShow.finger4.1): return 1
        default:
            if isEditMode { return 0.1 }
            else { return 0 }
        }
    }
    
    func isOpenString(_ string: Int) -> Bool {
        switch string {
        case chordToShow.finger1.0: return false
        case chordToShow.finger2.0: return false
        case chordToShow.finger3.0: return false
        case chordToShow.finger4.0: return false
        default: return true
        }
    }
    
    func fingerToShow(_ pos: (Int, Int)) -> String {
        guard pos.0 >= 0 else { return "0" }
        
        let correctedPos = (stringNames[pos.0], pos.1)
        switch correctedPos {
        case (chordToShow.finger1.0, chordToShow.finger1.1): return "1"
        case (chordToShow.finger2.0, chordToShow.finger2.1): return "2"
        case (chordToShow.finger3.0, chordToShow.finger3.1): return "3"
        case (chordToShow.finger4.0, chordToShow.finger4.1): return "4"
        default: return "0"
        }
    }
    
    // MARK: Edit Mode functions
    
    func toggleMutedString(forString: Int) {
        if isEditMode {
            let s = stringNames[forString]
            if chordToShow.mutedStrings.contains(s) {
                chordToShow.mutedStrings.removeAll(where: { $0 == stringNames[forString] })
            } else {
                chordToShow.mutedStrings.append(s)
            }
            
        }
    }
    
    func changeFingerPosition(to pos: (Int, Int)) {
        let correctedPos = (stringNames[pos.0], pos.1)
        clearPosition(correctedPos)
        switch selectedFinger {
        case 1: chordToShow.finger1 = correctedPos
        case 2: chordToShow.finger2 = correctedPos
        case 3: chordToShow.finger3 = correctedPos
        case 4: chordToShow.finger4 = correctedPos
        default: break
        }
        
        if chordToShow.mutedStrings.contains(stringNames[pos.0]) {
            toggleMutedString(forString: pos.0)
        }
    }
    
    func clearPosition(_ pos: (Int, Int)) {
        switch pos {
        case (chordToShow.finger1.0, chordToShow.finger1.1):
            chordToShow.finger1 = (0,0)
        case (chordToShow.finger2.0, chordToShow.finger2.1):
            chordToShow.finger2 = (0,0)
        case (chordToShow.finger3.0, chordToShow.finger3.1):
            chordToShow.finger3 = (0,0)
        case (chordToShow.finger4.0, chordToShow.finger4.1):
            chordToShow.finger4 = (0,0)
        default: break
        }
    }
    
    func toggleIsBarre() {
        chordToShow.isBarre.toggle()
        chordToShow.finger1 = (0,0)
        
        if chordToShow.isBarre {
            clearPosition((0,1))
            clearPosition((1,1))
            clearPosition((2,1))
            clearPosition((3,1))
            clearPosition((4,1))
            clearPosition((5,1))
            
            if selectedFinger == 1 {
                selectedFinger = 2
            }
        }
        
        
    }
    
    
    func colorStroke(_ j: Int) -> Color {
        selectedFinger != j+1
        ? AppColors.brandDark
        : .clear
    }
    
    func colorStroke2(_ j: Int) -> Color {
        selectedFinger == j+1
        ? AppColors.brandDark
        : .clear
    }
    
    func cococ(_ j: Int) -> Color {
        selectedFinger == j+1
        ? AppColors.brandLight
        : AppColors.brandDark
    }
    
    
    
    
    func editFunctionality(_ g: CGSize) -> some View {
        let w = g.width
        
        return Group {
            HStack {
                ForEach(0..<4) { j in
                    ZStack {
                        Circle()
                            .strokeBorder(colorStroke(j), lineWidth: w/196)
                            .background(
                                Circle()
                                    .foregroundColor(colorStroke2(j))
                            )
                            .frame(width: w / 9, height: w / 9)
                        
                        Text("\(j + 1)")
                            .monospaced()
                            .foregroundColor(cococ(j))
                            .font(.system(size: w / 16))
                    }
                    .opacity(
                        (j+1 != 1 || !chordToShow.isBarre)
                        ? 1
                        : 0.2
                    )
                    .padding(.horizontal, 2)
                    .onTapGesture {
                        if j+1 != 1 || !chordToShow.isBarre {
                            selectedFinger = j+1
                        }
                    }
                    
                }
            }
            
            ZStack {
                RoundedRectangle(cornerSize: CGSize(width: w / 7.8, height: w / 7.8))
                    .strokeBorder(chordToShow.isBarre ? .clear : AppColors.brandDark, lineWidth: w/196)
                    .background(
                        RoundedRectangle(cornerSize: CGSize(width: w / 7.8, height: w / 7.8))
                            .foregroundColor(chordToShow.isBarre ? AppColors.brandDark : .clear)
                    )
                
                
                    .frame(width: w/2.3, height: w/9.8)
                
                Text("isBarreLbl")
                    .monospaced()
                    .foregroundColor(chordToShow.isBarre
                                     ? AppColors.brandLight
                                     : AppColors.brandDark)
                    .font(.system(size: w / 16))
                
            }
            .padding(.horizontal, w/196)
            .onTapGesture {
                toggleIsBarre()
            }
        }
    }
    
    func fretsAndChordMarks(_ g: CGSize) -> some View {
        let w = g.width
        
        return VStack {
            HStack {
                ForEach(0..<6) { n in
                    
                    if chordToShow.mutedStrings.contains(stringNames[n]) {
                        Text("xChordMark").onTapGesture {
                            toggleMutedString(forString: n)
                        }
                    } else if isOpenString(stringNames[n]) {
                        Text("oChordMark").onTapGesture {
                            toggleMutedString(forString: n)
                        }
                    }
                    else {
                        Text(" ")
                            .onTapGesture {
                                toggleMutedString(forString: n)
                            }
                    }
                    
                }
                .monospaced()
                .font(.system(size: w/9.8))
                .padding(.horizontal, w/262)
            }
            
            Rectangle()
                .frame(minWidth: 140)
                .frame(width: w/1.7, height: w/11.2)
                .padding(.top, -(w/13.1))
                .padding(.bottom, w/19.65)
            
            // Draw the fret dividers
            ForEach(0..<5) { _ in
                Rectangle()
                    .fill(.gray.opacity(0.8))
                    .frame(minWidth: 125)
                    .frame(width: w/1.87, height: w/98.25)
                    .padding(.vertical, w/19.65)
            }
        }
        
    }
    
    func drawStrings(_ g: CGSize) -> some View {
        return HStack {
            ForEach(0..<6) { _ in
                // Draw the strings
                Rectangle()
                    .frame(minHeight: 160)
                    .frame(width: g.width/98.25, height: g.width/1.4)
                    .padding(.horizontal, g.width/32.75)
            }
        }.padding(.top, g.width/5.2 +
                  (g.width/11.2 < 20 ? 9 : 0)
        )
    }
    
    func drawCircles(_ g: CGSize) -> some View {
        let w = g.width
        
        return VStack {
            // Each fret
            ForEach(0..<5) { i in
                HStack {
                    // Each string
                    if i == 0 && chordToShow.isBarre {
                        Rectangle()
                            .fill(.black.opacity(0.6))
                            .cornerRadius(w/46)
                            .frame(minWidth: 125)
                            .frame(width: w/1.82, height: w/17.86)
                    } else {
                        ForEach(0..<6) { j in
                            ZStack {
                                Circle()
                                    .frame(width: w/15.5)
                                
                                Text(fingerToShow((j, i+1)))
                                    .monospaced()
                                    .foregroundColor(Color(UIColor.systemBackground))
                                    .font(.system(size: w/24.4))
                                
                            }
                            .padding(.horizontal, w/350)
                            .opacity(setCircleOpacity(for: (j, i+1)))
                            .onTapGesture {
                                changeFingerPosition(to: (j, i+1))
                            }
                            
                            
                        }
                    }
                    
                    
                }
                .padding(.bottom,
                         (g.width/11.2 < 20 ? w/16.5 : w/19.65)

                )
            }
        }
        .padding(.top,
                 (g.width/11.2 < 20 ? g.width/4.1 : w/4.25)

        )
    }
    
}

struct ChordView_Previews: PreviewProvider {
    static var previews: some View {
        
        VStack {
            ChordView(chordToShow: chordType3, isEditMode: true, changeHandler: nil)
                .frame(width: 300, height: 300)
            
            Spacer()
            
            VStack {
                ChordView(chordToShow: chordType3, isEditMode: true, changeHandler: nil)
            }.frame(width: 200, height: 200)
            
            Spacer()
        }

    }
}
