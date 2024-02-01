//
//  StringsFile.swift
//  GuitarTime
//
//  Created by Caroline Viana on 24/08/23.
//

import UIKit
import SwiftUI

struct AppStrings {
    // MARK: - Generic
    static let chord = "Chord"
    static let nameLbl = "Name"
    static let gradeLbl = "Grade"
    static let classesLbl = "Classes"
    static let savingError = "Error on save!"
    
    // MARK: General Buttons
    static let cancelBtn = "Cancel"
    static let saveBtn = "Save"
    static let okBtn = "OK"
    static let editBtn = "Edit"
    static let reorderBtn = "Reorder"
    static let doneBtn = "Done"
    
    // MARK: - Views
    
    
    // MARK: Tab bar
    static let homeTitle = "Home"
    static let modulesTitle = "Modules"
    static let toolsTitle = "Tools"
    
    // MARK: Practice Flow
    static let modDesc = "Classes in module"
    static let startBtn = "Start Practice"
    static let finishClassBtn = "Finish class"
    static let finishedPracticeLbl = "Practice Completed!"
    static let moduleLbl = "Module"
    static let totalTimeLbl = "Total Practice Time"
    static let omcChangesLbl = "OMC Changes:"
    static let pfcChangesLbl = "PFC Changes:"
    static let changeCountTitle = "How many changes?"
    static let changeCountMessage = "How many changes did you do?"
    
    static let leaveAlertMessage = "Are you sure? Your progress will be lost."
    static let leaveAlertOptStay = "Stay"
    static let leaveAlertOptLeave = "Leave"
    
    // MARK: New Module
    static let addModule = "Add new module"
    static let classDuration = "Duration"
    static let chordsInClass = "Chords in class"
    static let descriptionLabel = "Description"
    static let newModuleTitle = "New Module"
    static let newModuleErrorDesc = "Please fill all fields, and try again."
    static let newModuleNoClasses = "No classes added"
    static let newModuleClassesSaveError = "Please fill all duration and chord fields, and try again."
    
    // MARK: Modules List
    static let noModulesTitle = "There are no modules added to the list."
    static let noModulesDesc = "Try adding one with the plus button!"
    
    // MARK: New Chord
    static let categoryLbl = "Category"
    static let newChordTitle = "New Chord"
    static let newChordErrorDesc = "Please fill all fields, and try again."
    static let addChord = "Add new chord"
    
    // MARK: Chord List
    static let chordsTitle = "Chords"
    static let noChordsTitle = "There are no chords of this note added."
    static let noChordsDesc = "Try adding one on the list!"
    static let favoritedChords = "Favorited Chords"
    
    // MARK: Metronome
    static let metronomeTitle = "Metronome"
    static let timeSignLbl = "Time Signature"
    static let bpm = "BPM"
    
    // MARK: Statistics
    static let statisticsTitle = "Statistics"
    static let weeklyLbl = "Weekly practice"
    static let monthlyLbl = "Monthly practice"
    
    // MARK: History
    static let historyTitle = "History"
    
    // MARK: Import
    static let importTitle = "Import data"
    
    // MARK: Export
    static let exportTitle = "Export data"
    
    // MARK: Export
    static let removeContentTitle = "Remove content"
    
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

