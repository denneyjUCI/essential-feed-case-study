import XCTest
import EssentialFeed

final class ImageCommentsLocalizationTests: XCTestCase {

    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalization() {
        let table = "ImageComments"
        let bundle = Bundle(for: ImageCommentsPresenter.self)
        assertLocalizedKeyAndValuesExist(in: bundle, table)
    }

}
