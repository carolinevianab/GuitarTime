//
//  StatisticsHelper.swift
//  GuitarTime
//
//  Created by Caroline Viana on 10/09/23.
//

import Foundation
import SwiftUI

class StatisticsHelper: ObservableObject {
    @Published var last30DaysCount = 0
    @Published var last7DaysCount = 0
    @Published var avgTimeByModule: [String: Int] = [:]
    @Published var avgTimeMonth: Int = 0
    
    @Published var omcProgressByChords: [String: [ChangesPerDay]] = [:]
    @Published var omcSelected: [ChangesPerDay] = []
    @Published var omcAo5: [ChangesPerDay] = []
    @Published var omcAo10: [ChangesPerDay] = []
    @Published var omcSelectedValue = "" {
        didSet {
            updateOMCPFC()
        }
    }
    
    @Published var pfcProgress: [String: [ChangesPerDay]] = [:]
    @Published var pfcSelected: [ChangesPerDay] = []
    @Published var pfcAo5: [ChangesPerDay] = []
    @Published var pfcAo10: [ChangesPerDay] = []
    @Published var pfcSelectedValue = "" {
        didSet {
            updateOMCPFC()
        }
    }
    
    let today: Date
    var practices: [CompletedForStatistics]
    let calendar = Calendar.current
    
    struct ChangesPerDay: Identifiable, Hashable {
        var id = UUID()
        var changes: Int
        var day: Date
    }
    
    // MARK: init
    init(today: Date, practices: [CompletedForStatistics]) {
        self.today = today
        self.practices = practices
    }
    
    // MARK: generateStatistics
    func generateStatistics() {
        getNumberOf30Days()
        getNumberOf7Days()
        getOMCPFCProgress()
        getAvgTime()
        
        omcSelectedValue = omcProgressByChords.keys.first ?? ""
        pfcSelectedValue = pfcProgress.keys.first ?? ""
        
        updateOMCPFC()
    }
    
    // MARK: updateOMCPFC
    func updateOMCPFC() {
        omcSelected = omcProgressByChords[omcSelectedValue] ?? []
        
        for i in 0..<omcSelected.count {
            if i >= 4 {
                let v = (omcSelected[i-4].changes +
                         omcSelected[i-3].changes +
                         omcSelected[i-2].changes +
                         omcSelected[i-1].changes +
                         omcSelected[i].changes) / 5
                
                omcAo5.append(ChangesPerDay(changes: v, day: omcSelected[i].day))
            }
            
            if i >= 9 {
                let v = (omcSelected[i-9].changes +
                         omcSelected[i-8].changes +
                         omcSelected[i-7].changes +
                         omcSelected[i-6].changes +
                         omcSelected[i-5].changes +
                         omcSelected[i-4].changes +
                         omcSelected[i-3].changes +
                         omcSelected[i-2].changes +
                         omcSelected[i-1].changes +
                         omcSelected[i].changes) / 10
                
                omcAo10.append(ChangesPerDay(changes: v, day: omcSelected[i].day))
            }
        }
        
        
        pfcSelected = pfcProgress[pfcSelectedValue] ?? []
        
        for i in 0..<pfcSelected.count {
            if i >= 4 {
                let v = (pfcSelected[i-4].changes +
                         pfcSelected[i-3].changes +
                         pfcSelected[i-2].changes +
                         pfcSelected[i-1].changes +
                         pfcSelected[i].changes) / 5
                
                pfcAo5.append(ChangesPerDay(changes: v, day: pfcSelected[i].day))
            }
            
            if i >= 9 {
                let v = (pfcSelected[i-9].changes +
                         pfcSelected[i-8].changes +
                         pfcSelected[i-7].changes +
                         pfcSelected[i-6].changes +
                         pfcSelected[i-5].changes +
                         pfcSelected[i-4].changes +
                         pfcSelected[i-3].changes +
                         pfcSelected[i-2].changes +
                         pfcSelected[i-1].changes +
                         pfcSelected[i].changes) / 10
                
                pfcAo10.append(ChangesPerDay(changes: v, day: pfcSelected[i].day))
            }
        }
        
    }
    
    
   
    // MARK: getNumberOf30Days
    func getNumberOf30Days() {
        last30DaysCount = getNumberOfDays(30)
    }
    
    //MARK: getNumberOf7Days
    func getNumberOf7Days() {
        last7DaysCount = getNumberOfDays(7)
    }
    
    // MARK: getNumberOfDays
    func getNumberOfDays(_ days: Int) -> Int {
        let nthDay = calendar.date(byAdding: DateComponents(day: -days), to: today) ?? Date()
        
        let practicesSinceNth = practices.filter({
            let timeBetween = calendar.dateComponents([.day, .month], from: nthDay, to: $0.doneDate)
            return (timeBetween.day ?? 0) < days
        })
        
        var filteredPractices: [CompletedForStatistics] = []
        
        for dayPractice in practicesSinceNth {
            if filteredPractices.isEmpty {
                filteredPractices.append(dayPractice)
                continue
            }
            
            let dayPracticeComponents = calendar.dateComponents([.day, .month, .year], from: dayPractice.doneDate)
            var count = 0

            for practice in filteredPractices {
                let practiceComponents = calendar.dateComponents([.day, .month, .year], from: practice.doneDate)

                if dayPracticeComponents.day == practiceComponents.day &&
                    dayPracticeComponents.month == practiceComponents.month &&
                    dayPracticeComponents.year == practiceComponents.year { break }
                
                count += 1
            }
            
            if count == filteredPractices.count { filteredPractices.append(dayPractice) }
        }
        
        return filteredPractices.count
    }
    
    // MARK: getOMCPFCProgress
    func getOMCPFCProgress() {
        for practice in practices {
            if let omc = practice.omc.first {
                
                let key = omc.key
                if omcProgressByChords[key] == nil {
                    omcProgressByChords[key] = []
                }
                
                omcProgressByChords[key]?.append(ChangesPerDay(changes: omc.value, day: practice.doneDate))
            }
            
            if let pfc = practice.pfc.first {
                if pfcProgress[pfc.key] == nil { pfcProgress[pfc.key] = [] }
                pfcProgress[pfc.key]?.append(ChangesPerDay(changes: pfc.value, day: practice.doneDate))
            }
        }
    }
    
    // MARK: getAvgTime
    func getAvgTime() {
        var auxDict: [String: [Int]] = [:] // For all time, divided by module
        var auxArray: [Int] = [] // For 30 days
        
        let lastMonth = calendar.date(byAdding: DateComponents(day: -30), to: today) ?? Date()
        
        for lesson in practices {
            let time = lesson.classTimeSeconds
            let mod = lesson.completedModule
            
            if auxDict[mod] == nil { auxDict[mod] = [] }
            
            auxDict[mod]?.append(time)
            
            let timeBetween = calendar.dateComponents([.day, .month], from: lastMonth, to: lesson.doneDate)
            
            if (timeBetween.day ?? 0) < 30 { auxArray.append(time) }
        }
        
        // Key = module name, value = duration in seconds
        for (key, value) in auxDict {
            let count = value.count
            let sum = value.reduce(0, {t, tt in t + tt })
            
            if count == 0 {
                avgTimeByModule[key] = 0
            } else {
                avgTimeByModule[key] = sum / count
            }
        }
        
        let count = auxArray.count
        let sum = auxArray.reduce(0, {t, tt in t + tt })
        
        if count == 0 {
            avgTimeMonth = 0
        } else {
            avgTimeMonth = sum / count
        }
        
        
    }
    
}
