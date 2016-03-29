//
//  Convertible.swift
//  Topo
//
//  Created by Oleg Dreyman on 27.03.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

//import InterchangeData
import Foundation

public protocol InterchangeDataConvertible {
    associatedtype ConvertingTo = Self
    static func from(customInterchangeData value: InterchangeData) -> ConvertingTo?
//    init(fromInterchangeData interchangeData: InterchangeData)
}

public enum ConvertibleError: ErrorProtocol {
    case cantBindToNeededType
}

extension Int: InterchangeDataConvertible {
    public static func from(customInterchangeData value: InterchangeData) -> Int? {
        switch value {
        case .numberValue(let number):
            return Int(number)
        default:
            return nil
        }
    }
    
}