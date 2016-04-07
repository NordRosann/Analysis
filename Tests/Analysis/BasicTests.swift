import XCTest
@testable import Analysis

class BasicTests: XCTestCase {
    
    func testFirst() {
        let year = VariableDescription(name: "year", type: Int.self)
        let code = VariableDescription(name: "code", type: String.self)
        let schema = RowSchema(variables: year, code)
        if let year = try? year.type.init(dataPoint: 15) {
            print("Success \(year)")
        }
        print(schema)
    }
    
    func testRawValueInit() {
        enum Barney: String, DataPointConvertible {
            case stinson
            case awesome
        }
        let point: DataPoint = "stinson"
        let barney = try! Barney(dataPoint: point)
        XCTAssertEqual(barney, Barney.stinson)
    }
    
    func testRawValuePoint() {
        enum Barney: String, DataPointConvertible {
            case stinson
            case awesome
        }
        let awesome = Barney.awesome
        let point = awesome.dataPoint
        XCTAssertEqual(point, DataPoint.stringValue("awesome"))
    }
    
}