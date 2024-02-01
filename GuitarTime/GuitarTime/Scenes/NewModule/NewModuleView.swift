//
//  NewModuleView.swift
//  GuitarTime
//
//  Created by Caroline Viana on 25/08/23.
//

import SwiftUI

struct NewModuleView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Chord.chordname, ascending: true)],
            animation: .default)
    private var chords: FetchedResults<Chord>
    
    @Binding var newModSheetOpen: Bool
    @State var showingAlert = false
    
    @State var a = ""
    @State var b: JustinGuitarGrade = .none
    @State var c: [GuitarClassType] = []
    
    var body: some View {
        
        NavigationStack {
            ScrollView {
                VStack {
                    newModuleTextCell(AppStrings.nameLbl, bindTo: $a)
                    newModulePickerCell(AppStrings.gradeLbl, bindTo: $b)
                    newModuleClassesCell(AppStrings.classesLbl)
                }
                .padding()
            }
            .navigationTitle(AppStrings.newModuleTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(AppStrings.saveBtn, action: {
                        if !a.isEmpty && b != .none && !c.isEmpty {
                            saveModule()
                        }
                        else {
                            showingAlert = true
                        }
                    })
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(AppStrings.cancelBtn, action: {
                        newModSheetOpen = false
                    })
                }
            }
        }
        .alert(AppStrings.savingError, isPresented: $showingAlert) {
            Button(AppStrings.okBtn, role: .cancel) {}
        } message: {
            Text(AppStrings.newModuleErrorDesc)
        }
    }
    
    func saveModule() {
        withAnimation {
            
            let newModule = GuitarModuleType(id: UUID(), moduleTitle: a, moduleGrade: b, moduleClasses: c)
            
            _ = PersistenceService.convertSingleToGuitarModule(content: newModule, context: viewContext)
            
            for c in newModule.moduleClasses {
                _ = PersistenceService.convertSingleToGuitarClass(content: c, context: viewContext)
            }
            
            
            do {
                try viewContext.save()
                newModSheetOpen = false
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func newModuleTextCell(_ cellTitle: String, bindTo: Binding<String>) -> some View {
        CustomShadowCell {
            HStack {
                Text(cellTitle).font(.callout)
                TextField("", text: bindTo)
                    .textFieldStyle(.roundedBorder)
            }
        }
    }
    
    func newModulePickerCell(_ cellTitle: String, bindTo: Binding<JustinGuitarGrade>) -> some View {
        CustomShadowCell {
            HStack {
                Text(cellTitle).font(.callout)
                Spacer()
                Picker("", selection: bindTo, content: {
                    ForEach(JustinGuitarGrade.allCases, id:\.rawValue) { grade in
                        Text(grade.gradeTitle).tag(grade)
                    }
                })
            }
        }
    }
    
    func newModuleClassesCell(_ cellTitle: String) -> some View {
        CustomShadowCell {
            HStack {
                Text(cellTitle).font(.callout)
                Spacer()
                NavigationLink(AppStrings.editBtn, destination: NewModuleClassListView(selectedClasses: $c, chordList: getChordList()))
            }
            
            Divider()
            
            if c.isEmpty {
                Text(AppStrings.newModuleNoClasses).font(.footnote)
            } else {
                HStack {
                    Text("Total duration:").font(.callout)
                    Spacer()
                    Text(totalTime())
                }
                .padding(.bottom)
                
                ForEach(c) { cc in
                    HStack {
                        Text(cc.classTitle).font(.footnote)
                        Spacer()
                        Text("\(Utils.convertSecondsToString(Int(cc.duration)))").font(.footnote)
                    }
                }
            }
            
        }
        
    }
    
    func totalTime() -> String {
        let totalSec = c.reduce(0, { acc, n in acc + n.duration })
        return "\(Utils.convertSecondsToString(Int(totalSec)))"
    }
    
    func getChordList() -> [String] {
        chords.map({ $0.chordname ?? "E" })
        
    }
}

struct NewModuleView_Previews: PreviewProvider {
    static var previews: some View {
        NewModuleView(newModSheetOpen: .constant(true))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
