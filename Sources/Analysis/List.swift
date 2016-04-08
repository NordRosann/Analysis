public struct List {
    
    public init(elements: [DataPoint]) {
        self.elements = elements
    }
    
    private(set) var elements: [DataPoint]
    
}

extension List {
    
    public subscript(index: Int) -> DataPoint {
        get {
            if index < elements.count {
                return elements[index]
            }
            return .nullValue
        }
        set {
            elements[index] = newValue
        }
    }
    
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

extension List: RangeReplaceableCollection {
    
    public typealias Index = Int
    
    public init() {
        self.init(elements: [])
    }
    
    public var startIndex: Int {
        return elements.startIndex
    }
    
    public var endIndex: Int {
        return elements.endIndex
    }
    
    public subscript(bounds: Range<Int>) -> ArraySlice<DataPoint> {
        get {
            return elements[bounds]
        }
        set {
            elements[bounds] = newValue
        }
    }
    
    public func makeIterator() -> IndexingIterator<[DataPoint]> {
        return elements.makeIterator()
    }
    
    public mutating func replaceSubrange<C: Collection where C.Iterator.Element == DataPoint>(subRange: Range<Int>, with newElements: C) {
        elements.replaceSubrange(subRange, with: newElements)
    }
    
}

extension List: MutableCollection { }

extension List {
    
    public func map(@noescape transform: @noescape (DataPoint) throws -> DataPoint) rethrows -> List {
        let transformed: [DataPoint] = try self.map(transform)
        return List(elements: transformed)
    }
    
    public func map<U: DataPointConvertible, T>(@noescape transform: @noescape (U) throws -> T) rethrows -> [T] {
        print("Me got called!")
        return try (unified() as [U]).map(transform)
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

extension Sequence where Iterator.Element == List {
    internal func difuse() -> [List] {
        guard let rowsCount = map({ $0.elements.count }).max() else {
            return []
        }
        return (0 ..< rowsCount).map { index in
            let mapped = map({ $0[index] })
            return List(elements: mapped)
        }
    }
}

extension Sequence where Iterator.Element: Hashable {
    public func distinct() -> Set<Iterator.Element> {
        return Set(self)
    }
}

