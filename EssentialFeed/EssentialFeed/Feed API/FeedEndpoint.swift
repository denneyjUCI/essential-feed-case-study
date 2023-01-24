//
//  Created by Jonathan Denney on 1/20/23.
//

import Foundation

public enum FeedEndpoint {
    case get(after: UUID? = nil)

    public func url(baseURL: URL) -> URL {
        switch self {
        case let .get(id):
            var components = URLComponents()
            components.scheme = baseURL.scheme
            components.host = baseURL.host
            components.path = baseURL.path + "/v1/feed"
            components.queryItems = [
                URLQueryItem(name: "limit", value: "10"),
                id.map { URLQueryItem(name: "after_id", value: $0.uuidString) }
            ].compactMap { $0 }
            return components.url!
        }
    }
}
