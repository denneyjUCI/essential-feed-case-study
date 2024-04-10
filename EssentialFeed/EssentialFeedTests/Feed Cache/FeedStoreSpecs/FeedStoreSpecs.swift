//
//  FeedStoreSpecs.swift
//  EssentialFeedTests
//
//  Created by Jonathan Denney on 12/30/22.
//

import Foundation

protocol FeedStoreSpecs {
    func test_retrieve_deliversEmptyOnEmptyCache() throws
    func test_retrieveTwice_hasNoSideEffectsOnEmptyCache() throws
    func test_retrieve_deliversFoundValuesOnNonEmptyCache() throws
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() throws

    func test_insert_deliversNoErrorOnEmptyCache() throws
    func test_insert_deliversNoErrorOnNonEmptyCache() throws
    func test_insert_overridesPreviouslyInsertedCacheValues() throws

    func test_delete_deliversNoErrorOnEmptyCache() throws
    func test_delete_deliversNoErrorOnNonEmptyCache() throws
    func test_delete_hasNoSideEffectsOnEmptyCache() throws
    func test_delete_removesNonEmptyCache() throws
}

protocol FailableRetrieveFeedStoreSpecs: FeedStoreSpecs {
    func test_retrieve_hasNoSideEffectsOnFailure() throws
    func test_retrieve_deliversFailureOnRetrievalError() throws
}

protocol FailableInsertFeedStoreSpecs: FeedStoreSpecs {
    func test_insert_hasNoSideEffectsOnFailure() throws
    func test_insert_deliversErrorOnInsertionError() throws
}

protocol FailableDeleteFeedStoreSpecs: FeedStoreSpecs {
    func test_delete_hasNoSideEffectsOnFailure() throws
    func test_delete_deliversErrorOnDeletionError() throws
}

protocol AsyncFeedStore: FeedStoreSpecs {
    func test_storeSideEffects_runSerially() throws
}

typealias FailableFeedStore = FailableRetrieveFeedStoreSpecs & FailableInsertFeedStoreSpecs & FailableDeleteFeedStoreSpecs
