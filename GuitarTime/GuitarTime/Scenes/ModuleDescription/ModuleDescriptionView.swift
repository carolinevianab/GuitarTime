//
//  ModuleDescriptionView.swift
//  GuitarTime
//
//  Created by Caroline Viana on 24/08/23.
//

import SwiftUI

struct ModuleDescriptionView: View {
    @StateObject var router = PracticeRouter()
    
    @Binding var moduleClasses: GuitarModuleType
    @Binding var showSheet: Bool
    
    // MARK: body
    var body: some View {
        NavigationStack(path: $router.navigationPath) {
            VStack {
                CustomShadowCell {
                    HStack {
                        Text("classDuration")
                        Spacer()
                        Text(getModuleDuration())
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                }
                
                Text("modDesc").padding(.top)
                
                ForEach(moduleClasses.moduleClasses) { classs in
                    classcell(name: classs.classTitle,
                              duration: classs.duration)
                }
                
                Spacer()
                
                // Button
                NavigationLink(value: PracticeRouter.ScreenList.PracticeRoutine, label: {
                    Text("startBtn")
                        .font(.title2)
                        .frame(maxWidth: .infinity)
                        .padding(8)
                })
                .buttonStyle(.borderedProminent)
            }
            .padding(16)
            .navigationDestination(for: PracticeRouter.ScreenList.self) { screen in
                switch screen {
                case .PracticeRoutine:
                    PracticeRoutineView(viewModel: router, module: $moduleClasses, showSheet: $showSheet)
                case .PracticeCompleted:
                    PracticeCompletedView(showSheet: $showSheet, vm: router.practiceCompletedVm)
                        .navigationTitle(router.practiceCompletedVm.module.moduleTitle)
                }
                
            }
            .navigationTitle(moduleClasses.moduleTitle)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("cancelBtn", role: .cancel, action: dismissModal)
                }
            }
        }
        
    }
    
    // MARK: dismissModal
    func dismissModal() {
        showSheet = false
    }
    
    // MARK: classcell
    func classcell(name: String, duration: Int16) -> some View {
        CustomShadowCell {
            HStack {
                Text(name)
                Spacer()
                Text("\(Utils.convertSecondsToString(Int(duration)))")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    // MARK: getModuleDuration
    func getModuleDuration() -> String {
        let sum = moduleClasses.moduleClasses.reduce(0, {x, y in x + Int(y.duration)})
        return Utils.convertSecondsToString(sum)
    }
}

// MARK: - Preview

struct ModuleDescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        ModuleDescriptionView(moduleClasses: .constant(moduleType1), showSheet: .constant(false))
    }
}
