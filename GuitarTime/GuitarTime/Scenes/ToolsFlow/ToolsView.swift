//
//  ToolsView.swift
//  GuitarTime
//
//  Created by Caroline Viana on 26/08/23.
//

import SwiftUI

class ToolsNavigation: ObservableObject {
    @Published var navigationPath = NavigationPath()
    
    @Published var chordName = ""
    @Published var chordsToShow: [ChordType] = []
    
    enum ScreenList: Hashable {
        case Metronome
        case ChordList
        case ChordCarrousel(chord: Int16)
        case Statistics
        case History
        case ImportContent
        case ExportContent
        case RemoveContent
        
    }
    
    func navigateToMetronome() {
        navigationPath.append(ScreenList.Metronome)
    }
    
    func navigateToChordList() {
        navigationPath.append(ScreenList.ChordList)
    }
    
    func navigateToChordCarrousel(with name: String, chords: Int16) {
        chordName = name
        navigationPath.append(ScreenList.ChordCarrousel(chord: chords))
    }
    
    func navigateBack() {
        navigationPath.removeLast()
    }
}

struct ToolsView: View {
    @StateObject var viewModel = ToolsNavigation()
    
    var body: some View {
        NavigationStack(path: $viewModel.navigationPath) {
            List {
                Section("Guitar Tools") {
                    
                    NavigationLink(AppStrings.metronomeTitle, value: ToolsNavigation.ScreenList.Metronome)
                    
                    NavigationLink(AppStrings.chordsTitle, value: ToolsNavigation.ScreenList.ChordList)
                    
                    NavigationLink(AppStrings.statisticsTitle, value: ToolsNavigation.ScreenList.Statistics)
                    
                    NavigationLink(AppStrings.historyTitle, value: ToolsNavigation.ScreenList.History)
                }
                
                Section("App Tools") {
                    NavigationLink(AppStrings.importTitle, value: ToolsNavigation.ScreenList.ImportContent)
                    
                    NavigationLink(AppStrings.exportTitle, value: ToolsNavigation.ScreenList.ExportContent)
                    
                    NavigationLink(AppStrings.removeContentTitle, value: ToolsNavigation.ScreenList.RemoveContent)
                }
                
                
            }
            .navigationDestination(for: ToolsNavigation.ScreenList.self, destination: { i in
                
                switch i {
                case .Metronome:
                    MetronomeView(isPortable: false)
                        .navigationTitle(AppStrings.metronomeTitle)
                case .ChordList:
                    ChordListView(viewModel: viewModel)
                        .navigationTitle(AppStrings.chordsTitle)
                case .ChordCarrousel(let chord):
                    if chord == 0 {
                        ChordCarrouselView(chords: viewModel.chordsToShow.filter({ $0.isFavorited }))
                            .navigationTitle(viewModel.chordName)
                    } else {
                        ChordCarrouselView(chords: viewModel.chordsToShow.filter({ $0.chordCategory.rawValue == chord }))
                            .navigationTitle(viewModel.chordName)
                    }
                    
                case .Statistics:
                    StatisticsView()
                        .navigationTitle(AppStrings.statisticsTitle)
                case .History:
                    MonthCalendarView()
                        .navigationTitle(AppStrings.historyTitle)
                case .ImportContent:
                    ImportContentView()
                        .navigationTitle(AppStrings.importTitle)
                case .ExportContent:
                    ExportContentView()
                        .navigationTitle(AppStrings.exportTitle)
                case .RemoveContent:
                    RemoveContentView()
                        .navigationTitle(AppStrings.removeContentTitle)
                }
            })
            .navigationTitle(AppStrings.toolsTitle)
            .navigationBarTitleDisplayMode(.inline)
        }
        
        
        
  
    }
}

struct ToolsView_Previews: PreviewProvider {
    static var previews: some View {
        ToolsView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
