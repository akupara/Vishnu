//
//  CRC16.swift
//  Vishnu
//
//  Created by Daniel Lu on 3/10/16.
//  Copyright © 2016 Daniel Lu. All rights reserved.
//

import Foundation

public struct VishnuCRC16 {
    public typealias CRCType = UInt16
    public private(set) var crc:CRCType!
    
    public static func accumulate(buffer:UnsafeBufferPointer <UInt8>, crc:CRCType = 0xFFFF) -> CRCType {
        var accum = crc
        for b in buffer {
            var tmp = CRCType(b) ^ (accum & 0xFF)
            tmp = (tmp ^ (tmp << 4)) & 0xFF
            accum = (accum >> 8) ^ (tmp << 8) ^ (tmp << 3) ^ (tmp >> 4)
        }
        return accum
    }
    
    public mutating func accumulate(buffer:UnsafeBufferPointer <UInt8>) -> CRCType {
        if crc == nil {
            crc = 0xFFFF
        }
        crc = VishnuCRC16.accumulate(buffer, crc: crc)
        return crc
    }
    
    
    public static func accumulate(buffer:UnsafeBufferPointer<UInt8>, crc: CRCType = 0xFFFF, crcTableHi: UnsafeBufferPointer<UInt8>, crcTableLo:UnsafeBufferPointer<UInt8>) -> CRCType {
        var crcHi:UInt8 = UInt8(crc >> 8)
        var crcLo:UInt8 = UInt8(crc)
        for b in buffer {
            let index = Int(bitPattern: UInt(crcHi ^ b))
            crcHi = crcLo ^ crcTableHi[index]
            crcLo = crcTableLo[index]
        }
        
        return CRCType(crcHi) << 8 | CRCType(crcLo)
    }
    
    public mutating func accumulate(buffer: UnsafeBufferPointer<UInt8>, crcTableHi: UnsafeBufferPointer<UInt8>, crcTableLo: UnsafeBufferPointer<UInt8>) -> CRCType {
        if crc == nil {
            crc = 0xFFFF
        }
        
        crc = VishnuCRC16.accumulate(buffer, crc: crc, crcTableHi: crcTableHi, crcTableLo: crcTableLo)
        return crc
    }
    
}

public extension VishnuCRC16 {
    
    public mutating func accumulate(bytes:[UInt8]) -> CRCType {
        bytes.withUnsafeBufferPointer() {
            (body:UnsafeBufferPointer <UInt8>) -> Void in
            accumulate(body)
        }
        return crc
    }
    
    
    public mutating func accumulate(string:String) -> CRCType {
        string.withCString() {
            (ptr:UnsafePointer<Int8>) -> Void in
            let buffer = UnsafeBufferPointer <UInt8> (start: UnsafePointer <UInt8> (ptr), count: Int(strlen(ptr)))
            accumulate(buffer)
        }
        return crc
    }
    
    public mutating func accumulate(bytes:[UInt8], crcTableHi:[UInt8], crcTableLo: [UInt8]) -> CRCType {
        bytes.withUnsafeBufferPointer {
            (body:UnsafeBufferPointer<UInt8>) -> Void in
            var originalTableHi = crcTableHi
            var originalTableLo = crcTableLo
            let tableHi = UnsafeBufferPointer<UInt8>(start: &originalTableHi, count: crcTableHi.count)
            let tableLo = UnsafeBufferPointer<UInt8>(start: &originalTableLo, count: crcTableHi.count)
            accumulate(body,crcTableHi: tableHi, crcTableLo: tableLo)
        }
        return crc
    }
    
    public mutating func accumulate(string:String, crcTableHi:[UInt8], crcTableLo: [UInt8]) -> CRCType {
        string.withCString { (ptr:UnsafePointer<Int8>) -> Void in
            let buffer = UnsafeBufferPointer<UInt8>(start: UnsafePointer<UInt8>(ptr), count: Int(strlen(ptr)))
            var originalTableHi = crcTableHi
            var originalTableLo = crcTableLo
            let tableHi = UnsafeBufferPointer<UInt8>(start: &originalTableHi, count: crcTableHi.count)
            let tableLo = UnsafeBufferPointer<UInt8>(start: &originalTableLo, count: crcTableHi.count)
            accumulate(buffer, crcTableHi: tableHi, crcTableLo: tableLo)
        }
        return crc
    }
}