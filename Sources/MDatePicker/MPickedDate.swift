//
//  WDateValue.swift
//
//
//  Created by Jie Weng on 2022/11/25.
//

import Foundation

public enum MPickedDate: Equatable, Codable, Hashable, Sendable {

    case single(Date)
    case range(Date, Date)
    
    
    public var singleValue: Date {
        switch self {
        case .single(let date):
            return date
        case .range(let start, let end):
            return start
        }
    }

    public var rangeValue: ClosedRange<Date> {
        switch self {
        case .single(let date):
            return .init(uncheckedBounds: (date, date))
        case .range(let start, let end):
            return .init(uncheckedBounds: (start, end))
        }
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case let (.single(l), .single(r)):
            return l == r
        case let (.range(ll, lr), .range(rl, rr)):
            return ll == rl && lr == rr
        default:
            return false
        }
    }

    public var description: String {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("MMMM dd")
        
        let calendar = Calendar.current
        let today = Date()
        
        func formatDate(_ date: Date) -> String {
            if calendar.isDateInToday(date) {
                return "Today"
            } else if calendar.isDateInTomorrow(date) {
                return "Tomorrow"
            } else if calendar.isDateInYesterday(date) {
                return "Yesterday"
            } else {
                return formatter.string(from: date)
            }
        }
        
        switch self {
        case let .single(date):
            return formatDate(date)
        case let .range(date, date2):
            return "\(formatDate(date)) - \(formatDate(date2))"
        }
    }
}
