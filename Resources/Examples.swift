//
//  Examples.swift
//  Topo
//
//  Created by Oleg Dreyman on 28.03.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

struct User: Mappable {
    let id: Int
    let username: String
    let city: String?
    
    init(map: Mapper) throws {
        try id = map.from("id")
        try username = map.from("username")
        city = map.optionalFrom("city")
    }
}

let content: InterchangeData = [
    "id": 1654,
    "username": "fireringer",
    "city": "Houston"
]
let user = User.from(content)

enum GuitarType: String {
    case acoustic
    case electric
}

struct Guitar: Mappable {
    let vendor: String
    let type: GuitarType
    
    init(map: Mapper) throws {
        try vendor = map.from("vendor")
        try type = map.from("type")
    }
}

struct League: Mappable {
    let name: String
    init(map: Mapper) throws {
        try name = map.from("name")
    }
}

struct Club: Mappable {
    let name: String
    let league: League
    init(map: Mapper) throws {
        try name = map.from("name")
        try league = map.from("league")
    }
}

struct Album: Mappable {
    let songs: [String]
    init(map: Mapper) throws {
        try songs = map.fromArray("songs")
    }
}