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
                Section("guitarToolsSectionTitle") {
                    
                    NavigationLink("metronomeTitle", value: ToolsNavigation.ScreenList.Metronome)
                    
                    NavigationLink("chordsTitle", value: ToolsNavigation.ScreenList.ChordList)
                    
                    NavigationLink("statisticsTitle", value: ToolsNavigation.ScreenList.Statistics)
                    
                    NavigationLink("historyTitle", value: ToolsNavigation.ScreenList.History)
                }
                
                Section("appToolsSectionTitle") {
                    NavigationLink("importTitle", value: ToolsNavigation.ScreenList.ImportContent)
                    
                    NavigationLink("exportTitle", value: ToolsNavigation.ScreenList.ExportContent)
                    
                    NavigationLink("removeContentTitle", value: ToolsNavigation.ScreenList.RemoveContent)
                }
                
                
            }
            .navigationDestination(for: ToolsNavigation.ScreenList.self, destination: { i in
                
                switch i {
                case .Metronome:
                    MetronomeView(isPortable: false)
                        .navigationTitle("metronomeTitle")
                case .ChordList:
                    ChordListView(viewModel: viewModel)
                        .navigationTitle("chordsTitle")
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
                        .navigationTitle("statisticsTitle")
                case .History:
                    MonthCalendarView()
                        .navigationTitle("historyTitle")
                case .ImportContent:
                    ImportContentView()
                        .navigationTitle("importTitle")
                case .ExportContent:
                    ExportContentView()
                        .navigationTitle("exportTitle")
                case .RemoveContent:
                    RemoveContentView()
                        .navigationTitle("removeContentTitle")
                }
            })
            .navigationTitle("toolsTitle")
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
