//
//  AppDelegate.swift
//  OneFillSim
//
//  Created by RogerZ on 9/08/2016.
//  Copyright © 2016 MaxwellForest. All rights reserved.
//

import UIKit


let loginValidTime: NSTimeInterval = 10.0 //login session valid time 10s
let clientURLSchemeText = "maxwellforestonebank"
let urlSchemeText = "maxwellforestonefill"
var isiPad = true

//For debug
var sourceAppName: String = "NA"
var originalURLtext: String = "Waiting for coming..."

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        //Register url scheme in library
        IACManager.sharedManager().callbackURLScheme = urlSchemeText
        
        if(UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone) {
            isiPad = false
            print("This is iPhone")
        } else {
            print("This is iPad")
        }
        
        return true
    }
    
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        //print("In OneFillSim: \(sourceApplication), url: \(url.absoluteString)")
        //Handle the url input information
        return IACManager.sharedManager().handleOpenURL(url)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

