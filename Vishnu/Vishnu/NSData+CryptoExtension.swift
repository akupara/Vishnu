//
//  NSData+CryptoExtension.swift
//  Vishnu
//
//  Created by Daniel Lu on 2/19/16.
//  Copyright © 2016 Daniel Lu. All rights reserved.
//

import Foundation
import CommonCrypto

public extension NSData {
    
    // MARK: - Digest
    
    public var MD2: NSData {
        let hash = Digest.MD2(bytes: bytes, length: UInt32(length))
        return NSData(bytes: hash, length:  hash.count)
    }
    
    public var MD4: NSData {
        let hash = Digest.MD4(bytes: bytes, length: UInt32(length))
        return NSData(bytes: hash, length:  hash.count)
    }
    
    public var MD5: NSData {
        let hash = Digest.MD5(bytes: bytes, length: UInt32(length))
        return NSData(bytes: hash, length:  hash.count)
    }
    
    public var SHA1: NSData {
        let hash = Digest.SHA1(bytes: bytes, length: UInt32(length))
        return NSData(bytes: hash, length:  hash.count)
    }
    
    public var SHA224: NSData {
        let hash = Digest.SHA224(bytes: bytes, length: UInt32(length))
        return NSData(bytes: hash, length:  hash.count)
    }
    
    public var SHA256: NSData {
        let hash = Digest.SHA256(bytes: bytes, length: UInt32(length))
        return NSData(bytes: hash, length:  hash.count)
    }
    
    public var SHA384: NSData {
        let hash = Digest.SHA384(bytes: bytes, length: UInt32(length))
        return NSData(bytes: hash, length:  hash.count)
    }
    
    public var SHA512: NSData {
        let hash = Digest.SHA512(bytes: bytes, length: UInt32(length))
        return NSData(bytes: hash, length:  hash.count)
    }
    
    
    // MARK: - HMAC
    
    public func HMAC(key key: NSData, algorithm: Vishnu.HMAC.Algorithm) -> NSData {
        return Vishnu.HMAC.sign(data: self, algorithm: algorithm, key: key)
    }
}
