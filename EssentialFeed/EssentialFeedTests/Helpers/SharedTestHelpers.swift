//
//  SharedTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Jonathan Denney on 12/29/22.
//

import Foundation

func anyNSError() -> NSError {
    NSError(domain: "any error", code: 0)
}

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

func anyData() -> Data {
    Data("any data".utf8)
}
