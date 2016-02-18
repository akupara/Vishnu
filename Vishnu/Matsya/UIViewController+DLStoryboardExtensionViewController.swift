//
//  UIViewController+DLStoryboardExtensionViewController.swift
//  DLControl
//
//  Created by Daniel Lu on 2/18/16.
//  Copyright © 2016 Daniel Lu. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentInstantiateViewControllerWithIdentifier(identifier: String, animated: Bool, inStoryboardNamed name:String, withParams params:[String: AnyObject]? = nil) {
        presentinstantiateViewControllerWithIdentifier(identifier, animated: animated, inStoryboard: storyboardNamed(name), withParams: params)
    }
    
    func presentinstantiateViewControllerWithIdentifier(identifier: String, animated: Bool, inStoryboard: UIStoryboard, withParams params:[String:AnyObject]? = nil) {
        presentViewController(instantiateViewControllerWithIdentifier(identifier, inStoryboard: inStoryboard), animated: animated, withParams: params)
    }
    
    func presentViewController(controller:UIViewController, animated: Bool, withParams params:[String: AnyObject]? = nil) {
        if let targetParams = params {
            for (name, value) in targetParams {
                let method = "set\(name.upperCaseFirst()):"
                if controller.respondsToSelector(Selector(method)) {
                    controller.setValue(value, forKey: name)
                }
            }
        }
        if let navi = navigationController {
            navi.pushViewController(controller, animated: animated)
        } else {
            presentViewController(controller, animated: animated, completion: nil)
        }
    }
    
    private func storyboardNamed(name:String, bundle: NSBundle? = nil) -> UIStoryboard {
        return UIStoryboard(name: name, bundle: bundle)
    }

    private func instantiateViewControllerWithIdentifier(identifier:String, inStoryboard: UIStoryboard) -> UIViewController {
        return inStoryboard.instantiateViewControllerWithIdentifier(identifier)
    }
    
    private func instantiateViewControllerWithIdentifier(identifier:String, inStoryboardNamed name: String, bundle:NSBundle? = nil) -> UIViewController {
        return instantiateViewControllerWithIdentifier(identifier, inStoryboard: storyboardNamed(name, bundle: bundle))
    }
    
    private func instantiateInitialViewControllerInStoryboardNamed(name:String, bundle:NSBundle? = nil) -> UIViewController? {
        return storyboardNamed(name, bundle: bundle).instantiateInitialViewController()
    }
}