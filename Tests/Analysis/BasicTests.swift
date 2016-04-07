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
    
    func testTransform() {
        let row = Row(elements: [2015, "UA", 4, "shit"])
        let year = VariableDescription(name: "year", type: Int.self)
        let code = VariableDescription(name: "code", type: String.self)
        let value = VariableDescription(name: "value", type: Int.self)
        let anotherValue = VariableDescription(name: "anVal", type: Int.self)
        let schema = RowSchema(variables: year, code, value, anotherValue)
        let newRow = row.transformed(for: schema)
        XCTAssertEqual(newRow.elements, [2015, "UA", 4, .nullValue])
    }
    
    func testTransformShorter() {
        let row = Row(elements: [2015, "UA", 4])
        let year = VariableDescription(name: "year", type: Int.self)
        let code = VariableDescription(name: "code", type: String.self)
        let value = VariableDescription(name: "value", type: Int.self)
        let anotherValue = VariableDescription(name: "anVal", type: Int.self)
        let schema = RowSchema(variables: year, code, value, anotherValue)
        let newRow = row.transformed(for: schema)
        XCTAssertEqual(newRow.elements, [2015, "UA", 4, .nullValue])
    }
    
    func testTransformLonger() {
        let row = Row(elements: [2015, "UA", 4, "EU", false])
        let year = VariableDescription(name: "year", type: Int.self)
        let code = VariableDescription(name: "code", type: String.self)
        let value = VariableDescription(name: "value", type: Int.self)
        let anotherValue = VariableDescription(name: "anVal", type: String.self)
        let schema = RowSchema(variables: year, code, value, anotherValue)
        let newRow = row.transformed(for: schema)
        XCTAssertEqual(newRow.elements, [2015, "UA", 4, "EU"])
    }
    
}