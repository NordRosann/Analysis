public struct RowSchema {
    
    public var variables: [VariableDescription]
    
    public init(variables: VariableDescription...) {
        self.variables = variables
    }
    
    public init(variables: [VariableDescription]) {
        self.variables = variables
    }
    
}

extension RowSchema {
    
    public var length: Int {
        return variables.count
    }
    
    public func makeDataFrame(rows rows: [List]) -> DataFrame {
        return DataFrame(schema: self, rows: rows)
    }
    
    public func makeDataFrame(columns columns: [List]) -> DataFrame {
        return DataFrame(schema: self, columns: columns)
    }
    
}

extension RowSchema: Equatable { }

public func == (lhs: RowSchema, rhs: RowSchema) -> Bool {
    return lhs.variables == rhs.variables
}

extension List {
    
    mutating func adjust(to schema: RowSchema) {
        self = adjusted(to: schema)
    }
    
    func adjusted(to schema: RowSchema) -> List {
        let sizeDiff = schema.length - elements.count
        let curElements = sizeDiff > 0 ? elements + [DataPoint](repeating: .nullValue, count: sizeDiff) : elements
        let zipped = zip(curElements, schema.variables)
        let newElements: [DataPoint] = zipped.map { element, description in
            if let newElement = try? description.type.init(dataPoint: element) {
                return newElement.dataPoint
            } else {
                return .nullValue
            }
        }
        return List(elements: newElements)
    }
    
}