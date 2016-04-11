import StructuredData

extension StructuredData {
    
    internal var mapper: Mapper {
        return Mapper(structuredData: self)
    }
    
}

extension StructuredData {
    
    internal func mapThrough<T>(@noescape transform: (StructuredData throws -> T)) throws -> [T] {
        if let array = self.array {
            return try array.map(transform)
        }
        throw StructuredData.Error.incompatibleType
    }
    
    internal func mapThrough<T>(key: String, @noescape transform: (StructuredData throws -> T)) throws -> [T] {
        if let value = self[key] {
            return try value.mapThrough(transform)
        }
        throw StructuredData.Error.incompatibleType
    }
    
//    internal func mapThrough<T>(index: Int, @noescape transform: (StructuredData throws -> T)) throws -> [T] {
//        if let value = self[index] {
//            return try value.mapThrough(transform)
//        }
//        throw StructuredData.Error.incompatibleType
//    }
    
    internal func flatMapThrough<T>(@noescape transform: (StructuredData throws -> T?)) throws -> [T] {
        if let array = self.array {
            return try array.flatMap(transform)
        }
        throw StructuredData.Error.incompatibleType
    }
    
    internal func flatMapThrough<T>(key: String, @noescape transform: (StructuredData throws -> T?)) throws -> [T] {
        if let value = self[key] {
            return try value.flatMapThrough(transform)
        }
        throw StructuredData.Error.incompatibleType
    }
    
//    internal func flatMapThrough<T>(index: Int, @noescape transform: (StructuredData throws -> T?)) throws -> [T] {
//        if let value = self[index] {
//            return try value.flatMapThrough(transform)
//        }
//        throw StructuredData.Error.incompatibleType
//    }
    
}