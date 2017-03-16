/// Entity which can be mapped to any structured data type.
public protocol OutMappable {
    
    associatedtype MappingKeys : IndexPathElement
    
    /// Maps instance data to `mapper`.
    ///
    /// - parameter mapper: wraps the actual structured data instance.
    ///
    /// - throws: `OutMapperError`.
    func outMap<Destination : OutMap>(mapper: inout OutMapper<Destination, MappingKeys>) throws
    
}

public protocol BasicOutMappable {
    
    func outMap<Destination : OutMap>(mapper: inout BasicOutMapper<Destination>) throws
    
}

/// Entity which can be mapped to any structured data type in multiple ways using user-determined context instance.
public protocol OutMappableWithContext {
    
    associatedtype MappingKeys : IndexPathElement
    
    /// Context allows user to map data in different ways.
    associatedtype MappingContext
    
    
    /// Maps instance data to contextual `mapper`.
    ///
    /// - parameter mapper: wraps the actual structured data instance.
    ///
    /// - throws: `OutMapperError`
    func outMap<Destination : OutMap>(mapper: inout ContextualOutMapper<Destination, MappingKeys, MappingContext>) throws
    
}

extension OutMappable {
    
    /// Maps `self` to `Destination` structured data instance.
    ///
    /// - parameter destination: instance to map to. Leave it .blank if you want to create your instance from scratch.
    ///
    /// - throws: `OutMapperError`.
    ///
    /// - returns: structured data instance created from `self`.
    internal func map<Destination : OutMap>(to destination: Destination = .blank, parent: Destination) throws -> Destination {
        var child = destination
        parent.setup(&child)
        var mapper = OutMapper<Destination, MappingKeys>(of: child)
        try outMap(mapper: &mapper)
        return mapper.destination
    }
    
    public func map<Destination : OutMap>(to destination: Destination = .blank) throws -> Destination {
        return try map(to: destination, parent: .blank)
    }
    
    public func map<Destination : OutMapWithOptions>(to destination: Destination = .blank, withOptions options: Destination.Options) throws -> Destination {
        var destinationWithModifiedOptions = destination
        destinationWithModifiedOptions.applyOptions(options)
        var mapper = OutMapper<Destination, MappingKeys>(of: destinationWithModifiedOptions)
        try outMap(mapper: &mapper)
        return mapper.destination
    }
    
}

extension BasicOutMappable {
    
    /// Maps `self` to `Destination` structured data instance.
    ///
    /// - parameter destination: instance to map to. Leave it .blank if you want to create your instance from scratch.
    ///
    /// - throws: `OutMapperError`.
    ///
    /// - returns: structured data instance created from `self`.
    internal func map<Destination : OutMap>(to destination: Destination = .blank, parent: Destination) throws -> Destination {
        var child = destination
        parent.setup(&child)
        var mapper = BasicOutMapper<Destination>(of: child)
        try outMap(mapper: &mapper)
        return mapper.destination
    }
    
    public func map<Destination : OutMap>(to destination: Destination = .blank) throws -> Destination {
        return try map(to: destination, parent: .blank)
    }
    
    public func map<Destination : OutMapWithOptions>(to destination: Destination = .blank, withOptions options: Destination.Options) throws -> Destination {
        var destinationWithModifiedOptions = destination
        destinationWithModifiedOptions.applyOptions(options)
        var mapper = BasicOutMapper<Destination>(of: destinationWithModifiedOptions)
        try outMap(mapper: &mapper)
        return mapper.destination
    }
    
}

extension OutMappableWithContext {
    
    /// Maps `self` to `Destination` structured data instance using `context`.
    ///
    /// - parameter destination: instance to map to. Leave it .blank if you want to create your instance from scratch.
    /// - parameter context:     use `context` to describe the way of mapping.
    ///
    /// - throws: `OutMapperError`.
    ///
    /// - returns: structured data instance created from `self`.
    internal func map<Destination : OutMap>(to destination: Destination = .blank, withContext context: MappingContext, parent: Destination) throws -> Destination {
        var child = destination
        parent.setup(&child)
        var mapper = ContextualOutMapper<Destination, MappingKeys, MappingContext>(of: child, context: context)
        try outMap(mapper: &mapper)
        return mapper.destination
    }
    
    public func map<Destination : OutMap>(to destination: Destination = .blank, withContext context: MappingContext) throws -> Destination {
        return try map(to: destination, withContext: context, parent: .blank)
    }
    
    public func map<Destination : OutMapWithOptions>(to destination: Destination = .blank, withContext context: MappingContext, withOptions options: Destination.Options) throws -> Destination {
        var destinationWithModifiedOptions = destination
        destinationWithModifiedOptions.applyOptions(options)
        var mapper = ContextualOutMapper<Destination, MappingKeys, MappingContext>(of: destinationWithModifiedOptions, context: context)
        try outMap(mapper: &mapper)
        return mapper.destination
    }
        
}
