//
//  Convertible.swift
//  Topo
//
//  Created by Oleg Dreyman on 27.03.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import StructuredData

public enum InitializableError: ErrorProtocol {
    case cantBindToNeededType
    case failedToInitFromGivenValue
}

extension Int: StructuredDataInitializable {
    public init(structuredData: StructuredData) throws {
        switch structuredData {
        case .numberValue(let number):
            self.init(number)
        default:
            throw InitializableError.cantBindToNeededType
        }
    }
}

extension String: StructuredDataInitializable {
    public init(structuredData: StructuredData) throws {
        try self.init(structuredData.get() as String)
    }
}

extension Double: StructuredDataInitializable {
    public init(structuredData: StructuredData) throws {
        try self.init(structuredData.get() as Double)
    }
}