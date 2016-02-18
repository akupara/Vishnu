//
//  UIViewController+DLAlertExtension.swift
//  DLControl
//
//  Created by Daniel Lu on 2/17/16.
//  Copyright © 2016 Daniel Lu. All rights reserved.
//

import UIKit

public extension UIViewController {
    
    public func showAlertWithTitle(title:String?, message:String?, delegate: UIAlertViewDelegate?, cancelButtonTitle:String?, otherButtonTitles titles:String...) -> UIAlertView {
        let alert = UIAlertView.alertViewWithTitle(title, message: message, delegate: delegate, cancelButtonTitle: cancelButtonTitle)
        if titles.count > 0 {
            for title in titles {
                alert.addButtonWithTitle(title)
            }
        }
        alert.show()
        return alert
    }
    
    public func showAlertWithTitle(title:String?, message: String?, completion: ((UIAlertView, Int)->Void)! = nil, cancelButtonTitle:String?, otherButtonTitles titles:String...) {
        let alert = UIAlertView.alertViewWithTitle(title, message: message, completion: completion, cancelButtonTitle: cancelButtonTitle)
        if titles.count > 0 {
            for title in titles {
                alert.addButtonWithTitle(title)
            }
        }
        alert.show()
    }
    
    @available(iOS 8.0, *)
    public func showAlertWithTitle(title: String?, message: String?, preferedStyle: UIAlertControllerStyle = .Alert, completion:(() -> Void)! = nil, actions: UIAlertAction...) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: preferedStyle)
        if actions.count > 0 {
            for action in actions {
                controller.addAction(action)
            }
        }
        presentViewController(controller, animated: true, completion: completion)
    }
}
