//
//  CBCharacteristic+KurmaExtension.swift
//  Vishnu
//
//  Created by Daniel Lu on 6/15/16.
//  Copyright © 2016 Daniel Lu. All rights reserved.
//

import Foundation
import CoreBluetooth

extension CBCharacteristic {
    
    public var isBroadcast:Bool {
        get {
            return propertyEnabled(.Broadcast)
        }
    }
    
    public var isReadable:Bool {
        get {
            return propertyEnabled(.Read)
        }
    }
    
    public var isWritableWithoutRespoinse:Bool {
        get {
            return propertyEnabled(.WriteWithoutResponse)
        }
    }
    
    public var isWritable:Bool {
        get {
            return propertyEnabled(.Write)
        }
    }
    
    public var isNotify:Bool {
        get {
            return propertyEnabled(.Notify)
        }
    }
    
    public var isIndicate:Bool {
        get {
            return propertyEnabled(.Indicate)
        }
    }
    
    public var isAuthenticatedSignedWritable:Bool {
        get {
            return propertyEnabled(.AuthenticatedSignedWrites)
        }
    }
    
    public var isNotifyEncryptionRequired:Bool {
        get {
            return propertyEnabled(.NotifyEncryptionRequired)
        }
    }
    
    public var isIndicateEncryptionRequired:Bool {
        get {
            return propertyEnabled(.IndicateEncryptionRequired)
        }
    }
    
    internal func propertyEnabled(property:CBCharacteristicProperties) -> Bool {
        return (properties.rawValue & property.rawValue) > 0
    }
}
