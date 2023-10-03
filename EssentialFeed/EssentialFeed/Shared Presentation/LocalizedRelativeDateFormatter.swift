//
//  LocalizedRelativeDateFormatter.swift
//  EssentialFeed
//
//  Created by Jonathan Denney on 10/3/23.
//

import Foundation

public final class LocalizedRelativeDateFormatter {

    private let currentDate: () -> Date

    public init(currentDate: @escaping () -> Date, calendar: Calendar = .current, locale: Locale = .current) {
        self.currentDate = currentDate
    }

    public func string(for date: Date) -> String {
        let now = currentDate()
        let secondsDiff = Int(now.timeIntervalSince(date))
        if secondsDiff == 0 { return "Now" }
        guard secondsDiff >= 60 else { return "\(secondsDiff)s ago"}

        let dateFormatter = RelativeDateTimeFormatter()

        return dateFormatter.localizedString(for: date, relativeTo: now)
    }

}
