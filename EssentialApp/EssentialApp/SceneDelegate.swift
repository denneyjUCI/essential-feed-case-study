//
//  SceneDelegate.swift
//  EssentialApp
//
//  Created by Jonathan Denney on 1/9/23.
//

import UIKit
import CoreData
import EssentialFeed
import EssentialFeediOS

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    let imageStoreURL = NSPersistentContainer
        .defaultDirectoryURL()
        .appending(component: "feed-store.sqlite")


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }

        configureWindow()
    }

    func configureWindow() {
        let url = URL(string: "https://ile-api.essentialdeveloper.com/essential-feed/v1/feed")!
        let client = makeRemoteClient()
        let remoteFeedLoader = RemoteFeedLoader(url: url, client: client)
        let remoteImageLoader = RemoteFeedImageDataLoader(client: client)

        let localStore = try! CoreDataFeedStore(storeURL: imageStoreURL)
        let localFeedLoader = LocalFeedLoader(store: localStore, currentDate: Date.init)
        let localImageLoader = LocalFeedImageDataLoader(store: localStore)

        window?.rootViewController = UINavigationController(
            rootViewController:
                FeedUIComposer.feedComposedWith(
                    feedLoader: FeedLoaderWithFallbackComposite(
                        primary: FeedLoaderCacheDecorator(
                            decoratee: remoteFeedLoader,
                            cache: localFeedLoader),
                        fallback: localFeedLoader),
                    imageLoader: FeedImageDataLoaderWithFallbackComposite(
                        primary: localImageLoader,
                        fallback: FeedImageDataLoaderCacheDecorator(
                            decoratee: remoteImageLoader,
                            cache: localImageLoader))
                )
            )
    }

    func makeRemoteClient() -> HTTPClient {
        return URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }

}

