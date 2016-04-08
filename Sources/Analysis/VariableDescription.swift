public struct VariableDescription {
    
    public init(name: String, type: DataPointConvertible.Type) {
        self.name = name
        self.type = type
    }
    
    public var name: String
    public let type: DataPointConvertible.Type
    
}

extension VariableDescription: Equatable { }

public func == (lhs: VariableDescription, rhs: VariableDescription) -> Bool {
    return lhs.name == rhs.name && lhs.type == rhs.type
}