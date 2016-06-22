//
//  KurmaCentralManager.swift
//  Vishnu
//
//  Created by Daniel Lu on 6/15/16.
//  Copyright © 2016 Daniel Lu. All rights reserved.
//

import UIKit
import CoreBluetooth
import Matsya

@objc public class KurmaCentralManager: NSObject, CBCentralManagerDelegate {
    
    private var _centralManager:CBCentralManager
    private var _status:KurmaCentralStatus {
        didSet {
            if _status == .Scanning {
                return
            }
            if _startScanWhenReady == true && false == KurmaCentralStatus.ReadyForScanStatus.contains(oldValue) && true == KurmaCentralStatus.ReadyForScanStatus.contains(_status) {
                startScan()
            }
        }
    }
    private var _discoveredPeripheralsDictionary:[String: KurmaPeripheral] = [:]
    private var _discoveredPeripherals:[KurmaPeripheral] = []
    
    private var _connectedPeripheralsDictionary:[String: KurmaPeripheral] = [:]
    private var _connectedPeripherals:[KurmaPeripheral] = []
    
    private var _targets:[String:Set<NSObject>] = [:]
    
    private var _peripheralTargets:[String: [String: Set<NSObject>]] = [:]
    
    private var _startScanWhenReady:Bool = true
    
    
    //Public readonly variables
    public var centralManager:CBCentralManager {
        get {
            return _centralManager
        }
    }
    
    public var status:KurmaCentralStatus {
        get {
            return _status
        }
    }
    
    public var discoveredPeripheralCount:Int{
        get {
            return _discoveredPeripherals.count
        }
    }
    
    public var discoveredPeripherals:[KurmaPeripheral] {
        get {
            return _discoveredPeripherals
        }
    }
    
    public var connectedPeripherals:[KurmaPeripheral] {
        get {
            return _connectedPeripherals
        }
    }
    
    //public settings
    public var filterServiceUUIDs:[CBUUID]?
    
    //Singleton instance
    public static let sharedInstance = KurmaCentralManager()
    
    private override init() {
        _centralManager = CBCentralManager()
        _status = .Unknown
        super.init()
        _centralManager.delegate = self
    }
    
    //options = [CBCentralManagerScanOptionAllowDuplicatesKey: false]
    public func startScan(serviceUUIDs:[CBUUID]? = nil, options: [String : AnyObject]? = nil) {
        filterServiceUUIDs = serviceUUIDs
        
        if false == KurmaCentralStatus.ReadyForScanStatus.contains(_status) {
            _startScanWhenReady = true
            return
        }
        _startScanWhenReady = false
        
        //Remove all saved devices
        _discoveredPeripherals.removeAll()
        _status = _status == .Connected ? .Connected : .Scanning
        _centralManager.scanForPeripheralsWithServices(serviceUUIDs, options: options)
        
        if let eventTargets = _targets[KurmaCentralManagerEvents.ScanStart.eventKey] {
            for target in eventTargets {
                guard let t = target as? KurmaCentralManagerEventsHandler else {
                    continue
                }
                t.centralManagerScanStart?(self)
            }
        }
    }
    
    public func stopScan(){
        if _status != .Scanning && _status != .Connected {
            return
        }

        _centralManager.stopScan()
        _status = _status == .Connected ? .Connected : .Idle
        if let eventTargets = _targets[KurmaCentralManagerEvents.ScanStop.eventKey] {
            for target in eventTargets {
                guard let t = target as? KurmaCentralManagerEventsHandler else {
                    continue
                }
                t.centralManagerScanStop?(self)
            }
        }
    }
    
    public func restartScan() {
        stopScan()
        startScan()
    }
    
    @objc(connectToPeripheral:options:)
    public func connect(peripheral:KurmaPeripheral, options:([String:AnyObject]?) = nil) {
        _centralManager.connectPeripheral(peripheral.peripheral, options: options)
    }
    
    @objc(connectToPeripheralWithUUID:options:)
    public func connect(uuid:CBUUID, options:([String:AnyObject]?) = nil) {
        let uuidStr = uuid.UUIDString
        connect(uuidStr, options: options)
    }
    
    @objc(connectToPeripheralWithUUIDInString:options:)
    public func connect(uuid:String, options:([String:AnyObject]?) = nil) {
        if let peripheral = _discoveredPeripheralsDictionary[uuid] {
            connect(peripheral, options: options)
        }
    }
    
    @objc(disconnectFromPeripheral:)
    public func disconnect(peripheral:CBPeripheral) {
        if let _ = _connectedPeripheralsDictionary[peripheral.identifier.UUIDString] {
            _centralManager.cancelPeripheralConnection(peripheral)
        }
    }
    
    @objc(disconnectFromPeripheralWithUUIDInString:)
    public func disconnect(uuid:String) {
        if let peripheral = _connectedPeripheralsDictionary[uuid] {
            _centralManager.cancelPeripheralConnection(peripheral.peripheral)
        }
    }
    
    @objc(disconnectFromPeripheralWithUUID:)
    public func disconnect(uuid:CBUUID) {
        disconnect(uuid.UUIDString)
    }
    
    // MARK: - CBCentralManagerDelegate
    @objc public func centralManagerDidUpdateState(central: CBCentralManager) {
        if central != _centralManager {
            return
        }

        switch central.state {
        case .PoweredOff:
            _status = .PowerOff
        case .PoweredOn:
            _status = .PowerOn
        case .Unauthorized:
            _status = .Unauthorized
        case .Unsupported:
            _status = .Unsupported
        case .Unknown:
            _status = .Unknown
        case .Resetting:
            _status = .Resetting
        }
        
        if let eventTargets = _targets[KurmaCentralManagerEvents.StatusUpdated.eventKey] {
            for target in eventTargets {
                guard let t = target as? KurmaCentralManagerEventsHandler else {
                    continue
                }
                t.centralManager!(self, statusUpdated: status)
            }
        }
    }
    
    @objc public func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        if central != centralManager {
            return
        }
        
        let uuid = peripheral.identifier.UUIDString
        let kPeripheral:KurmaPeripheral!
        if let kp = _discoveredPeripheralsDictionary[uuid] {
            kPeripheral = kp
        } else {
            kPeripheral = KurmaPeripheral(peripheral: peripheral)
            _discoveredPeripheralsDictionary[uuid] = kPeripheral
            _discoveredPeripherals.append(kPeripheral)
        }
        
        if let eventTargets = _targets[KurmaCentralManagerEvents.PeripheralDiscovered.eventKey] {
            for target in eventTargets {
                guard let t = target as? KurmaCentralManagerEventsHandler else {
                    continue
                }
                t.centralManager?(self, didDiscoverPeripheral: kPeripheral, advertisementData: advertisementData, RSSI: RSSI)
            }
        }
    }
    
    @objc public func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        if central != centralManager {
            return
        }
        stopScan()
        let uuid = peripheral.identifier.UUIDString
        let connectedPeripheral:KurmaPeripheral!
        if let discoveredPeripheral = _discoveredPeripheralsDictionary[uuid] {
            connectedPeripheral = discoveredPeripheral
        } else {
            connectedPeripheral = KurmaPeripheral(peripheral: peripheral)
            _connectedPeripheralsDictionary[uuid] = connectedPeripheral
        }
        
        if false == _connectedPeripheralsDictionary.keys.contains(uuid) {
            _connectedPeripherals.append(connectedPeripheral)
            _connectedPeripheralsDictionary[uuid] = connectedPeripheral
        }
        
        _status = .Connected
        if let eventTargets = _targets[KurmaCentralManagerEvents.PeripheralConnected.eventKey] {
            for target in eventTargets {
                guard let t = target as? KurmaCentralManagerEventsHandler else {
                    continue
                }
                t.centralManager?(self, didConnectedToPeripheral: connectedPeripheral)
            }
        }
    }
    
    @objc public func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        let uuid = peripheral.identifier.UUIDString
        if let kPeripheral = _connectedPeripheralsDictionary[uuid] {
            
            _connectedPeripheralsDictionary.removeValueForKey(uuid)
//            _connectedPeripherals
            //Set status to idle when no peripheral connected
            if _connectedPeripherals.count < 1 {
                _status = .Idle
            }
            if let eventTargets = _targets[KurmaCentralManagerEvents.PeripheralDisconnected.eventKey] {
                for target in eventTargets {
                    guard let t = target as? KurmaCentralManagerEventsHandler else {
                        continue
                    }
                    t.centralManager?(self, didDisconnectedPeripheral: kPeripheral)
                }
            }
        }
    }
    
    //MARK: - events support (Central Manager)
    public func addTarget<T:NSObject where T:KurmaCentralManagerEventsHandler>(target:T, forEvent event: KurmaCentralManagerEvents) {
        if _targets.keys.contains(event.eventKey) == false {
            _targets[event.eventKey] = Set()
        }
        (_targets[event.eventKey]!).insert(target)
    }
    
    public func removeTarget<T:NSObject where T:KurmaCentralManagerEventsHandler>(target:T, forEvent event: KurmaCentralManagerEvents) {
        guard let _ = _targets[event.eventKey] else {
            return
        }
        
        (_targets[event.eventKey]!).remove(target)
    }
    
    public func removeTarget<T:NSObject where T:KurmaCentralManagerEventsHandler>(target:T) {
        for event in KurmaCentralManagerEvents.allEvents {
            removeTarget(target, forEvent: event)
        }
    }
    
    public func isConnectedToPeripheral(peripheral:KurmaPeripheral) -> Bool {
        return _connectedPeripherals.contains(peripheral)
    }
    
    @objc(isConnectedToPeripheralWithUUIDString:)
    public func isConnectedToPeripheral(peripheral:String) -> Bool {
        if peripheral.isEmpty {
            return false
        }
        
        return _connectedPeripheralsDictionary.keys.contains(peripheral)
    }
    
    @objc(isConnectedToPeripheralWithUUID:)
    public func isConnectedToPeripheral(peripheral:CBUUID) -> Bool {
        return isConnectedToPeripheral(peripheral.UUIDString)
    }
    
    public func discoveredPeripheral(peripheral:KurmaPeripheral) -> Bool {
        return _discoveredPeripherals.contains(peripheral)
    }
    
    @objc(discoveredPeripheralWithUUIDString:)
    public func discoveredPeripheral(peripheral:String) -> Bool {
        return _discoveredPeripheralsDictionary.keys.contains(peripheral)
    }
    
    @objc(discoveredPeripheralWithUUID:)
    public func discoveredPeripheral(peripheral:CBUUID) -> Bool {
        return discoveredPeripheral(peripheral.UUIDString)
    }
}

extension KurmaCentralManager {
    
    public func addTarget<T:NSObject where T:KurmaPeripheralEventsHandler>(target:T, forEvent event:KurmaPeripheralEvents, forPeripheral peripheral:KurmaPeripheral) {
        if _connectedPeripherals.contains(peripheral) {
            peripheral.addTarget(target, forEvent: event)
        }
    }
    
    public func removeTarget<T:NSObject where T:KurmaPeripheralEventsHandler>(target:T, forEvent event:KurmaPeripheralEvents, forPeripheral peripheral: KurmaPeripheral) {
        if _connectedPeripherals.contains(peripheral) {
            peripheral.removeTarget(target, forEvent: event)
        }
    }
    
    public func removeTarget<T: NSObject where T:KurmaPeripheralEventsHandler>(target:T, forPeripheral peripheral:KurmaPeripheral) {
        if _connectedPeripherals.contains(peripheral) {
            peripheral.removeTarget(target)
        }
    }
    
    public func addTarget<T:NSObject where T:KurmaPeripheralEventsHandler>(target:T, forEvent event:KurmaPeripheralEvents, forPeripheral peripheralUUID: String) {
        guard let peripheral = _connectedPeripheralsDictionary[peripheralUUID] else {
            return
        }
        
        addTarget(target, forEvent: event, forPeripheral: peripheral)
    }
    
    public func removeTarget<T:NSObject where T:KurmaPeripheralEventsHandler>(target:T, forEvent event:KurmaPeripheralEvents, forPeripheral peripheralUUID:String) {
        guard let peripheral = _connectedPeripheralsDictionary[peripheralUUID] else {
            return
        }
        removeTarget(target, forEvent: event, forPeripheral: peripheral)
    }
    
    public func removeTarget<T:NSObject where T:KurmaPeripheralEventsHandler>(target:T, forPeripheral peripheralUUID:String) {
        guard let peripheral = _connectedPeripheralsDictionary[peripheralUUID] else {
            return
        }
        removeTarget(target, forPeripheral: peripheral)
    }
    
    public func addTarget<T:NSObject where T:KurmaPeripheralEventsHandler>(target:T, forEvent event:KurmaPeripheralEvents, forPeripheral peripheralUUID: CBUUID) {
        addTarget(target, forEvent: event, forPeripheral: peripheralUUID.UUIDString)
    }
    
    public func removeTarget<T:NSObject where T:KurmaPeripheralEventsHandler>(target:T, forEvent event:KurmaPeripheralEvents, forPeripheral peripheralUUID: CBUUID) {
        removeTarget(target, forEvent: event, forPeripheral: peripheralUUID.UUIDString)
    }
    
    public func removeTarget<T:NSObject where T:KurmaPeripheralEventsHandler>(target:T, forPeripheral peripheralUUID:CBUUID) {
        removeTarget(target, forPeripheral: peripheralUUID.UUIDString)
    }
}

@objc public enum KurmaCentralStatus:Int {
    case Scanning = 1, Idle = 2, Connected, PowerOn, PowerOff, Unauthorized, Unsupported, Resetting
    case Unknown = -1
    
    static let ReadyForScanStatus:[KurmaCentralStatus] = [.PowerOn, .Connected, .Idle]
}

@objc public enum KurmaCentralManagerEvents:Int {
    case ScanStart = 1, ScanStop, PeripheralDiscovered, PeripheralConnected, PeripheralDisconnected, StatusUpdated
    
    var eventKey:String {
        var key:String = ""
        switch self {
        case .ScanStart:
            key = "scan_start"
        case .ScanStop:
            key = "scan_stop"
        case .PeripheralDiscovered:
            key = "peripheral_discovered"
        case .PeripheralConnected:
            key = "peripheral_connected"
        case .PeripheralDisconnected:
            key = "peripheral_disconnected"
        case .StatusUpdated:
            key = "status_updated"
        }
        return key
    }
    
    static let allEvents = [ScanStart, ScanStop, PeripheralDiscovered, PeripheralConnected, PeripheralDisconnected, StatusUpdated]
}

@objc public protocol KurmaCentralManagerEventsHandler {
    optional func centralManagerScanStart(central:KurmaCentralManager)
    optional func centralManagerScanStop(central:KurmaCentralManager)
    optional func centralManager(central:KurmaCentralManager, didDiscoverPeripheral peripheral: KurmaPeripheral, advertisementData:[String:AnyObject], RSSI: NSNumber)
    optional func centralManager(central:KurmaCentralManager, didConnectedToPeripheral peripheral: KurmaPeripheral)
    optional func centralManager(central:KurmaCentralManager, didDisconnectedPeripheral peripheral: KurmaPeripheral)
    optional func centralManager(central:KurmaCentralManager, statusUpdated:KurmaCentralStatus)
}
