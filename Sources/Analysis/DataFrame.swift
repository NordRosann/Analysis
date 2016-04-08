public struct DataFrame {
    
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
    
    public init(schema: RowSchema, rows: [List]) {
        self.schema = schema
        self.rows = rows.map({ $0.transformed(for: schema) })
    }
    
    public init(schema: RowSchema, columns: [List]) {
        self.schema = schema
        guard let rowsCount = columns.map({ $0.elements.count }).max() else {
            self.rows = []
            return
        }
        self.rows = (0 ..< rowsCount).map { index in
            let mapped = columns.map({ $0[index] })
            return List(elements: mapped).transformed(for: schema)
        }
    }
    
}