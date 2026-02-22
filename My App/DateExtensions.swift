//
//  DateExtensions.swift
//  My App
//
//  Created by Kailey Liou on 2/22/26.
//

import Foundation

extension Date {
    func isTodayOrLater() -> Bool {
        self >= Calendar.current.startOfDay(for: Date())
    }
    
    func isPast() -> Bool {
        self < Calendar.current.startOfDay(for: Date())
    }
}
