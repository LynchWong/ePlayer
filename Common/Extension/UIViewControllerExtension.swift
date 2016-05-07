//
//  UIViewControllerExtension.swift
//  ePlayer
//
//  Created by Lynch Wong on 5/2/16.
//  Copyright © 2016 Lynch Wong. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    static func initializeViewControllerWith<T: UIViewController>(
        storyboardName: String,
        storyboardId: String,
        controllerType: T.Type,
        bundle: NSBundle? = nil
        ) -> T {
        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
        let viewController = storyboard.instantiateViewControllerWithIdentifier(storyboardId) as! T
        return viewController
    }
    
}