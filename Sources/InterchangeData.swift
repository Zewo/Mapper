//
//  InterchangeData.swift
//  Topo
//
//  Created by Oleg Dreyman on 29.03.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import InterchangeData

extension InterchangeData {
    
    internal func mapThrough<T>(@noescape transform: (InterchangeData throws -> T)) throws -> [T] {
        if let array = self.array {
            return try array.map(transform)
        }
        throw InterchangeData.Error.incompatibleType
    }
    
    internal func mapThrough<T>(key: String, @noescape transform: (InterchangeData throws -> T)) throws -> [T] {
        if let value = self[key] {
            return try value.mapThrough(transform)
        }
        throw InterchangeData.Error.incompatibleType
    }
    
//    internal func mapThrough<T>(index: Int, @noescape transform: (InterchangeData throws -> T)) throws -> [T] {
//        if let value = self[index] {
//            return try value.mapThrough(transform)
//        }
//        throw InterchangeData.Error.incompatibleType
//    }
    
    internal func flatMapThrough<T>(@noescape transform: (InterchangeData throws -> T?)) throws -> [T] {
        if let array = self.array {
            return try array.flatMap(transform)
        }
        throw InterchangeData.Error.incompatibleType
    }
    
    internal func flatMapThrough<T>(key: String, @noescape transform: (InterchangeData throws -> T?)) throws -> [T] {
        if let value = self[key] {
            return try value.flatMapThrough(transform)
        }
        throw InterchangeData.Error.incompatibleType
    }
    
//    internal func flatMapThrough<T>(index: Int, @noescape transform: (InterchangeData throws -> T?)) throws -> [T] {
//        if let value = self[index] {
//            return try value.flatMapThrough(transform)
//        }
//        throw InterchangeData.Error.incompatibleType
//    }
    
}