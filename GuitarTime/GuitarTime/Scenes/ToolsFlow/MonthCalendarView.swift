//
//  MonthCalendarView.swift
//  GuitarTime
//
//  Created by Caroline Viana on 06/09/23.
//

import SwiftUI

struct MonthCalendarView: View {
    @StateObject var ch = CalendarHelper(todayIs: Date(), month: Date(), monthNumber: 9)
    @StateObject var sh = StatisticsHelper(today: Date(), practices: [])
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \CompletedForStats.doneDate, ascending: true)],
        animation: .default)
    private var dones: FetchedResults<CompletedForStats>
    
    @State var convertedDones: [CompletedForStatistics] = []
    
    
    @State var showBottomSheet = false
    @State var clickedDay = Date()
    
    var body: some View {
        VStack {
            // Calendar
            VStack(spacing: 20) {
                monthControls()
                calendarView()
            }.padding(.top, 10)
            
            HStack(alignment: .top, spacing: 20) {
                CustomShadowCell {
                    Text("weeklyPracticeLbl").multilineTextAlignment(.center)
                    
                    Text("\(sh.last7DaysCount)/7")
                        .font(.largeTitle)
                        .padding(5)
                    Spacer()
                    Text(desc2())
                        .font(.caption2)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(uiColor: UIColor.secondaryLabel))
                }
                
                CustomShadowCell {
                    Text("monthlyLbl").multilineTextAlignment(.center)
                    
                    Text("\(sh.last30DaysCount)/30")
                        .font(.largeTitle)
                        .padding(5)
                    Spacer()
                    Text(desc())
                        .font(.caption2)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(uiColor: UIColor.secondaryLabel))
                }

            }
            .padding(20)
            .frame(maxHeight: 200)
            
            Spacer()
                
            
        }
        .onAppear() {
            convertedDones = PersistenceService.convertToCompletedType(content: dones)
            
            sh.practices = convertedDones
            sh.generateStatistics()
        }
        .sheet(isPresented: $showBottomSheet) {
            CalendarSheetInfoView(clickedDay: $clickedDay, convertedDones: $convertedDones, ch: ch)
            .presentationDetents([.medium])
        }
        
        
    }
    
    func desc() -> String {
        if sh.last30DaysCount >= 30 { return "PERFECT MONTH!" }
        else if sh.last30DaysCount > 25 { return "Great Job! Keep up!" }
        else if sh.last30DaysCount > 15 { return "Half-way is still half-way. Keep Going!" }
        else if sh.last30DaysCount > 10 { return "Any progress is still progress!" }
        else { return "Things are tough, but we're still here." }
    }
    
    func desc2() -> String {
        if sh.last30DaysCount >= 7 { return "PERFECT WEEK!" }
        else if sh.last30DaysCount > 5 { return "Great Job! Keep up!" }
        else if sh.last30DaysCount > 3 { return "Half-way is still half-way. Keep Going!" }
        else if sh.last30DaysCount > 2 { return "Any progress is still progress!" }
        else { return "Things are tough, but we're still here." }
    }
    
    
    
    func monthControls() -> some View {
        HStack() {
            Button(action: { previousMonth() }, label: {
                Image(systemName: "chevron.left.circle")
            })
            
            Spacer()
            Text(ch.getMonthName())
            Spacer()
            
            Button(action: { nextMonth() }, label: {
                Image(systemName: "chevron.right.circle")
            })
        }.padding(.horizontal, 75)
    }
    
    func calendarView() -> some View {
        VStack(spacing: 30) {
            HStack(spacing: 2) {
                ForEach(0..<Calendar.current.shortWeekdaySymbols.count, id: \.self) { i in
                    Text(Calendar.current.shortWeekdaySymbols[i])
                        .font(.caption)
                        .frame(width: 44)
                }
                
            }
            
            ForEach(1..<ch.numberOfWeeks, id: \.self) { i in
                HStack(spacing: 2) {
                    ForEach(ch.returnFullWeek(for: i), id: \.self) { date in
                        dayCell(date: date, week: i)
                            .frame(width: 44)
                            .onTapGesture {
                                clickedDay = date
                                    showBottomSheet = true
                                sh.getNumberOf30Days()
                            }
                    }
                }
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 15)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .strokeBorder(Color.accentColor.opacity(0.5), lineWidth: 1)
            
        )
    }
    
    func dayCell(date: Date, week: Int) -> some View {
        ZStack(alignment: .bottomTrailing) {
            ZStack {
                Circle()
                    .fill(
                        ch.isDateToday(date) ? Color.accentColor : Color.clear
                    )
                    .saturation(0.5)
                    .frame(width: 30)
                
                
                Text(ch.getOnlyDayNumber(date))
                    .font(.caption)
                    .fontWeight(ch.isDateToday(date)
                                ? .bold : .regular)
                    .foregroundColor(
                        ch.setTextColor(date: date, week: week)
                    )
                
            }
            
            if convertedDones.contains(where: {
                let formatter = DateFormatter()
                formatter.dateStyle = .full
                formatter.timeStyle = .none
                
                return formatter.string(from: $0.doneDate) == formatter.string(from: date)
            }) {
                Circle()
                    .fill(.green)
                    .padding(.bottom, 2)
                    .frame(width: 8)
            }
        }
    }
    
    func previousMonth() {
        let p = Calendar.current.date(byAdding: DateComponents(month: -1), to: ch.currentMonth) ?? Date()
        
        let i = ch.currentMonthNumber == 1 ? 12 : ch.currentMonthNumber - 1
        
        ch.updateMonth(month: p, monthNumber: i)
    }
    
    func nextMonth() {
        let p = Calendar.current.date(byAdding: DateComponents(month: 1), to: ch.currentMonth) ?? Date()
        
        let i = ch.currentMonthNumber == 12 ? 1 : ch.currentMonthNumber + 1
        
        ch.updateMonth(month: p, monthNumber: i)
    }
    
    
    
}

struct MonthCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        MonthCalendarView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}



