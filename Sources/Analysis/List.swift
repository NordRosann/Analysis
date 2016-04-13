public struct List {
    
    public init(elements: [DataPoint]) {
        self.elements = elements
    }
    
    public init<T: DataPointRepresentable>(representables: [T]) {
        self.elements = representables.map({ $0.dataPoint })
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
    
    public mutating func unify(for type: DataPointConvertible.Type) {
        self = unified(for: type)
    }
    
    public func unified(for type: DataPointConvertible.Type) -> List {
        let newElements: [DataPoint] = elements.map { element in
            if let newElement = try? type.init(dataPoint: element) {
                return newElement.dataPoint
            } else {
                return .nullValue
            }
        }
        return List(elements: newElements)
    }
    
    public func unified<T: DataPointInitializable>() -> [T] {
        return elements.flatMap({ try? T(dataPoint: $0) })
    }
    
    public func keyed(with schema: RowSchema) -> [String: DataPoint] {
        let zipped = zip(schema.variables.map({ $0.name }), self)
        return zipped.toDict()
    }
    
    // TODO: Find a better name
    func coupled(with schema: RowSchema) -> [Variable: DataPoint] {
        let zipped = zip(schema.variables, self)
        return zipped.toDict()
        
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
    
    public mutating func replaceSubrange<C: Collection where C.Iterator.Element == DataPoint>(_ subRange: Range<Int>, with newElements: C) {
        elements.replaceSubrange(subRange, with: newElements)
    }
    
}

extension List: MutableCollection { }

// MARK: - Custom high-order functions

extension List {
    
    // MARK: Map
    
    public func map(@noescape transform: @noescape (DataPoint) throws -> DataPoint) rethrows -> List {
        let transformed: [DataPoint] = try self.map(transform)
        return List(elements: transformed)
    }
    
    public func map<U: DataPointInitializable, T>(@noescape transform: @noescape (U) throws -> T) rethrows -> [T] {
        print("Me got called!")
        return try (unified() as [U]).map(transform)
    }
    
    public func map<U: DataPointInitializable, T: DataPointRepresentable>(@noescape transform: @noescape (U) throws -> T) rethrows -> List {
        let mapped: [DataPoint] = try self.map {
            if let transformingValue = try? U(dataPoint: $0) {
                return try transform(transformingValue).dataPoint
            }
            return $0
        }
        return List(elements: mapped)
    }
    
    // MARK: Filter
    
    public func filter(@noescape includeElement: @noescape (DataPoint) throws -> Bool) rethrows -> List {
        let filtered: [DataPoint] = try self.filter(includeElement)
        return List(elements: filtered)
    }
    
    public func filter<T: DataPointInitializable>(@noescape includeElement: @noescape (T) throws -> Bool) rethrows -> [T] {
        let unifiedArray: [T] = unified()
        return try unifiedArray.filter(includeElement)
    }
    
    public func filter<T: DataPointConvertible>(@noescape includeElement: @noescape (T) throws -> Bool) rethrows -> List {
        let filtered: [DataPoint] = try self.filter {
            if let filteringValue = try? T(dataPoint: $0) {
                return try includeElement(filteringValue)
            }
            return true
        }
        return List(elements: filtered)
    }
    
}

extension List: ArrayLiteralConvertible {
    
    public init(arrayLiteral elements: DataPoint...) {
        self.elements = elements
    }
    
}

extension List: Hashable {
    public var hashValue: Int {
        return elements.reduce(0) { $0 + $1.hashValue }
    }
}

public func == (lhs: List, rhs: List) -> Bool {
    return lhs.elements == rhs.elements
}

extension Sequence where Iterator.Element == List {
    
    public func transposed() -> [List] {
        guard let rowsCount = map({ $0.elements.count }).max() else {
            return []
        }
        return (0 ..< rowsCount).map { index in
            let mapped = map({ $0[index] })
            return List(elements: mapped)
        }
    }
    
    public func aligned() -> [List] {
        guard let longest = map({ $0.elements.count }).max() else {
            return []
        }
        return self.map({ $0.count < longest ? $0.filled(upTo: longest) : $0 })
    }
    
}

private extension List {
    
    func filled(upTo size: Int) -> List {
        let sizeDiff = size - self.count
        if sizeDiff > 0 {
            return self + List(elements: [DataPoint](repeating: .nullValue,
                                                     count: sizeDiff))
        }
        return self
    }
    
}

extension Sequence where Iterator.Element: Hashable {
    public func distinct() -> [Iterator.Element] {
        return Array(Set(self))
    }
}

private extension Zip2Sequence where Sequence1.Iterator.Element: Hashable {
    
    func toDict() -> Dictionary<Sequence1.Iterator.Element, Sequence2.Iterator.Element> {
        return {
            var dict: [Sequence1.Iterator.Element: Sequence2.Iterator.Element] = [:]
            for (element1, element2) in self {
                dict[element1] = element2
            }
            return dict
        }()
    }
    
}

