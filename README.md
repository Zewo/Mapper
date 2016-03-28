# Topo
[![Zewo 0.4][zewo-badge]](http://zewo.io)
[![Swift 3][swift-badge]](https://swift.org)

**Topo** is a tiny and simple library which allows you to convert Zewo's `InterchangeData` to strongly typed objects. Deeply inspired by Lyft's [Mapper][mapper-url].

## Usage
#### Simplest example:

``` swift
import Topo

struct User: Mappable {
    let id: Int
    let username: String
    let city: String?
    
    // Mappable requirement
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
struct Album: Mappable {
    let songs: [String]
    init(map: Mapper) throws {
        try songs = map.fromArray("songs")
    }
}
```

```swift
struct Album: Mappable {
    let songs: [String]?
    init(map: Mapper) throws {
        songs = map.fromOptionalArray("songs")
    }
}
```

#### Mapping enums
You can use **Topo** for mapping enums with raw values. Right now you can use only `String` and `Double` as raw value.

```swift
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
```

#### Nested `Mappable` objects

```swift
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
```

#### Using `Convertible`
`Mappable` is great for complex entities, but for the simplest one you can use `Convertible` protocol. `Convertible` objects can be initializaed from `InterchangeData` itself, not from its `Mapper`. For example, **Topo** uses `Convertible` to allow seamless `Int` conversion:

```swift
extension Int: Convertible {
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

## Installation
- Add `Topo` to your `Package.swift`

```swift
import PackageDescription

let package = Package(
    dependencies: [
        .Package(url: "https://github.com/dreymonde/Topo.git", majorVersion: 0, minor: 4),
    ]
)
```

## Destination
Behind **Topo** stands the idea to use the same data structures both on Swift server-side and client-side. **Topo** depends only on Zewo's [InterchangeData][interchange-data-url], so once it will be ported on Apple systems, **Topo** will become available for iOS, OS X, watchOS and tvOS.

### Why not `ContentMappable`?
`ContentMappable: ContentInitializable` is a protocol provided by Zewo's [ContentNegotiationMiddleware][cont-neg-mid-url] and it has similar functionality to **Topo**. But it's a lot harder to use `ContentMappable` for types which are not described in `InterchangeData`. For example, you cannot simply call `content.get()` on `Int`. Nesting is another powerful feature of **Topo**.

Also, use of `ContentMappable` would make **Topo** depends on `ContentNegotiationMiddleware`, which is senseless for client-side. 

Although, it is possible to have another version of **Topo** which is fully compatible with `ContentNegotiationMiddleware`. It may appear in future.


### See also
[Resource][resource-url], which provides RESTful resources for Zewo's Router.

## Contributing
**Topo** is in very early stage. If you want to contribute or to propose a change - you are very welcome. Almost anything can be questioned. Open an issue or submit a pull request if you have an idea.

## Community

[![Slack](http://s13.postimg.org/ybwy92ktf/Slack.png)](http://slack.zewo.io)

Join us on [Slack](http://slack.zewo.io).

## License
**Topo** is released under the MIT license. See LICENSE for details.

[zewo-badge]: https://img.shields.io/badge/Zewo-0.4-FF7565.svg?style=flat
[swift-badge]: https://img.shields.io/badge/Swift-3.0-orange.svg?style=flat
[mapper-url]: https://github.com/lyft/mapper
[interchange-data-url]: https://github.com/Zewo/InterchangeData
[resource-url]: https://github.com/paulofaria/Resource
[cont-neg-mid-url]: https://github.com/Zewo/ContentNegotiationMiddleware