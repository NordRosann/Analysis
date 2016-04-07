public struct Row {
    public var name: String
    private var values: [String: Any]
}

extension Row: Collection {
    public var endIndex: DictionaryIndex<String, Any> {
        return values.endIndex
    }
    public var startIndex: DictionaryIndex<String, Any> {
        return values.startIndex
    }
    public subscript(position: DictionaryIndex<String, Any>) -> (key: String, value: Any) {
        return values[position]
    }
    public subscript(bounds: Range<DictionaryIndex<String, Any>>) -> Slice<Dictionary<String, Any>> {
        return values[bounds]
    }
    public func makeIterator() -> DictionaryIterator<String, Any> {
        return values.makeIterator()
    }
}