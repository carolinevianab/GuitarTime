//
//  PersistenceService.swift
//  GuitarTime
//
//  Created by Caroline Viana on 24/08/23.
//

import SwiftUI
import CoreData

struct PersistenceService {
    static func convertToClasstype(content: FetchedResults<GuitarClass>) -> [GuitarClassType] {
        var classList: [GuitarClassType] = []
        
        for singleClass in content {
            let chords = singleClass.classchords?.split(separator: ",") ?? []
            
            classList.append(GuitarClassType(id: singleClass.classid ?? UUID(),
                                             classTitle: singleClass.classtitle ?? "",
                                             classDescription: singleClass.classdescription ?? "",
                                             classChords: chords.map({ String($0) }),
                                             classType: ClassType(rawValue: singleClass.classtype) ?? .generic,
                                             duration: singleClass.duration,
                                             needsMetronome: singleClass.metronome,
                                             saveStatistics: singleClass.savestats))
        }
        
        return classList
    }
    
    static func convertSingleToGuitarClass(content: GuitarClassType, context: NSManagedObjectContext) -> GuitarClass {
        let m = ""
        
        let item = GuitarClass(context: context)
        item.classid = content.id
        item.classtitle = content.classTitle
        item.classdescription = content.classDescription
        item.classchords = content.classChords.reduce(m, { t, tt in return t + "," + tt})
        item.classtype = content.classType.rawValue
        item.duration = content.duration
        item.metronome = content.needsMetronome
        item.savestats = content.saveStatistics
        
        return item
    }
    
    
    static func convertToModuleType(content: FetchedResults<GuitarModule>, classes: [GuitarClassType]) -> [GuitarModuleType] {
        var moduleList: [GuitarModuleType] = []
        let allClasses = classes
        
        for module in content {
            let a = (module.moduleclasses?.split(separator: ",") ?? []).map({ String($0) })
            
            var moduleClasses: [GuitarClassType] = []
            
            for classid in a {
                for guitarClass in allClasses {
                    if classid == guitarClass.id.uuidString {
                        moduleClasses.append(guitarClass)
                        break
                    }
                }
            }
            
            guard moduleClasses.count == a.count else { continue }
            
            moduleList.append(GuitarModuleType(id: UUID(),
                                               moduleTitle: module.moduletitle ?? "Erro",
                                               moduleGrade: JustinGuitarGrade(rawValue: module.modulegrade) ?? .Grade1,
                                               moduleClasses: moduleClasses))
        }
        
        return moduleList
    }
    
    
    static func convertSingleToGuitarModule(content: GuitarModuleType, context: NSManagedObjectContext) -> GuitarModule {
        let m = ""
        
        let item = GuitarModule(context: context)
        item.moduleclasses = content.moduleClasses.reduce(m, { t, tt in return t + "," + tt.id.uuidString})
        item.modulegrade = content.moduleGrade.rawValue
        item.moduletitle = content.moduleTitle
        
        return item
    }
    
    static func convertToChordType(content: FetchedResults<Chord>) -> [ChordType] {
        var chordList: [ChordType] = []
        
        
        for chord in content {
            let muted = (chord.mutedStrings?.split(separator: ",") ?? []).map({ String($0) })
            let ints = muted.compactMap({ Int($0) })
            
            let item = ChordType(id: UUID(),
                                 chordName: chord.chordname ?? "",
                                 chordCategory: ChordCategory(rawValue: chord.category) ?? .A,
                                 isFavorited: chord.favorited,
                                 mutedStrings: ints,
                                 isBarre: chord.barre,
                                 finger1: convertIntegerToTuple(chord.finger1),
                                 finger2: convertIntegerToTuple(chord.finger2),
                                 finger3: convertIntegerToTuple(chord.finger3),
                                 finger4: convertIntegerToTuple(chord.finger4))
            
            chordList.append(item)
        }
        
        return chordList
    }
    
    static func convertIntegerToTuple(_ integer: Int16) -> (Int, Int) {
        let str = String(integer)
        
        let t1 = String(str[str.startIndex])
        let t2 = String(str[str.index(before: str.endIndex)])
        
        guard let a = Int(t1), let b = Int(t2) else { return (0, 0) }
        
        return (a, b)
        
       
    }
    
    static func convertSingleToChord(content: ChordType, context: NSManagedObjectContext) -> Chord {
        let m = ""
        
        let item = Chord(context: context)
        item.chordname = content.chordName
        item.category = content.chordCategory.rawValue
        item.favorited = content.isFavorited
        item.barre = content.isBarre
        item.finger1 = convertTupleToInteger(content.finger1)
        item.finger2 = convertTupleToInteger(content.finger2)
        item.finger3 = convertTupleToInteger(content.finger3)
        item.finger4 = convertTupleToInteger(content.finger4)
        item.mutedStrings = content.mutedStrings.reduce(m, { t, tt in return t + "," + String(tt)})
        
        return item
    }
    
    static func convertTupleToInteger(_ tuple: (Int, Int)) -> Int16 {
        let t1 = tuple.0
        let t2 = tuple.1
        
        let str = "\(t1)\(t2)"
        let i = Int16(str) ?? 0
        
        return i
    }
    
    static func convertToCompletedType(content: FetchedResults<CompletedForStats>) -> [CompletedForStatistics] {
        var completeList: [CompletedForStatistics] = []
        
        for lesson in content {
            // C,C:1
            var dictOmc: [String: Int] = [:]
            
            if !(lesson.omc?.isEmpty ?? true) {
                let omc = (lesson.omc?.split(separator: ":") ?? []).map({ String($0) })
                dictOmc = [omc.first ?? "Erro": Int(omc.last ?? "0") ?? 0]
            }
            
            var dictPfc: [String: Int] = [:]
            if !(lesson.pfc?.isEmpty ?? true) {
                let pfc = (lesson.pfc?.split(separator: ":") ?? []).map({ String($0) })
                dictPfc = [pfc.first ?? "Erro": Int(pfc.last ?? "0") ?? 0]
            }
            
            let item = CompletedForStatistics(id: UUID(),
                                              completedModule: lesson.completedModule ?? "Conversion Class Error",
                                              omc: dictOmc,
                                              pfc: dictPfc,
                                              classTimeSeconds: Int(lesson.totalTimeSeconds),
                                              doneDate: lesson.doneDate ?? Date())
            
            completeList.append(item)
        }
        
        return completeList
    }
    
    
    static func convertSingleToCompletedClass(content: CompletedForStatistics, context: NSManagedObjectContext) -> CompletedForStats {
        let item = CompletedForStats(context: context)
        
        item.completedModule = content.completedModule
        item.totalTimeSeconds = Int16(content.classTimeSeconds)
        item.omc = convertDictionaryToString(dict: content.omc)
        item.pfc = convertDictionaryToString(dict: content.pfc)
        item.doneDate = content.doneDate
        
        return item
    }
    
    static func convertDictionaryToString(dict: Dictionary<String, Int>) -> String {
        var acc = ""
        let keys = dict.keys
        
        for key in keys {
            acc += key + ":" + String(dict[key] ?? 0)
        }
        
        return acc
    }
    
}
