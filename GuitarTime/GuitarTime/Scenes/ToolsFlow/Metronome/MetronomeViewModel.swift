//
//  MetronomeViewModel.swift
//  GuitarTime
//
//  Created by Caroline Viana on 19/10/23.
//

import SwiftUI
import AVFoundation

class MetronomeViewModel: ObservableObject {
    @Published var beats = 4
    @Published var bars = 4
    @Published var timeSignature = 1
    @Published var bpm = 60
    
    @Published var currentBeat = 0
    
    @Published var timer: Timer? = nil
    @Published var timerIsRunning = false
    
    let i: SystemSoundID = 1104
    let j: SystemSoundID = 1105
    
    func startTimer() {
        if timer == nil {
            currentBeat = 1
            AudioServicesPlaySystemSound(j)
            
            let interval = Double(beats) / Double(beats) * 60 / Double(bpm) / (beats == 6 ? 2 : 1)
            timer = Timer(timeInterval: interval, repeats: true) { [self] t in
                
                if timerIsRunning {
                    if currentBeat == beats {
                        currentBeat = 1
                        AudioServicesPlaySystemSound(j)
                    } else {
                        if (beats == 6 && currentBeat == 3) { AudioServicesPlaySystemSound(j) }
                        else { AudioServicesPlaySystemSound(i) }
                        
                        currentBeat += 1
                    }
                }
            }
            
            RunLoop.current.add(timer!, forMode: .common)
        } else {
            timer?.invalidate()
            timer = nil
            currentBeat = 0
        }
        
        timerIsRunning.toggle()
    }
    
}
