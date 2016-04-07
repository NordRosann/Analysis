extension Bool: DataPointConvertible {
    public init(dataPoint: DataPoint) throws {
        switch dataPoint {
        case .boolValue(let bool):
            self = bool
        default:
            throw DataPoint.Error.incompatibleType
        }
    }
    public var dataPoint: DataPoint {
        return .boolValue(self)
    }
}

extension Double: DataPointConvertible {
    public init(dataPoint: DataPoint) throws {
        switch dataPoint {
        case .numericValue(let numeric):
            self = numeric
        default:
            throw DataPoint.Error.incompatibleType
        }
    }
    public var dataPoint: DataPoint {
        return .numericValue(self)
    }
}

extension Int: DataPointConvertible {
    public init(dataPoint: DataPoint) throws {
        switch dataPoint {
        case .integerValue(let number):
            self = number
        default:
            throw DataPoint.Error.incompatibleType
        }
    }
    public var dataPoint: DataPoint {
        return .integerValue(self)
    }
}

extension String: DataPointConvertible {
    public init(dataPoint: DataPoint) throws {
        switch dataPoint {
        case .stringValue(let string):
            self = string
        default:
            throw DataPoint.Error.incompatibleType
        }
    }
    public var dataPoint: DataPoint {
        return .stringValue(self)
    }
}

extension DataPointConvertible where Self: RawRepresentable, Self.RawValue: DataPointConvertible {
    public init(dataPoint: DataPoint) throws {
        let rawValue: Self.RawValue = try Self.RawValue(dataPoint: dataPoint)
        print(rawValue)
        if let ready = Self.init(rawValue: rawValue) {
            print(ready)
            self = ready
        } else {
            throw DataPoint.Error.cantInitFromGivenValue
        }
    }
    public var dataPoint: DataPoint {
        return rawValue.dataPoint
    }
}
