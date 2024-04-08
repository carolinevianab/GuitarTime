//
//  ClassCompletedView.swift
//  GuitarTime
//
//  Created by Caroline Viana on 24/08/23.
//

import SwiftUI

struct PracticeCompletedView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var showSheet: Bool
    
    let vm: PracticeCompletedViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Text("finishedPracticeLbl")
                .font(.largeTitle)
                .padding()
            
            Divider()
            
            CustomShadowCell {
                HStack {
                    Text("moduleLbl")
                    Spacer()
                    Text("\(vm.module.moduleTitle)")
                }
            }
            
            CustomShadowCell {
                HStack {
                    Text("totalTimeLbl")
                    Spacer()
                    Text(Utils.convertSecondsToString(vm.totalTime))
                }
            }
            
            HStack {
                if !vm.omc.isEmpty {
                    ShadowCard(width: .infinity, height: .infinity) {
                        Text("omcChangesLbl")
                        Divider()
                        ForEach(vm.omc.keys.sorted(), id: \.self) { i in
                            HStack {
                                Text("\(i)")
                                Spacer()
                                Text("\(vm.omc[i] ?? -1)")
                            }
                        }
                    }
                }
                
                if !vm.pfc.isEmpty {
                    ShadowCard(width: .infinity, height: .infinity) {
                        Text("pfcChangesLbl")
                        Divider()
                        ForEach(vm.pfc.keys.sorted(), id: \.self) { i in
                            HStack {
                                Text("\(i)")
                                Spacer()
                                Text("\(vm.pfc[i] ?? -1)")
                            }
                        }
                    }
                }
            }
            
            Spacer()
            
            
            Button(action: dismiss, label: {
                Text("finishClassBtn")
                    .font(.title2)
                    .frame(maxWidth: .infinity)
                    .padding(8)
            })
            
            .buttonStyle(.borderedProminent)
            
            

        }
        .padding(16)
        .navigationBarBackButtonHidden(true)
    }

    func dismiss() {
        let completed = CompletedForStatistics(
            id: UUID(),
            completedModule: vm.module.moduleTitle,
            omc: vm.omc,
            pfc: vm.pfc,
            classTimeSeconds: vm.totalTime,
            doneDate: Date())
        
        _ = PersistenceService.convertSingleToCompletedClass(
            content: completed,
            context: viewContext)
        
        do {
            try viewContext.save()
            showSheet = false
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

struct PracticeCompletedView_Previews: PreviewProvider {
    static var previews: some View {
        PracticeCompletedView_PreviewProvider()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

struct PracticeCompletedView_PreviewProvider: View {
    let vm = PracticeCompletedViewModel(module: moduleType1, omc: ["C,D": 11], pfc: ["C,D": 11], totalTime: 177)
    
    var body: some View {
        PracticeCompletedView(showSheet: .constant(true), vm: vm)
    }
}
