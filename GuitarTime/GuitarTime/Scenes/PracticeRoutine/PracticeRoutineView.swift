//
//  PracticeRoutineView.swift
//  GuitarTime
//
//  Created by Caroline Viana on 24/08/23.
//

import SwiftUI

struct PracticeRoutineView: View {
    // Core data
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Chord.chordname, ascending: true)],
            animation: .default)
    private var cdChords: FetchedResults<Chord>
    
    @State var chords: [ChordType] = []
    
    // Bindings
    @StateObject var viewModel: PracticeRouter
    @StateObject var timerVm = VisualTimerViewModel()
    @Binding var module: GuitarModuleType
    @Binding var showSheet: Bool
    
    // Alerts Shows
    @State var showAlertLeave = false
    @State var showAlertClass = false
    
    // Data for statistics
    @State var numberOfChanges = ""
    @State var stats: [String:[String:Int]] = ["OMC": [:], "PFC": [:]]
    
    // Lesson Progress
    @State var currentClass = 0
    @State var totalPracticeTime = 0
    @State var completedClasses: [UUID] = []
    
    
    // MARK: body
    var body: some View {
        VStack {
            
            if !timerVm.shrink { Spacer() }
            
            VisualTimer(vm: timerVm).padding(.top)
                .onChange(of: timerVm.hasCompleted) { n in
                    if n { setCompletedClass() }
                }
            
            DisclosureGroup(isExpanded: $timerVm.shrink, content: {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.secondaryBackground)
                    
                    setupClass()
                }
            }, label: {
                Text("\(module.moduleClasses[currentClass].classTitle)")
                    .font(.title)
            })
            .padding()
            
            Spacer()
            
            setupProgressIndicator()
                .alert(AppStrings.changeCountTitle, isPresented: $showAlertClass) {
                    TextField(AppStrings.changeCountMessage, text: $numberOfChanges)
                        .foregroundColor(.black)
                        
                    Button(AppStrings.okBtn, action: submitValue)
                }
                
            
            ClassButtonGroup(isMovementDisabled: $timerVm.timerIsRunning, handlerBack: previousClass, handlerPlayPause: timerVm.startTimer, handlerForw: nextClass)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear() { setupData() }
        .alert(AppStrings.leaveAlertMessage, isPresented: $showAlertLeave) {
            Button(AppStrings.leaveAlertOptStay, role: .cancel, action: { showAlertLeave = false })
            Button(AppStrings.leaveAlertOptLeave, role: .destructive, action: dismissModal)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(AppStrings.cancelBtn, role: .cancel, action: { showAlertLeave = true })
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(AppStrings.finishClassBtn) {
                    totalPracticeTime += timerVm.restartTimer()
                    
                    viewModel.navigateToCompleted(module: module, omc: stats["OMC"] ?? [:], pfc: stats["PFC"] ?? [:], totalTime: totalPracticeTime)
                }
                .disabled(completedClasses.count < module.moduleClasses.count)
            }
        }
        
    }
    
    // MARK: - Setups
    
    // MARK: setupData
    func setupData() {
        chords = PersistenceService.convertToChordType(content: cdChords)
        updateFinalTime()
        print(module)
    }
    
    // MARK: setupClass
    func setupClass() -> some View {
        let current = module.moduleClasses[currentClass]
        let cardH: CGFloat = 250
        let cardW: CGFloat = 200
        
        return VStack {
            ScrollView(.horizontal) {
                HStack {
                    ShadowCard(width: cardW, height: cardH) {
                        Text("\(current.classDescription)")
                            .font(.footnote)
                            .multilineTextAlignment(.center)
                    }
                    
                    if current.needsMetronome {
                        ShadowCard(width: 300, height: cardH) {
                            MetronomeView(isPortable: true)
                        }
                    }
                    
                    ForEach(current.classChords, id: \.self) { chord in
                        ShadowCard(width: cardW, height: cardH) {
                            Text("\(chord)")
                                .fontDesign(.monospaced)
                                .font(.headline)
                            
                            ChordView(chordToShow: chords.first(where: { $0.chordName == chord }) ?? chordType2,
                                      isEditMode: false,
                                      changeHandler: nil)
                        }
                    }
                    
                }
                .padding()
            }
        }
    }
    
    // MARK: setupProgressIndicator
    func setupProgressIndicator() -> some View {
        HStack {
            ForEach(module.moduleClasses) { oneclass in
                Circle()
                    .fill(setProgressColor(oneclass))
                    .frame(width: 10)
            }
        }.padding(.horizontal, 32)
    }
    
    
    // MARK: - Lesson Controls
    
    // MARK: previousClass
    func previousClass() {
        if currentClass != 0 {
            currentClass -= 1
            updateFinalTime()
            
            if timerVm.timer != nil {
                totalPracticeTime += timerVm.restartTimer()
            }
        }
    }
    
    // MARK: nextClass
    func nextClass() {
        if module.moduleClasses.count - 1 != currentClass {
            currentClass += 1
            updateFinalTime()
            
            if timerVm.timer != nil {
                totalPracticeTime += timerVm.restartTimer()
            }
        }
    }
    
    // MARK: - UI
    
    // MARK: setProgressColor
    func setProgressColor(_ myClass: GuitarClassType) -> Color {
        let c = module.moduleClasses[currentClass]
        
        if completedClasses.contains(myClass.id) { return .green }
        else if myClass.id == c.id { return AppColors.brandOrange }
        return AppColors.brandDark.opacity(0.3)
    }
    
    
    // MARK: - Handlers and setters
    
    // MARK: submitValue
    func submitValue() {
        let c = module.moduleClasses[currentClass]
        let concatKey = "\(c.classChords.first ?? ""),\(c.classChords.last ?? "")"
        
        if c.classType == .PFC {
            stats["PFC"]?[concatKey] = Int(numberOfChanges)
        } else if c.classType == .oneMinChanges {
            stats["OMC"]?[concatKey] = Int(numberOfChanges)
        }
        
    }
    
    // MARK: updateFinalTime
    func updateFinalTime() {
        timerVm.totalTime = Int(module.moduleClasses[currentClass].duration)
    }
    
    // MARK: setCompletedClass
    func setCompletedClass() {
        let c = module.moduleClasses[currentClass]
        
        if !completedClasses.contains(c.id) {
            completedClasses.append(c.id)
            if c.classType == .PFC {
                timerVm.startTimer()
                showAlertClass = true
            }
        }
    }
    
    // MARK: dismissModal
    func dismissModal() { showSheet = false }
    
}

// MARK: - Preview

struct PracticeRoutineView_Previews: PreviewProvider {
    static var previews: some View {
        ModuleDescriptionView(moduleClasses: .constant(moduleType1), showSheet: .constant(false))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
