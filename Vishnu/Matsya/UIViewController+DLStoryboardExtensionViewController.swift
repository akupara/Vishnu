//
//  UIViewController+DLStoryboardExtensionViewController.swift
//  DLControl
//
//  Created by Daniel Lu on 2/18/16.
//  Copyright © 2016 Daniel Lu. All rights reserved.
//

import UIKit
import Vishnu

public extension UIViewController {
    
    public func presentInstantiateViewControllerWithIdentifier(identifier: String, animated: Bool, inStoryboardNamed name:String, withParams params:[String: AnyObject]? = nil, inViewController: UIViewController? = nil) {
        presentinstantiateViewControllerWithIdentifier(identifier, animated: animated, inStoryboard: storyboardNamed(name), withParams: params, inViewController: inViewController)
    }
    
    public func presentinstantiateViewControllerWithIdentifier(identifier: String, animated: Bool, inStoryboard: UIStoryboard, withParams params:[String:AnyObject]? = nil, inViewController: UIViewController? = nil) {
        presentViewController(instantiateViewControllerWithIdentifier(identifier, inStoryboard: inStoryboard), animated: animated, withParams: params, inViewController: inViewController)
    }
    
    public func presentViewController(controller:UIViewController, animated: Bool, withParams params:[String: AnyObject]? = nil, inViewController: UIViewController? = nil) {
        setupParams(controller, params: params)
        let sourceController:UIViewController!
        if inViewController != nil {
            sourceController = inViewController
        } else {
            sourceController = self
        }
        
        if let navi = sourceController as? UINavigationController {
            navi.pushViewController(controller, animated: animated)
        } else if let navi = sourceController.navigationController {
            navi.pushViewController(controller, animated: animated)
        } else {
            sourceController.presentViewController(controller, animated: animated, completion: nil)
        }
    }
    
    internal func storyboardNamed(name:String, bundle: NSBundle? = nil) -> UIStoryboard {
        return UIStoryboard(name: name, bundle: bundle)
    }

    internal func instantiateViewControllerWithIdentifier(identifier:String, inStoryboard: UIStoryboard) -> UIViewController {
        return inStoryboard.instantiateViewControllerWithIdentifier(identifier)
    }
    
    internal func instantiateViewControllerWithIdentifier(identifier:String, inStoryboardNamed name: String, bundle:NSBundle? = nil) -> UIViewController {
        return instantiateViewControllerWithIdentifier(identifier, inStoryboard: storyboardNamed(name, bundle: bundle))
    }
    
    internal func instantiateInitialViewControllerInStoryboardNamed(name:String, bundle:NSBundle? = nil) -> UIViewController? {
        return storyboardNamed(name, bundle: bundle).instantiateInitialViewController()
    }
    
    internal func setupParams(target:UIViewController, params:[String:AnyObject]?) {
        if params != nil {
            for (name, value) in params! {
                let method = "set\(name.upperCaseFirst()):"
                if target.respondsToSelector(Selector(method)) {
                    target.setValue(value, forKey: name)
                }
            }
        }
    }
}