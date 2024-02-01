//
//  RemoveContentView.swift
//  GuitarTime
//
//  Created by Caroline Viana on 06/09/23.
//

import SwiftUI

struct RemoveContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
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
    
    var body: some View {
        List {
            Section("Mod") {
                ForEach(modules) { m in
                    Text(m.moduletitle ?? "Erro")
                }
                .onDelete(perform: deleteModule)
            }
            
            Section("Classes") {
                ForEach(classes) { c in
                    Text(c.classtitle ?? "Erro")
                }
                .onDelete(perform: deleteClasses)
            }
            
            Section("Chords") {
                ForEach(chords) { ch in
                    Text(ch.chordname ?? "Erro")
                    
                }
                .onDelete(perform: deleteChord)
                
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
        }
    }
    
    func deleteModule(offsets: IndexSet) {
        for index in offsets {
            let ch = modules[index]
            viewContext.delete(ch)
        }
        
        do {
            try viewContext.save()
        } catch {
            print("aaaaa")
        }
        
    }
    
    func deleteClasses(offsets: IndexSet) {
        for index in offsets {
            let ch = classes[index]
            viewContext.delete(ch)
        }
        
        do {
            try viewContext.save()
        } catch {
            print("aaaaa")
        }
        
    }
    
    func deleteChord(offsets: IndexSet) {
        for index in offsets {
            let ch = chords[index]
            viewContext.delete(ch)
        }
        
        do {
            try viewContext.save()
        } catch {
            print("aaaaa")
        }
        
    }
}

struct RemoveContentView_Previews: PreviewProvider {
    static var previews: some View {
        RemoveContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
