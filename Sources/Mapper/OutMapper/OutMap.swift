/// Data type to which strongly-typed instances can be mapped.
public protocol OutMap {
        
    /// Blank state of the map.
    static var blank: Self { get }

    /// Sets value to given index path.
    ///
    /// - parameter map:       value to be set.
    /// - parameter indexPath: path to set value to.
    ///
    /// - throws: throw if value cannot be set for some reason.
    mutating func set(_ map: Self?, at indexPath: IndexPathValue) throws
    
    /// Usually used to pass the mapping context to nested maps.
    ///
    /// - Parameter child: instance of `Self` to which the context should be passed
    /// 
    /// - note: base implementation of `OutMap` doesn't do anything, but `OutMapWithOptions` uses this method to pass the options to childs.
    func setup(_ child: inout Self)
    
    /// Sets value to given index path.
    ///
    /// - parameter map:       value to be set.
    /// - parameter indexPath: path to set value to.
    ///
    /// - throws: throw if value cannot be set for some reason.
    mutating func set(_ map: Self?, at indexPath: [IndexPathValue]) throws
    
    /// Creates instance from array of instances of the same type.
    ///
    /// - returns: instance of the same type as array element. `nil` if such conversion cannot be done.
    static func fromArray(_ array: [Self]) -> Self?
    
    /// Creates instance from any given type.
    ///
    /// - parameter value: input value.
    ///
    /// - returns: instance from the given value. `nil` if conversion cannot be done.
    static func from<T>(_ value: T) -> Self?
    
    /// Creates instance of `Self` from `Int`.
    ///
    /// - parameter int: input value.
    ///
    /// - returns: instance from the given `Int`. `nil` if conversion cannot be done.
    static func fromInt(_ int: Int) -> Self?
    
    /// Creates instance of `Self` from `Double`.
    ///
    /// - parameter double: input value.
    ///
    /// - returns: instance from the given `Double`. `nil` if conversion cannot be done.
    static func fromDouble(_ double: Double) -> Self?
    
    /// Creates instance of `Self` from `Bool`.
    ///
    /// - parameter bool: input value.
    ///
    /// - returns: instance from the given `Bool`. `nil` if conversion cannot be done.
    static func fromBool(_ bool: Bool) -> Self?
    
    /// Creates instance of `Self` from `String`.
    ///
    /// - parameter string: input value.
    ///
    /// - returns: instance from the given `String`. `nil` if conversion cannot be done.
    static func fromString(_ string: String) -> Self?

}

public extension OutMap {
    
    func setup(_ child: inout Self) {
        // do nothing
    }
    
}

public protocol OutMapWithOptions : OutMap {
    
    associatedtype Options
    
    var options: Options { get set }
    
    mutating func applyOptions(_ options: Options)
    
}

extension OutMapWithOptions where Options : OptionSet {
    
    public mutating func applyOptions(_ options: Options) {
        self.options = self.options.union(options)
    }
    
}

public extension OutMapWithOptions {
    
    public func adopt(_ child: inout Self) {
        child.applyOptions(options)
    }
    
}

public enum OutMapError : Error {
    case deepSetIsNotImplementedYet
    case tryingToSetNilAtTheTopLevel
}

extension OutMap {
    mutating public func set(_ map: Self?, at indexPath: [IndexPathValue]) throws {
        let count = indexPath.count
        switch count {
        case 0:
            self = .blank
        case 1:
            try set(map, at: indexPath[0])
        default:
            throw OutMapError.deepSetIsNotImplementedYet
        }
    }
}
