# Mapper
[![Zewo 0.4][zewo-badge]](http://zewo.io)
[![Swift 3][swift-badge]](https://swift.org)
[![Platform Linux][platforms-badge]](https://swift.org)
[![License MIT][mit-badge]](https://tldrlegal.com/license/mit-license)
[![Codebeat][codebeat-badge]](https://codebeat.co/projects/github-com-zewo-interchangedatamapper)

**Mapper** is a tiny and simple library which allows you to convert Zewo's `StructuredData` to strongly typed objects. Deeply inspired by Lyft's [Mapper][mapper-url].

## Usage
#### Simplest example:

``` swift
import Mapper

struct User: Mappable {
    let id: Int
    let username: String
    let city: String?
    
    // Mappable requirement
    init(mapper: Mapper) throws {
        id = try mapper.map(from: "id")
        username = try mapper.map(from: "username")
        city = mapper.map(optionalFrom: "city")
    }
}

let content: StructuredData = [
    "id": 1654,
    "username": "fireringer",
    "city": "Houston"
]
let user = User.makeWith(structuredData: content) // User?
```

#### Mapping arrays
**Be careful!** If you use `map(from:)` instead of `map(arrayFrom:)`, mapping will fail.

```swift
struct Album: Mappable {
    let songs: [String]
    init(mapper: Mapper) throws {
        songs = try mapper.map(arrayFrom: "songs")
    }
}
```

```swift
struct Album: Mappable {
    let songs: [String]?
    init(mapper: Mapper) throws {
        songs = try mapper.map(optionalArrayFrom: "songs")
    }
}
```

#### Mapping enums
You can use **Mapper** for mapping enums with raw values. Right now you can use only `String`, `Int` and `Double` as raw value.

```swift
enum GuitarType: String {
    case acoustic
    case electric
}

struct Guitar: Mappable {
    let vendor: String
    let type: GuitarType
    
    init(mapper: Mapper) throws {
        vendor = try mapper.map(from: "vendor")
        type = try mapper.map(from: "type")
    }
}
```

#### Nested `Mappable` objects

```swift
struct League: Mappable {
    let name: String
    init(mapper: Mapper) throws {
        name = try mapper.map(from: "name")
    }
}

struct Club: Mappable {
    let name: String
    let league: League
    init(mapper: Mapper) throws {
        name = try mapper.map(from: "name")
        league = try mapper.map(from: "league")
    }
}
```

#### Using `StructuredDataInitializable`
`Mappable` is great for complex entities, but for the simplest one you can use `StructuredDataInitializable` protocol. `StructuredDataInitializable` objects can be initializaed from `StructuredData` itself, not from its `Mapper`. For example, **Mapper** uses `StructuredDataInitializable` to allow seamless `Int` conversion:

```swift
extension Int: StructuredDataInitializable {
    public init(structuredData value: StructuredData) throws {
        switch value {
        case .numberValue(let number):
            self.init(number)
        default:
            throw InitializableError.cantBindToNeededType
        }
    }
}
```

Now you can map `Int` using `from(_:)` just like anything else:

```swift
struct Generation: Mappable {
    let number: Int
    init(mapper: Mapper) throws {
        number = try mapper.map(from: "number")
    }
}
```

Conversion of `Int` is available in **Mapper** out of the box, and you can extend any other type to conform to `StructuredDataInitializable` yourself, for example, `NSDate`:

```swift
import Foundation
import Mapper

extension StructuredDataInitializable where Self: NSDate {
    public init(structuredData value: StructuredData) throws {
        switch value {
        case .numberValue(let number):
            self.init(timeIntervalSince1970: number)
        default:
            throw InitializableError.cantBindToNeededType
        }
    }
}
extension NSDate: StructuredDataInitializable { }
```

## Installation
- Add `Mapper` to your `Package.swift`

```swift
import PackageDescription

let package = Package(
    dependencies: [
        .Package(url: "https://github.com/Zewo/Mapper.git", majorVersion: 0, minor: 4),
    ]
)
```

**Mapper** (as *Topo*) is also available for [Zewo 0.3][topo-0.3].

## See also
[Resource][resource-url], which provides RESTful resources for Zewo's Router.

## Community

[![Slack](http://s13.postimg.org/ybwy92ktf/Slack.png)](http://slack.zewo.io)

Join us on [Slack](http://slack.zewo.io).

## License
**Mapper** is released under the MIT license. See LICENSE for details.

[zewo-badge]: https://img.shields.io/badge/Zewo-0.4-FF7565.svg?style=flat
[swift-badge]: https://img.shields.io/badge/Swift-3.0-orange.svg?style=flat
[mapper-url]: https://github.com/lyft/mapper
[interchange-data-url]: https://github.com/Zewo/StructuredData
[resource-url]: https://github.com/paulofaria/Resource
[cont-neg-mid-url]: https://github.com/Zewo/ContentNegotiationMiddleware
[mit-badge]: https://img.shields.io/badge/License-MIT-blue.svg?style=flat
[platforms-badge]: https://img.shields.io/badge/Platform-Linux-lightgray.svg?style=flat
[topo-0.3]: https://github.com/Zewo/Topo/tree/zewo0.3
[codebeat-badge]: https://codebeat.co/badges/67df5828-b0d3-4d73-a587-3b994d6aaf1fStructuredData