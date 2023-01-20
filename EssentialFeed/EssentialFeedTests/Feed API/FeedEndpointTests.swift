//
//  FeedEndpointTests.swift
//  EssentialFeedTests
//
//  Created by Jonathan Denney on 1/20/23.
//

import XCTest
import EssentialFeed

final class FeedEndpointTests: XCTestCase {
    func test_feed_endpointURL() {
        let baseURL = URL(string: "http://base-url.com")!

        let received = FeedEndpoint.get.url(baseURL: baseURL)

        XCTAssertEqual(received.scheme, "http", "scheme")
        XCTAssertEqual(received.host, "base-url.com", "host")
        XCTAssertEqual(received.path, "/v1/feed", "path for feed")
    }
}