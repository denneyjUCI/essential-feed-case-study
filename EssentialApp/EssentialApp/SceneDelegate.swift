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
        let url = URL(string: "https://ile-api.essentialdeveloper.com/essential-feed/v1/feed")!

        let remoteFeedLoader = RemoteFeedLoader(url: url, client: httpClient)
        let remoteImageLoader = RemoteFeedImageDataLoader(client: httpClient)
        let localImageLoader = LocalFeedImageDataLoader(store: store)

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

        let remoteFeedLoader = RemoteFeedLoader(url: url, client: httpClient)

        return remoteFeedLoader
            .loadPublisher()
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

public extension FeedImageDataLoader {
    typealias Publisher = AnyPublisher<Data, Swift.Error>

    func loadImageDataPublisher(_ url: URL) -> Publisher {
        var task: FeedImageDataLoaderTask?

        return Deferred {
            Future { completion in
                task = self.loadImageData(from: url, completion: completion)
            }
        }
        .handleEvents(receiveCancel: { task?.cancel() })
        .eraseToAnyPublisher()
    }
}

extension Publisher where Output == Data {
    func fallback(to fallbackPublisher: @escaping () -> AnyPublisher<Output, Failure>) -> AnyPublisher<Output, Failure> {
        self.catch { _ in fallbackPublisher() }.eraseToAnyPublisher()
    }
}

extension Publisher where Output == Data {
    func caching(to cache: FeedImageDataCache, with url: URL) -> AnyPublisher<Output, Failure> {
        handleEvents(receiveOutput: { data in cache.saveIgnoringResult(data, for: url) }).eraseToAnyPublisher()
    }
}

extension FeedImageDataCache {
    func saveIgnoringResult(_ data: Data, for url: URL) {
        save(data, for: url) { _ in }
    }
}


public extension FeedLoader {
    typealias Publisher = AnyPublisher<[FeedImage], Swift.Error>
    func loadPublisher() -> Publisher {
        return Deferred {
            Future(self.load)
        }.eraseToAnyPublisher()
    }
}

extension Publisher where Output == [FeedImage] {
    func fallback(to fallbackPublisher: @escaping () -> AnyPublisher<Output, Failure>) -> AnyPublisher<Output, Failure> {
        self.catch { _ in fallbackPublisher() }.eraseToAnyPublisher()
    }
}

extension Publisher where Output == [FeedImage] {
    func caching(to cache: FeedCache) -> AnyPublisher<Output, Failure> {
        handleEvents(receiveOutput: cache.saveIgnoringResult).eraseToAnyPublisher()
    }
}

extension FeedCache {
    func saveIgnoringResult(feed: [FeedImage]) {
        save(feed) { _ in }
    }
}

extension Publisher {
    func dispatchOnMainQueue() -> AnyPublisher<Output, Failure> {
        receive(on: DispatchQueue.immediateWhenOnMainQueueScheduler).eraseToAnyPublisher()
    }
}

extension DispatchQueue {
    
    static var immediateWhenOnMainQueueScheduler: ImmediateWhenOnMainQueueScheduler {
        ImmediateWhenOnMainQueueScheduler()
    }
    
    struct ImmediateWhenOnMainQueueScheduler: Scheduler {
        typealias SchedulerTimeType = DispatchQueue.SchedulerTimeType
        typealias SchedulerOptions = DispatchQueue.SchedulerOptions
        
        var now: SchedulerTimeType {
            DispatchQueue.main.now
        }
        
        var minimumTolerance: SchedulerTimeType.Stride {
            DispatchQueue.main.minimumTolerance
        }
        
        func schedule(options: SchedulerOptions?, _ action: @escaping () -> Void) {
            guard Thread.isMainThread else {
                return DispatchQueue.main.schedule(options: options, action)
            }
            
            action()
        }
        
        func schedule(after date: SchedulerTimeType, tolerance: SchedulerTimeType.Stride, options: SchedulerOptions?, _ action: @escaping () -> Void) {
            DispatchQueue.main.schedule(after: date, tolerance: tolerance, options: options, action)
        }
        
        func schedule(after date: SchedulerTimeType, interval: SchedulerTimeType.Stride, tolerance: SchedulerTimeType.Stride, options: SchedulerOptions?, _ action: @escaping () -> Void) -> Cancellable {
            DispatchQueue.main.schedule(after: date, interval: interval, tolerance: tolerance, options: options, action)
        }
    }
}
