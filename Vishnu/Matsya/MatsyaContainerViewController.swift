//
//  MatsyaContainerViewController.swift
//  Vishnu
//
//  Created by Daniel Lu on 3/9/16.
//  Copyright © 2016 Daniel Lu. All rights reserved.
//

import UIKit

public class MatsyaContainerViewController: UIViewController {

    enum PanelStatus {
        case RightExpaned
        case LeftExpanded
        case BothCollapsed
    }
    
    private var mainNavigationController:UINavigationController!
    private var rightPanel:UIViewController?
    private var leftPanel:UIViewController?
    
    private var mainViewGestures:[UISwipeGestureRecognizer] = []
    private var leftViewGesture:UISwipeGestureRecognizer?
    private var rightViewGesture:UISwipeGestureRecognizer?
    
    private var currentPanelStatus:PanelStatus = .BothCollapsed
    
    internal var targetPosRate:CGFloat = 0.7
    internal var targetSizeScaleRate:CGFloat = 1
    
    public var positionRate:CGFloat {
        get {
            return targetPosRate
        }
        set {
            if newValue > 1 || newValue < 0 {
                targetPosRate = 0.7
            } else {
                targetPosRate = newValue
            }
        }
    }
    
    public var mainViewScaleRate:CGFloat {
        get {
            return targetSizeScaleRate
        }
        set {
            if newValue > 1 || newValue < 0 {
                targetSizeScaleRate = 1
            } else {
                targetSizeScaleRate = newValue
            }
        }
    }
    
    public var backgroundImage:UIImage! = nil
    public var backgroundView:UIView! = nil
    
    static let animationDuration:NSTimeInterval = 0.5
    static let springWithDamping:CGFloat = 0.8
    
    override public func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MAKR: - MainViewController
    public func setMainViewController(viewController:UIViewController) {
        if mainNavigationController != nil {
            if mainViewGestures.count > 0 {
                for gesture in mainViewGestures {
                    mainNavigationController.view.removeGestureRecognizer(gesture)
                }
            }
            mainNavigationController.view.removeFromSuperview()
            mainNavigationController.removeFromParentViewController()
            mainNavigationController = nil
        }
        
        if let navigation = viewController as? UINavigationController {
            mainNavigationController = navigation
            if let viewController = navigation.topViewController as? MatsyaContainerContent {
                viewController.delegate = self
            }
        } else {
            let navigation = UINavigationController(rootViewController: viewController)
            mainNavigationController = navigation
            if let mainController = viewController as? MatsyaContainerContent {
                mainController.delegate = self
            }
        }
        
        let index = view.subviews.count
        
        let leftGesture = setupSwipeGestureRecognizerViewController(viewController, direction: .Left)
        let rightGesture = setupSwipeGestureRecognizerViewController(viewController, direction: .Right)
        mainViewGestures.append(leftGesture)
        mainViewGestures.append(rightGesture)
        
        view.insertSubview(viewController.view, atIndex: index)
        addChildViewController(viewController)
        viewController.didMoveToParentViewController(self)
    }
    
    public func setMainViewControllerInStoryboard(storyboard:UIStoryboard, withIdentifier identifier:String, params: [String:AnyObject]! = nil) {
        let viewController = storyboard.instantiateViewControllerWithIdentifier(identifier)
        setupParams(viewController, params: params)
        setMainViewController(viewController)
    }
    
    public func setMainViewControllerWithStoryboardInitialController(storyboard: UIStoryboard, params:[String:AnyObject]! = nil) {
        if let viewController = storyboard.instantiateInitialViewController() {
            setupParams(viewController, params: params)
            setMainViewController(viewController)
        }
    }
    
    // MARK: - Panel update
    public func setLeftPanel<T: UIViewController where T:MatsyaContainerContent> (panel: T) {
        if currentPanelStatus == .LeftExpanded {
            hidePanel(leftPanel)
            if let gesture = leftViewGesture {
                leftPanel?.view.removeGestureRecognizer(gesture)
                leftViewGesture = nil
            }
            leftPanel = nil
        }
        leftPanel = panel
        leftViewGesture = setupSwipeGestureRecognizerViewController(panel, direction: .Left)
        panel.delegate = self
    }
    
    public func setRightPanen<T: UIViewController where T:MatsyaContainerContent> (panel: T) {
        if currentPanelStatus == .RightExpaned {
            hidePanel(rightPanel)
            if let gesture = rightViewGesture {
                rightPanel?.view.removeGestureRecognizer(gesture)
            }
            rightPanel = nil
        }
        
        rightPanel = panel
        rightViewGesture = setupSwipeGestureRecognizerViewController(panel, direction: .Right)
        panel.delegate  = self
    }
    
    //MARK: - panel toggle and main view navigation
    public func toggleRightPanel() {
        if currentPanelStatus == .RightExpaned {
            hidePanel(rightPanel)
        } else if let _ = rightPanel {
            currentPanelStatus = .RightExpaned
            let targetPosition = (0 - (view.frame.size.width * targetPosRate))
            showPanel(rightPanel, mainViewPosition: targetPosition)
        }
    }
    
    public func toggleLeftPanel() {
        if currentPanelStatus == .LeftExpanded {
            hidePanel(leftPanel)
        } else if let _ = leftPanel {
            let targetPosition = view.frame.size.width * targetPosRate
            showPanel(leftPanel, mainViewPosition: targetPosition)
        }
    }
    
    public func collapsePanels(completion:((Bool) -> Void)! = nil) {
        if currentPanelStatus == .LeftExpanded {
            hidePanel(leftPanel, completion: completion)
        } else if currentPanelStatus == .RightExpaned {
            hidePanel(rightPanel, completion: completion)
        }
    }
    
    public func presentViewController(viewController: UIViewController, animated:Bool, params:[String:AnyObject]! = nil) {
        super.presentViewController(viewController, animated: animated, withParams: params, inViewController: mainNavigationController)
    }
    
    public func presentViewControllerInStoryboard(storyboard:UIStoryboard, withIdentifier identifier:String, animated:Bool, params: [String: AnyObject]! = nil) {
        let viewController = storyboard.instantiateViewControllerWithIdentifier(identifier)
        presentViewController(viewController, animated: animated, params: params)
    }
    
    public func presentInitialViewControllerInStoryboard(storyboard:UIStoryboard, animated:Bool, params:[String:AnyObject]! = nil) {
        if let viewController = storyboard.instantiateInitialViewController() {
            presentViewController(viewController, animated: animated, params: params)
        }
    }
    
    // MARK: - internal messages
    internal func animateMainView(targetPosition:CGFloat, newSize: CGSize! = nil, completion: ((Bool) -> Void)! = nil) {
        UIView.animateWithDuration(MatsyaContainerViewController.animationDuration, delay: 0.0,
            usingSpringWithDamping: MatsyaContainerViewController.springWithDamping,
            initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
                [unowned self] in
                self.mainNavigationController.view.frame.origin.x = targetPosition
                if newSize != nil {
                    self.mainNavigationController.view.frame.size = newSize
                    self.mainNavigationController.view.layoutIfNeeded()
                }
            }, completion: completion)
    }
    
    internal func hidePanel(panel:UIViewController?, completion: ((Bool) -> Void)! = nil) {
        currentPanelStatus = .BothCollapsed
        if let viewController = panel {
            animateMainView(0.0, newSize: view.frame.size) {
                [unowned self] (finished:Bool) in
                self.showShadowForMainViewController(false)
                viewController.view.removeFromSuperview()
                viewController.removeFromParentViewController()
                if completion != nil {
                    completion(finished)
                }
            }
        }
    }
    
    internal func showPanel(panel:UIViewController?, mainViewPosition position:CGFloat) {
        if let viewController = panel {
            view.insertSubview(viewController.view, belowSubview: mainNavigationController.view)
            addChildViewController(viewController)
            viewController.didMoveToParentViewController(self)
            let newSize:CGSize!
            if targetSizeScaleRate < 1 {
                let newWidth = mainNavigationController.view.frame.width * targetSizeScaleRate
                let newHeight = mainNavigationController.view.frame.height * targetSizeScaleRate
                newSize = CGSizeMake(newWidth, newHeight)
            } else {
                newSize = nil
            }
            showShadowForMainViewController(true)
            layoutPanelForPosition(position, panel: panel)
            animateMainView(position, newSize: newSize)
        }
    }
    
    internal func showShadowForMainViewController(showShadow:Bool = true) {
        if (showShadow) {
            mainNavigationController.view.layer.shadowOpacity = 0.8
        } else {
            mainNavigationController.view.layer.shadowOpacity = 0.0
        }
    }
    
    internal func layoutPanelForPosition(position:CGFloat, panel:UIViewController?) {
        if position == 0.0 {
            return
        }
        if let viewController = panel {
            let maxWidth = view.frame.width
            let height = view.frame.height
            let width = abs(position)
            let xPos:CGFloat!
            if position > 0 {
                xPos = 0.0
            } else {
                xPos = maxWidth - width
            }
            let targetFrame = CGRectMake(xPos, 0.0, width, height)
            viewController.view.frame = targetFrame
            viewController.view.layoutIfNeeded()
        }
    }
    
    internal func setupSwipeGestureRecognizerViewController(viewController:UIViewController, direction:UISwipeGestureRecognizerDirection) -> UISwipeGestureRecognizer {
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(MatsyaContainerViewController.gestureSwipeHandler(_:)))
        gesture.numberOfTouchesRequired = 1
        gesture.direction = direction
        viewController.view.addGestureRecognizer(gesture)
        return gesture
    }
    
    // MARK: - Gesture Recogniser Handlers
    public func gestureSwipeHandler(sender:UISwipeGestureRecognizer) {
        if sender.view == leftPanel?.view {
            leftPanelSwiped(sender)
        } else if sender.view == rightPanel?.view {
            rightPanelSwiped(sender)
        } else if sender.view == mainNavigationController.view {
            mainViewSwiped(sender)
        }
    }
    
    internal func leftPanelSwiped(gesture:UISwipeGestureRecognizer) {
        if currentPanelStatus == .LeftExpanded && gesture.direction == .Left {
            hidePanel(leftPanel)
        }
    }
    
    internal func rightPanelSwiped(gesture:UISwipeGestureRecognizer) {
        if currentPanelStatus == .RightExpaned && gesture.direction == .Right {
            hidePanel(rightPanel)
        }
    }
    
    internal func mainViewSwiped(gesture:UISwipeGestureRecognizer) {
        if gesture.direction == .Right {
            if currentPanelStatus == .BothCollapsed {
                toggleLeftPanel()
            } else if currentPanelStatus == .RightExpaned {
                hidePanel(rightPanel)
            }
        } else if gesture.direction == .Left {
            if currentPanelStatus == .BothCollapsed {
                toggleRightPanel()
            } else if currentPanelStatus == .LeftExpanded {
                hidePanel(leftPanel)
            }
        }
    }
    
    //MARK: - Background
    private func setupBackgroundImage() {
        if backgroundImage != nil {
            //Remove previous background view
            if backgroundView != nil {
                backgroundView.removeFromSuperview()
                backgroundView = nil
            }
            let imageView = UIImageView(image: backgroundImage)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            view.insertSubview(imageView, atIndex: 0)
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[imageView]|", options: [NSLayoutFormatOptions.AlignAllCenterX, NSLayoutFormatOptions.AlignAllCenterY], metrics: nil, views: ["imageView": imageView]))
            imageView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .Height, relatedBy: .Equal, toItem: imageView, attribute: .Width, multiplier: backgroundImage.size.height/backgroundImage.size.width, constant: 0))
            
//            let rate = backgroundImage.size.width
        }
    }

}


@objc public protocol MatsyaContainerContent {
    weak var delegate:MatsyaContainerViewController? { get set }
}