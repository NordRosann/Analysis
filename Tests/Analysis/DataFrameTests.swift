import XCTest
@testable import Analysis

class DataFrameTests: XCTestCase {
    
    func testDataFrameSchemeMutation() {
        let row: List = [2015, "UA", 4]
        let year = Variable(name: "year", type: Int.self)
        let code = Variable(name: "code", type: String.self)
        let value = Variable(name: "value", type: Int.self)
        let schema = RowSchema(variables: year, code, value)
        var frame = DataFrame(schema: schema, rows: [row])
        frame.schema.variables[2] = Variable(name: "value", type: String.self)
        XCTAssertEqual(frame.rows.first!, List(elements: [2015, "UA", .nullValue]))
    }
    
    func testDataFrameColumns() {
        let year = Variable(name: "year", type: Int.self)
        let code = Variable(name: "code", type: String.self)
        let value = Variable(name: "value", type: Int.self)
        let schema = RowSchema(variables: year, code, value)
        let years: List = [2015, 2016, 2017]
        let codes: List = ["UA", "RU", "BL"]
        let values: List = [4, 12, 5]
        let countriesFrame = DataFrame(schema: schema, columns: [years, codes, values])
        XCTAssertEqual(countriesFrame.rows, [[2015, "UA", 4], [2016, "RU", 12], [2017, "BL", 5]])
        // print(countriesFrame.rows)
    }
    
    func testDataFrameSubscripts() {
        let year = Variable(name: "year", type: Int.self)
        let code = Variable(name: "code", type: String.self)
        let value = Variable(name: "value", type: Int.self)
        let schema = RowSchema(variables: year, code, value)
        let rows: [List] = [[2015, "UA", 4], [2016, "RU", 12], [2017, "BL", 5]]
        let frame = schema.makeDataFrame(rows: rows)
        XCTAssertEqual(frame[year]!, [2015, 2016, 2017] as List)
        XCTAssertEqual(frame[code], ["UA", "RU", "BL"] as List)
        var newFrame = frame
        newFrame[year] = [2013, 2011, 2009]
        XCTAssertEqual(newFrame[row: 0, column: 0], 2013)
    }
    
    func testDataFrameWithDifferentColumnsLength() {
        let year = Variable(name: "year", type: Int.self)
        let code = Variable(name: "code", type: String.self)
        let value = Variable(name: "value", type: Int.self)
        let schema = RowSchema(variables: year, code, value)
        let years: List = [2015, 2016]
        let codes: List = ["UA", "RU", "BL", "GR"]
        let values: List = [4, 12, 5]
        let countriesFrame = DataFrame(schema: schema, columns: [years, codes, values])
        XCTAssertEqual(countriesFrame.rows, [[2015, "UA", 4], [2016, "RU", 12], [nil, "BL", 5], [nil, "GR", nil]])
        // print(countriesFrame.rows)
    }
    
    func testDataFrameWithShorterScheme() {
        let year = Variable(name: "year", type: Int.self)
        let code = Variable(name: "code", type: String.self)
        let value = Variable(name: "value", type: Int.self)
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
        let year = Variable(name: "year", type: Int.self)
        let code = Variable(name: "code", type: String.self)
        let value = Variable(name: "value", type: Int.self)
        let machine = Variable(name: "machine", type: String.self)
        let schema = RowSchema(variables: year, code, value, machine)
        let years: List = [2015, 2016, 2017]
        let codes: List = ["UA", "RU", "BL"]
        let values: List = [4, 12, 5]
        let countriesFrame = DataFrame(schema: schema, columns: [years, codes, values])
        XCTAssertEqual(countriesFrame.rows, [[2015, "UA", 4, nil], [2016, "RU", 12, nil], [2017, "BL", 5, nil]])
    }
    
    func testDataFrameTransformToEnum() {
        let year = Variable(name: "year", type: Int.self)
        let code = Variable(name: "code", type: String.self)
        let value = Variable(name: "value", type: Int.self)
        let schema = RowSchema(variables: year, code, value)
        let years: List = [2015, 2016, 2017]
        let codes: List = ["UA", "RU", "BL"]
        let values: List = [4, 12, 5]
        let countriesFrame = DataFrame(schema: schema, columns: [years, codes, values])
        print(countriesFrame)
        
        enum Country: String, DataPointConvertible {
            case ukraine = "UA"
            case russia = "RU"
            case belarus = "BL"
        }
        let countryCode = Variable(name: "country", type: Country.self)
        var secondFrame = countriesFrame
        secondFrame.schema.variables = secondFrame.schema.variables.map({ $0.name == "code" ? countryCode : $0 })
        let countries: [Country] = secondFrame.columns[1].unified()
        print(countries)
        XCTAssertEqual(countries, [Country.ukraine, Country.russia, Country.belarus])
        print(secondFrame)
    }
    
}