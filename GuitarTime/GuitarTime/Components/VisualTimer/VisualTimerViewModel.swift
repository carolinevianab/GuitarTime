//
//  VisualTimerViewModel.swift
//  GuitarTime
//
//  Created by Caroline Viana on 19/09/23.
//

import SwiftUI
import AVFoundation

class VisualTimerViewModel: ObservableObject {
    @Published var totalTime: Int
    @Published var hasCompleted: Bool
    @Published var shrink: Bool {
        didSet {
            shrinkView()
        }
    }
    
    @Published var currentPercentage: CGFloat = 0
    @Published var percentConstant = 0.000001
    
    @Published var currentTime = 0
    @Published var timer: Timer?
    @Published var timerIsRunning = false
    
    @Published var currentFrame: CGFloat = 300
    @Published var finishSound: SystemSoundID = 1000
    
    init() {
        self.totalTime = 0
        hasCompleted = false
        shrink = false
    }
    
    // MARK: shrinkView
    func shrinkView() {
        withAnimation {
            currentFrame = shrink ? 200 : 300
        }
    }
    // MARK: startTimer
    func startTimer() {
        if timer == nil {
            timer = Timer(timeInterval: 1.0, repeats: true) { [self] t in
                
                if timerIsRunning {
                    upCounter()
                }
                
            }
            
            RunLoop.current.add(timer!, forMode: .common)
        }
        
        timerIsRunning.toggle()
    }
    
        // MARK: isCompleted
        func isCompleted() -> Bool {
            currentTime >= totalTime
        }
    
    // MARK: restartTimer
    func restartTimer() -> Int {
        let t = currentTime
        
        timer?.invalidate()
        timer = nil
        timerIsRunning = false
        currentTime = 0
        hasCompleted = false
        withAnimation {
            currentPercentage = 0
        }
        
        return t
    }
    
    // MARK: markAsCompleted
    func markAsCompleted() {
        if !hasCompleted {
            hasCompleted = true
            AudioServicesPlaySystemSound(finishSound)
        }
    }
    
    // MARK: upCounter
    func upCounter() {
        currentTime += 1
        
        if !isCompleted() {
            withAnimation { currentPercentage = calculatePercent() }
        }
        else {
            withAnimation { currentPercentage = 1 }
            markAsCompleted()
        }
        
    }
    
    // MARK: calculatePercent
    func calculatePercent() -> CGFloat {
        let perCent = (CGFloat(currentTime) / CGFloat(totalTime)) - percentConstant
        
        if percentConstant < 0.01 { percentConstant += 0.0001 }
        return perCent
    }
}
