//
//  Mappable.swift
//  Topo
//
//  Created by Oleg Dreyman on 27.03.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import StructuredData
import Foundation

public protocol Mappable: StructuredDataInitializable {
    
    init(map: Mapper) throws
    
}

extension Mappable {
    public init(structuredData: StructuredData) throws {
        try self.init(map: structuredData.mapper)
    }
}

extension Mappable {
    
    public static func makeWith(structuredData structuredData: StructuredData) -> Self? {
        do {
            return try self.init(map: structuredData.mapper)
        } catch {
            return nil
        }
    }
    
}