//
//  MastyaTabBarController.swift
//  Vishnu
//
//  Created by Daniel Lu on 5/20/16.
//  Copyright © 2016 Daniel Lu. All rights reserved.
//

import UIKit

struct MatsyaTabConfig {
    var storyboardName:String
    var viewControllerName:String? = nil
    var bundle:NSBundle? = nil
    var isInitialViewController:Bool
    
    var viewController:UIViewController? {
        get {
            let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
            if isInitialViewController {
                return storyboard.instantiateInitialViewController()
            } else {
                if let controllerName = viewControllerName {
                    return storyboard.instantiateViewControllerWithIdentifier(controllerName)
                }
            }
            
            return nil
        }
    }
    
    init (storyboardName aName:String, inBundle aBundle:NSBundle? = nil, withViewControllerName aControllerName:String? = nil, isInitialViewController isInitialOne:Bool = true) {
        storyboardName = aName
        bundle = aBundle
        viewControllerName = aControllerName
        isInitialViewController = isInitialOne
    }
    
    init(storyboardName aName:String) {
        self.init(storyboardName: aName, inBundle: nil, withViewControllerName: nil, isInitialViewController: true)
    }
}

@IBDesignable public class MatsyaTabBarController: UITabBarController {
    
    @IBInspectable public var loadFromConfigure:Bool = false
    
    //Default tabs
    private var tabs:[MatsyaTabConfig] = []
    static let tabConfigureName = "MastyaTabBarController"
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupViewControllers()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    public func setViewControllerAt(index:Int, withViewController newController:UIViewController) {
        if index < 0 {
            return
        }
        if var controllers = viewControllers {
            if index > controllers.count {
                controllers.append(newController)
            } else {
                controllers[index] = newController
            }
        }
    }
    
    public func setupViewControllers() {
        loadConfigureAndUpdateTabs(true)
    }
    
    public func loadConfigure() {
        //Check if load from configure is enabled
        if false == loadFromConfigure {
            return
        }
        
        //Make sure only load once
        if tabs.count > 0 {
            return
        }
        
        guard let appConfigures = NSBundle.mainBundle().infoDictionary else {
            return
        }
        
        if let tabsInConfig = appConfigures[MatsyaTabBarController.tabConfigureName] as? [[String:String]] {
            for tab in tabsInConfig {
                if let storyboardName = tab["Storyboard"] {
                    if storyboardName.isEmpty {
                        continue
                    }
                    let controllerName:String?
                    let isInitialController:Bool!
                    if let name = tab["ViewController"] {
                        controllerName = name
                        isInitialController = false
                    } else {
                        controllerName = nil
                        isInitialController = true
                    }
                    
                    var bundle:NSBundle? = nil
                    if let bundleId = tab["Bundle"] {
                        if let bundleConfigured = NSBundle(identifier: bundleId) {
                            bundle = bundleConfigured
                        }
                    }
                    
                    let mastyaTab = MatsyaTabConfig(storyboardName: storyboardName, inBundle: bundle, withViewControllerName: controllerName, isInitialViewController: isInitialController)
                    tabs.append(mastyaTab)
                }
            }
        }
    }
    
    public func reloadConfigures() {
        if false == loadFromConfigure {
            return
        }
        
        tabs.removeAll()
        
        loadConfigure()
    }
    
    public func loadConfigureAndUpdateTabs(updateAfterLoad:Bool = true) {
        loadConfigure()
        if updateAfterLoad {
            updateTabsFromConfiguire()
        }
    }
    
    public func reloadConfigureAndUpdateTabs(updateAfterLoad:Bool = true) {
        reloadConfigures()
        if updateAfterLoad {
            updateTabsFromConfiguire()
        }
    }
    
    internal func updateTabsFromConfiguire(animated:Bool = false) {
        if tabs.count > 0 {
            if let _ = viewControllers {
                for (index, tab) in tabs.enumerate() {
                    if let controller = tab.viewController {
                        setViewControllerAt(index, withViewController: controller)
                    }
                }
            } else {
                var controllers:[UIViewController] = []
                for tab in tabs {
                    if let controller = tab.viewController {
                        controllers.append(controller)
                    }
                }
                setViewControllers(controllers, animated: animated)
            }
        }
    }

}
