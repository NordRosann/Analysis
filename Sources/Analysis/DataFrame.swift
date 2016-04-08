public struct DataFrame {
    
    public init(schema: RowSchema, rows: [List]) {
        self.schema = schema
        self.rows = rows.map({ $0.adjusted(to: schema) })
    }
    
    public init(schema: RowSchema, columns: [List]) {
        self.schema = schema
        self.rows = columns.lazy.transposed().map({ $0.adjusted(to: schema) })
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
            return rows.transposed()
        }
        set {
            rows = newValue.lazy.transposed().map({ $0.adjusted(to: schema) })
        }
    }
    
    public var variables: [VariableDescription] {
        get {
            return schema.variables
        }
        set {
            schema.variables = variables
        }
    }
    
}

extension DataFrame {
    
    public subscript(row row: Int, column column: Int) -> DataPoint {
        get {
            return rows[row][column]
        }
        set {
            rows[row][column] = newValue
        }
    }
    
    public subscript(row: Int, column: Int) -> DataPoint {
        get {
            return self[row: row, column: column]
        }
        set {
            self[row: row, column: column] = newValue
        }
    }
    
    public subscript(rowsBounds: Range<Int>, column: Int) -> List {
        get {
            return rows[rowsBounds][column]
        }
        set {
            rows[rowsBounds][column] = newValue
        }
    }
    
    public subscript(row: Int, columnBounds: Range<Int>) -> List {
        get {
            return columns[columnBounds][row]
        }
        set {
            columns[columnBounds][row] = newValue
        }
    }
    
    public subscript(rowsBounds: Range<Int>, columnBounds: Range<Int>) -> [List] {
        get {
            return columnBounds.map { rows[rowsBounds][$0] }
        }
        // TODO: Set for subscript
    }
    
    public subscript(variable: VariableDescription) -> List? {
        get {
            for (list, description) in zip(columns, variables) {
                if description == variable {
                    return list
                }
            }
            return nil
        }
        set {
            guard let list = newValue else { return }
            columns = zip(columns, variables).lazy.map { column, description in
                if description == variable {
                    return list
                }
                return column
            }
        }
    }
    
}

extension DataFrame {
    
    public typealias KeyedList = [String: DataPoint]
    
    public var keyedRows: [[String: DataPoint]] {
        get {
            return rows.map({ $0.keyed(with: schema) })
        }
        set {
            rows = newValue.map({ List(elements: Array($0.values)) })
        }
    }
    
    public var coupledRows: [[VariableDescription: DataPoint]] {
        get {
            return rows.map({ $0.coupled(with: schema) })
        }
        set {
            rows = newValue.map({ List(elements: Array($0.values)) })
        }
    }
    
}

extension DataFrame: Equatable { }

public func == (lhs: DataFrame, rhs: DataFrame) -> Bool {
    return lhs.schema == rhs.schema && 
        lhs.rows == rhs.rows
}