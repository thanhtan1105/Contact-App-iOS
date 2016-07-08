//
//  UIViewExtension.swift
//  Contact
//
//  Created by Le Thanh Tan on 4/16/16.
//  Copyright © 2016 Le Thanh Tan. All rights reserved.
//

import UIKit

extension UIView {
	class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> UIView? {
		return UINib(
			nibName: nibNamed,
			bundle: bundle
			).instantiateWithOwner(nil, options: nil)[0] as? UIView
	}
	
	class func alertViewComingSoon() {
		let alertView = UIAlertController(title: "Coming Soon", message: "", preferredStyle: .Alert)
		let okButton = UIAlertAction(title: "OK", style: .Default) { (action: UIAlertAction) in
		}
		
		alertView.addAction(okButton)
		
		var topVC = UIApplication.sharedApplication().keyWindow?.rootViewController
		while (topVC!.presentedViewController != nil) {
			topVC = topVC!.presentedViewController
		}
		
		topVC?.presentViewController(alertView, animated: true, completion: nil)
	}
}

extension String {
	func replace(string:String, replacement:String) -> String {
		return self.stringByReplacingOccurrencesOfString(string, withString: replacement, options: NSStringCompareOptions.LiteralSearch, range: nil)
	}
	
	func removeWhitespace() -> String {
		return self.replace(" ", replacement: "")
	}
}