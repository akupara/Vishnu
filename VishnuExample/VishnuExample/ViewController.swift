
//  ViewController.swift
//  VishnuExample
//
//  Created by Daniel Lu on 2/18/16.
//  Copyright © 2016 Daniel Lu. All rights reserved.
//

import UIKit
import Vishnu
import Matsya

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tbDemoList: UITableView!
    
    private var titles = ["UIAlert Extension Demo", "UIViewController Alert Extension Demo", "UIViewController Mulitple Storyboard Demo"]

    override func viewDidLoad() {
        super.viewDidLoad()
        tbDemoList.registerNib(UINib(nibName: "SimpleTitleCell", bundle: nil), forCellReuseIdentifier: "demoCell")

        
        let configure = AVishnuConfigure(file: "Test")
        let value = configure.getBoolFromConfigureWithName("boolValue")
        let string = configure.getStringFromConfigureWithName("AppId", defaultValue: nil, inGroup: "Unicorn")
//        let TetstDictionary\\dic_level2\\dic_level3\boolValue dateValue dataValue stringValue dictValue arrayValue
//        let boolValue = configure.getBoolFromPath("TestDictionary\\dic_level2\\dic_level3\\boolValue")
//        let dateValue = configure.getDateFromPath("TestDictionary\\dic_level2\\dic_level3\\dateValue")
//        let dataValue = configure.getDataFromPath("TestDictionary\\dic_level2\\dic_level3\\dataValue")
//        let stringValue = configure.getStringFromPath("TestDictionary\\dic_level2\\dic_level3\\stringValue")
//        let numberValue = configure.getNumberFromPath("TestDictionary\\dic_level2\\dic_level3\\numberValue")
//        let arrayValue = configure.getArrayFromPath("TestDictionary\\dic_level2\\dic_level3\\arrayValue")
//        let dictValue = configure.getDictonaryFromPath("TestDictionary\\dic_level2\\dic_level3\\dictValue")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    //MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("demoCell") as! SimpleTitleTableViewCell
        cell.title = ""
        
        if indexPath.row < titles.count {
            cell.title = titles[indexPath.row]
        }
        return cell
    }
    
    //MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:
            UIAlertView.showAlertViewWithTitle("Alert Demo", message: "This is first alert with completion block. Will triggle another new alert after click button.", completion: {
                (alert: UIAlertView, buttonIndex:Int) in
                UIAlertView.showAlertViewWithTitle("Alert Demo", message: "This is second alert.", cancelButtonTitle: "OK")
            }, cancelButtonTitle: "OK")
        case 1:
            
            if #available(iOS 8.0, *) {
                let defaultAction = UIAlertAction(title: "OK", style: .Cancel, handler: {
                    (action: UIAlertAction) in
                    UIAlertView.showAlertViewWithTitle("ViewController Alert Demo", message: "This is second alert triggled by action.", cancelButtonTitle: "OK")
                })
                showAlertWithTitle("ViewController Alert Demo", message: "This is first alert with action present by alert controller in a view controller, and iOS version is at least 8.0", actions: defaultAction)
            } else {
                showAlertWithTitle("ViewController Alert Demo", message: "This is first alert with completion block present by view controller, and iOS version is below 8.0", completion: {
                    (alert: UIAlertView, buttonIndex: Int) -> Void in
                    UIAlertView.showAlertViewWithTitle("ViewController Alert Demo", message: "This is second alert.", cancelButtonTitle: "OK")
                }, cancelButtonTitle: "OK")
            }
        default:
            break
        }
    }
}

