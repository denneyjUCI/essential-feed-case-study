import XCTest

class HTTPClient {
    static var shared = HTTPClient()

    private init() {}

    var requestedURL: URL?
}

class RemoteFeedLoader {

    func load() {
        HTTPClient.shared.requestedURL = URL(string: "https://a-url.com")!
    }

}

final class RemoteFeedLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() throws {
        let client = HTTPClient.shared
        _ = RemoteFeedLoader()

        XCTAssertNil(client.requestedURL)
    }

    func test_load_requestsDataFromURL() throws {
        let client = HTTPClient.shared
        let sut = RemoteFeedLoader()

        sut.load()

        XCTAssertNotNil(client.requestedURL)
    }
}
