//
//  Created by Jonathan Denney on 1/20/23.
//

import Foundation

public enum FeedEndpoint {
    case get

    public func url(baseURL: URL) -> URL {
        switch self {
        default:
            return baseURL.appendingPathComponent("/v1/feed")
        }
    }
}
