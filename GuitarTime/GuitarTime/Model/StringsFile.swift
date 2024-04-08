//
//  StringsFile.swift
//  GuitarTime
//
//  Created by Caroline Viana on 24/08/23.
//

import UIKit
import SwiftUI

struct AppStrings {
    
    // MARK: - System Images
    static let sysimgPlus = "plus"
    static let sysimgBack = "backward.fill"
    static let sysimgPause = "pause.fill"
    static let sysimgPlay = "play.fill"
    static let sysimgForw = "forward.fill"
    static let sysimgRemoveList = "minus.circle.fill"
    static let sysimgToggleClosed = "chevron.right"
    static let sysimgToggleOpened = "chevron.down"
    static let sysimgAddList = "plus.circle.fill"
    static let sysimgStar = "star"
    static let sysimgStarFill = "star.fill"
    static let sysimgHomeTab = "music.house"
    static let sysimgModTab = "guitars"
    static let sysimgToolsTab = "tuningfork"
    
}

enum AppColors {
    static let brandDark = color(named: "brandDark")
    static let brandGreen = color(named: "brandGreen")
    static let brandLight = color(named: "brandLight")
    static let brandOrange = color(named: "brandOrange")
    static let brandPrimary = color(named: "brandPrimary")
    static let brandRed = color(named: "brandRed")
    static let brandYellow = color(named: "brandYellow")
    
    static let primaryBackground = color(named: "bgPrimary")
    static let secondaryBackground = color(named: "bgSecondary")
    static let labelColor = color(named: "lblColor")
    
    static func color(named name: String) -> Color {
        guard let color = UIColor(named: name) else { return Color.clear }
        return Color(uiColor: color)
    }
}

