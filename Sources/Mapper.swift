import StructuredData

// MARK: - Main
public final class Mapper {
    
    public enum Error: ErrorProtocol {
        case cantInitFromRawValue
        case noInterchangeData(key: String)
        case incompatibleSequence
    }
    
    public init(structuredData: StructuredData) {
        self.structuredData = structuredData
    }
    
    private let structuredData: StructuredData
    
}

// MARK: - General case

extension Mapper {

    public func map<T>(from key: String) throws -> T {
        let value: T = try structuredData.get(key)
        return value
    }
    
    public func map<T: StructuredDataInitializable>(from key: String) throws -> T {
        if let nested = structuredData[key] {
            return try unwrap(T(structuredData: nested))
        }
        throw Error.noInterchangeData(key: key)
    }
    
    public func map<T: RawRepresentable where T.RawValue: StructuredDataInitializable>(from key: String) throws -> T {
        guard let rawValue = try structuredData[key].flatMap({ try T.RawValue(structuredData: $0) }) else {
            throw Error.cantInitFromRawValue
        }
        if let value = T(rawValue: rawValue) {
            return value
        }
        throw Error.cantInitFromRawValue
    }
    
}

// MARK: - Arrays

extension Mapper {
    
    public func map<T>(arrayFrom key: String) throws -> [T] {
        return try structuredData.flatMapThrough(key) { try $0.get() as T }
    }
    
    public func map<T where T: StructuredDataInitializable>(arrayFrom key: String) throws -> [T] {
        return try structuredData.flatMapThrough(key) { try? T(structuredData: $0) }
    }
    
    public func map<T: RawRepresentable where
                    T.RawValue: StructuredDataInitializable>(arrayFrom key: String) throws -> [T] {
        return try structuredData.flatMapThrough(key) {
            return (try? T.RawValue(structuredData: $0)).flatMap({ T(rawValue: $0) })
        }
    }
    
}

// MARK: - Optionals

extension Mapper {
    
    public func map<T>(optionalFrom key: String) -> T? {
        do {
            return try map(from: key)
        } catch {
            return nil
        }
    }
    
    public func map<T: StructuredDataInitializable>(optionalFrom key: String) -> T? {
        if let nested = structuredData[key] {
            return try? T(structuredData: nested)
        }
        return nil
    }
    
    public func map<T: RawRepresentable where T.RawValue: StructuredDataInitializable>(optionalFrom key: String) -> T? {
        do {
            if let rawValue = try structuredData[key].flatMap({ try T.RawValue(structuredData: $0) }),
                value = T(rawValue: rawValue) {
                return value
            }
            return nil
        } catch {
            return nil
        }
    }

}

// MARK: - Optional arrays

extension Mapper {
    
    public func map<T>(optionalArrayFrom key: String) -> [T]? {
        return try? structuredData.flatMapThrough(key) { try $0.get() as T }
    }
    
    public func map<T where T: StructuredDataInitializable>(optionalArrayFrom key: String) -> [T]? {
        return try?  structuredData.flatMapThrough(key) { try? T(structuredData: $0) }
    }
    
    public func map<T: RawRepresentable where
                    T.RawValue: StructuredDataInitializable>(optionalArrayFrom key: String) -> [T]? {
        return try? structuredData.flatMapThrough(key) {
            return (try? T.RawValue(structuredData: $0)).flatMap({ T(rawValue: $0) })
        }
    }
    
}

// MARK: - Unwrap

public enum UnwrapError: ErrorProtocol {
    case tryingToUnwrapNil
}

extension Mapper {
    
    private func unwrap<T>(optional: T?) throws -> T {
        if let nonoptional = optional {
            return nonoptional
        }
        throw UnwrapError.tryingToUnwrapNil
    }
    
}