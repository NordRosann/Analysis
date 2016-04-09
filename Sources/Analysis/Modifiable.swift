protocol Modifiable {

	func modified(update: (inout Self) -> Void) -> Self

}

extension Modifiable {

	func modified(update: (inout Self) -> Void) -> Self {
        var this = self
        update(&this)
        return this
    }

}

extension Dictionary: Modifiable { }