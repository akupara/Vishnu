//
//  NSData+DLExtension.swift
//  Vishnu
//
//  Created by Daniel Lu on 2/19/16.
//  Copyright © 2016 Daniel Lu. All rights reserved.
//


import Foundation

extension NSData {
    func hexString() -> String {
        // "Array" of all bytes:
        let bytes = UnsafeBufferPointer<UInt8>(start: UnsafePointer(self.bytes), count:self.length)
        // Array of hex strings, one for each byte:
        let hexBytes = bytes.map { String(format: "%02hhx", $0) }
        // Concatenate all hex strings:
        return hexBytes.joinWithSeparator("")
    }
}