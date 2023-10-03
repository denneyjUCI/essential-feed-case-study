//
//  LocalizedRelativeDateFormatterTests.swift
//  EssentialFeedTests
//
//  Created by Jonathan Denney on 10/3/23.
//

import XCTest
import EssentialFeed

final class LocalizedRelativeDateFormatterTests: XCTestCase {

    func test_whenDatesAreFarApart_returnsOneDayAgo() {
        let octoberSecond2023 = Date(timeIntervalSince1970: 1696204800)
        let octoberThird2023 = Date(timeIntervalSince1970: 1696291200)
        let sut = LocalizedRelativeDateFormatter(currentDate: { octoberThird2023 })

        XCTAssertEqual(sut.string(for: octoberSecond2023), "1 day ago")
    }

    func test_whenDatesAreClose_returnsOneSecondAgo() {
        let octoberSecond2023At1159 = Date(timeIntervalSince1970: 1696291199)
        let octoberThird2023 = Date(timeIntervalSince1970: 1696291200)
        let sut = LocalizedRelativeDateFormatter(currentDate: { octoberThird2023 })

        XCTAssertEqual(sut.string(for: octoberSecond2023At1159), "1s ago")
    }

    func test_whenDatesAreSame_returnsNOw() {
        let octoberThird2023 = Date(timeIntervalSince1970: 1696291200)
        let sut = LocalizedRelativeDateFormatter(currentDate: { octoberThird2023 })

        XCTAssertEqual(sut.string(for: octoberThird2023), "Now")
    }

}
