//
//  UIAlertView+DLExtension.swift
//  DLControl
//
//  Created by Daniel Lu on 2/17/16.
//  Copyright © 2016 Daniel Lu. All rights reserved.
//

import UIKit

public extension UIAlertView {
    
    class func showAlertViewWithTitle(title:String?, message: String?, completion: ((UIAlertView, Int) -> Void)! = nil, cancelButtonTitle: String?, otherButtonTitles titles:String...) -> UIAlertView {
        let alert = UIAlertView.alertViewWithTitle(title, message: message, completion: completion, cancelButtonTitle: cancelButtonTitle)
        alert.addTitles(titles)
        alert.show()
        return alert
    }
    
    class func showAlertViewWithTitle(title:String?, message: String?, delegate: AnyObject?, cancelButtonTitle:String?, otherButtonTitles titles: String...) -> UIAlertView {
        let alert = UIAlertView(title: title, message: message, delegate: delegate, cancelButtonTitle: cancelButtonTitle)
        alert.addTitles(titles)
        alert.show()
        return alert
    }
    
    class func alertViewWithTitle(title:String?, message: String?, completion: ((UIAlertView, Int) -> Void)! = nil, cancelButtonTitle: String?, otherButtonTitles titles:String...) -> UIAlertView {
        let alert = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: cancelButtonTitle)
        
        if completion != nil {
            alert.delegate = Delegate(completion: completion)
        }
        return alert
    }
    
    class func alertViewWithTitle(title:String?, message: String?, delegate: AnyObject?, cancelButtonTitle:String?, otherButtonTitles titles: String...) -> UIAlertView {
        let alert = UIAlertView(title: title, message: message, delegate: delegate, cancelButtonTitle: cancelButtonTitle)
        alert.addTitles(titles)
        return alert
    }
    
    @objc(showWithCompletion:)
    public func show(completion: (UIAlertView, Int) -> Void) {
        let blockDelegate = Delegate(completion:completion)
        if delegate != nil {
            blockDelegate.originalDelegate = delegate
        }
        delegate = blockDelegate
        show()
    }
    
    private func addTitles(titles:[String]) {
        if titles.count > 0 {
            for title in titles {
                addButtonWithTitle(title)
            }
        }
    }
    
    private class Delegate:NSObject, UIAlertViewDelegate {
        var completionHandler: (UIAlertView, Int) -> Void
        var retainedSelf:Delegate?
        var originalDelegate:AnyObject?
        
        init(completion:(UIAlertView, Int) -> Void) {
            completionHandler = completion
            super.init()
            retainedSelf = self
        }
    
        // MARK: -  UIAlertViewDelegate
        @objc private func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
            if let retain = retainedSelf {
                retain.retainedSelf = nil
                retain.completionHandler(alertView, buttonIndex)
                
                if let dele = originalDelegate {
                    if dele.respondsToSelector("alertView:didDismissWithButtonIndex:") {
                        dele.alertView(alertView, didDismissWithButtonIndex: buttonIndex)
                    }
                }
            }
        }
        
        deinit {
            originalDelegate = nil
        }
    }
}
