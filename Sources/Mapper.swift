//
//  Mapper.swift
//  Topo
//
//  Created by Oleg Dreyman on 27.03.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import StructuredData

// MARK: - Main
public final class Mapper {
    
    public enum Error: ErrorProtocol {
        case cantInitFromRawValue
        case noInterchangeData(key: String)
    }
    
    public init(structuredData: StructuredData) {
        self.structuredData = structuredData
    }
    
    private let structuredData: StructuredData
    
}

// MARK: - General case

extension Mapper {

    public func from<T>(key: String) throws -> T {
        let value: T = try structuredData.get(key)
        return value
    }
    
    public func from<T: StructuredDataInitializable>(key: String) throws -> T {
        if let nested = structuredData[key] {
            return try unwrap(T(structuredData: nested))
        }
        throw Error.noInterchangeData(key: key)
    }
    
    public func from<T: RawRepresentable where T.RawValue: StructuredDataInitializable>(key: String) throws -> T {
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
    
    public func arrayFrom<T>(key: String) throws -> [T] {
        return try structuredData.flatMapThrough(key) {
            do {
                let some: T = try $0.get()
                return some
            } catch {
                return nil
            }
        }
    }
    
    public func arrayFrom<T: StructuredDataInitializable>(key: String) throws -> [T] {
        return try structuredData.flatMapThrough(key) { try? T(structuredData: $0) }
    }
    
    public func arrayFrom<T: RawRepresentable where T.RawValue: StructuredDataInitializable>(key: String) throws -> [T] {
        return try structuredData.flatMapThrough(key) {
            do {
                let rawValue = try T.RawValue(structuredData: $0)
                return T(rawValue: rawValue)
            } catch {
                return nil
            }
        }
    }
    
}

// MARK: - Optionals

extension Mapper {
    
    public func optionalFrom<T>(key: String) -> T? {
        do {
            return try from(key)
        } catch {
            return nil
        }
    }
    
    public func optionalFrom<T: StructuredDataInitializable>(key: String) -> T? {
        if let nested = structuredData[key] {
            return try? T(structuredData: nested)
        }
        return nil
    }
    
    public func optionalFrom<T: RawRepresentable where T.RawValue: StructuredDataInitializable>(key: String) -> T? {
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
    
    public func optionalArrayFrom<T>(key: String) -> [T]? {
        do {
            let inter: [StructuredData] = try structuredData.get(key)
            return inter.flatMap {
                do {
                    let some: T = try $0.get()
                    return some
                } catch {
                    return nil
                }
            }
        } catch {
            return nil
        }
    }
    
    public func optionalArrayFrom<T: StructuredDataInitializable>(key: String) -> [T]? {
        do {
            let inter: [StructuredData] = try structuredData.get(key)
            return inter.flatMap({ try? T(structuredData: $0) })
        } catch {
            return nil
        }
    }
    
    public func optionalArrayFrom<T: RawRepresentable where T.RawValue: StructuredDataInitializable>(key: String) -> [T]? {
        do {
            let inter: [StructuredData] = try structuredData.get(key)
            return inter.flatMap {
                do {
                    let rawValue = try T.RawValue(structuredData: $0)
                    return T(rawValue: rawValue)
                } catch {
                    return nil
                }
            }
        } catch {
            return nil
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