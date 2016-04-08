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
    
    
    
}

extension RowSchema: Equatable { }

public func == (lhs: RowSchema, rhs: RowSchema) -> Bool {
    return lhs.variables == rhs.variables
}