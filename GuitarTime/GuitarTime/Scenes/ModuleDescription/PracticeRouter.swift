//
//  PracticeRouter.swift
//  GuitarTime
//
//  Created by Caroline Viana on 16/10/23.
//

import SwiftUI

class PracticeRouter: ObservableObject {
    @Published var navigationPath = NavigationPath()
    @Published var practiceCompletedVm = PracticeCompletedViewModel()
    
    enum ScreenList: Hashable {
        case PracticeRoutine
        case PracticeCompleted
    }
    
    func navigateToPractice() {
        navigationPath.append(ScreenList.PracticeRoutine)
    }
    
    func navigateToCompleted(module: GuitarModuleType, omc: [String: Int], pfc: [String: Int], totalTime: Int) {
        practiceCompletedVm = PracticeCompletedViewModel(module: module, omc: omc, pfc: pfc, totalTime: totalTime)
        navigationPath.append(ScreenList.PracticeCompleted)
    }
    
}
