//
//  PracticeCompletedViewModel.swift
//  GuitarTime
//
//  Created by Caroline Viana on 19/09/23.
//

import Foundation

class PracticeCompletedViewModel {
    let module: GuitarModuleType
    let omc: [String: Int]
    let pfc: [String: Int]
    let totalTime: Int
    
    init(module: GuitarModuleType, omc: [String: Int], pfc: [String: Int], totalTime: Int) {
        self.module = module
        self.omc = omc
        self.pfc = pfc
        self.totalTime = totalTime
        
    }
    
    init() {
        self.module = .emptyModule()
        self.omc = [:]
        self.pfc = [:]
        self.totalTime = 0
    }
}
