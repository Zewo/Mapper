//
//  Convertible.swift
//  Topo
//
//  Created by Oleg Dreyman on 27.03.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation

public protocol InterchangeDataCore {
    
}

extension Double: InterchangeDataCore { }

public protocol Convertible {
    static func fromCustomInterchangeData(value: InterchangeData) -> Self?
}

public enum ConvertibleError: ErrorType {
    case CantBindToNeededType
}

extension Int: Convertible {
    public static func fromCustomInterchangeData(value: InterchangeData) -> Int? {
        switch value {
        case .NumberValue(let number):
            return Int(number)
        default:
            return nil
        }
    }
}