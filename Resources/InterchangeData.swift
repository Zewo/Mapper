// InterchangeData.swift
//
// The MIT License (MIT)
//
// Copyright (c) 2015 Zewo
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

public protocol InterchangeDataParser {
    func parse(data: Data) throws -> InterchangeData
}

public extension InterchangeDataParser {
    public func parse(convertible: DataConvertible) throws -> InterchangeData {
        return try parse(convertible.data)
    }
}

public protocol InterchangeDataSerializer {
    func serialize(interchangeData: InterchangeData) throws -> Data
}

public enum InterchangeData {
    case nullValue
    case boolValue(Bool)
    case numberValue(Double)
    case stringValue(String)
    case binaryValue(Data)
    case arrayValue([InterchangeData])
    case dictionaryValue([String: InterchangeData])

    public enum Error: ErrorProtocol {
        case incompatibleType
    }

    public static func from(value: Bool) -> InterchangeData {
        return .boolValue(value)
    }

    public static func from(value: Double) -> InterchangeData {
        return .numberValue(value)
    }

    public static func from(value: Int) -> InterchangeData {
        return .numberValue(Double(value))
    }

    public static func from(value: String) -> InterchangeData {
        return .stringValue(value)
    }

    public static func from(value: Data) -> InterchangeData {
        return .binaryValue(value)
    }

    public static func from(value: [InterchangeData]) -> InterchangeData {
        return .arrayValue(value)
    }

    public static func from(value: [String: InterchangeData]) -> InterchangeData {
        return .dictionaryValue(value)
    }

    public var isBool: Bool {
        switch self {
        case .boolValue: return true
        default: return false
        }
    }

    public var isNumber: Bool {
        switch self {
        case .numberValue: return true
        default: return false
        }
    }

    public var isString: Bool {
        switch self {
        case .stringValue: return true
        default: return false
        }
    }

    public var isBinary: Bool {
        switch self {
        case .binaryValue: return true
        default: return false
        }
    }

    public var isArray: Bool {
        switch self {
        case .arrayValue: return true
        default: return false
        }
    }

    public var isDictionary: Bool {
        switch self {
        case .dictionaryValue: return true
        default: return false
        }
    }

    public var bool: Bool? {
        switch self {
        case .boolValue(let b): return b
        default: return nil
        }
    }

    public var double: Double? {
        switch self {
        case .numberValue(let n): return n
        default: return nil
        }
    }

    public var int: Int? {
        if let v = double {
            return Int(v)
        }
        return nil
    }

    public var uint: UInt? {
        if let v = double {
            return UInt(v)
        }
        return nil
    }

    public var string: String? {
        switch self {
        case .stringValue(let s): return s
        default: return nil
        }
    }

    public var binary: Data? {
        switch self {
        case .binaryValue(let d): return d
        default: return nil
        }
    }

    public var array: [InterchangeData]? {
        switch self {
        case .arrayValue(let array): return array
        default: return nil
        }
    }

    public var dictionary: [String: InterchangeData]? {
        switch self {
        case .dictionaryValue(let dictionary): return dictionary
        default: return nil
        }
    }

    public func get<T>() -> T? {
        switch self {
        case nullValue:
            return nil
        case boolValue(let bool):
            return bool as? T
        case numberValue(let number):
            return number as? T
        case stringValue(let string):
            return string as? T
        case binaryValue(let binary):
            return binary as? T
        case arrayValue(let array):
            return array as? T
        case dictionaryValue(let dictionary):
            return dictionary as? T
        }
    }

    public func get<T>(key: String) throws -> T {
        if let value = self[key] {
            return try value.get()
        }

        throw Error.incompatibleType
    }

    public func get<T>() throws -> T {
        switch self {
        case boolValue(let boolean):
            if let value = boolean as? T {
                return value
            }

        case numberValue(let number):
            if let value = number as? T {
                return value
            }

        case stringValue(let string):
            if let value = string as? T {
                return value
            }

        case .binaryValue(let binary):
            if let value = binary as? T {
                return value
            }

        case arrayValue(let array):
            if let value = array as? T {
                return value
            }

        case dictionaryValue(let dictionary):
            if let value = dictionary as? T {
                return value
            }

        default: break
        }

        throw Error.incompatibleType
    }

    public func asBool() throws -> Bool {
        if let bool = bool {
            return bool
        }
        throw Error.incompatibleType
    }

    public func asDouble() throws -> Double {
        if let double = double {
            return double
        }
        throw Error.incompatibleType
    }

    public func asInt() throws -> Int {
        if let int = int {
            return int
        }
        throw Error.incompatibleType
    }

    public func asUInt() throws -> UInt {
        if let uint = uint {
            return UInt(uint)
        }
        throw Error.incompatibleType
    }

    public func asString() throws -> String {
        if let string = string {
            return string
        }
        throw Error.incompatibleType
    }

    public func asBinary() throws -> Data {
        if let binary = binary {
            return binary
        }
        throw Error.incompatibleType
    }

    public func asArray() throws -> [InterchangeData] {
        if let array = array {
            return array
        }
        throw Error.incompatibleType
    }

    public func asDictionary() throws -> [String: InterchangeData] {
        if let dictionary = dictionary {
            return dictionary
        }
        throw Error.incompatibleType
    }

    public subscript(index: Int) -> InterchangeData? {
        get {
            if let array = array where index > 0  && index < array.count {
                return array[index]
            }
            return nil
        }

        set(interchangeData) {
            switch self {
            case .arrayValue(let array):
                var array = array
                if index > 0 && index < array.count {
                    if let interchangeData = interchangeData {
                        array[index] = interchangeData
                    } else {
                        array[index] = .nullValue
                    }
                    self = .arrayValue(array)
                }
            default: break
            }
        }
    }

    public subscript(key: String) -> InterchangeData? {
        get {
            return dictionary?[key]
        }

        set(interchangeData) {
            switch self {
            case .dictionaryValue(let dictionary):
                var dictionary = dictionary
                dictionary[key] = interchangeData
                self = .dictionaryValue(dictionary)
            default: break
            }
        }
    }
}

extension InterchangeData: Equatable {}

public func ==(lhs: InterchangeData, rhs: InterchangeData) -> Bool {
    switch lhs {
    case .nullValue:
        switch rhs {
        case .nullValue: return true
        default: return false
        }
    case .boolValue(let lhsValue):
        switch rhs {
        case .boolValue(let rhsValue): return lhsValue == rhsValue
        default: return false
        }
    case .stringValue(let lhsValue):
        switch rhs {
        case .stringValue(let rhsValue): return lhsValue == rhsValue
        default: return false
        }
    case .binaryValue(let lhsValue):
        switch rhs {
        case .binaryValue(let rhsValue): return lhsValue == rhsValue
        default: return false
        }
    case .numberValue(let lhsValue):
        switch rhs {
        case .numberValue(let rhsValue): return lhsValue == rhsValue
        default: return false
        }
    case .arrayValue(let lhsValue):
        switch rhs {
        case .arrayValue(let rhsValue): return lhsValue == rhsValue
        default: return false
        }
    case .dictionaryValue(let lhsValue):
        switch rhs {
        case .dictionaryValue(let rhsValue): return lhsValue == rhsValue
        default: return false
        }
    }
}

extension InterchangeData: NilLiteralConvertible {
    public init(nilLiteral value: Void) {
        self = .nullValue
    }
}

extension InterchangeData: BooleanLiteralConvertible {
    public init(booleanLiteral value: BooleanLiteralType) {
        self = .boolValue(value)
    }
}

extension InterchangeData: IntegerLiteralConvertible {
    public init(integerLiteral value: IntegerLiteralType) {
        self = .numberValue(Double(value))
    }
}

extension InterchangeData: FloatLiteralConvertible {
    public init(floatLiteral value: FloatLiteralType) {
        self = .numberValue(Double(value))
    }
}

extension InterchangeData: StringLiteralConvertible {
    public init(unicodeScalarLiteral value: String) {
        self = .stringValue(value)
    }

    public init(extendedGraphemeClusterLiteral value: String) {
        self = .stringValue(value)
    }

    public init(stringLiteral value: StringLiteralType) {
        self = .stringValue(value)
    }
}

extension InterchangeData: StringInterpolationConvertible {
    public init(stringInterpolation strings: InterchangeData...) {
        var string = ""

        for s in strings {
            string += s.string!
        }

        self = .stringValue(String(string))
    }

    public init<T>(stringInterpolationSegment expr: T) {
        self = .stringValue(String(expr))
    }
}

extension InterchangeData: ArrayLiteralConvertible {
    public init(arrayLiteral elements: InterchangeData...) {
        self = .arrayValue(elements)
    }
}

extension InterchangeData: DictionaryLiteralConvertible {
    public init(dictionaryLiteral elements: (String, InterchangeData)...) {
        var dictionary = [String: InterchangeData](minimumCapacity: elements.count)

        for pair in elements {
            dictionary[pair.0] = pair.1
        }

        self = .dictionaryValue(dictionary)
    }
}

extension InterchangeData: CustomStringConvertible {
    public var description: String {
        var indentLevel = 0

        func serialize(data: InterchangeData) -> String {
            switch data {
            case .nullValue: return "null"
            case .boolValue(let b): return b ? "true" : "false"
            case .numberValue(let n): return serializeNumber(n)
            case .stringValue(let s): return escape(s)
            case .binaryValue(let d): return escape(d.hexDescription)
            case .arrayValue(let a): return serializeArray(a)
            case .dictionaryValue(let o): return serializeObject(o)
            }
        }

        func serializeNumber(n: Double) -> String {
            if n == Double(Int64(n)) {
                return Int64(n).description
            } else {
                return n.description
            }
        }

        func serializeArray(a: [InterchangeData]) -> String {
            var s = "["
            indentLevel += 1

            for i in 0 ..< a.count {
                s += "\n"
                s += indent()
                s += serialize(a[i])

                if i != (a.count - 1) {
                    s += ","
                }
            }

            indentLevel -= 1
            return s + "\n" + indent() + "]"
        }

        func serializeObject(o: [String: InterchangeData]) -> String {
            var s = "{"
            indentLevel += 1
            var i = 0

            for (key, value) in o {
                s += "\n"
                s += indent()
                s += "\(escape(key)): \(serialize(value))"

                if i != (o.count - 1) {
                    s += ","
                }
                i += 1
            }

            indentLevel -= 1
            return s + "\n" + indent() + "}"
        }

        func indent() -> String {
            var s = ""

            for _ in 0 ..< indentLevel {
                s += "    "
            }

            return s
        }

        return serialize(self)
    }
}

func escape(source: String) -> String {
    var s = "\""

    for c in source.characters {
        if let escapedSymbol = escapeMapping[c] {
            s.append(escapedSymbol)
        } else {
            s.append(c)
        }
    }

    s.append("\"")

    return s
}

let escapeMapping: [Character: String] = [
    "\r": "\\r",
    "\n": "\\n",
    "\t": "\\t",
    "\\": "\\\\",
    "\"": "\\\"",

    "\u{2028}": "\\u2028",
    "\u{2029}": "\\u2029",

    "\r\n": "\\r\\n"
]
