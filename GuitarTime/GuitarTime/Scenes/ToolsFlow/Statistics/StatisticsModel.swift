//
//  StatisticsModel.swift
//  GuitarTime
//
//  Created by Caroline Viana on 10/09/23.
//

import SwiftUI


struct StatisticsModel {
    
    func setCircleColor(_ show: Int) -> Color {
        switch show {
        case 1:  return .blue
        case 2:  return .orange
        case 3:  return .green
        default: return .clear
        }
    }
    
    func segButtonBackground(_ isShow: Bool) -> Color {
        if isShow { return Color(uiColor: .secondarySystemFill) }
        return Color(uiColor: .systemBackground)
    }
}
