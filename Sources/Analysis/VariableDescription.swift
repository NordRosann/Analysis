public struct Variable {
    
    public init(name: String, type: DataPointConvertible.Type) {
        self.name = name
        self.type = type
    }
    
    public var name: String
    public let type: DataPointConvertible.Type
    
}

extension Variable: Hashable {
    
    public var hashValue: Int {
        return name.hashValue
    }
    
}

public func == (lhs: Variable, rhs: Variable) -> Bool {
    return lhs.name == rhs.name && lhs.type == rhs.type
}