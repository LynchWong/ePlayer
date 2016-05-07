//
//  EPTabBarController.swift
//  ePlayer
//
//  Created by Lynch Wong on 5/1/16.
//  Copyright © 2016 Lynch Wong. All rights reserved.
//

import UIKit

class EPTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Status Bar
    
    override func childViewControllerForStatusBarHidden() -> UIViewController? {
        return selectedViewController
    }
    
    override func childViewControllerForStatusBarStyle() -> UIViewController? {
        return selectedViewController
    }
    
    // MARK: - Device Orientation
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        guard let selectedViewController = selectedViewController else {
            return UIInterfaceOrientation.Portrait
        }
        return selectedViewController.preferredInterfaceOrientationForPresentation()
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        guard let selectedViewController = selectedViewController else {
            return UIInterfaceOrientationMask.Portrait
        }
        return selectedViewController.supportedInterfaceOrientations()
    }
    
    override func shouldAutorotate() -> Bool {
        guard let selectedViewController = selectedViewController else {
            return true
        }
        return selectedViewController.shouldAutorotate()
    }

}
