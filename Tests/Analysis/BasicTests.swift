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
        let row = List(elements: [2015, "UA", 4, "shit"])
        let year = VariableDescription(name: "year", type: Int.self)
        let code = VariableDescription(name: "code", type: String.self)
        let value = VariableDescription(name: "value", type: Int.self)
        let anotherValue = VariableDescription(name: "anVal", type: Int.self)
        let schema = RowSchema(variables: year, code, value, anotherValue)
        let newRow = row.transformed(for: schema)
        XCTAssertEqual(newRow.elements, [2015, "UA", 4, .nullValue])
    }
    
    func testTransformShorter() {
        let row = List(elements: [2015, "UA", 4])
        let year = VariableDescription(name: "year", type: Int.self)
        let code = VariableDescription(name: "code", type: String.self)
        let value = VariableDescription(name: "value", type: Int.self)
        let anotherValue = VariableDescription(name: "anVal", type: Int.self)
        let schema = RowSchema(variables: year, code, value, anotherValue)
        let newRow = row.transformed(for: schema)
        XCTAssertEqual(newRow.elements, [2015, "UA", 4, .nullValue])
    }
    
    func testTransformLonger() {
        let row = List(elements: [2015, "UA", 4, "EU"])
        let year = VariableDescription(name: "year", type: Int.self)
        let code = VariableDescription(name: "code", type: String.self)
        let value = VariableDescription(name: "value", type: Int.self)
        let schema = RowSchema(variables: year, code, value)
        let newRow = row.transformed(for: schema)
        XCTAssertEqual(newRow.elements, [2015, "UA", 4])
    }
    
    func testDataFrameSchemeMutation() {
        let row: List = [2015, "UA", 4]
        let year = VariableDescription(name: "year", type: Int.self)
        let code = VariableDescription(name: "code", type: String.self)
        let value = VariableDescription(name: "value", type: Int.self)
        let schema = RowSchema(variables: year, code, value)
        var frame = DataFrame(schema: schema, rows: [row])
        frame.schema.variables[2] = VariableDescription(name: "value", type: String.self)
        XCTAssertEqual(frame.rows.first!, List(elements: [2015, "UA", .nullValue]))
    }
    
    func testDataFrameColumns() {
        let year = VariableDescription(name: "year", type: Int.self)
        let code = VariableDescription(name: "code", type: String.self)
        let value = VariableDescription(name: "value", type: Int.self)
        let schema = RowSchema(variables: year, code, value)
        let years: List = [2015, 2016, 2017]
        let codes: List = ["UA", "RU", "BL"]
        let values: List = [4, 12, 5]
        let countriesFrame = DataFrame(schema: schema, columns: [years, codes, values])
        XCTAssertEqual(countriesFrame.rows, [[2015, "UA", 4], [2016, "RU", 12], [2017, "BL", 5]])
        // print(countriesFrame.rows)
    }
    
    func testDataFrameWithDifferentColumnsLength() {
        let year = VariableDescription(name: "year", type: Int.self)
        let code = VariableDescription(name: "code", type: String.self)
        let value = VariableDescription(name: "value", type: Int.self)
        let schema = RowSchema(variables: year, code, value)
        let years: List = [2015, 2016]
        let codes: List = ["UA", "RU", "BL", "GR"]
        let values: List = [4, 12, 5]
        let countriesFrame = DataFrame(schema: schema, columns: [years, codes, values])
        XCTAssertEqual(countriesFrame.rows, [[2015, "UA", 4], [2016, "RU", 12], [nil, "BL", 5], [nil, "GR", nil]])
        // print(countriesFrame.rows)
    }
    
    func testDataFrameWithShorterScheme() {
        let year = VariableDescription(name: "year", type: Int.self)
        let code = VariableDescription(name: "code", type: String.self)
        let value = VariableDescription(name: "value", type: Int.self)
        let schema = RowSchema(variables: year, code, value)
        let years: List = [2015, 2016, 2017]
        let codes: List = ["UA", "RU", "BL"]
        let values: List = [4, 12, 5]
        let machines: List = ["How", "Big", "How"]
        let countriesFrame = DataFrame(schema: schema, columns: [years, codes, values, machines])
        XCTAssertEqual(countriesFrame.rows, [[2015, "UA", 4], [2016, "RU", 12], [2017, "BL", 5]])
        // print(countriesFrame.rows)
    }
    
    func testDataFrameWithLongerScheme() {
        let year = VariableDescription(name: "year", type: Int.self)
        let code = VariableDescription(name: "code", type: String.self)
        let value = VariableDescription(name: "value", type: Int.self)
        let machine = VariableDescription(name: "machine", type: String.self)
        let schema = RowSchema(variables: year, code, value, machine)
        let years: List = [2015, 2016, 2017]
        let codes: List = ["UA", "RU", "BL"]
        let values: List = [4, 12, 5]
        let countriesFrame = DataFrame(schema: schema, columns: [years, codes, values])
        XCTAssertEqual(countriesFrame.rows, [[2015, "UA", 4, nil], [2016, "RU", 12, nil], [2017, "BL", 5, nil]])
    }
    
}