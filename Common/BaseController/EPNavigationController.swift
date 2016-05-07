//
//  EPNavigationController.swift
//  ePlayer
//
//  Created by Lynch Wong on 5/1/16.
//  Copyright © 2016 Lynch Wong. All rights reserved.
//

import UIKit

class EPNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Status Bar
    
    override func childViewControllerForStatusBarStyle() -> UIViewController? {
        return topViewController
    }
    
    override func childViewControllerForStatusBarHidden() -> UIViewController? {
        return topViewController
    }
    
    // MARK: - Device Orientation
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        guard let topViewController = topViewController else {
            return UIInterfaceOrientation.Portrait
        }
        return topViewController.preferredInterfaceOrientationForPresentation()
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        guard let topViewController = topViewController else {
            return UIInterfaceOrientationMask.Portrait
        }
        return topViewController.supportedInterfaceOrientations()
    }
    
    override func shouldAutorotate() -> Bool {
        guard let topViewController = topViewController else {
            return true
        }
        return topViewController.shouldAutorotate()
    }

}
