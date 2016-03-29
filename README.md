# InterchangeDataMapper
[![Zewo 0.4][zewo-badge]](http://zewo.io)
[![Swift 3][swift-badge]](https://swift.org)
[![Platform Linux][platforms-badge]](https://swift.org)
[![License MIT][mit-badge]](https://tldrlegal.com/license/mit-license)

**InterchangeDataMapper** is a tiny and simple library which allows you to convert Zewo's `InterchangeData` to strongly typed objects. Deeply inspired by Lyft's [Mapper][mapper-url].

## Usage
#### Simplest example:

``` swift
import InterchangeDataMapper

struct User: InterchangeDataMappable {
    let id: Int
    let username: String
    let city: String?
    
    // InterchangeDataMappable requirement
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
let user = User.from(content) // User?
```

#### Mapping arrays
**Be careful!** If you use `from` instead of `fromArray`, mapping will fail.

```swift
struct Album: InterchangeDataMappable {
    let songs: [String]
    init(map: Mapper) throws {
        try songs = map.fromArray("songs")
    }
}
```

```swift
struct Album: InterchangeDataMappable {
    let songs: [String]?
    init(map: Mapper) throws {
        songs = map.fromOptionalArray("songs")
    }
}
```

#### Mapping enums
You can use **InterchangeDataMapper** for mapping enums with raw values. Right now you can use only `String` and `Double` as raw value.

```swift
enum GuitarType: String {
    case acoustic
    case electric
}

struct Guitar: InterchangeDataMappable {
    let vendor: String
    let type: GuitarType
    
    init(map: Mapper) throws {
        try vendor = map.from("vendor")
        try type = map.from("type")
    }
}
```

#### Nested `InterchangeDataMappable` objects

```swift
struct League: InterchangeDataMappable {
    let name: String
    init(map: Mapper) throws {
        try name = map.from("name")
    }
}

struct Club: InterchangeDataMappable {
    let name: String
    let league: League
    init(map: Mapper) throws {
        try name = map.from("name")
        try league = map.from("league")
    }
}
```

#### Using `InterchangeDataConvertible`
`InterchangeDataMappable` is great for complex entities, but for the simplest one you can use `InterchangeDataConvertible` protocol. `InterchangeDataConvertible` objects can be initializaed from `InterchangeData` itself, not from its `Mapper`. For example, **InterchangeDataMapper** uses `InterchangeDataConvertible` to allow seamless `Int` conversion:

```swift
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
```

Now you can map `Int` using `from(_:)` just like anything else:

```swift
struct Generation: InterchangeDataMappable {
    let number: Int
    init(map: Mapper) throws {
        try number = map.from("number")
    }
}
```

Conversion of `Int` is available in **InterchangeDataMapper** out of the box, and you can extend any other type to conform to `InterchangeDataConvertible` yourself.

## Installation
- Add `InterchangeDataMapper` to your `Package.swift`

```swift
import PackageDescription

let package = Package(
    dependencies: [
        .Package(url: "https://github.com/Zewo/InterchangeDataMapper.git", majorVersion: 0, minor: 4),
    ]
)
```

**InterchangeDataMapper** is also available for Zewo 0.3:

```swift
import PackageDescription

let package = Package(
    dependencies: [
        .Package(url: "https://github.com/Zewo/InterchangeDataMapper.git", majorVersion: 0, minor: 3),
    ]
)
```

## See also
[Resource][resource-url], which provides RESTful resources for Zewo's Router.

## Community

[![Slack](http://s13.postimg.org/ybwy92ktf/Slack.png)](http://slack.zewo.io)

Join us on [Slack](http://slack.zewo.io).

## License
**InterchangeDataMapper** is released under the MIT license. See LICENSE for details.

[zewo-badge]: https://img.shields.io/badge/Zewo-0.4-FF7565.svg?style=flat
[swift-badge]: https://img.shields.io/badge/Swift-3.0-orange.svg?style=flat
[mapper-url]: https://github.com/lyft/mapper
[interchange-data-url]: https://github.com/Zewo/InterchangeData
[resource-url]: https://github.com/paulofaria/Resource
[cont-neg-mid-url]: https://github.com/Zewo/ContentNegotiationMiddleware
[mit-badge]: https://img.shields.io/badge/License-MIT-blue.svg?style=flat
[platforms-badge]: https://img.shields.io/badge/Platform-Linux-lightgray.svg?style=flat
