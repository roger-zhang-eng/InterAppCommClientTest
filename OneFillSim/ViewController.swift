//
//  ViewController.swift
//  OneFillSim
//
//  Created by RogerZ on 9/08/2016.
//  Copyright © 2016 MaxwellForest. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var contentTextView: UITextView!
    
    var userDataJSON: JSON?
    
    var inputText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.contentTextView.delegate = self
        self.contentTextView.text = "SourceApp: " + sourceAppName + "URL: " + originalURLtext
        
        addAPIHandlers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btn1Clicked(sender: UIButton) {
    }
    
    
    @IBAction func btn2Clicked(sender: UIButton) {
    }
    
    @IBAction func btn3Clicked(sender: UIButton) {
    }
    
    //Hook the treatment for different URL scheme request.
    func addAPIHandlers() {
        IACManager.sharedManager().handleAction("loginFromOnebank", withBlock: { inputParameters, success, failure in
        
            if success != nil {
                    
                    //var userData : JSON = inputParameters["userData"]! as AnyObject
                    print("Get loginFromOnebank url parameters: \(inputParameters)")
                    
                    let userDataString = inputParameters["userData"] as! String
                    
                    if let userDataDictionary = self.convertStringToDictionary(userDataString) {
                        self.userDataJSON = JSON(userDataDictionary)
                        let userName = self.userDataJSON!["user"]["profile"]["first_name"]
                        print("\(userName.string) send message from Onebank")
                    }
                
                    //reply data back to URL sender
                    /*let jsonData = try NSJSONSerialization.dataWithJSONObject(["loginOkay"], options:[])
                    
                    let jsonStr = NSString(data: jsonData, encoding: NSUTF8StringEncoding) as! String
                    success(["reply":jsonStr],false)*/
                    

            }
        
        
        })
        
    }
    
    //construct JSON string to dictionary
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
        //data(using: String.Encoding.utf8) {
            do {
                return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String:AnyObject]
                    
                    //JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print("Convert String to Dictionary Error: \(error.localizedDescription)")
            }
        }
        return nil
    }

}

