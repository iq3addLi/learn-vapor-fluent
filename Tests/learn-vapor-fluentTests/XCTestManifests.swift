import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(learn_vapor_fluentTests.allTests),
    ]
}
#endif
