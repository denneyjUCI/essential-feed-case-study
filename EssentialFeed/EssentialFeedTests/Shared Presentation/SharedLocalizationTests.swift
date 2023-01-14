import XCTest
import EssentialFeed

final class SharedLocalizationTests: XCTestCase {

    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalization() {
        let table = "Shared"
        let bundle = Bundle(for: LoadResourcePresenter<String, DummyView>.self)
        assertLocalizedKeyAndValuesExist(in: bundle, table)
    }

    struct DummyView: ResourceView {
        func display(_ viewModel: Any) {}
    }

}
