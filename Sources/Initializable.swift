//
//  Convertible.swift
//  Topo
//
//  Created by Oleg Dreyman on 27.03.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import InterchangeData

public enum InitializableError: ErrorProtocol {
    case cantBindToNeededType
    case failedToInitFromGivenValue
}

extension Int: InterchangeDataInitializable {
    public init(interchangeData: InterchangeData) throws {
        switch interchangeData {
        case .numberValue(let number):
            self.init(number)
        default:
            throw InitializableError.cantBindToNeededType
        }
    }
}

extension String: InterchangeDataInitializable {
    public init(interchangeData: InterchangeData) throws {
        try self = interchangeData.get()
    }
}

extension Double: InterchangeDataInitializable {
    public init(interchangeData: InterchangeData) throws {
        try self = interchangeData.get()
    }
}