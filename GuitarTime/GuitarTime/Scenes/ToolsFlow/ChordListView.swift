//
//  ChordListView.swift
//  GuitarTime
//
//  Created by Caroline Viana on 26/08/23.
//

import SwiftUI

struct ChordListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Chord.chordname, ascending: true)],
            animation: .default)
    private var chords: FetchedResults<Chord>
    
    @State var chordList: [ChordType] = []
    @StateObject var viewModel: ToolsNavigation
    @State var showSheet = false
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    chordCollectionCell(nil)
                    Spacer()
                    chordCollectionCell(.A)
                    Spacer()
                    chordCollectionCell(.B)
                    Spacer()
                    chordCollectionCell(.C)
                    Spacer()
                }
                
                Spacer()
                
                VStack {
                    Spacer()
                    chordCollectionCell(.D)
                    Spacer()
                    chordCollectionCell(.E)
                    Spacer()
                    chordCollectionCell(.F)
                    Spacer()
                    chordCollectionCell(.G)
                    Spacer()
                }
                
                Spacer()
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showSheet = true }) {
                    Label("addChord", systemImage: AppStrings.sysimgPlus)
                }
            }
        }
        .onAppear {
            chordList = PersistenceService.convertToChordType(content: chords)
            viewModel.chordsToShow = chordList
        }
        .sheet(isPresented: $showSheet) {
            NewChordView(isSelfOpen: $showSheet)
        }
        .onChange(of: showSheet, perform: { newValue in
            if !newValue {
                viewContext.refreshAllObjects()
                chordList = PersistenceService.convertToChordType(content: chords)
                viewModel.chordsToShow = chordList
            }
        })
        
    }
    
    func chordCollectionCell(_ chord: ChordCategory?) -> some View {
        guard let c = chord else {
            return createCell(name: String(localized: "favoritedChords"), forChord: 0)
        }
        
        return createCell(name: c.chordName, forChord: c.rawValue)
        
    }
    
    
    func createCell(name: String, forChord: Int16) -> some View {
        Button(action: {
            viewModel.navigateToChordCarrousel(with: name,
                                               chords: forChord)
        }, label: {
            if name == String(localized: "favoritedChords") {
                Image(systemName:  AppStrings.sysimgStarFill)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30)
            }
            else {
                Text(name).font(.largeTitle)
            }
        })
        .frame(width: 150, height: 150)
        .background()
        .shadow(color: .gray.opacity(0.2),radius: 2)
    }
    
}

struct ChordListView_Previews: PreviewProvider {
    static var previews: some View {
        ToolsView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
