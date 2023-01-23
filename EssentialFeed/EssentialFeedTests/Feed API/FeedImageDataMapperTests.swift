import XCTest
import EssentialFeed


final class FeedImageDataMapperTests: XCTestCase {

    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        let samples = [199, 201, 300, 400, 500]

        try samples.forEach { code in
            XCTAssertThrowsError(try FeedImageDataMapper.map(anyData(), from: HTTPURLResponse(statusCode: code)))
        }
    }

    func test_map_deliversInvalidDataErrorOn200HTTPResponseWithEmptyData() {
        let emptyData = Data()

        XCTAssertThrowsError(
            try FeedImageDataMapper.map(emptyData, from: .init(statusCode: 200))
        )
    }

    func test_map_deliversReceivedNonEmptyDataOn200HTTPResponse() throws {
        let data = Data("any data".utf8)

        let result = try FeedImageDataMapper.map(data, from: .init(statusCode: 200))

        XCTAssertEqual(result, data)
    }
}
