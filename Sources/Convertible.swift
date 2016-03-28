//
//  Convertible.swift
//  Topo
//
//  Created by Oleg Dreyman on 27.03.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import InterchangeData

public protocol Convertible {
    associatedtype ConvertedTo = Self
    static func from(customInterchangeData value: InterchangeData) -> ConvertedTo?
}

public enum ConvertibleError: ErrorType {
    case CantBindToNeededType
}

extension Int: Convertible {
    public static func from(customInterchangeData value: InterchangeData) -> Int? {
        switch value {
        case .NumberValue(let number):
            return Int(number)
        default:
            return nil
        }
    }
}