//
//  NewChordView.swift
//  GuitarTime
//
//  Created by Caroline Viana on 06/09/23.
//

import SwiftUI

struct NewChordView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var isSelfOpen: Bool
    @State var showingAlert = false
    
    @State var builtedChord = ChordType.emptyChord()
    @State var chordName = ""
    @State var chordCat = ChordCategory.C
    
    var body: some View {
        NavigationStack {
            ScrollView {
                
                VStack {
                    newChordTextCell(String(localized: "nameLbl"), bindTo: $chordName)
                    newChordPickerCell(String(localized: "categoryLbl"))
                    newChordEditChord()
                }.padding()
                
            }
            .navigationTitle("newChordTitle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("saveBtn", action: {
                        if !chordName.isEmpty &&
                            builtedChord.mutedStrings.count != 6 {
                            saveModule()
                        }
                        else {
                            showingAlert = true
                        }
                    })
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("cancelBtn", action: {
                        isSelfOpen = false
                    })
                }
            }
            
            
        }
        .alert("savingError", isPresented: $showingAlert) {
            Button("okBtn", role: .cancel) {}
        } message: {
            Text("newChordErrorDesc")
        }
        
        
    }
    
    func saveModule() {
        withAnimation {
            builtedChord.chordName = chordName
            builtedChord.chordCategory = chordCat
            _ = PersistenceService.convertSingleToChord(content: builtedChord, context: viewContext)
            
            do {
                try viewContext.save()
                isSelfOpen = false
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func newChordPickerCell(_ cellTitle: String) -> some View {
        CustomShadowCell {
            HStack {
                Text(cellTitle).font(.callout)
                Spacer()
                Picker("", selection: $chordCat, content: {
                    ForEach(ChordCategory.allCases, id:\.rawValue) { chord in
                        Text(chord.chordName).tag(chord)
                    }
                })
            }
        }
        
        
    }
    
    func newChordTextCell(_ cellTitle: String, bindTo: Binding<String>) -> some View {
        CustomShadowCell {
            HStack {
                Text(cellTitle).font(.callout)
                TextField("", text: bindTo)
                    .textFieldStyle(.roundedBorder)
            }
        }
    }
    
    func newChordEditChord() -> some View {
        CustomShadowCell {
            ChordView(chordToShow: ChordType.emptyChord(), isEditMode: true) { chordChanged in
                builtedChord = chordChanged
            }
        }
    }
}

struct NewChordView_Previews: PreviewProvider {
    static var previews: some View {
        NewChordView(isSelfOpen: .constant(true))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
