public struct RowSchema {
    public var variables: [VariableDescription]
    public init(variables: VariableDescription...) {
        self.variables = variables
    }
}