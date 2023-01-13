//
//  SceneDelegate.swift
//  EssentialApp
//
//  Created by Jonathan Denney on 1/9/23.
//

import UIKit
import Combine
import CoreData
import EssentialFeed
import EssentialFeediOS

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private lazy var httpClient: HTTPClient = {
        return URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()
    private lazy var store: FeedStore & FeedImageDataStore = {
        try! CoreDataFeedStore(storeURL: NSPersistentContainer
            .defaultDirectoryURL()
            .appending(component: "feed-store.sqlite"))
    }()

    var remoteLoader: RemoteLoader<[FeedImage]>?

    private lazy var localFeedLoader: LocalFeedLoader = {
        LocalFeedLoader(store: store, currentDate: Date.init)
    }()

    convenience init(httpClient: HTTPClient, store: FeedStore & FeedImageDataStore) {
        self.init()
        self.httpClient = httpClient
        self.store = store
    }


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: scene)
        configureWindow()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        localFeedLoader.validateCache { _ in }
    }

    func configureWindow() {
        window?.rootViewController = UINavigationController(
            rootViewController:
                FeedUIComposer.feedComposedWith(
                    feedLoader: makeRemoteFeedLoaderWithLocalFallback,
                    imageLoader: makeLocalFeedImageLoaderWithRemoteFallback
                )
            )
        window?.makeKeyAndVisible()
    }

    private func makeRemoteFeedLoaderWithLocalFallback() -> FeedLoader.Publisher {
        let url = URL(string: "https://ile-api.essentialdeveloper.com/essential-feed/v1/feed")!

        return httpClient
            .getPublisher(url: url)
            .tryMap(FeedItemsMapper.map)
            .caching(to: localFeedLoader)
            .fallback(to: localFeedLoader.loadPublisher)
    }

    private func makeLocalFeedImageLoaderWithRemoteFallback(url: URL) -> FeedImageDataLoader.Publisher {
        let remoteImageLoader = RemoteFeedImageDataLoader(client: httpClient)
        let localImageLoader = LocalFeedImageDataLoader(store: store)

        return localImageLoader
            .loadImageDataPublisher(url)
            .fallback(to: {
                remoteImageLoader
                    .loadImageDataPublisher(url)
                    .caching(to: localImageLoader, with: url)
            })
    }

}

extension RemoteLoader: FeedLoader where Resource == [FeedImage] {}
