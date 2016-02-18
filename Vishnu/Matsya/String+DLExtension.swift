//
//  String+DLExtension.swift
//  DLControl
//
//  Created by Daniel Lu on 2/18/16.
//  Copyright © 2016 Daniel Lu. All rights reserved.
//

import Foundation
import CommonCrypto

extension String {
    func md5() -> String {
        var digest = [UInt8](count: Int(CC_MD5_DIGEST_LENGTH), repeatedValue: 0)
        if let data = self.dataUsingEncoding(NSUTF8StringEncoding) {
            CC_MD5(data.bytes, CC_LONG(data.length), &digest)
        }
        
        var digestHex = ""
        for index in 0..<Int(CC_MD5_DIGEST_LENGTH) {
            
            digestHex += String(format: "%02x", digest[index])
        }
        
        return digestHex
    }
    
    func upperCaseFirst() -> String {
        if characters.count < 1 {
            return ""
        }
        
        let firstCharacter = characters.first!
        let first = String([firstCharacter]).uppercaseString
        
        if characters.count < 2 {
            return first
        }
        
        let suffixIndex = startIndex.advancedBy(1)
        let suffix = substringFromIndex(suffixIndex)
        return "\(first)\(suffix)"
    }
}
