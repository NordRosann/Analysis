public protocol Column: Collection {
    associatedtype CellValue
    var values: [CellValue] { get }
}

extension Column {
    public var endIndex: Int {
        return values.endIndex
    }
    public var startIndex: Int {
        return values.startIndex
    }
    public subscript(position: Int) -> CellValue {
        return values[position]
    }
    public subscript(bounds: Range<Int>) -> ArraySlice<CellValue> {
        return values[bounds]
    }
    public func makeIterator() -> IndexingIterator<[CellValue]> {
        return values.makeIterator()
    }
}

public struct MatrixColumn<Element>: Column {
    public var name: String?
    private let storage: [Element]
    public var values: [Element] {
        return storage
    }
}

extension MatrixColumn {
    public init(values: [Element], name: String? = nil) {
        self.storage = values
        self.name = name
    }
}