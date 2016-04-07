public struct List {
    var elements: [DataPoint]
}

extension List {
    func transformed(for schema: RowSchema) -> List {
        let sizeDiff = schema.length - elements.count
        let curElements = sizeDiff > 0 ? elements + [DataPoint](repeating: .nullValue, count: sizeDiff) : elements
        let zipped = zip(curElements, schema.variables)
        let newElements: [DataPoint] = zipped.map { element, description in
            if let newElement = try? description.type.init(dataPoint: element) {
                return newElement.dataPoint
            } else {
                return .nullValue
            }
        }
        return List(elements: newElements)
    }
}