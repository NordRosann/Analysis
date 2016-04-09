import XCTest
@testable import Analysis

class TransposeTests: XCTestCase {
    
    func testRegularTranspose() {
        let years: List = [2015, 2014, 2013]
        let codes: List = ["UA", "RU", "PL"]
        let values: List = [4, 5, 6]
        let lists = [years, codes, values]
        let rotated = lists.transposed()
        XCTAssertEqual(rotated[0], [2015, "UA", 4])
    }
    
    func testRowTranspose() {
        let ukraine: List = ["UA", 2015, 4]
        let russia: List = ["RU", 2014, 5]
        let poland: List = ["PL", 2013, 6]
        let lists = [ukraine, russia, poland]
        let rotated = lists.transposed()
        XCTAssertEqual(rotated[0], ["UA", "RU", "PL"])
    }
    
    func testDifferentSizedRowTranspose() {
        let ukraine: List = ["UA", 2015, 4, false]
        let russia: List = ["RU", 2014, 5]
        let poland: List = ["PL", 2013]
        let lists = [ukraine, russia, poland]
        let rotated = lists.transposed()
        XCTAssertEqual(rotated, [["UA", "RU", "PL"], [2015, 2014, 2013], [4, 5, nil], [false, nil, nil]])
    }
    
    func testAligned() {
        let ukraine: List = ["UA", 2015, 4, false]
        let russia: List = ["RU", 2014, 5]
        let poland: List = ["PL", 2013]
        let lists = [ukraine, russia, poland]
        let aligned = lists.aligned()
        XCTAssertEqual(aligned, [ukraine, ["RU", 2014, 5, nil], ["PL", 2013, nil, nil]])
    }
    
}