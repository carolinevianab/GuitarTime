//
//  ChordCarrouselView.swift
//  GuitarTime
//
//  Created by Caroline Viana on 03/09/23.
//

import SwiftUI

struct ChordCarrouselView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var chords: [ChordType]
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Chord.chordname, ascending: true)],
            animation: .default)
    private var cdChords: FetchedResults<Chord>
    
    var body: some View {
        VStack {
            if chords.isEmpty {
                VStack {
                    Text(AppStrings.noChordsTitle)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.secondary)
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .padding()
                    
                    Text(AppStrings.noChordsDesc)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(UIColor.tertiaryLabel))
                        .fontWeight(.medium)
                        .padding(.horizontal)
                        .padding()
                }
            } else {
                TabView {
                    ForEach(chords) { chord in
                        VStack(spacing: 25) {
                            HStack {
                                Text(chord.chordName)
                                    .font(.largeTitle)
                                    .bold()
                                
                                Spacer()
                                
                                
                                Image(systemName: chord.isFavorited ? AppStrings.sysimgStarFill : AppStrings.sysimgStar)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(.orange.opacity(0.9))
                                    .frame(width: 35)
                                    .onTapGesture {
                                        favoriteChord(fav: chord)
                                    }
                                
                            }
                            .padding(.horizontal, 80)
                            
                            Divider().padding(.horizontal, 50)
                            
                            ChordView(chordToShow: chord, isEditMode: false, changeHandler: nil)
                        }
                    }
                    .padding(.bottom, 50)
                }
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
            }
            
        }
    }
    
    
    func favoriteChord(fav: ChordType) {
        withAnimation {
            for chord in cdChords {
                if chord.chordname == fav.chordName {
                    chord.favorited.toggle()
                    break
                }
            }

            do {
                try viewContext.save()
                
                if let b = chords.firstIndex(where: { $0.id == fav.id }) {
                    chords[b].isFavorited.toggle()
                }
                
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
}

struct ChordCarrouselView_Previews: PreviewProvider {
    static var previews: some View {
        ChordCarrouselView(chords: [chordType1, chordType2])
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
