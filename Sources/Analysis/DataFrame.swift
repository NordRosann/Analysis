public struct DataFrame {
    
    public init(schema: RowSchema, rows: [List]) {
        self.schema = schema
        self.rows = rows.map({ $0.transformed(for: schema) })
    }
    
    public init(schema: RowSchema, columns: [List]) {
        self.schema = schema
        self.rows = columns.lazy.difuse().map({ $0.transformed(for: schema) })
    }

    public var schema: RowSchema {
        didSet {
            rows = rows.map({ $0.transformed(for: schema) })
        }
    }
    
    public var rows: [List] {
        didSet {
            rows = rows.map({ $0.transformed(for: schema) })
        }
    }

    public var columns: [List] {
        get {
            return rows.difuse()
        }
        set {
            rows = newValue.lazy.difuse().map({ $0.transformed(for: schema) })
        }
    }
    
}