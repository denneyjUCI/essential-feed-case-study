import XCTest
import EssentialFeed

final class FeedItemsMapperTests: XCTestCase {

    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        let json = makeItemsJSON([])
        let samples = [199, 201, 300, 400, 500]

        try samples.forEach { code in
            XCTAssertThrowsError(
                try FeedItemsMapper.map(json, HTTPURLResponse(statusCode: code))
            )
        }
    }

    func test_load_deliversInvalidDataResponseOn200ResponseAndInvalidJSON() throws {
        let json = Data("invalid json".utf8)

        XCTAssertThrowsError(
            try FeedItemsMapper.map(json, HTTPURLResponse(statusCode: 200))
        )
    }

    func test_load_deliversEmptyResultOn200ResponseWithEmptyJSONList() throws {
        let json = makeItemsJSON([])

        let result = try FeedItemsMapper.map(json, HTTPURLResponse(statusCode: 200))

        XCTAssertEqual(result, [])
    }

    func test_load_deliversNoItemsOn200ResponseAndEmptyJSONList() throws {
        let item1 = makeItem(id: UUID(),
                             imageURL: URL(string: "http://a-url.com")!)

        let item2 = makeItem(id: UUID(),
                             description: "a description",
                             location: "a location",
                             imageURL: URL(string: "http://another-url.com")!)

        let items = [item1.model, item2.model]
        let itemsJSON = makeItemsJSON([item1.json, item2.json])

        let result = try FeedItemsMapper.map(itemsJSON, HTTPURLResponse(statusCode: 200))

        XCTAssertEqual(result, items)
    }

    // MARK: - Helpers

    private func makeItem(id: UUID, description: String? = nil, location: String? = nil, imageURL: URL) -> (model: FeedImage, json: [String: Any]) {
        let item = FeedImage(id: id,
                             description: description,
                             location: location,
                             url: imageURL)
        let itemJSON = [
            "id": id.uuidString,
            "description": description,
            "location": location,
            "image": imageURL.absoluteString
        ].compactMapValues { $0 }

        return (model: item, json: itemJSON)
    }
}
