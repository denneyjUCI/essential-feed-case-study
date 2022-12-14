import XCTest

protocol HTTPClient {
    func get(from url: URL)
}

class RemoteFeedLoader {
    let url: URL
    let client: HTTPClient

    init(url: URL = URL(string: "http://any-url.com")!, client: HTTPClient) {
        self.url = url
        self.client = client
    }

    func load() {
        client.get(from: url)
    }

}

final class RemoteFeedLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() throws {
        let (_, client) = makeSUT()

        XCTAssertNil(client.requestedURL)
    }

    func test_load_requestsDataFromURL() throws {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)

        sut.load()

        XCTAssertEqual(client.requestedURL, url)
    }

    // MARK: - Helpers
    private func makeSUT(
        url: URL = URL(string: "http://any-url.com")!
    ) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        return (sut, client)
    }

    private class HTTPClientSpy: HTTPClient {
        var requestedURL: URL?

        func get(from url: URL) {
            requestedURL = url
        }
    }
}
