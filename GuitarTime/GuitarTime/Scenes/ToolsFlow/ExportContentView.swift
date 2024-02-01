//
//  ExportContentView.swift
//  GuitarTime
//
//  Created by Caroline Viana on 07/09/23.
//

import SwiftUI

struct ExportContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \CompletedForStats.doneDate, ascending: true)],
        animation: .default)
    private var dones: FetchedResults<CompletedForStats>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \GuitarModule.moduletitle, ascending: true)],
        animation: .default)
    private var modules: FetchedResults<GuitarModule>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \GuitarClass.classtitle, ascending: true)],
        animation: .default)
    private var classes: FetchedResults<GuitarClass>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Chord.chordname, ascending: true)],
            animation: .default)
    private var chords: FetchedResults<Chord>
    
    
    
    @State var content = AllContentData(classes: [], modules: [], chords: [], practiceData: [])
    let encoder = JSONEncoder()
    
    var body: some View {
        List {
            Section {
                ShareLink("Export classes", item: exportClasses())
                ShareLink("Export modules", item: exportModules())
                ShareLink("Export chords", item: exportChords())
                ShareLink("Export practice data", item: exportPracticeData())
            }
            
            Section {
                Button("Export all content", action: {
                    exportAllContent()
                })
            }
        }
    }
    
    func exportClasses() -> URL {
        let dataToEncode = PersistenceService.convertToClasstype(content: classes)
        
        do {
            let dataEncoded = try encoder.encode(dataToEncode)
            if let jsonString = String(data: dataEncoded, encoding: .utf8) {
                let docsDirURL = try FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                let fileToShareURL = docsDirURL.appendingPathComponent("GuitarTime-Classes.json")
                
                try jsonString.write(to: fileToShareURL, atomically: false, encoding: .utf8)
                
                return fileToShareURL
            }
        }
        catch(let error) {
            print(error)
        }
        return URL(string: "fallback")!
    }
    
    func exportModules() -> URL {
        let dataToEncode = PersistenceService.convertToModuleType(content: modules, classes: PersistenceService.convertToClasstype(content: classes))
        
        do {
            let dataEncoded = try encoder.encode(dataToEncode)
            if let jsonString = String(data: dataEncoded, encoding: .utf8) {
                let docsDirURL = try FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                let fileToShareURL = docsDirURL.appendingPathComponent("GuitarTime-Modules.json")
                
                try jsonString.write(to: fileToShareURL, atomically: false, encoding: .utf8)
                
                return fileToShareURL
            }
        }
        catch(let error) {
            print(error)
        }
        return URL(string: "fallback")!
    }
    
    func exportChords() -> URL {
        let dataToEncode = PersistenceService.convertToChordType(content: chords)
        
        do {
            let dataEncoded = try encoder.encode(dataToEncode)
            if let jsonString = String(data: dataEncoded, encoding: .utf8) {
                let docsDirURL = try FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                let fileToShareURL = docsDirURL.appendingPathComponent("GuitarTime-Chords.json")
                
                try jsonString.write(to: fileToShareURL, atomically: false, encoding: .utf8)
                
                return fileToShareURL
            }
        }
        catch(let error) {
            print(error)
        }
        return URL(string: "fallback")!
        
    }
    
    func exportPracticeData() -> URL {
        let dataToEncode = PersistenceService.convertToCompletedType(content: dones)
        
        do {
            let dataEncoded = try encoder.encode(dataToEncode)
            if let jsonString = String(data: dataEncoded, encoding: .utf8) {
                let docsDirURL = try FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                let fileToShareURL = docsDirURL.appendingPathComponent("GuitarTime-PracticeData.json")
                
                try jsonString.write(to: fileToShareURL, atomically: false, encoding: .utf8)
                
                return fileToShareURL
            }
        }
        catch(let error) {
            print(error)
        }
        return URL(string: "fallback")!
    }
    
    func exportAllContent() {
        content.chords = PersistenceService.convertToChordType(content: chords)
        content.classes = PersistenceService.convertToClasstype(content: classes)
        content.modules = PersistenceService.convertToModuleType(content: modules, classes: content.classes)
        content.practiceData = PersistenceService.convertToCompletedType(content: dones)
        
        print(content)
        
        do {
            let dataEncoded = try encoder.encode(content)
            print(dataEncoded)
            if let jsonString = String(data: dataEncoded, encoding: .utf8) {
                let docsDirURL = try FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                let fileToShareURL = docsDirURL.appendingPathComponent("GuitarTime-Data.json")
                
                try jsonString.write(to: fileToShareURL, atomically: false, encoding: .utf8)
                
                shareAction(fileToShareURL)
            }
        }
        catch(let error) {
            print(error)
        }
        
    }
    
    func shareAction(_ url: URL) {
        let ac = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        
        let window = UIApplication.shared.connectedScenes.flatMap({ ($0 as? UIWindowScene)?.windows ?? [] }).first {$0.isKeyWindow}
        
        window?.rootViewController?.present(ac, animated: true, completion: nil)
        
    }
}

struct ExportContentView_Previews: PreviewProvider {
    static var previews: some View {
        ExportContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
