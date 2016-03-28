// Data.swift
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

public protocol ByteType {}
extension UInt8: ByteType {}
extension Int8: ByteType {}

extension Data {
    public init<T: ByteType>(pointer: UnsafePointer<T>, length: Int) {
        var bytes: [UInt8] = [UInt8](repeating: 0, count: length)
        memcpy(&bytes, pointer, length)
        self.bytes = bytes
    }
}

extension Data {
	public func hexString(delimiter delimiter: Int = 0) -> String {
		var string = ""
		for (index, value) in enumerated() {
			if delimiter != 0 && index > 0 && index % delimiter == 0 {
				string += " "
			}
			string += (value < 16 ? "0" : "") + String(value, radix: 16)
		}
		return string
	}

    public var hexDescription: String {
		return hexString(delimiter: 2)
    }
}

extension Data: CustomStringConvertible {
    public var description: String {
        if let string = try? String(data: self) {
            return string
        }

        return debugDescription
    }
}

extension Data: CustomDebugStringConvertible {
    public var debugDescription: String {
        return hexDescription
    }
}

extension Data {
    internal func convert<T>() -> T {
        return bytes.withUnsafeBufferPointer {
            return UnsafePointer<T>($0.baseAddress).pointee
        }
    }

    internal init<T>(value: T) {
        var value = value
        self.bytes = withUnsafePointer(&value) {
            Array(UnsafeBufferPointer(start: UnsafePointer<Byte>($0), count: sizeof(T)))
        }
    }
}
