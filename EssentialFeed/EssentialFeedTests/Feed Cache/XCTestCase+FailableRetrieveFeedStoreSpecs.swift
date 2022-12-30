//
//  XCTestCase+FailableRetrieveFeedStoreSpecs.swift
//  EssentialFeedTests
//
//  Created by Jonathan Denney on 12/30/22.
//

import XCTest
import EssentialFeed

extension FailableRetrieveFeedStoreSpecs where Self: XCTestCase {
    func assertThatRetrieveDeliversFailureOnRetrievalError(on sut: FeedStore) {
        expect(sut, toRetrieve: .failure(anyNSError()))
    }

    func assertThatRetrieveHasNoSideEffectsOnFailure(on sut: FeedStore) {
        expect(sut, toRetrieveTwice: .failure(anyNSError()))
    }
}

