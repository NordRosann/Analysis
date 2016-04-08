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
    
    func keyed(with schema: RowSchema) -> [String: DataPoint] {
        let zipped = zip(self, schema.variables.map({ $0.name }))
        return zipped.reduce([:]) {
            var dict = $0
            dict[$1.1] = $1.0
            return dict
        }
    }
    
    // TODO: Find a better name
    func coupled(with schema: RowSchema) -> [Variable: DataPoint] {
        let zipped = zip(self, schema.variables)
        return zipped.reduce([:]) {
            var dict = $0
            dict[$1.1] = $1.0
            return dict
        }
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
    
    // TODO: Redesign
    public func map<U: DataPointInitializable, T: DataPointRepresentable>(@noescape transform: @noescape (U) throws -> T) rethrows -> List {
        let mapped: [DataPoint] = try self.map {
            do {
                let transformingValue = try U(dataPoint: $0)
                do {
                    return try transform(transformingValue).dataPoint
                } catch let error {
                    throw error
                }
            } catch let error where error is DataPoint.Error {
                return $0
            }
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
        let filtered: [T] = try filter(includeElement)
        return List(representables: filtered)
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
    internal func transposed() -> [List] {
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

