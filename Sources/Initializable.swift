//
//  Convertible.swift
//  Topo
//
//  Created by Oleg Dreyman on 27.03.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import InterchangeData

public enum ConvertibleError: ErrorProtocol {
    case cantBindToNeededType
}

//public typealias InterchangeDataConvertible = InterchangeDataInitializable

public protocol InterchangeDataInitializable {
    init(interchangeData value: InterchangeData) throws
}

extension Int: InterchangeDataInitializable {
    public init(interchangeData value: InterchangeData) throws {
        switch value {
        case .numberValue(let number):
            self.init(number)
        default:
            throw ConvertibleError.cantBindToNeededType
        }
    }
}
