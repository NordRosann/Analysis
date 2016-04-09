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
        let changed: [Int] = list.filter({ $0 > 2 })
        XCTAssertEqual(changed, [3, 5])
    }
    
    func testKeying() {
        let year = Variable(name: "year", type: Int.self)
        let code = Variable(name: "code", type: String.self)
        let value = Variable(name: "value", type: Int.self)
        let schema = RowSchema(variables: year, code, value)
        let list: List = [2015, "UA", 4]
        let keyed = list.keyed(with: schema)
        let expected: [String: DataPoint] = ["year": 2015, "code": "UA", "value": 4]
        XCTAssertEqual(keyed, expected)
    }
    
    func testCoupling() {
        let year = Variable(name: "year", type: Int.self)
        let code = Variable(name: "code", type: String.self)
        let value = Variable(name: "value", type: Int.self)
        let schema = RowSchema(variables: year, code, value)
        let list: List = [2015, "UA", 4]
        let keyed = list.coupled(with: schema)
        let expected: [Variable: DataPoint] = [year: 2015, code: "UA", value: 4]
        XCTAssertEqual(keyed, expected)
    }
    
    func testSorting() {
        let list: List = [2, 5, 0, 4, "key", 8, -1, "fake", false, nil, nil, 15]
        let sorted: [Int] = list.sorted { ($0 as Int) < $1 }
        let unifiedSorted: [Int] = list.unified().sorted { $0 < $1 }
        let unifiedStrignsSorted: [String] = list.unified().sorted { $0.characters.count < $1.characters.count }
        let expected = [-1, 0, 2, 4, 5, 8, 15]
        let expectedStrings = ["key", "fake"]
        XCTAssertEqual(sorted, expected)
        XCTAssertEqual(unifiedSorted, expected)
        XCTAssertEqual(unifiedStrignsSorted, expectedStrings)
    }
    
}