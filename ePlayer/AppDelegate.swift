//
//  AppDelegate.swift
//  ePlayer
//
//  Created by Lynch Wong on 5/1/16.
//  Copyright © 2016 Lynch Wong. All rights reserved.
//

import UIKit
import GCDWebServer

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var webUploader: GCDWebUploader!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        configAppearance()
        configAppSetting()
        
        return true
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
    
    private func configAppearance() {
        if let image = UIImage(named: "navigation_back_icon")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal) {
            // 设置返回按钮图片，不显示按钮标题
            UINavigationBar.appearance().backIndicatorImage = image
            UINavigationBar.appearance().backIndicatorTransitionMaskImage = image
            UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(-2000, 0), forBarMetrics: UIBarMetrics.Default)
            
            //
            UINavigationBar.appearance().translucent = false
            UINavigationBar.appearance().barTintColor = UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 0.8)//UIColor.mainColor()
            UINavigationBar.appearance().tintColor = UIColor.blackColor()//UIColor.whiteColor()
            UINavigationBar.appearance().titleTextAttributes = [
                NSForegroundColorAttributeName: UIColor.blackColor(),
                NSFontAttributeName: UIFont(name: "PingFangSC-Regular", size: 18.0)!
            ]
        }
        
        UITabBar.appearance().translucent = false
        UITabBar.appearance().barTintColor = UIColor.bottomBarBgColor()
    }
    
    private func configAppSetting() {
        MobClick.startWithAppkey("563ec835e0f55a0a7e007087", reportPolicy: BATCH, channelId: "Web")
        
        webUploader = GCDWebUploader(uploadDirectory: FileUtils.documentDirectory)
        webUploader.allowedFileExtensions = [
            "3gp", "3gp", "3gp2", "3gpp", "amv", "asf", "avi",
            "axv", "divx", "dv", "flv", "f4v", "gvi", "gxf",
            "m1v", "m2p", "m2t", "m2ts", "m2v", "m4v", "mks",
            "mkv", "moov", "mov", "mp2v", "mp4", "mpeg", "mpeg1",
            "mpeg2", "mpeg4", "mpg", "mpv", "mt2s", "mts", "mxf",
            "mxg", "nsv", "nuv", "oga", "ogg", "ogm", "ogv", "ogx",
            "spx", "ps", "qt", "rec", "rm", "rmvb", "tod", "ts", "tts",
            "vlc", "vob", "vro", "webm", "wm", "wmv", "wtv", "xesc"
        ]
        webUploader.footer = "简易播放器 1.1.0"
    }

}

