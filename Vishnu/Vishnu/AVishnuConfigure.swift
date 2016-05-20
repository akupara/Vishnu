//
//  AVishnuConfigure.swift
//  Vishnu
//
//  Created by Daniel Lu on 2/23/16.
//  Copyright © 2016 Daniel Lu. All rights reserved.
//

import Foundation

public class AVishnuConfigure: NSObject {
    
    private var configures:[String:AnyObject]!
    
    public class func ApplicationInfo() -> AVishnuConfigure {
        return AVishnuConfigure()
    }

    public init(file:String, ofType: String?, bundle:NSBundle?) {
        let fileBundle:NSBundle!
        if bundle == nil {
            fileBundle = NSBundle(forClass: AVishnuConfigure.self)
        } else {
            fileBundle = bundle!
        }
        
        let fileType:String!
        if ofType == nil {
            fileType = "plist"
        } else {
            fileType = ofType!
        }
        
        if let path = fileBundle.pathForResource(file, ofType: fileType) {
            let values = NSDictionary(contentsOfFile: path) as? [String:AnyObject]
            configures = values
        } else {
            assert(false, "Cannot find resource \(file) with type \(fileType) in bundle")
        }
        super.init()
        assert(configures != nil, "Cannot parse configure file \(file).\(fileType)")
    }
    
    public convenience init(file:String, bundle: NSBundle?) {
        self.init(file: file, ofType: "plist", bundle: bundle)
    }
    
    public convenience init(file:String) {
        self.init(file:file, ofType: "plist", bundle: NSBundle.mainBundle())
    }
    
    override init() {
        super.init()
        configures = NSBundle.mainBundle().infoDictionary
    }
    
    //MARK: - Get value with name and group (2 level)
    public func getStringFromConfigureWithName(name:String, defaultValue:String? = nil, inGroup group: String? = nil) -> String? {
        let value:String? = getConfigureValueFromConfigWithName(name, defaultValue: defaultValue, inGroup: group)
        return value
    }
    
    public func getArrayFromConfigureWithName(name:String, defaultValue:[AnyObject]? = nil, inGroup group: String? = nil) -> [AnyObject]? {
        let value:[AnyObject]? = getConfigureValueFromConfigWithName(name, defaultValue: defaultValue, inGroup: group)
        return value
    }
    
    public func getDictionaryFromConfigureWithName(name:String, defaultValue:[String:AnyObject]? = nil, inGroup group: String? = nil) -> [String:AnyObject]? {
        let value:[String:AnyObject]? = getConfigureValueFromConfigWithName(name, defaultValue: defaultValue, inGroup: group)
        return value
    }
    
    public func getBoolFromConfigureWithName(name:String, defaultValue:Bool = false, inGroup group:String? = nil) -> Bool {
        let configValue:Bool? = getConfigureValueFromConfigWithName(name, defaultValue: defaultValue, inGroup: group)
        guard let value = configValue else {
            return defaultValue
        }
        return value
    }
    
    public func getNumberFromConfigureWithName(name:String, defaultValue:NSNumber? = nil, inGroup group: String? = nil) -> NSNumber? {
        let value:NSNumber? = getConfigureValueFromConfigWithName(name, defaultValue: defaultValue, inGroup: group)
        return value
    }
    
    public func getDateFromConfigureWithName(name:String, defaultValue:NSDate? = nil, inGroup group: String? = nil) -> NSDate? {
        let value:NSDate? = getConfigureValueFromConfigWithName(name, defaultValue: defaultValue, inGroup: group)
        return value
    }

    public func getDataFromConfigureWithName(name:String, defaultValue:NSData? = nil, inGroup group: String? = nil) -> NSData? {
        let value:NSData? = getConfigureValueFromConfigWithName(name, defaultValue: defaultValue, inGroup: group)
        return value
    }
    
    //MARK: Get Value from path
    public func getStringFromPath(path:String, defaultValue:String? = nil) -> String? {
        let value:String? = getConfigureValueFromPath(path, defaultValue: defaultValue)
        return value
    }
    
    public func getArrayFromPath(path:String, defaultValue:[AnyObject]? = nil) -> [AnyObject]? {
        let value:[AnyObject]? = getConfigureValueFromPath(path, defaultValue: defaultValue)
        return value
    }
    
    public func getDictonaryFromPath(path:String, defaultValue:[String:AnyObject]? = nil) -> [String:AnyObject]? {
        let value:[String:AnyObject]? = getConfigureValueFromPath(path, defaultValue: defaultValue)
        return value
    }
    
    public func getDateFromPath(path:String, defaultValue:NSDate? = nil) -> NSDate? {
        let value:NSDate? = getConfigureValueFromPath(path, defaultValue: defaultValue)
        return value
    }
    
    public func getDataFromPath(path:String, defaultValue:NSData? = nil) -> NSData? {
        let value:NSData? = getConfigureValueFromPath(path, defaultValue: defaultValue)
        return value
    }
    
    public func getNumberFromPath(path:String, defaultValue:NSNumber? = nil) -> NSNumber? {
        let value:NSNumber? = getConfigureValueFromPath(path, defaultValue: defaultValue)
        return value
    }
    
    public func getBoolFromPath(path:String, defaultValue:Bool = false) -> Bool {
        let configureValue:Bool? = getConfigureValueFromPath(path, defaultValue: defaultValue)
        guard let value = configureValue else {
            return defaultValue
        }
        return value
    }
    
    //MARK: private funcs
    private func getConfigureValueFromPath<T>(path:String, defaultValue:T? = nil) -> T? {
        let trimedPath = path.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if trimedPath.characters.count < 1 {
            return defaultValue
        }
        
        var configPathes = trimedPath.componentsSeparatedByString("\\")
        if configPathes.count < 1 {
            return defaultValue
        }
        
        var configs:[String:AnyObject] = configures
        while configPathes.count > 0 {
            let key = configPathes.removeFirst()
            if configPathes.count < 1 {
                if let value = configs[key] as? T {
                    return value
                }
                return defaultValue
            } else {
                if let values = configs[key] as? [String:AnyObject] {
                    configs = values
                } else {
                    return defaultValue
                }
            }
        }
        return nil
    }
    
    private func getConfigureValueFromConfigWithName<T>(name:String, defaultValue:T? = nil, inGroup group:String? = nil) -> T? {
        if let groupName = group {
            if let groupConfigs = configures[groupName] as? [String:AnyObject] {
                if let value = groupConfigs[name] as? T {
                    return value
                }
            }
        } else if let value = configures[name] as? T {
            return value
        }
        return defaultValue
    }
    
    
}