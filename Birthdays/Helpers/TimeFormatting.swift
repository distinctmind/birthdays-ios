//
//  TimeFormatting.swift
//  People
//
//  Created by USER on 2024-03-26.
//

import Foundation

func daysUntil(birthday: Date) -> String {
    let cal = Calendar.current
    let today = cal.startOfDay(for: Date())
    let date = cal.startOfDay(for: birthday)
    let components = cal.dateComponents([.day, .month], from: date)
    let nextDate = cal.nextDate(after: today, matching: components, matchingPolicy: .nextTimePreservingSmallerComponents)
    let daysUntil = cal.dateComponents([.day], from: today, to: nextDate ?? today).day
    
    if let daysUntil = daysUntil {
        if daysUntil == 1 {
            return "in 1 day"
        } else {
            return "in \(daysUntil as Int) days"
        }
    } else {
        return "today"
    }
}

func getTurningAge(birthday: Date) -> Int {
    let calendar = Calendar.current
    let year = calendar.component(.year, from: birthday)
    return 2024 - year
}
