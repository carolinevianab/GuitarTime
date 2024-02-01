//
//  CalendarSheetInfoView.swift
//  GuitarTime
//
//  Created by Caroline Viana on 07/09/23.
//

import SwiftUI

struct CalendarSheetInfoView: View {
    @Binding var clickedDay: Date
    @Binding var convertedDones: [CompletedForStatistics]
    @StateObject var ch: CalendarHelper
    
    @State var too: CompletedForStatistics?
    
    var body: some View {
        VStack(alignment: .leading) {
            
            if let tooShow = too {
                HStack {
                    Spacer()
                    Text(ch.formatDate(tooShow.doneDate,
                                       dateStyle: .medium,
                                       timeStyle: .none))
                        .padding()
                        .font(.title)
                    Spacer()
                }
                
                
                
                
                HStack {
                    Spacer()
                    VStack(spacing: 20) {
                        Text("Module: \(tooShow.completedModule)")
                            .font(.title3)
                            .padding(.bottom)
                        
                        Text("Class total time: \(getTime(tooShow.classTimeSeconds))")
                        Text("\(tooShow.omc.keys.first ?? "ERRO D:")")
                        Text("\(tooShow.pfc.keys.first ?? "ERRO D:")")
                    }.padding()
                    
                    Spacer()
                }
                
                Spacer()
                
            } else {
                
                HStack {
                    VStack {
                        Text(ch.formatDate(clickedDay,
                                           dateStyle: .medium,
                                           timeStyle: .none))
                            .padding()
                            .font(.title)
                        
                        Spacer()
                        
                        Text("There's no content for this day D:")
                        Text("That means you didn't practice this day.")
                        Text("GO PRACTICE :D")
                        
                        Spacer()
                    }
                }
                
            }
            
        }
        .onAppear() {
            too = convertedDones.first(where: {
                let formatter = DateFormatter()
                formatter.dateStyle = .full
                formatter.timeStyle = .none
                
                return formatter.string(from: $0.doneDate) == formatter.string(from: clickedDay)
            })
        }
        
    }
    
    func getTime(_ sec: Int) -> String {
        Utils.convertSecondsToString(sec)
    }
    
}

struct CalendarSheetInfoView_Previews: PreviewProvider {
    static var previews: some View {
        MonthCalendarView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
