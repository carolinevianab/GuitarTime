//
//  ModulesView.swift
//  GuitarTime
//
//  Created by Caroline Viana on 24/08/23.
//

import SwiftUI

struct ModulesView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \GuitarModule.moduletitle, ascending: true)],
        animation: .default)
    private var modules: FetchedResults<GuitarModule>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \GuitarClass.classtitle, ascending: true)],
        animation: .default)
    private var classes: FetchedResults<GuitarClass>
    
    @State var moduleList: [GuitarModuleType] = []
    
    
    @State var showSheet = false
    @State var newModSheetOpen = false
    @State var moduleClicked: GuitarModuleType = GuitarModuleType(id: UUID(), moduleTitle: "", moduleGrade: .Grade1, moduleClasses: [])
    
    var body: some View {
        NavigationStack {
            if moduleList.isEmpty {
                VStack {
                    Text(AppStrings.noModulesTitle)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.secondary)
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .padding()
                    
                    Text(AppStrings.noModulesDesc)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(UIColor.tertiaryLabel))
                        .fontWeight(.medium)
                        .padding(.horizontal)
                        .padding()
                }
                .navigationTitle(AppStrings.modulesTitle)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem {
                        Button(action: addItem) {
                            Label(AppStrings.addModule, systemImage: AppStrings.sysimgPlus)
                        }
                    }
                }
            } else {
                List {
                    ForEach(modulesByGrade()) { grade in
                        Section(grade.grade.gradeTitle) {
                            ForEach(grade.modules) { module in
                                Button(module.moduleTitle, action: {
                                    moduleClicked = module
                                    showSheet = true
                                })
                            }
                        }
                    }
                }
                .navigationTitle(AppStrings.modulesTitle)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem {
                        Button(action: addItem) {
                            Label(AppStrings.addModule, systemImage: AppStrings.sysimgPlus)
                        }
                    }
                }
            }
        }
        
        .fullScreenCover(isPresented: $showSheet) {
            ModuleDescriptionView(moduleClasses: $moduleClicked, showSheet: $showSheet)
                .navigationTitle(moduleClicked.moduleTitle)
        }
        .sheet(isPresented: $newModSheetOpen) {
            NewModuleView(newModSheetOpen: $newModSheetOpen)
                .environment(\.managedObjectContext, viewContext)
        }
        .onChange(of: newModSheetOpen, perform: { newValue in
            if !newValue {
                viewContext.refreshAllObjects()
                moduleList = convertModule()
            }
        })
        .onAppear {
            viewContext.refreshAllObjects()
            moduleList = convertModule()
        }
        
    }
    
    func convertModule() -> [GuitarModuleType] {
        PersistenceService.convertToModuleType(content: modules, classes: convertClasses())
    }
    
    func convertClasses() -> [GuitarClassType] {
        PersistenceService.convertToClasstype(content: classes)
    }
    
    private func addItem() {
        newModSheetOpen = true
    }
    
    
    func modulesByGrade() -> [ModulesByGrade] {
        guard !moduleList.isEmpty else { return [] }
        let modulesByGrade = Dictionary(grouping: moduleList, by: { $0.moduleGrade })
        let grades = modulesByGrade.compactMap( {
            ModulesByGrade(id: UUID(), grade: $0.key, modules: $0.value)
        })
        return grades.sorted(by: {$0.grade.rawValue < $1.grade.rawValue})
    }
}

struct ModulesView_Previews: PreviewProvider {
    static var previews: some View {
        ModulesView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
