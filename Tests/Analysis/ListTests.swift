import XCTest
@testable import Analysis

class ListTests: XCTestCase {
    
    func testListMap() {
        let list: List = [2, 3, 5, "andrey"]
        let changed: List = list.map {
            switch $0 {
            case .integerValue(let number):
                return .stringValue(String(number))
            default: return $0
            }
        }
        let awaited: List = ["2", "3", "5", "andrey"]
        XCTAssertEqual(changed, awaited)
    }
    
    func testUnifiedMap() {
        let list: List = [2, 3, 5, "andrey", 12, "peter"]
        let numbers: [Int] = list.map { (number: Int) -> Int in
            return number * 2
        }
        XCTAssertEqual(numbers, [4, 6, 10, 24])
        let strings: [String] = list.map { (string: String) -> String in
            return string.uppercased()
        }
        XCTAssertEqual(strings, ["ANDREY", "PETER"])
    }
    
    func testAdvancedUnifiedMap() {
        let list: List = [2, 3, 5, "andrey", 12, "peter"]
        let numbers: [Int] = list.map { $0 * 2 }
        XCTAssertEqual(numbers, [4, 6, 10, 24])
        let strings: [String] = list.map { ($0 as String).uppercased() }
        XCTAssertEqual(strings, ["ANDREY", "PETER"])
    }
    
    func testEnumMapping() {
        enum Name: String, DataPointConvertible {
            case andrey, peter
        }
        let list: List = [2, 3, 5, "andrey", 12, "peter", "bjorn"]
        let names: [String] = list.map { ($0 as Name).rawValue }
        XCTAssertEqual(names, ["andrey", "peter"])
    }
    
    func testFilter() {
        let list: List = [2, 3, 5, false, nil, nil, "human", 4.0]
        let changed: [Int] = list.unified().filter({ $0 > 2 })
        XCTAssertEqual(changed, [3, 5])
    }
    
}