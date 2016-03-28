// Drain.swift
//
// The MIT License (MIT)
//
// Copyright (c) 2015 SwiftX
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

public final class Drain: DataRepresentable, Stream {
    var buffer: Data
    public var closed = false

    public var data: Data {
        if !closed {
            return buffer
        }
        return Data([])
    }

    public convenience init() {
         self.init(Data([]))
    }

    public init(_ stream: Stream) {
        var buffer = Data([])

        if stream.closed {
            self.closed = true
        }

        while !stream.closed {
            if let chunk = try? stream.receive() {
                buffer.bytes += chunk.bytes
            } else {
                break
            }
        }

        self.buffer = buffer
    }

    public init(_ buffer: Data) {
        self.buffer = buffer
        if buffer.bytes.isEmpty {
            close()
        }
    }

    public convenience init(_ buffer: DataRepresentable) {
        self.init(buffer.data)
    }

    public func close() -> Bool {
        if closed {
            return false
        }
        closed = true
        return true
    }

    public func receive() throws -> Data {
        let data = self.data
        close()
        return data
    }

    public func send(data: Data) throws {
        enum Error: ErrorProtocol {
            case sendUnsupported
        }
        throw Error.sendUnsupported
    }

    public func flush() throws {
        enum Error: ErrorProtocol {
            case flushUnsupported
        }
        throw Error.flushUnsupported
    }
}