//
//  Created by Jonathan Denney on 1/20/23.
//

import XCTest
import EssentialFeed

final class ImageCommentsEndpointTests: XCTestCase {
    func test_image_endpointURL() {
        let id = UUID()
        let baseURL = URL(string: "http://base-url.com")!

        let received = ImageCommentsEndpoint.get(id).url(baseURL: baseURL)

        XCTAssertEqual(received.scheme, "http", "scheme")
        XCTAssertEqual(received.host, "base-url.com", "host")
        XCTAssertEqual(received.path, "/v1/image/\(id.uuidString)/comments", "path for image with id \(id.uuidString)")
    }
}
