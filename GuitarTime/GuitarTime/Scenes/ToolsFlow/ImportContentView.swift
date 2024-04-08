//
//  ImportContentView.swift
//  GuitarTime
//
//  Created by Caroline Viana on 07/09/23.
//

import SwiftUI
import UniformTypeIdentifiers

struct ImportContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    enum ImportingConfig {
        case none
        case classes
        case modules
        case chords
        case practices
        case all
    }
    
    @State var showFileImp = false
    @State var importingNow: ImportingConfig = .none
    let decoder = JSONDecoder()
    
    var body: some View {
        List {
            Button("importClasses") {
                    importingNow = .classes
                    showFileImp = true
                }
            
            Button("importModules") {
                    importingNow = .modules
                    showFileImp = true
                }
            
            Button("importChords") {
                    importingNow = .chords
                    showFileImp = true
                }
            
            Button("importPracticeData") {
                    importingNow = .practices
                    showFileImp = true
                }
            
            Button("importAllContent") {
                    importingNow = .all
                    showFileImp = true
                }
            
        }
        .fileImporter(isPresented: $showFileImp, allowedContentTypes: [.commaSeparatedText, .text], allowsMultipleSelection: false) { result in
            
            switch result {
            case .success(let fileURLs):
                guard let fileURL = fileURLs.first else {return}
                print(fileURL)
                if fileURL.startAccessingSecurityScopedResource() {
                    guard let fileData = try? Data(contentsOf: fileURL) else {
                        return
                    }
                    
                    let k = String(data: fileData, encoding: .utf8)
                    print(String(describing: k))
                    fileURL.stopAccessingSecurityScopedResource()
                    
                    switch importingNow {
                        
                    case .none:
                        break
                    case .classes:
                        importClasses(fileData)
                    case .modules:
                        importModules(fileData)
                    case .chords:
                        importChords(fileData)
                    case .practices:
                        importPracticeData(fileData)
                    case .all:
                        importAllContent(fileData)
                    }
                }
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    func importClasses(_ data: Data) {
        var content: [GuitarClassType] = []
        
        do {
            let qq = try decoder.decode([GuitarClassType].self, from: data)
            print(qq)
            content = qq
        }
        catch(let error) {
            print(error)
        }
        
        for lesson in content {
            _ = PersistenceService.convertSingleToGuitarClass(content: lesson, context: viewContext)
        }
        
        saveContext()
    }
    
    func importModules(_ data: Data) {
        var content: [GuitarModuleType] = []
        
        do {
            let qq = try decoder.decode([GuitarModuleType].self, from: data)
            print(qq)
            content = qq
        }
        catch(let error) {
            print(error)
        }
        
        for lesson in content {
            _ = PersistenceService.convertSingleToGuitarModule(content: lesson, context: viewContext)
        }
        
        saveContext()
    }
    
    func importChords(_ data: Data) {
        var content: [ChordType] = []
        
        do {
            let qq = try decoder.decode([ChordType].self, from: data)
            print(qq)
            content = qq
        }
        catch(let error) {
            print(error)
        }
        
        for lesson in content {
            _ = PersistenceService.convertSingleToChord(content: lesson, context: viewContext)
        }
        
        saveContext()
        
    }
    
    func importPracticeData(_ data: Data) {
        var content: [CompletedForStatistics] = []
        
        do {
            let qq = try decoder.decode([CompletedForStatistics].self, from: data)
            print(qq)
            content = qq
        }
        catch(let error) {
            print(error)
        }
        
        for lesson in content {
            _ = PersistenceService.convertSingleToCompletedClass(content: lesson, context: viewContext)
        }
        
        saveContext()
    }
    
    func importAllContent(_ data: Data) {
        var content: AllContentData? = nil
        
        do {
            let qq = try decoder.decode(AllContentData.self, from: data)
            print(qq)
            content = qq
        }
        catch(let error) {
            print(error)
        }
        
        guard let content = content else {return}
        
        for lesson in content.chords {
            _ = PersistenceService.convertSingleToChord(content: lesson, context: viewContext)
        }
        
        for lesson in content.modules {
            _ = PersistenceService.convertSingleToGuitarModule(content: lesson, context: viewContext)
        }
        
        for lesson in content.classes {
            _ = PersistenceService.convertSingleToGuitarClass(content: lesson, context: viewContext)
        }
        
        for lesson in content.practiceData {
            _ = PersistenceService.convertSingleToCompletedClass(content: lesson, context: viewContext)
        }
        
        
        saveContext()
        
        
        
//        let j = JSONEncoder()
//
//        content.chords = PersistenceService.convertToChordType(content: chords)
//        content.classes = PersistenceService.convertToClasstype(content: classes)
//        content.modules = PersistenceService.convertToModuleType(content: modules, classes: content.classes)
//        content.practiceData = PersistenceService.convertToCompletedType(content: dones)
//
//
//        var qm = Data()
//
//        do {
//            let q = try j.encode(content)
//            let k = String(data: q, encoding: .utf8)
////            print(String(describing: k))
//            qm = q
//        }
//        catch(let error) {
//            print(error)
//        }
//
//
//        let w = JSONDecoder()
//
//        do {
//            let qq = try w.decode(AllContentData.self, from: qm)
//            print(qq)
//        }
//        catch(let error) {
//            print(error)
//        }
    }
    
    func saveContext() {
        do {
            try viewContext.save()
            importingNow = .none
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
}

struct ImportContentView_Previews: PreviewProvider {
    static var previews: some View {
        ImportContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
