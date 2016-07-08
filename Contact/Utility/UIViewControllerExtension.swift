//
//  UIViewControllerExtension.swift
//  Contact
//
//  Created by Le Thanh Tan on 6/11/16.
//  Copyright © 2016 Le Thanh Tan. All rights reserved.
//

import UIKit

extension UIViewController {
	class func topViewController() -> UIViewController {
		var topVC = UIApplication.sharedApplication().keyWindow?.rootViewController
		while (topVC!.presentedViewController != nil) {
			topVC = topVC!.presentedViewController
		}
		return topVC!
	}
}

