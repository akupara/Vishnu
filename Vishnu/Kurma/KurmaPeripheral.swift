//
//  KurmaPeripheral.swift
//  Vishnu
//
//  Created by Daniel Lu on 6/15/16.
//  Copyright © 2016 Daniel Lu. All rights reserved.
//
import Foundation
import CoreBluetooth

@objc public class KurmaPeripheral:NSObject, CBPeripheralDelegate {
    
    private var _peripheral:CBPeripheral
    
//  property
    private var _name:String?
    private var _deviceInformations:[String: String] = [:]
    
    private var _services:[CBUUID:KurmaService] = [:]
    private var _RSSI:NSNumber?
    
    private var autoDiscoverCharacterist:Bool = false
    private var autoDiscoverIncludedService:Bool = false
    private var autoDiscoverCharacteristicDescriptor:Bool = false
    
    private var _targets:[String:Set<NSObject>] = [:]
    
    internal var peripheral:CBPeripheral {
        get {
            return _peripheral
        }
    }
    
    public var filterServiceUUIDs:[CBUUID]? = nil
    
//    private lazy var _filterCharacteristicUUIDS:[CBUUID:[CBUUID]] = [:]
//    private lazy var _filterIncludedServiceUUIDs:[CBUUID:[CBUUID]] = [:]
    
    public lazy var filterCharacteristicUUIDs:[CBUUID]? = nil
    public lazy var filterIncludedServiceUUIDs:[CBUUID]? = nil
    
//    public var serviceUUIDsFilter:[CBUUID]? = nil
//    public var characteristicUUIDsFilter:[CBUUID]? = nil
//    public var includedServiceUUIDsFilter:[CBUUID]? = nil
    
    public var identifier:NSUUID {
        get {
            return _peripheral.identifier
        }
    }
    
    public var state:CBPeripheralState {
        get {
            return _peripheral.state
        }
    }
    
    public var deviceInformations:[String: String] {
        get {
            return _deviceInformations
        }
    }
    
    public var name:String? {
        get {
            return _name
        }
    }
    
    public var RSSI:NSNumber? {
        get {
            return _RSSI
        }
    }
    
    init(peripheral:CBPeripheral) {
        _peripheral = peripheral
        super.init()
        _peripheral.delegate = self
        reloadDeviceName()
    }
    
    private func reloadDeviceName() {
        let deviceName = _peripheral.name ?? "Unnamed Device"
        let uuidSuffix = (_peripheral.identifier.UUIDString as NSString).substringFromIndex(_peripheral.identifier.UUIDString.characters.count - 5)
        _name = "\(deviceName)(\(uuidSuffix))"
    }
    
    // MARK: - CBPeripheralDelegate
    @objc public func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        if peripheral != _peripheral {
            return
        }
        
        if let services = _peripheral.services {
            for service in services {
                _services[service.UUID] = KurmaService(service: service, peripheral: self)
                if autoDiscoverCharacterist {
                    _peripheral.discoverCharacteristics(filterCharacteristicUUIDs, forService: service)
                }
                
                if autoDiscoverIncludedService {
                    _peripheral.discoverIncludedServices(filterIncludedServiceUUIDs, forService: service)
                }
            }
        }
        
        if let handlers = _targets[KurmaPeripheralEvents.ServiceDiscovered.eventKey] {
            for handler in handlers {
                guard let h = handler as? KurmaPeripheralEventsHandler else {
                    continue
                }
                h.peripheral?(self, didDiscoverServices: error)
            }
        }
    }
    
    @objc public func peripheral(peripheral: CBPeripheral, didDiscoverIncludedServicesForService service: CBService, error: NSError?) {
        if peripheral != _peripheral {
            return
        }
        
        let kService = KurmaService(service: service, peripheral: self)
        if let handlers = _targets[KurmaPeripheralEvents.IncludedServiceDiscovered.eventKey] {
            for handler in handlers {
                guard let h = handler as? KurmaPeripheralEventsHandler else {
                    continue
                }
                h.peripheral?(self, didDiscoverIncludedServicesForService: kService, error: error)
            }
        }
    }
    
    @objc public func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        if _peripheral != peripheral {
            return
        }
        
        let kService:KurmaService!
        if let s = _services[service.UUID] {
            kService = s
        } else {
            kService = KurmaService(service: service, peripheral: self)
            _services[service.UUID] = kService
        }
        
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                kService.discoverdCharacteristic(characteristic)
                if autoDiscoverCharacteristicDescriptor {
                    _peripheral.discoverDescriptorsForCharacteristic(characteristic)
                }
            }
        }
        if let handlers = _targets[KurmaPeripheralEvents.CharacteristicDiscovered.eventKey] {
            for handler in handlers {
                guard let h = handler as? KurmaPeripheralEventsHandler else {
                    continue
                }
                h.peripheral?(self, didDiscoverCharacteristicsForService: kService, error: error)
            }
        }
    }
    
    @objc public func peripheralDidUpdateName(peripheral: CBPeripheral) {
        if _peripheral != peripheral {
            return
        }
        
        reloadDeviceName()
        
        if let handlers = _targets[KurmaPeripheralEvents.NameUpdated.eventKey] {
            for handler in handlers {
                guard let h = handler as? KurmaPeripheralEventsHandler else {
                    continue
                }
                h.peripheralDidUpdateName?(self)
            }
        }
    }
    
    @objc public func peripheral(peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: NSError?) {
        if _peripheral != peripheral {
            return
        }
        _RSSI = RSSI
        if let handlers = _targets[KurmaPeripheralEvents.RSSIRead.eventKey] {
            for handler in handlers {
                guard let h = handler as? KurmaPeripheralEventsHandler else {
                    continue
                }
                h.peripheral?(self, didReadRSSI: RSSI, error: error)
            }
        }
    }
    
    @objc public func peripheral(peripheral: CBPeripheral, didDiscoverDescriptorsForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        if _peripheral != peripheral {
            return
        }
        
        if let handlers = _targets[KurmaPeripheralEvents.DescriptorDiscovered.eventKey] {
            for handler in handlers {
                guard let h = handler as? KurmaPeripheralEventsHandler else {
                    continue
                }
                h.peripheral?(self, didDiscoverDescriptorsForCharacteristic: characteristic, error: error)
            }
        }
    }
    
    @objc public func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        if peripheral != _peripheral {
            return
        }
        
        if let handlers = _targets[KurmaPeripheralEvents.CharacteristicValueUpdated.eventKey] {
            for handler in handlers {
                guard let h = handler as? KurmaPeripheralEventsHandler else {
                    continue
                }
                h.peripheral?(self, didUpdateValueForCharacteristic: characteristic, error: error)
            }
        }
    }
    
    @objc public func peripheral(peripheral: CBPeripheral, didUpdateValueForDescriptor descriptor: CBDescriptor, error: NSError?) {
        if peripheral != _peripheral {
            return
        }
        
        if let handlers = _targets[KurmaPeripheralEvents.DescriptorValueUpdated.eventKey] {
            for handler in handlers {
                guard let h = handler as? KurmaPeripheralEventsHandler else {
                    continue
                }
                h.peripheral?(self, didUpdateValueForDescriptor: descriptor, error: error)
            }
        }
    }
    
    @objc public func peripheral(peripheral: CBPeripheral, didWriteValueForDescriptor descriptor: CBDescriptor, error: NSError?) {
        if peripheral != _peripheral {
            return
        }
        
        if let handlers = _targets[KurmaPeripheralEvents.ValueWrittenForDescriptor.eventKey] {
            for handler in handlers {
                guard let h = handler as? KurmaPeripheralEventsHandler else {
                    continue
                }
                h.peripheral?(self, didWriteValueForDescriptor: descriptor, error: error)
            }
        }
    }
    
    @objc public func peripheral(peripheral: CBPeripheral, didWriteValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        if peripheral != _peripheral {
            return
        }
        if let handlers = _targets[KurmaPeripheralEvents.ValueWrittenForCharacteristic.eventKey] {
            for handler in handlers {
                guard let h = handler as? KurmaPeripheralEventsHandler else {
                    continue
                }
                h.peripheral?(self, didWriteValueForCharacteristic: characteristic, error: error)
            }
        }
    }
    
    @objc public func peripheral(peripheral: CBPeripheral, didUpdateNotificationStateForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        if peripheral != _peripheral {
            return
        }
        
        if let handlers = _targets[KurmaPeripheralEvents.CharacteristicNotificationStateUpdated.eventKey] {
            for handler in handlers {
                guard let h = handler as? KurmaPeripheralEventsHandler else {
                    continue
                }
                h.peripheral?(self, didUpdateNotificationStateForCharacteristic: characteristic, error: error)
            }
        }
    }
    
    // MARK: -  Write data
    @objc(writeData:toCharacteristic:inService:type:)
    public func writeData(data:NSData, forCharacteristic characteristic: CBCharacteristic, inService service:KurmaService, type: CBCharacteristicWriteType) {
        guard let characteristics = _services[service.UUID]?.rxCharacteristics else {
            return
        }
        
        if characteristics.keys.contains(characteristic.UUID) {
            if let handlers = _targets[KurmaPeripheralEvents.WillWirteValueForCharacteristic.eventKey] {
                for handler in handlers {
                    guard let h = handler as? KurmaPeripheralEventsHandler else {
                        continue
                    }
                    h.peripheral?(self, willWriteData: data, forCharacteristic: characteristic, inService: service, type: type)
                }
            }
            _peripheral.writeValue(data, forCharacteristic: characteristic, type: type)
        }
    }
    
    @objc(writeData:toCharacteristicWithUUIDString:inServiceWithUUIDString:type:)
    public func writeData(data:NSData, forCharacteristic characteristicUUID:String, inService serviceUUID:String, type:CBCharacteristicWriteType) {
        let characteristic = CBUUID(string: characteristicUUID)
        let service = CBUUID(string: serviceUUID)
        writeData(data, forCharacteristic: characteristic, inService: service, type: type)
    }
    
    @objc(writeData:toCharacteristicWithUUID:inServiceWithUUID:type:)
    public func writeData(data:NSData, forCharacteristic characteristic:CBUUID, inService service:CBUUID, type:CBCharacteristicWriteType) {
        guard let characteristics = _services[service]?.txCharacteristics, let kService = _services[service] else {
            return
        }
        
        for c in characteristics.values {
            if c == characteristic {
                if let handlers = _targets[KurmaPeripheralEvents.WillWirteValueForCharacteristic.eventKey] {
                    for handler in handlers {
                        guard let h = handler as? KurmaPeripheralEventsHandler else {
                            continue
                        }
                        h.peripheral?(self, willWriteData: data, forCharacteristic: c, inService: kService, type: type)
                    }
                }
                _peripheral.writeValue(data, forCharacteristic: c, type: type)
                break
            }
        }
    }
    
    public func writeData(data:NSData, forDescriptor descriptor:CBDescriptor) {
        //TODO: implement this
    }
    
    //MARK: - Peripheral operation
    public func discoverCharacteristics(characteristicUUIDs:[CBUUID]?, forService service:CBService) {
        if let service = _services[service.UUID] {
            _peripheral.discoverCharacteristics(characteristicUUIDs, forService: service.service)
        }
    }
    
    public func discoverDescriptorForCharacteristic(characteristic:CBCharacteristic) {
        for service in _services.values {
            if service.hasCharacteristic(characteristic) {
                _peripheral.discoverDescriptorsForCharacteristic(characteristic)
            }
        }
    }
    
    public func discoverServices(serviceUUIDs uuids:[CBUUID]? = nil) {
        filterServiceUUIDs = uuids
        _peripheral.discoverServices(uuids)
    }
    
    public func discoverCharacteristic(characteristicUUIDs UUIDs:[CBUUID]?, forService service:CBService) {
        guard let services = _peripheral.services else {
            return
        }
        
        filterCharacteristicUUIDs = UUIDs
        if services.contains(service) {
            _peripheral.discoverCharacteristics(filterCharacteristicUUIDs, forService: service)
        }
    }
    
    @objc(discoverCharacteristic:forServiceWithUUID:)
    public func discoverCharacteristic(characteristicUUIDs UUIDs:[CBUUID]?, forService serviceUUID:CBUUID) {
        guard let service = _services[serviceUUID] else {
            return
        }
        filterCharacteristicUUIDs = UUIDs
        discoverCharacteristic(characteristicUUIDs: filterCharacteristicUUIDs, forService: service.service)
    }
    
    public func discoverIncludedSerivces(forService service:KurmaService, includedServiceUUIDs UUIDs:[CBUUID]? = nil) {
        guard let service = _services[service.UUID] else {
            return
        }
        
        filterIncludedServiceUUIDs = UUIDs
        _peripheral.discoverIncludedServices(filterIncludedServiceUUIDs, forService: service.service)
    }
    
    public func discover(serviceUUIDs:[CBUUID]?, characteristicUUIDs:[CBUUID]?, discoverIncluedService includedService:Bool = false, includedServiceUUIDs:[CBUUID]? = nil, discoverCharacteristicDescriptor characteristicDescriptor:Bool = false) {
        autoDiscoverCharacterist = true
        autoDiscoverIncludedService = includedService
        autoDiscoverCharacteristicDescriptor = characteristicDescriptor
        
        filterServiceUUIDs = serviceUUIDs
        filterCharacteristicUUIDs = characteristicUUIDs
        filterIncludedServiceUUIDs = includedServiceUUIDs
        discoverServices(serviceUUIDs: filterServiceUUIDs)
    }
    
    //MARK: - Event handler management
    public func addTarget<T:NSObject where T:KurmaPeripheralEventsHandler>(target:T, forEvent event:KurmaPeripheralEvents) {
        var handlers:Set<NSObject>!
        if let t = _targets[event.eventKey] {
            handlers = t
        } else {
            handlers = Set()
            _targets[event.eventKey] = handlers
        }
        handlers.insert(target)
    }
    
    public func removeTarget<T:NSObject where T:KurmaPeripheralEventsHandler>(target:T, forEvent event:KurmaPeripheralEvents) {
        guard var handlers = _targets[event.eventKey] else {
        }
        handlers.remove(target)
    }
    
    public func removeTarget<T:NSObject where T:KurmaPeripheralEventsHandler>(target:T) {
        for event in KurmaPeripheralEvents.allEvents {
            removeTarget(target, forEvent: event)
        }
    }
}

@objc public class KurmaService:NSObject {
    private var _service:CBService
    private unowned var _peripheral:KurmaPeripheral
    
    //Writeable characteristics
    private var _rxCharacteristics:[CBUUID: CBCharacteristic] = [:]
    //Readable characteristics
    private var _txCharacteristics:[CBUUID: CBCharacteristic] = [:]
    
    private var _notifyCharacteristics:[CBUUID: CBCharacteristic] = [:]
    
    internal var service:CBService {
        get {
            return _service
        }
    }
    
    public var characteristics:[CBCharacteristic]? {
        get {
            return _service.characteristics
        }
    }
    
    public var includedServices:[CBService]? {
        get {
            return _service.includedServices
        }
    }
    
    public var rxCharacteristics:[CBUUID:CBCharacteristic] {
        get {
            return _rxCharacteristics
        }
    }
    
    public var txCharacteristics:[CBUUID:CBCharacteristic] {
        get {
            return _txCharacteristics
        }
    }
    
    public var notifyCharacteristics:[CBUUID:CBCharacteristic] {
        get {
            return _notifyCharacteristics
        }
    }
    
    
    public var peripheral:KurmaPeripheral {
        get {
            return _peripheral
        }
    }
    
    public var UUID:CBUUID {
        get {
            return _service.UUID
        }
    }
    
    init(service:CBService, peripheral:KurmaPeripheral) {
        _service = service
        _peripheral = peripheral
        super.init()
    }
    
    internal func discoverdCharacteristic(characteristic:CBCharacteristic) {
        if characteristic.isReadable {
            _txCharacteristics[characteristic.UUID] = characteristic
        }
        
        if characteristic.isWritable {
            _rxCharacteristics[characteristic.UUID] = characteristic
        }
        
        if characteristic.isNotify {
            _notifyCharacteristics[characteristic.UUID] = characteristic
        }
    }
    
    internal func hasCharacteristic(characteristic:CBCharacteristic) -> Bool {
        return _rxCharacteristics.values.contains(characteristic) || _txCharacteristics.values.contains(characteristic) || _notifyCharacteristics.values.contains(characteristic)
    }
    
    @objc(hasCharacteristicWithUUID:)
    internal func hasCharacteristic(characteristic:CBUUID) -> Bool {
        return _rxCharacteristics.keys.contains(characteristic) || _txCharacteristics.keys.contains(characteristic) || _notifyCharacteristics.keys.contains(characteristic)
    }
    
    @objc(hasCharacteristicWithUUIDString:)
    internal func hasCharacteristic(characteristic:String) -> Bool {
        return hasCharacteristic(CBUUID(string: characteristic))
    }
}

@objc public enum KurmaPeripheralEvents:Int {
    case ServiceDiscovered = 1
    case IncludedServiceDiscovered
    case CharacteristicDiscovered
    case DescriptorDiscovered
    case NameUpdated
    case RSSIRead
    case CharacteristicValueUpdated
    case DescriptorValueUpdated
    case ValueWrittenForCharacteristic
    case ValueWrittenForDescriptor
    case CharacteristicNotificationStateUpdated
    case WillWirteValueForCharacteristic
    case WillWriteValueForDescriptor
    
    var eventKey:String {
        get {
            var key:String = ""
            switch self {
            case .ServiceDiscovered:
                key = "service_discovered"
            case .IncludedServiceDiscovered:
                key = "included_service_discovered"
            case .CharacteristicDiscovered:
                key = "characteristic_discovered"
            case .DescriptorDiscovered:
                key = "descriptor_discovered"
            case .NameUpdated:
                key = "name_updated"
            case .RSSIRead:
                key = "rssi_read"
            case .CharacteristicValueUpdated:
                key = "characteristic_value_updated"
            case .DescriptorValueUpdated:
                key = "descriptor_value_updated"
            case .ValueWrittenForDescriptor:
                key = "value_written_for_descriptor"
            case .ValueWrittenForCharacteristic:
                key = "value_written_for_characteristic"
            case .CharacteristicNotificationStateUpdated:
                key = "characteristic_notification_state_updated"
            case .WillWirteValueForCharacteristic:
                key = "will_write_value_for_characteristic"
            case .WillWriteValueForDescriptor:
                key = "will_write_value_for_descriptor"
            }
            return key
        }
    }
    
    static let allEvents:[KurmaPeripheralEvents] = [.ServiceDiscovered, .IncludedServiceDiscovered, .CharacteristicDiscovered, .DescriptorDiscovered, .NameUpdated, .RSSIRead, .CharacteristicValueUpdated, .DescriptorValueUpdated, .ValueWrittenForCharacteristic, .ValueWrittenForDescriptor, .CharacteristicNotificationStateUpdated, .WillWirteValueForCharacteristic, .WillWriteValueForDescriptor]
}



@objc public protocol KurmaPeripheralEventsHandler {
    optional func peripheral(peripheral:KurmaPeripheral, didDiscoverServices error:NSError?)
    optional func peripheral(peripheral:KurmaPeripheral, didDiscoverIncludedServicesForService service: KurmaService, error: NSError?)
    optional func peripheral(peripheral: KurmaPeripheral, didDiscoverCharacteristicsForService service: KurmaService, error: NSError?)
    optional func peripheralDidUpdateName(peripheral: KurmaPeripheral)
    optional func peripheral(peripheral: KurmaPeripheral, didReadRSSI RSSI: NSNumber, error: NSError?)
    optional func peripheral(peripheral: KurmaPeripheral, didDiscoverDescriptorsForCharacteristic characteristic: CBCharacteristic, error: NSError?)
    optional func peripheral(peripheral: KurmaPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?)
    optional func peripheral(peripheral: KurmaPeripheral, didUpdateValueForDescriptor descriptor: CBDescriptor, error: NSError?)
    optional func peripheral(peripheral: KurmaPeripheral, didWriteValueForDescriptor descriptor: CBDescriptor, error: NSError?)
    optional func peripheral(peripheral: KurmaPeripheral, didWriteValueForCharacteristic characteristic: CBCharacteristic, error: NSError?)
    optional func peripheral(peripheral: KurmaPeripheral, didUpdateNotificationStateForCharacteristic characteristic: CBCharacteristic, error: NSError?)
    
    optional func peripheral(peripheral: KurmaPeripheral, willWriteData data:NSData, forCharacteristic characteristic: CBCharacteristic, inService service: KurmaService, type: CBCharacteristicWriteType)
    optional func peripheral(peripheral: KurmaPeripheral, willWriteData data:NSData, forDescriptor descriptor: CBDescriptor)
}