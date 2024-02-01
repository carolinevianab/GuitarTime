//
//  PersistenceDataModels.swift
//  GuitarTime
//
//  Created by Caroline Viana on 23/08/23.
//

import Foundation

struct ChordType: Identifiable, Codable {
    var id: UUID
    
    var chordName: String
    var chordCategory: ChordCategory
    var isFavorited: Bool
    var mutedStrings: [Int]
    
    var isBarre: Bool
    var finger1: (Int, Int)
    var finger2: (Int, Int)
    var finger3: (Int, Int)
    var finger4: (Int, Int)
    
    static func emptyChord() -> ChordType {
        ChordType(id: UUID(),
                  chordName: "",
                  chordCategory: .C,
                  isFavorited: false,
                  mutedStrings: [],
                  isBarre: false,
                  finger1: (0,0),
                  finger2: (0,0),
                  finger3: (0,0),
                  finger4: (0,0))
    }
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case chordName = "chordName"
        case chordCategory = "chordCategory"
        case isFavorited = "isFavorited"
        case mutedStrings = "mutedStrings"
        case isBarre = "isBarre"
        case finger1 = "finger1"
        case finger2 = "finger2"
        case finger3 = "finger3"
        case finger4 = "finger4"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(chordName, forKey: .chordName)
        try container.encode(chordCategory, forKey: .chordCategory)
        try container.encode(isFavorited, forKey: .isFavorited)
        try container.encode(mutedStrings, forKey: .mutedStrings)
        try container.encode(isBarre, forKey: .isBarre)
        try container.encode(PersistenceService.convertTupleToInteger(finger1), forKey: .finger1)
        try container.encode(PersistenceService.convertTupleToInteger(finger2), forKey: .finger2)
        try container.encode(PersistenceService.convertTupleToInteger(finger3), forKey: .finger3)
        try container.encode(PersistenceService.convertTupleToInteger(finger4), forKey: .finger4)
    }
    
    init( id: UUID,
     chordName: String,
     chordCategory: ChordCategory,
     isFavorited: Bool,
     mutedStrings: [Int],
     isBarre: Bool,
     finger1: (Int, Int),
     finger2: (Int, Int),
     finger3: (Int, Int),
          finger4: (Int, Int)) {
        self.id = id
        self.chordName = chordName
        self.chordCategory = chordCategory
        self.isFavorited = isFavorited
        self.mutedStrings = mutedStrings
        self.isBarre = isBarre
        self.finger1 = finger1
        self.finger2 = finger2
        self.finger3 = finger3
        self.finger4 = finger4
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decode(UUID.self, forKey: .id)
        chordName = try values.decode(String.self, forKey: .chordName)
        chordCategory = try values.decode(ChordCategory.self, forKey: .chordCategory)
        isFavorited = try values.decode(Bool.self, forKey: .isFavorited)
        mutedStrings = try values.decode([Int].self, forKey: .mutedStrings)
        isBarre = try values.decode(Bool.self, forKey: .isBarre)
        finger1 = PersistenceService.convertIntegerToTuple(try values.decode(Int16.self, forKey: .finger1))
        finger2 = PersistenceService.convertIntegerToTuple(try values.decode(Int16.self, forKey: .finger2))
        finger3 = PersistenceService.convertIntegerToTuple(try values.decode(Int16.self, forKey: .finger3))
        finger4 = PersistenceService.convertIntegerToTuple(try values.decode(Int16.self, forKey: .finger4))
    }
}


struct GuitarClassType: Identifiable, Codable {
    var id: UUID
    var classTitle: String
    var classDescription: String
    var classChords: [String]
    var classType: ClassType
    var duration: Int16
    var needsMetronome: Bool
    var saveStatistics: Bool
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case classTitle = "classTitle"
        case classDescription = "classDescription"
        case classChords = "classChords"
        case classType = "classType"
        case duration = "duration"
        case needsMetronome = "needsMetronome"
        case saveStatistics = "saveStatistics"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(classTitle, forKey: .classTitle)
        try container.encode(classDescription, forKey: .classDescription)
        try container.encode(classChords, forKey: .classChords)
        try container.encode(classType, forKey: .classType)
        try container.encode(duration, forKey: .duration)
        try container.encode(needsMetronome, forKey: .needsMetronome)
        try container.encode(saveStatistics, forKey: .saveStatistics)
    }
    
    init( id: UUID,
          classTitle: String,
          classDescription: String,
          classChords: [String],
          classType: ClassType,
          duration: Int16,
          needsMetronome: Bool,
          saveStatistics: Bool) {
        self.id = id
        self.classTitle = classTitle
        self.classDescription = classDescription
        self.classChords = classChords
        self.classType = classType
        self.duration = duration
        self.needsMetronome = needsMetronome
        self.saveStatistics = saveStatistics
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decode(UUID.self, forKey: .id)
        classTitle = try values.decode(String.self, forKey: .classTitle)
        classDescription = try values.decode(String.self, forKey: .classDescription)
        classChords = try values.decode([String].self, forKey: .classChords)
        classType = try values.decode(ClassType.self, forKey: .classType)
        duration = try values.decode(Int16.self, forKey: .duration)
        needsMetronome = try values.decode(Bool.self, forKey: .needsMetronome)
        saveStatistics = try values.decode(Bool.self, forKey: .saveStatistics)
    }
}

struct GuitarModuleType: Identifiable, Codable {
    var id: UUID
    var moduleTitle: String
    var moduleGrade: JustinGuitarGrade
    var moduleClasses: [GuitarClassType]
    
    static func emptyModule() -> GuitarModuleType {
        GuitarModuleType(id: UUID(), moduleTitle: "", moduleGrade: .none, moduleClasses: [])
    }
}

enum ChordCategory: Int16, CaseIterable, Codable {
    case C = 1
    case D = 2
    case E = 3
    case F = 4
    case G = 5
    case A = 6
    case B = 7
    
    var chordName: String {
        switch self {
        case .C:
            return "C"
        case .D:
            return "D"
        case .E:
            return "E"
        case .F:
            return "F"
        case .G:
            return "G"
        case .A:
            return "A"
        case .B:
            return "B"
        }
    }
    
    enum CodingKeys: Int, CodingKey {
        case C = 1
        case D = 2
        case E = 3
        case F = 4
        case G = 5
        case A = 6
        case B = 7
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.singleValueContainer().decode(Int.self)
        
        switch values {
        case 1: self = .C
        case 2: self = .D
        case 3: self = .E
        case 4: self = .F
        case 5: self = .G
        case 6: self = .A
        case 7: self = .B
        default: self = .C
        }
        
            
    }
  
}


enum ClassType: Int16, CaseIterable, Codable {
    case generic = 0
    case PFC = 1
    case singleCPP = 2
    case oneMinChanges = 3
    case songPractice = 4
    case riffFun = 5
    case multipleCPP = 6
    case strummingPractice = 7
    case repertourRev = 8
    
    var classTitle: String {
        switch self {
        case .generic:              return "Gen"
        case .PFC:                  return "Perfect Fast Changes"
        case .singleCPP:            return "Chord Perfect Practice"
        case .oneMinChanges:        return "1 Minute Changes"
        case .songPractice:         return "Song Practice"
        case .riffFun:              return "Riff Fun"
        case .multipleCPP:          return "Exploring New Chords"
        case .strummingPractice:    return "Strumming Practice"
        case .repertourRev:         return "Repertour Revision"
        }
    }
}

enum JustinGuitarGrade: Int16, CaseIterable, Codable {
    case none = -1
    case Grade1 = 1
    case Grade2 = 2
    
    
    var gradeTitle: String {
        switch self {
        case .Grade1:
            return "Grade 1"
        case .Grade2:
            return "Grade 2"
        case .none:
            return "Select one"
        }
    }
}

struct ModulesByGrade: Identifiable {
    var id: UUID
    let grade: JustinGuitarGrade
    let modules: [GuitarModuleType]
}

struct ChordsByCategory: Identifiable {
    var id: UUID
    let category: ChordCategory
    let chords: [ChordType]
}


struct Utils {
    static func convertSecondsToString(_ seconds: Int) -> String {
        let min = seconds / 60
        let sec = seconds % 60
        
        let strSec = sec < 10 ? "0" : ""
        
        return "\(min):\(strSec)\(sec)"
    }
}

struct CompletedForStatistics: Identifiable, Codable {
    var id: UUID
    var completedModule: String
    var omc: [String: Int]
    var pfc: [String: Int]
    var classTimeSeconds: Int
    var doneDate: Date
    
    static func emptyData() -> CompletedForStatistics {
        CompletedForStatistics(id: UUID(), completedModule: "", omc: [:], pfc: [:], classTimeSeconds: 0, doneDate: Date())
    }
}

struct AllContentData: Codable {
    var classes: [GuitarClassType]
    var modules: [GuitarModuleType]
    var chords: [ChordType]
    var practiceData: [CompletedForStatistics]
    
//    let getShit: () async -> URL
    
    func createURL() async -> Data? {
        guard let shortURL = fetch() else {
            return "a".data(using: .utf8)
        }
        return shortURL.data(using: .utf8)
    }
    
    func fetch() -> String? {
        return "a"
    }
}


