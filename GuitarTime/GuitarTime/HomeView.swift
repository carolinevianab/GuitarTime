//
//  HomeView.swift
//  GuitarTime
//
//  Created by Caroline Viana on 11/09/23.
//

import SwiftUI

struct HomeView: View {
    @StateObject var sh = StatisticsHelper(today: Date(), practices: [])
    
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
    
    @State var module = GuitarModuleType.emptyModule()
    @State var moduleList: [GuitarModuleType] = []
    @State var showSheet = false
    
    
    var body: some View {
        VStack() {
            ZStack(alignment: .top) {
                HStack {
                    Circle().fill(.orange.opacity(0.5))
                        .frame(width: 400)
                        .padding(.leading, 20)
                        .padding(.top, -15)
                    Circle().fill(.orange.opacity(0.5))
                        .frame(width: 400)
                        .padding(.leading, -200)
                        .padding(.top, -15)
                }
                .ignoresSafeArea()
                
                VStack(alignment: .leading) {
                    Text("dailyModuleTitle")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 10)
                        .shadow(color: .gray.opacity(0.5),radius: 3)
                    
                    todaysModule()
                }
                
            }
            
            CustomShadowCell {
                Text("If you start practicing now, you will finish \(module.moduleTitle) around \(calculateFinishingTime())")
                    .multilineTextAlignment(.center)
            }.padding(.horizontal)
            
            
            HStack {
                CustomShadowCell {
                    Text("weeklyPracticeLbl").multilineTextAlignment(.center)
                    
                    Text("\(sh.last7DaysCount)/7")
                        .font(.largeTitle)
                        .padding(5)
                }
                
                CustomShadowCell {
                    Text("monthlyLbl").multilineTextAlignment(.center)
                    
                    Text("\(sh.last30DaysCount)/30")
                        .font(.largeTitle)
                        .padding(5)
                }
            }
            .padding()
            
            
            
            Spacer()
        }
        .onAppear() {
            sh.practices = PersistenceService.convertToCompletedType(content: dones)
            sh.generateStatistics()
            
            
            let lastOne = dones.last
            
            let a = PersistenceService.convertToModuleType(content: modules, classes: PersistenceService.convertToClasstype(content: classes))
            
            let b = a.filter({
                lastOne?.completedModule == $0.moduleTitle
            })
            
            if b.count == 1, let m = b.first {
                module = m
            }
            
        }
        .fullScreenCover(isPresented: $showSheet) {
            ModuleDescriptionView(moduleClasses: $module, showSheet: $showSheet)
                .navigationTitle(module.moduleTitle)
        }
    }
    
    func todaysModule() -> some View {
        ZStack(alignment: .top) {

            RoundedRectangle(cornerRadius: 15)
                .fill(.white)
                .frame(width: 325, height: 200)
                .shadow(color: .gray.opacity(0.5),radius: 3)
            
            VStack {
                Text("\(module.moduleTitle)")
                    .padding(.top)
                    .font(.title)
                
                Text("(\(module.moduleGrade.gradeTitle))")
                    .padding(.bottom)
                    .font(.subheadline)
                    .foregroundColor(Color(uiColor: .secondaryLabel))
                
                Text(desc())
                    .multilineTextAlignment(.center)
                    .frame(width: 250)
                    
            }
        }
        
    }
    
    
    func desc() -> String {
        let lastOne = dones.last
        var possibilities: [String] = []
        
        for c in module.moduleClasses {
            if c.classType == .singleCPP {
                possibilities.append("Continue learning the \(c.classChords.first ?? "Erro") chord!")
            }
            
            if c.classType == .oneMinChanges || c.classType == .PFC {
                if !(lastOne?.omc?.isEmpty ?? true) {
                    let v = (lastOne?.omc?.split(separator: ":") ?? []).map({ String($0) }).last
                    let x = Int(v ?? "0") ?? 0
                    
                    possibilities.append("Last time we got \(v ?? "Erro") changes. Let's make it \(x+1)!")
                } else if !(lastOne?.pfc?.isEmpty ?? true) {
                    let v = (lastOne?.pfc?.split(separator: ":") ?? []).map({ String($0) }).last
                    let x = Int(v ?? "0") ?? 0
                    
                    possibilities.append("Last time we got \(v ?? "Erro") fast changes. Let's make it \(x+1)!")
                    
                } else {
                    possibilities.append("One Minute to Perfect Changes!")
                }
                
            }
            
            if c.classType == .strummingPractice {
                possibilities.append("One and two and three and four and one and two... Unless is 6/8...")
            }
            
            if c.classType != .repertourRev {
                possibilities.append("Playing Black on Repertour Revision is a must!")
            }
            
            if c.classType != .songPractice {
                possibilities.append("Goal: Sing Along!")
            }
            
        }
        
        return possibilities.randomElement() ?? "Lettuce Begin!"
    }
    
    func calculateFinishingTime() -> String {
        let moduleTime = module.moduleClasses.reduce(0, {t, tt in t + tt.duration })
        
        let p = Calendar.current.date(byAdding: DateComponents(second: Int(moduleTime)), to: Date()) ?? Date()
        
        let q = Calendar.current.dateComponents([.hour, .minute], from: p)
        
        if q.minute ?? 0 < 10 {
            return "\(q.hour ?? 0):0\(q.minute ?? 0)"
        }
        
        return "\(q.hour ?? 0):\(q.minute ?? 0)"
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
