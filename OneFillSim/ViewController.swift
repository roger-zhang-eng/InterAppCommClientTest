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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.contentTextView.delegate = self
        self.contentTextView.text = "SourceApp: " + sourceAppName + "URL: " + originalURLtext
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
    

}

