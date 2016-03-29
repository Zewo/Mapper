//
//  Mappable.swift
//  Topo
//
//  Created by Oleg Dreyman on 27.03.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

//import InterchangeData

public protocol InterchangeDataMappable {
    
    init(map: Mapper) throws
    
}

extension InterchangeDataMappable {
    
    public static func from(interchangeData interchangeData: InterchangeData) -> Self? {
        do {
            return try self.init(map: Mapper(interchangeData: interchangeData))
        } catch {
            return nil
        }
    }
    
}