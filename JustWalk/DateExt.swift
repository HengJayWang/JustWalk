//
//  DateExt.swift
//  JustWalk
//
//  Created by M100-M1MacMini on 2022/3/3.
//

import Foundation

extension Date {
    static func mondayAt12AM() -> Date {
        return Calendar(identifier: .iso8601).date(from: Calendar(identifier: .iso8601).dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
    }
}
