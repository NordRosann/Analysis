public struct List {
    
    public init(elements: [DataPoint]) {
        self.elements = elements
    }
    
    var elements: [DataPoint]
    
}

extension List {
    
    public subscript(index: Int) -> DataPoint {
        if index < elements.count {
            return elements[index]
        }
        return .nullValue
    }
    
}

extension List {
    
    mutating func transform(for schema: RowSchema) {
        self = transformed(for: schema)
    }
    
    func transformed(for schema: RowSchema) -> List {
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
    
    mutating func unify(for type: DataPointConvertible.Type) {
        self = unified(for: type)
    }
    
    func unified(for type: DataPointConvertible.Type) -> List {
        let newElements: [DataPoint] = elements.map { element in
            if let newElement = try? type.init(dataPoint: element) {
                return newElement.dataPoint
            } else {
                return .nullValue
            }
        }
        return List(elements: newElements)
    }
    
    func unified<T: DataPointInitializable>() -> [T] {
        return elements.flatMap({ try? T(dataPoint: $0) })
    }
    
}

extension List: ArrayLiteralConvertible {
    
    public init(arrayLiteral elements: DataPoint...) {
        self.elements = elements
    }
    
}

extension List: Equatable { }

public func == (lhs: List, rhs: List) -> Bool {
    return lhs.elements == rhs.elements
}