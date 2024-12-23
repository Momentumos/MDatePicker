//
//  WDateValue.swift
//
//
//  Created by Jie Weng on 2022/11/25.
//

import Foundation

public enum MPickedDate: Equatable {

    case single(Date)
    case range(Date, Date)

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
        switch self {
        case let .single(date):
            return formatter.string(from: date)
        case let .range(date, date2):
            return "\(formatter.string(from: date)) - \(formatter.string(from: date2))"
        }
    }
}
