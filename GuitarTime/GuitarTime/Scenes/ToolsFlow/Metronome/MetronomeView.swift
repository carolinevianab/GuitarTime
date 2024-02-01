//
//  MetronomeView.swift
//  GuitarTime
//
//  Created by Caroline Viana on 26/08/23.
//

import SwiftUI
import AVFoundation

struct MetronomeView: View {
    @StateObject var vm = MetronomeViewModel()
    
    @State var isPortable: Bool
    @State var timeSignature = "4/4"
    
    
    var body: some View {
        VStack {
            setupMainView()
            
            Spacer()
            generateCell()
            Spacer()
            
            CircularButton(symbol: vm.timerIsRunning ?
                            AppStrings.sysimgPause :
                            AppStrings.sysimgPlay,
                           action: vm.startTimer)
        }
        .padding(isPortable ? .top : .all)
        
    }
    
    // MARK: setupMainView
    func setupMainView() -> some View {
        return ZStack {
            createMetronomeLayout()
        }
    }
    
    // MARK: createMetronomeLayout
    func createMetronomeLayout() -> some View {
        let currentBeat = AppColors.brandPrimary
        let notCurrent = AppColors.brandDark.opacity(0.2)
        
        let c = 0.01
        var numberCircles: [Double] = [0]
        
        
        for i in 1...vm.beats - 1 {
            numberCircles.append(Double(i)/Double(vm.beats) - c)
        }
        
        numberCircles.append(1 - c)
        
        return ZStack {
            ForEach(0..<numberCircles.count - 1, id: \.self) { n in
                Circle()
                    .trim(from: numberCircles[n] + c,
                          to: numberCircles[n+1])
                    .stroke(n+1 == vm.currentBeat
                            ? currentBeat
                            : notCurrent,
                            style: StrokeStyle(lineWidth: 20, lineCap: .butt))
            }
            
 
        }.rotationEffect(.degrees(vm.beats == 4 ? -45 : 0))
    }
    
    // MARK: generateCell
    func generateCell() -> some View {
        return Group {
            if isPortable {
                HStack {
                    Spacer()
                    
                    Picker("", selection: $timeSignature, content: {
                        Text("4/4").tag("4/4")
                        Text("6/8").tag("6/8")
                    })
                    .disabled(vm.timerIsRunning)
                    .scaleEffect(1.25)
                    .onChange(of: timeSignature) { newValue in
                        let parts = newValue.split(separator: "/").map({ String($0) })
                        vm.beats = Int(parts.first ?? "4") ?? 4
                        vm.bars = Int(parts.last ?? "4") ?? 4
                    }
                    
                    Spacer()
                    
                    
                    Picker("", selection: $vm.bpm, content: {
                        ForEach(40..<200, content: { v in
                            Text("\(v)").tag(v)
                        })
                    })
                    .disabled(vm.timerIsRunning)
                    .scaleEffect(1.25)
                    
                    Spacer()
                }
            } else {
                HStack {
                    Text(AppStrings.timeSignLbl)
                    Spacer()
                    
                    Picker("", selection: $timeSignature, content: {
                        Text("4/4").tag("4/4")
                        Text("3/4").tag("3/4")
                        Text("6/8").tag("6/8")
                    }).disabled(vm.timerIsRunning)
                        
                    .onChange(of: timeSignature) { newValue in
                        let parts = newValue.split(separator: "/").map({ String($0) })
                        vm.beats = Int(parts.first ?? "4") ?? 4
                        vm.bars = Int(parts.last ?? "4") ?? 4
                    }
                }
                
                HStack {
                    Text(AppStrings.bpm)
                    Spacer()
                    
                    Picker("", selection: $vm.bpm, content: {
                        ForEach(40..<200, content: { v in
                            Text("\(v)").tag(v)
                        })
                    }).disabled(vm.timerIsRunning)
                }
            }
            
        }
        
        
    }
    
    
}

// MARK: - Preview

struct MetronomeView_Previews: PreviewProvider {
    static var previews: some View {
        MetronomeView(isPortable: false)
        
        ModuleDescriptionView(moduleClasses: .constant(moduleType1), showSheet: .constant(false))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
