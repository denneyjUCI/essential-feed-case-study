//
//  DebuggingSceneDelegate.swift
//  EssentialApp
//
//  Created by Jonathan Denney on 1/11/23.
//

#if DEBUG
import UIKit
import EssentialFeed

final class DebuggingSceneDelegate: SceneDelegate {

    override func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        super.scene(scene, willConnectTo: session, options: connectionOptions)

        if CommandLine.arguments.contains("-reset") {
            try? FileManager.default.removeItem(at: imageStoreURL)
        }
    }

    override func makeRemoteClient() -> HTTPClient {
        if UserDefaults.standard.string(forKey: "connectivity") == "offline" {
            return AlwaysFailingHTTPClient()
        }

        return super.makeRemoteClient()
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

#endif
