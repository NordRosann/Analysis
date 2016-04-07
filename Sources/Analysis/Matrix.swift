public struct Matrix<Element> {
    private var storage: [MatrixColumn<Element>]
    public init(cells: [Element], rowsNumber: Int, columnsNumber: Int) throws {
        guard rowsNumber * columnsNumber == cells.count else {
            throw MatrixError.buildError
        }
        self.storage = (0 ..< columnsNumber).map {
            MatrixColumn(values: Array(cells[$0 * rowsNumber ..< $0 * rowsNumber + rowsNumber]))
        }
    }
}

extension Matrix {
    
}

public enum MatrixError: ErrorProtocol {
    case buildError
}