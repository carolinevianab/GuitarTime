//
//  NewModuleClassListView.swift
//  GuitarTime
//
//  Created by Caroline Viana on 25/08/23.
//

import SwiftUI

struct NewModuleClassListView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var editMode: EditMode = .inactive
    
    @Binding var selectedClasses: [GuitarClassType]
    
    @State var pickerTrail: [String] = []
    @State var showingAlert = false
    @State var backFromSave = false
    
    let chordList: [String]
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach($selectedClasses) { guitarClass in
                        sendCorrectInfo(guitarClass: guitarClass,
                                        type: guitarClass.classType.wrappedValue)
                    }
                    .onMove(perform: moveAction)
                    
                }
                
                Section {
                    ForEach(ClassType.allCases, id:\.self) { guitarClass in
                        addableCell(guitarClass)
                            .onTapGesture {
                                addClassToList(guitarClass)
                            }
                    }
                }
                
            }
            .navigationBarHidden(true)
            .environment(\.editMode, .constant(editMode))
            .alert(AppStrings.savingError, isPresented: $showingAlert) {
                Button(AppStrings.okBtn, role: .cancel) {}
            } message: {
                Text(AppStrings.newModuleClassesSaveError)
            }

        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(editMode == .inactive ?
                       AppStrings.reorderBtn : AppStrings.doneBtn,
                       action: {
                    withAnimation {
                        if editMode == .active {
                            editMode = .inactive
                        } else {
                            editMode = .active
                        }
                    }
                    
                })
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(AppStrings.saveBtn, action: {
                    print(selectedClasses)
                    for myClass in selectedClasses {
                        if myClass.duration == 0 || myClass.classChords.contains("") {
                            showingAlert = true
                            return
                        }
                    }
                    backFromSave = true
                    dismiss()
                })
            }
            
            
        }.onDisappear {
            if !backFromSave {
                selectedClasses.removeAll()
            }
        }
    }
    
    func sendCorrectInfo(guitarClass: Binding<GuitarClassType>, type: ClassType) -> some View {
        
        let min = guitarClass.duration.wrappedValue / 60
        let sec = guitarClass.duration.wrappedValue % 60
        
        let d1 = guitarClass.classChords.first?.wrappedValue
        let d2 = guitarClass.classChords.last?.wrappedValue
        
        switch type {
        case .PFC, .oneMinChanges:
            return ModuleDeletableCell(moduleClass: guitarClass,
                                canOpenTogle: $editMode,
                                chordList: chordList,
                                deleteHandler: { selectedClasses.removeAll(where: { $0.id == guitarClass.id }) },
                                minField: "1",
                                secField: "00",
                                titleText: guitarClass.classTitle.wrappedValue,
                                decision1: d1 ?? "A",
                                decision2: d2 ?? "A")
        case .generic, .songPractice, .riffFun, .strummingPractice, .repertourRev:
            return ModuleDeletableCell(moduleClass: guitarClass,
                                canOpenTogle: $editMode,
                                chordList: chordList,
                                deleteHandler: { selectedClasses.removeAll(where: { $0.id == guitarClass.id }) },
                                minField: String(min),
                                       secField: sec < 10 ? "0" + String(sec) : String(sec),
                                titleText: guitarClass.classTitle.wrappedValue,
                                       decision1: guitarClass.classDescription.wrappedValue,
                                decision2: "")
        case .singleCPP:
            return ModuleDeletableCell(moduleClass: guitarClass,
                                canOpenTogle: $editMode,
                                chordList: chordList,
                                deleteHandler: { selectedClasses.removeAll(where: { $0.id == guitarClass.id }) },
                                minField: String(min),
                                       secField: sec < 10 ? "0" + String(sec) : String(sec),
                                titleText: guitarClass.classTitle.wrappedValue,
                                decision1: d1 ?? "A",
                                decision2: "")
        case .multipleCPP:
            return ModuleDeletableCell(moduleClass: guitarClass,
                                canOpenTogle: $editMode,
                                chordList: chordList) {
                selectedClasses.removeAll(where: { $0.id == guitarClass.id })
                
            }
        }
    }
    
    func addClassToList(_ classType: ClassType) {
        let classDuration = classType == .PFC || classType == .oneMinChanges ? 60 : 0
        
        withAnimation {
            selectedClasses.append(
                GuitarClassType(id: UUID(),
                                classTitle: classType.classTitle,
                                classDescription: "",
                                classChords: ["A", "A"],
                                classType: classType,
                                duration: Int16(classDuration),
                                needsMetronome: false,
                                saveStatistics: false)
            )
        }
    }
    
    func addableCell(_ classType: ClassType) -> some View {
        HStack {
            Image(systemName: AppStrings.sysimgAddList)
                .foregroundColor(.green)
                .padding(.leading, 8)
                .font(.system(size: 18))
            Text(classType.classTitle).padding(.leading, 8)
        }
    }
    
    func moveAction(from souce: IndexSet, to destination: Int) {
        selectedClasses.move(fromOffsets: souce, toOffset: destination)
    }
}

struct NewModuleClassListView_Previews: PreviewProvider {
    static var previews: some View {
        NewModuleClassListView(selectedClasses: .constant([classType1]), chordList: ["A", "B", "C", "D"])
    }
}
