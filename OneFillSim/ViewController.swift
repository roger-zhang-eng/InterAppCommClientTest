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
    
    @IBOutlet weak var indication: UILabel!
    @IBOutlet weak var authenButton: UIButton!
    @IBOutlet weak var shoppingButton: UIButton!
    
    //Onebank App instance
    let clientApp = OnebankClient()
    
    //var userDataJSON: JSON?
    var authentication = false
    var userLoginData: UserLoginInfo?
    //timer for login session valid time
    var timer = NSTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.contentTextView.delegate = self
        self.contentTextView.text = "SourceApp: " + sourceAppName + "URL: " + originalURLtext
        
        //Set InterAppComm handler
        addAPIHandlers()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(refresh), name: UIApplicationWillEnterForegroundNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        if !authentication {
            self.authenClicked(self.authenButton)
        }
    }

    @IBAction func authenClicked(sender: UIButton) {
        guard !self.authentication else {
            print("user session is valid, do nothing!")
            return
        }
        
        print("Launch Onebank to relogin")
        if launchOnebank() {
            if self.authentication {
            self.timer = NSTimer.scheduledTimerWithTimeInterval(loginValidTime, target: self, selector: #selector(timerAction), userInfo: nil, repeats: false)
            }
        } else {
            //Alert to install OneFill
            let alert = UIAlertController(title: "Reminder", message: "OneFill need be installed now.", preferredStyle: UIAlertControllerStyle.ActionSheet)
            let confirm = UIAlertAction(title: "Install", style: UIAlertActionStyle.Default) { (action: UIAlertAction) -> Void in
                print("Launch Apple Store to install Onebank.")
            }
            let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
            alert.addAction(confirm)
            alert.addAction(cancel)
            presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    
    @IBAction func shoppingClicked(sender: UIButton) {
        print("User want to shopping!")
        self.indication.text = "User is going to shopping..."
    }
    
    @IBAction func btn3Clicked(sender: UIButton) {
    }
    
    func launchOnebank() -> Bool {
        if clientApp.isAppInstalled() {
            print("Onebank is installed!")
            if userLoginData == nil {
                print("user login data is empty, send message to Onebank...!")
                clientApp.pushLoginInformation(nil)
                return true
            } else {
                print("Onefill: send message to Onebank...")
                clientApp.pushLoginInformation(userLoginData!)
                return true
            }
        } else {
            print("Onebank need installed first!")
            return false
        }
    }
    
    func displayOnebankMessage(data: JSON) {
        dispatch_async(dispatch_get_main_queue(), {
            self.contentTextView.text = data.description
        })
    }
    
    func refresh() {
        print("Onefill App come back foreground, need refresh.")
        self.displayIndication()
    }
    
    func displayIndication() {
        dispatch_async(dispatch_get_main_queue(), {
            if(self.authentication) {
                self.indication.text = "User session valid"
                self.shoppingButton.enabled = true
            } else {
                self.indication.text = "User session expired"
                self.shoppingButton.enabled = false
            }
            self.indication.hidden = false
        })
    }
    
    func setupUserInfo(data: JSON) {
        let userProfileJSON = data["user"]["profile"]
        let firstName = userProfileJSON["first_name"]
        let lastName = userProfileJSON["last_name"]
        let email = userProfileJSON["email"]

        let profile = UserProfile(firstName: firstName.string!, lastName: lastName.string!, email: email.string!)
        
        let userID = data["user"]["id"]
        let userInfo = UserInfo(id: userID.string!, profile: profile, accounts: [:], addresses: [:])
        
        let userToken = data["token"]
        self.userLoginData = UserLoginInfo(token: userToken.string!, user: userInfo)
        self.authentication = true
        
        //Set timer for relogin, maximum 10mins, otherwise app will be stopped by iOS
        //Other solution: Timer need be set under background task
        self.timer = NSTimer.scheduledTimerWithTimeInterval(loginValidTime, target: self, selector: #selector(timerAction), userInfo: nil, repeats: false)
    }
    
    func timerAction() {
        print("User login session is expired!")
        self.authentication = false
        self.displayIndication()
    }
    
    //Hook the treatment for different URL scheme request.
    func addAPIHandlers() {
        IACManager.sharedManager().handleAction("loginFromOnebank", withBlock: { inputParameters, success, failure in
        
            if success != nil {
                    //print("Get loginFromOnebank url parameters: \(inputParameters)")
                    
                    let userDataString = inputParameters["userData"] as! String
                    
                    if let userDataDictionary = self.convertStringToDictionary(userDataString) {
                        let userDataJSON = JSON(userDataDictionary)
                        let userName = userDataJSON["user"]["profile"]["first_name"]
                        print("\(userName.string!) send message from Onebank")
                    
                        self.displayOnebankMessage(userDataJSON)
                        self.displayIndication()
                        self.setupUserInfo(userDataJSON)
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

