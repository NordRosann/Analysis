public struct DataFrame {
    
    public init(schema: RowSchema, rows: [List]) {
        self.schema = schema
        self.rows = rows.map({ $0.adjusted(to: schema) })
    }
    
    public init(schema: RowSchema, columns: [List]) {
        self.schema = schema
        self.rows = columns.lazy.difuse().map({ $0.adjusted(to: schema) })
    }

    public var schema: RowSchema {
        didSet {
            rows = rows.map({ $0.adjusted(to: schema) })
        }
    }
    
    public var rows: [List] {
        didSet {
            rows = rows.map({ $0.adjusted(to: schema) })
        }
    }

    public var columns: [List] {
        get {
            return rows.difuse()
        }
        set {
            rows = newValue.lazy.difuse().map({ $0.adjusted(to: schema) })
        }
    }
    
}

extension DataFrame: Equatable { }

public func == (lhs: DataFrame, rhs: DataFrame) -> Bool {
    return lhs.schema == rhs.schema && 
        lhs.rows == rhs.rows
}