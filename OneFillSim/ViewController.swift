//
//  ViewController.swift
//  OneFillSim
//
//  Created by RogerZ on 9/08/2016.
//  Copyright © 2016 MaxwellForest. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var contentTextView: UITextView!
    
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
                do {
                    
                    print("Get loginFromOnebank url parameters: \(inputParameters)")
                    
                    
                    //reply data back to URL sender
                    let jsonData = try NSJSONSerialization.dataWithJSONObject(["loginOkay"], options:[])
                    
                    let jsonStr = NSString(data: jsonData, encoding: NSUTF8StringEncoding) as! String
                    success(["reply":jsonStr],false)
                    
                } catch {
                    print("JSON serialization failed: \(error)")
                }
            }
        
        
        })
        
    }

}

