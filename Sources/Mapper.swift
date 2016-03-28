//
//  Mapper.swift
//  Topo
//
//  Created by Oleg Dreyman on 27.03.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation
import InterchangeData

// MARK: - Main
public final class Mapper {
    
    public enum Error: ErrorProtocol {
        case cantInitFromRawValue
        case noInterchangeData(key: String)
        case rawIntNotSupported
    }
    
    public init(interchangeData: InterchangeData) {
        self.interchangeData = interchangeData
    }
    
    private let interchangeData: InterchangeData
    
}

// MARK: - General case

extension Mapper {

    public func from<T>(key: String) throws -> T {
        let value: T = try interchangeData.get(key)
        return value
    }
    
    public func from<T: Convertible>(key: String) throws -> T {
        if let nested = interchangeData[key] {
            return try unwrap(T.fromCustomInterchangeData(nested))
        }
        throw Error.noInterchangeData(key: key)
    }
    
    public func from<T: RawRepresentable>(key: String) throws -> T {
        guard T.self != Int.self else {
            throw Error.rawIntNotSupported
        }
        let rawValue: T.RawValue = try interchangeData.get(key)
        if let value = T(rawValue: rawValue) {
            return value
        }
        throw Error.cantInitFromRawValue
    }
    
    // public func from<T: RawRepresentable where T.RawValue: Convertible>(key: String) throws -> T {
    //     let rawValue: T.RawValue = try unwrap(interchangeData[key].flatMap(T.RawValue.fromCustomInterchangeData))
    //     if let value = T(rawValue: rawValue) {
    //         return value
    //     }
    //     throw Error.cantInitFromRawValue
    // }
    
    public func from<T: Mappable>(key: String) throws -> T {
        if let nestedInterchange = interchangeData[key] {
            return try T(map: Mapper(interchangeData: nestedInterchange))
        }
        throw Error.noInterchangeData(key: key)
    }
    
}

// MARK: - Arrays

extension Mapper {
    
    public func fromArray<T>(key: String) throws -> [T] {
        let interDataArray: [InterchangeData] = try interchangeData.get(key)
        return interDataArray.flatMap {
            do {
                let some: T = try $0.get()
                return some
            } catch {
                return nil
            }
        }
    }
    
    public func fromArray<T: Convertible>(key: String) throws -> [T] {
        let inter: [InterchangeData] = try interchangeData.get(key)
        return inter.flatMap({ T.fromCustomInterchangeData($0) })
    }
    
    public func fromArray<T: RawRepresentable>(key: String) throws -> [T] {
        let inter: [InterchangeData] = try interchangeData.get(key)
        return inter.flatMap {
            do {
                let rawValue: T.RawValue = try $0.get()
                return T(rawValue: rawValue)
            } catch {
                return nil
            }
        }
    }
    
    public func fromArray<T: Mappable>(key: String) throws -> [T] {
        let inter: [InterchangeData] = try interchangeData.get(key)
        return inter.flatMap({ T.from($0) })
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
    
    public func optionalFrom<T: Convertible>(key: String) -> T? {
        if let nested = interchangeData[key] {
            return T.fromCustomInterchangeData(nested)
        }
        return nil
    }
    
    public func optionalFrom<T: RawRepresentable>(key: String) -> T? {
        do {
            return try from(key)
        } catch {
            return nil
        }
    }
    
    public func optionalFrom<T: Mappable>(key: String) -> T? {
        do {
            return try from(key)
        } catch {
            return nil
        }
    }
    
}

// MARK: - Optional arrays

extension Mapper {
    
    public func optionalFromArray<T>(key: String) -> [T]? {
        do {
            let inter: [InterchangeData] = try interchangeData.get(key)
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
    
    public func optionalFromArray<T: Convertible>(key: String) -> [T]? {
        do {
            let inter: [InterchangeData] = try interchangeData.get(key)
            return inter.flatMap({ T.fromCustomInterchangeData($0) })
        } catch {
            return nil
        }
    }
    
    public func optionalFromArray<T: RawRepresentable>(key: String) -> [T]? {
        do {
            let inter: [InterchangeData] = try interchangeData.get(key)
            return inter.flatMap {
                do {
                    let rawValue: T.RawValue = try $0.get()
                    return T(rawValue: rawValue)
                } catch {
                    return nil
                }
            }
        } catch {
            return nil
        }
    }
    
    public func optionalFromArray<T: Mappable>(key: String) -> [T]? {
        do {
            let inter: [InterchangeData] = try interchangeData.get(key)
            return inter.flatMap({ T.from($0) })
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
    
    internal func unwrap<T>(optional: T?) throws -> T {
        if let nonoptional = optional {
            return nonoptional
        }
        throw UnwrapError.tryingToUnwrapNil
    }
    
}

func testRawRepresentableNumber() {
    enum Value: Int {
        case first = 1
    }
    struct Test: Mappable {
        let value: Value
        init(map: Mapper) throws {
            try self.value = map.from("value")
        }
    }
    let _ = try! Test(map: Mapper(interchangeData: ["value": 1]))
}
