//
//  FeedStoreSpecs.swift
//  EssentialFeedTests
//
//  Created by Jonathan Denney on 12/30/22.
//

import Foundation

protocol FeedStoreSpecs {
    func test_retrieve_deliversEmptyOnEmptyCache()
    func test_retrieveTwice_hasNoSideEffectsOnEmptyCache()
    func test_retrieve_deliversFoundValuesOnNonEmptyCache()
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache()

    func test_insert_deliversNoErrorOnEmptyCache()
    func test_insert_deliversNoErrorOnNonEmptyCache()
    func test_insert_overridesPreviouslyInsertedCacheValues()

    func test_delete_deliversNoErrorOnEmptyCache()
    func test_delete_deliversNoErrorOnNonEmptyCache()
    func test_delete_hasNoSideEffectsOnEmptyCache()
    func test_delete_removesNonEmptyCache()
}

protocol FailableRetrieveFeedStoreSpecs: FeedStoreSpecs {
    func test_retrieve_hasNoSideEffectsOnFailure()
    func test_retrieve_deliversFailureOnRetrievalError()
}

protocol FailableInsertFeedStoreSpecs: FeedStoreSpecs {
    func test_insert_hasNoSideEffectsOnFailure()
    func test_insert_deliversErrorOnInsertionError()
}

protocol FailableDeleteFeedStoreSpecs: FeedStoreSpecs {
    func test_delete_hasNoSideEffectsOnFailure()
    func test_delete_deliversErrorOnDeletionError()
}

protocol AsyncFeedStore: FeedStoreSpecs {
    func test_storeSideEffects_runSerially()
}

typealias FailableFeedStore = FailableRetrieveFeedStoreSpecs & FailableInsertFeedStoreSpecs & FailableDeleteFeedStoreSpecs
