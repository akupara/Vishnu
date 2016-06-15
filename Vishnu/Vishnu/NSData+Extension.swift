//
//  NSData+DLExtension.swift
//  Vishnu
//
//  Created by Daniel Lu on 2/19/16.
//  Copyright © 2016 Daniel Lu. All rights reserved.
//


import Foundation

extension NSData {
    public func hexString() -> String {
        // "Array" of all bytes:
        let bytes = UnsafeBufferPointer<UInt8>(start: UnsafePointer(self.bytes), count:self.length)
        // Array of hex strings, one for each byte:
        let hexBytes = bytes.map { String(format: "%02hhx", $0) }
        // Concatenate all hex strings:
        return hexBytes.joinWithSeparator("")
    }
    
    public func getBytes<U:UnsignedIntegerType>(position: Int, _:U.Type) -> UInt64 {
        if position >= 0 && position < length {
            let size = sizeof(U)
            let originalData = subdataWithRange(NSMakeRange(position, size))
            var value:UInt64 = 0
            for i in 0..<size {
                originalData.getBytes(&value, range: NSMakeRange(i, 1))
                let moveStep = i + 1
                if moveStep < size {
                    value = value << UInt64(8)
                }
            }
            return value
        }
        return 0
    }
    
    public func getBytes<U:UnsignedIntegerType>(position: Int, _:U.Type) -> UInt {
        let value:UInt64 = getBytes(position, U.self)
        return UInt(value)
    }
    
    public func getBytes<U:UnsignedIntegerType>(position: Int, _:U.Type) -> U {
        let value:UInt64 = getBytes(position, U.self)
        return U(value)
    }
}