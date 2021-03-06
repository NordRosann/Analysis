public protocol DataPointInitializable {
    init(dataPoint: DataPoint) throws
}

public protocol DataPointRepresentable {
    var dataPoint: DataPoint { get }
}

public protocol DataPointConvertible: DataPointInitializable, DataPointRepresentable { }

public enum DataPoint {
    case nullValue
    case boolValue(Bool)
    case numericValue(Double)
    case integerValue(Int)
    case stringValue(String)
    
    public enum Error: ErrorProtocol {
        case incompatibleType
        case cantInitFromGivenValue
    }
}

extension DataPoint {
    
    public func get<T>() -> T? {
        switch self {
        case .nullValue:
            return nil
        case .boolValue(let bool):
            return bool as? T
        case .numericValue(let double):
            return double as? T
        case .integerValue(let integer):
            return integer as? T
        case .stringValue(let string):
            return string as? T
        }
    }
    
    public func get<T>() throws -> T {
        switch self {
        case .boolValue(let bool):
            if let value = bool as? T { return value }
        case .numericValue(let double):
            if let value = double as? T { return value }
        case .integerValue(let integer):
            if let value = integer as? T { return value }
        case .stringValue(let string):
            if let value = string as? T { return value }
        default: break
        }
        throw Error.incompatibleType
    }
    
    public func get<T: DataPointInitializable>() throws -> T {
        return try T(dataPoint: self)
    }
    
}

extension DataPoint {
    
    func isSameType(as dataPoint: DataPoint) -> Bool {
        switch self {
        case .nullValue:
            return dataPoint == .nullValue
        case .boolValue:
            switch dataPoint {
            case .boolValue: return true
            default: return false
            }
        case .numericValue:
            switch dataPoint {
            case .numericValue: return true
            default: return false
            }
        case .integerValue:
            switch dataPoint {
            case .integerValue: return true
            default: return false
        }
        case .stringValue:
            switch dataPoint {
            case .stringValue: return true
            default: return false
            }
        }
    }
    
}

extension DataPoint: Hashable {
    public var hashValue: Int {
        switch self {
        case .nullValue:
            return 0
        case .boolValue(let bool):
            return bool.hashValue
        case .numericValue(let double):
            return double.hashValue
        case .integerValue(let integer):
            return integer.hashValue
        case .stringValue(let string):
            return string.hashValue
        }
    }
}

public func == (lhs: DataPoint, rhs: DataPoint) -> Bool {
    switch lhs {
    case .nullValue:
        switch rhs {
        case .nullValue: return true
        default: return false
        }
    case .boolValue(let lhsValue):
        switch rhs {
        case .boolValue(let rhsValue): return lhsValue == rhsValue
        default: return false
        }
    case .numericValue(let lhsValue):
        switch rhs {
        case .numericValue(let rhsValue): return lhsValue == rhsValue
        default: return false
        }
    case .integerValue(let lhsValue):
        switch rhs {
        case .integerValue(let rhsValue): return lhsValue == rhsValue
        default: return false
        }
    case .stringValue(let lhsValue):
        switch rhs {
        case .stringValue(let rhsValue): return lhsValue == rhsValue
        default: return false
        }
    }
}

extension DataPoint: NilLiteralConvertible {
    public init(nilLiteral: ()) {
        self = .nullValue
    }
}

extension DataPoint: BooleanLiteralConvertible {
    public init(booleanLiteral value: BooleanLiteralType) {
        self = .boolValue(value)
    }
}

extension DataPoint: IntegerLiteralConvertible {
    public init(integerLiteral value: IntegerLiteralType) {
        self = .integerValue(value)
    }
}

extension DataPoint: FloatLiteralConvertible {
    public init(floatLiteral value: FloatLiteralType) {
        self = .numericValue(value)
    }
}

extension DataPoint: StringLiteralConvertible {
    public init(unicodeScalarLiteral value: String) {
        self = .stringValue(value)
    }
    public init(extendedGraphemeClusterLiteral value: String) {
        self = .stringValue(value)
    }
    public init(stringLiteral value: StringLiteralType) {
        self = .stringValue(value)
    }
}

extension DataPoint: CustomStringConvertible {
    public var description: String {
        switch self {
        case .nullValue:
            return "null"
        case .boolValue(let bool):
            return bool.description
        case .numericValue(let double):
            return double.description
        case .integerValue(let integer):
            return integer.description
        case .stringValue(let string):
            return string
        }
    }
}
