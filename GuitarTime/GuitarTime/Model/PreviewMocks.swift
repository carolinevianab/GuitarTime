//
//  PreviewMocks.swift
//  GuitarTime
//
//  Created by Caroline Viana on 24/08/23.
//

import Foundation


let classType1 = GuitarClassType(id: UUID(),
                                 classTitle: "Test Lesson 1",
                                 classDescription: "This lesson uses the chords A and B, and has a duration of 8 seconds. It's also a PFC.",
                                 classChords: ["A", "B"],
                                 classType: .PFC,
                                 duration: 8,
                                 needsMetronome: true,
                                 saveStatistics: false)

let classType2 = GuitarClassType(id: UUID(),
                                 classTitle: "Test Lesson 2",
                                 classDescription: "This lesson uses the chords C and Em, and has a duration of 68 seconds. It's also a gen.",
                                 classChords: ["C", "Em"],
                                 classType: .generic,
                                 duration: 68,
                                 needsMetronome: false,
                                 saveStatistics: false)

let classType3 = GuitarClassType(id: UUID(),
                                 classTitle: "Test Lesson 3",
                                 classDescription: "This lesson uses the chords A and B, and has a duration of 68 seconds. It's also a gen.",
                                 classChords: ["A", "B"],
                                 classType: .generic,
                                 duration: 68,
                                 needsMetronome: false,
                                 saveStatistics: false)



let moduleType1 = GuitarModuleType(id: UUID(), moduleTitle: "M1", moduleGrade: .Grade1, moduleClasses: [classType1, classType2, classType3])
let moduleType2 = GuitarModuleType(id: UUID(), moduleTitle: "M2", moduleGrade: .Grade1, moduleClasses: [classType1, classType2, classType3])
let moduleType3 = GuitarModuleType(id: UUID(), moduleTitle: "M3", moduleGrade: .Grade2, moduleClasses: [classType1, classType2, classType3])
let moduleType4 = GuitarModuleType(id: UUID(), moduleTitle: "M4", moduleGrade: .Grade2, moduleClasses: [classType1, classType2, classType3])

// String, fret
let chordType1 = ChordType(id: UUID(), chordName: "Em", chordCategory: .E, isFavorited: false, mutedStrings: [6], isBarre: false, finger1: (0,0), finger2: (1,1), finger3: (2,2), finger4: (3,3))

let chordType2 = ChordType(id: UUID(), chordName: "E", chordCategory: .E, isFavorited: false, mutedStrings: [6,4,1], isBarre: false, finger1: (3,1), finger2: (5,2), finger3: (4,2), finger4: (0,0))

let chordType3 = ChordType(id: UUID(), chordName: "A", chordCategory: .A, isFavorited: false, mutedStrings: [6], isBarre: false, finger1: (4,2), finger2: (3,2), finger3: (2,2), finger4: (0,0))


let dayCompleted1 = CompletedForStatistics(id: UUID(), completedModule: "M1", omc: ["C,D": 60], pfc: [:], classTimeSeconds: 904, doneDate: Date())
let dayCompleted2 = CompletedForStatistics(id: UUID(), completedModule: "M1", omc: [:], pfc: ["C,D": 55], classTimeSeconds: 904, doneDate: Date())
let dayCompleted3 = CompletedForStatistics(id: UUID(), completedModule: "M1", omc: [:], pfc: ["C,D": 42], classTimeSeconds: 810, doneDate: Date(timeIntervalSince1970: TimeInterval(integerLiteral: 1693922130)))
let dayCompleted4 = CompletedForStatistics(id: UUID(), completedModule: "M1", omc: ["C,D": 74], pfc: [:], classTimeSeconds: 810, doneDate: Date(timeIntervalSince1970: TimeInterval(integerLiteral: 1693922130)))
let dayCompleted5 = CompletedForStatistics(id: UUID(), completedModule: "M4", omc: [:], pfc: [:], classTimeSeconds: 327, doneDate: Date())

let dayCompleted6 = CompletedForStatistics(id: UUID(), completedModule: "M1", omc: ["C,D": 60], pfc: [:], classTimeSeconds: 904, doneDate: Date(timeIntervalSince1970: TimeInterval(integerLiteral: 1693922930)))
let dayCompleted7 = CompletedForStatistics(id: UUID(), completedModule: "M1", omc: ["C,D": 22], pfc: [:], classTimeSeconds: 904, doneDate: Date(timeIntervalSince1970: TimeInterval(integerLiteral: 1694021830)))
let dayCompleted8 = CompletedForStatistics(id: UUID(), completedModule: "M1", omc: ["C,D": 42], pfc: [:], classTimeSeconds: 904, doneDate: Date(timeIntervalSince1970: TimeInterval(integerLiteral: 1694123630)))
let dayCompleted9 = CompletedForStatistics(id: UUID(), completedModule: "M1", omc: ["C,D": 10], pfc: [:], classTimeSeconds: 904, doneDate: Date(timeIntervalSince1970: TimeInterval(integerLiteral: 1694225430)))
let dayCompleted10 = CompletedForStatistics(id: UUID(), completedModule: "M1", omc: ["C,D": 17], pfc: [:], classTimeSeconds: 904, doneDate: Date(timeIntervalSince1970: TimeInterval(integerLiteral: 1694326330)))
let dayCompleted11 = CompletedForStatistics(id: UUID(), completedModule: "M1", omc: ["C,D": 34], pfc: [:], classTimeSeconds: 904, doneDate: Date(timeIntervalSince1970: TimeInterval(integerLiteral: 1694427230)))
let dayCompleted12 = CompletedForStatistics(id: UUID(), completedModule: "M1", omc: ["C,D": 28], pfc: [:], classTimeSeconds: 904, doneDate: Date(timeIntervalSince1970: TimeInterval(integerLiteral: 1694528130)))
let dayCompleted13 = CompletedForStatistics(id: UUID(), completedModule: "M1", omc: ["C,D": 30], pfc: [:], classTimeSeconds: 904, doneDate: Date(timeIntervalSince1970: TimeInterval(integerLiteral: 1694629030)))
let dayCompleted14 = CompletedForStatistics(id: UUID(), completedModule: "M1", omc: ["C,D": 30], pfc: [:], classTimeSeconds: 904, doneDate: Date(timeIntervalSince1970: TimeInterval(integerLiteral: 1694729030)))
