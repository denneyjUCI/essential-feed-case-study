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


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }

        let url = URL(string: "https://ile-api.essentialdeveloper.com/essential-feed/v1/feed")!
        let client = makeRemoteClient()
        let remoteFeedLoader = RemoteFeedLoader(url: url, client: client)
        let remoteImageLoader = RemoteFeedImageDataLoader(client: client)

        let imageStoreURL = NSPersistentContainer.defaultDirectoryURL().appending(component: "feed-store.sqlite")
        let localStore = try! CoreDataFeedStore(storeURL: imageStoreURL)
        let localFeedLoader = LocalFeedLoader(store: localStore, currentDate: Date.init)
        let localImageLoader = LocalFeedImageDataLoader(store: localStore)

        if CommandLine.arguments.contains("-reset") {
            try? FileManager.default.removeItem(at: imageStoreURL)
        }

        window?.rootViewController = FeedUIComposer.feedComposedWith(
            feedLoader: FeedLoaderWithFallbackComposite(
                primary: FeedLoaderCacheDecorator(
                    decoratee: remoteFeedLoader,
                    cache: localFeedLoader),
                fallback: localFeedLoader),
            imageLoader: FeedImageDataLoaderWithFallbackComposite(
                primary: localImageLoader,
                fallback: FeedImageDataLoaderCacheDecorator(
                    decoratee: remoteImageLoader,
                    cache: localImageLoader)))
    }

    private func makeRemoteClient() -> HTTPClient {
        switch UserDefaults.standard.string(forKey: "connectivity") {
        case "offline":
            return AlwaysFailingHTTPClient()

        default:
            return URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        }
    }

    private class AlwaysFailingHTTPClient: HTTPClient {
        struct Task: HTTPClientTask {
            func cancel() {}
        }
        func get(from url: URL, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> Void) -> HTTPClientTask {
            completion(.failure(NSError(domain: "offline", code: 0)))
            return Task()
        }
    }


}

