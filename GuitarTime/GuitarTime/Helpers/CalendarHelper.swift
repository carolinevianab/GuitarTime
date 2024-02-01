//
//  CalendarHelper.swift
//  GuitarTime
//
//  Created by Caroline Viana on 07/09/23.
//

import SwiftUI

class CalendarHelper: ObservableObject {
    @Published var today: Date
    @Published var currentMonth: Date
    @Published var currentMonthNumber: Int
    @Published var numberOfWeeks: Int
    
    let calendar = Calendar.current
    
    // MARK: init
    init(todayIs: Date, month: Date, monthNumber: Int) {
        today = todayIs
        currentMonth = month
        currentMonthNumber = monthNumber
        numberOfWeeks = 0
        
        numberOfWeeks = getNumberOfWeeksInMonth()
    }
    
    // MARK: updateMonth
    func updateMonth(month: Date, monthNumber: Int) {
        currentMonth = month
        currentMonthNumber = monthNumber
        
        numberOfWeeks = getNumberOfWeeksInMonth()
    }
    
    // MARK: setTextColor
    func setTextColor(date: Date, week: Int) -> Color {
        let day = Int(getOnlyDayNumber(date)) ?? 0
        
        if isDateToday(date) { return .white }
        if (day > 7 && week == 1) { return .gray }
        if (day < 24 && week >= getNumberOfWeeksInMonth()-1) { return .gray }
        return .black
    }
    
    // MARK: getMonth
    func getMonth() -> Date {
        let january = calendar.date(bySetting: .month, value: 1, of: currentMonth) ?? Date()
        
        if currentMonthNumber == 1 { return january }
        // Need to subtract one year because it's set for january for the next year
        let januaryCurrentYear = calendar.date(byAdding: DateComponents(year: -1), to: january) ?? Date()
        
        let currentMonth = calendar.date(byAdding: DateComponents(month: currentMonthNumber-1), to: januaryCurrentYear) ?? Date()
        return currentMonth
    }
    
    // MARK: getNumberOfWeeksInMonth
    func getNumberOfWeeksInMonth() -> Int {
        let startOfNextMonth = getEndOfMonth(getMonth())
        let endOfMonth = calendar.date(byAdding: DateComponents(day: -1), to: startOfNextMonth) ?? Date()
        let numberOfWeek = calendar.dateComponents([.weekOfMonth], from: endOfMonth)
        return (numberOfWeek.weekOfMonth ?? 0) + 1
    }
    
    // MARK: returnFullWeek
    func returnFullWeek(for week: Int) -> [Date] {
        var startOfMonth = getStartOfMonth(getMonth())
        
        if week != 1 {
            startOfMonth = calendar.date(byAdding: DateComponents(weekOfMonth: week-1), to: startOfMonth) ?? Date()
        }
        
        let sunday = getSunday(of: startOfMonth)
        return generateWeek(sunday: sunday)
    }
    
    // MARK: getOnlyDayNumber
    func getOnlyDayNumber(_ date: Date) -> String {
        let day = calendar.dateComponents([.day, .weekOfMonth], from: date)
        return String(day.day ?? 0)
    }
    
    // MARK: isDateToday
    func isDateToday(_ date: Date) -> Bool {
        let formattedDate = formatDate(date, dateStyle: .full, timeStyle: .none)
        let formattedToday = formatDate(today, dateStyle: .full, timeStyle: .none)
        return formattedDate == formattedToday
    }
    
    // MARK: getMonthName
    func getMonthName() -> String {
        formatDate(getMonth(), format: "LLLL, YYYY")
    }
    
    // MARK: formatDate
    /// Locale to english: "en-US".
    ///
    /// Locale to Brazil: "pt-BR"
    func formatDate(_ date: Date,
                    dateStyle: DateFormatter.Style = .full,
                    timeStyle: DateFormatter.Style = .medium,
                    format: String? = nil,
                    locale: String = "en-US") -> String {
        
        let formatter = DateFormatter()
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        formatter.locale = Locale(identifier: locale)
        
        if let dateFormat = format { formatter.dateFormat = dateFormat }
        return formatter.string(from: date)
    }
    
    // MARK: generateWeek
    func generateWeek(sunday: Date) -> [Date] {
        var week = [sunday]
        
        for i in 1...6 {
            let weekday = calendar.date(byAdding: DateComponents(day: i), to: sunday)
            week.append(weekday ?? Date())
        }
        
        return week
    }
    
    // MARK: getSunday
    func getSunday(of day: Date) -> Date {
        let c = formatDate(day).split(separator: ",")
        var pastDays = 0
        
        switch c.first {
        case "Sunday": return day
        case "Monday": pastDays = -1
        case "Tuesday": pastDays = -2
        case "Wednesday": pastDays = -3
        case "Thursday": pastDays = -4
        case "Friday": pastDays = -5
        case "Saturday": pastDays = -6
        default: break
        }
        
        return calendar.date(byAdding: DateComponents(day: pastDays), to: day) ?? day
    }
    
    // MARK: getStartOfMonth
    func getStartOfMonth(_ date: Date) -> Date  {
        let month = calendar.dateInterval(of: .month, for: date) ?? DateInterval()
        return month.start
    }
    
    // MARK: getEndOfMonth
    func getEndOfMonth(_ date: Date) -> Date  {
        let month = calendar.dateInterval(of: .month, for: date) ?? DateInterval()
        return month.end
    }
}
