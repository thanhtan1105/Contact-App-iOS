//
//  EmailContactDetailView.swift
//  Contact
//
//  Created by Le Thanh Tan on 4/17/16.
//  Copyright © 2016 Le Thanh Tan. All rights reserved.
//

import UIKit
import MessageUI

protocol EmailContactDetailViewDelegate: class {
	func emailContactDetailView(emailContactDetailView: EmailContactDetailView, presentEmailView emailVC: MFMailComposeViewController)
}

class EmailContactDetailView: UIView, MFMailComposeViewControllerDelegate {

	@IBOutlet weak var emailImage: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	
	weak var delegate : EmailContactDetailViewDelegate!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		let longPress = UILongPressGestureRecognizer(target: self, action: #selector(EmailContactDetailView.handleGestureRecognizer(_:)))
		longPress.minimumPressDuration = 0.1
		self.addGestureRecognizer(longPress)
		
		let singleTap = UITapGestureRecognizer(target: self, action: #selector(EmailContactDetailView.handleGestureRecognizer(_:)))
		self.addGestureRecognizer(singleTap)
	}
	
	func handleGestureRecognizer (gesture: UIGestureRecognizer) {
		func showEmailVC () {
			let emailVC = MFMailComposeViewController()
			emailVC.setSubject("")
			emailVC.setMessageBody("", isHTML: false)
			emailVC.setToRecipients([descriptionLabel.text!])
			emailVC.mailComposeDelegate = self
			delegate.emailContactDetailView(self, presentEmailView: emailVC)
		}
		
		
		if let _ = gesture as? UITapGestureRecognizer {
			// Tap
			// nothing to do
			showEmailVC()
		} else {
			// Long
			if gesture.state == UIGestureRecognizerState.Ended{
				self.backgroundColor = UIColor.clearColor()
				showEmailVC()
			} else if gesture.state == UIGestureRecognizerState.Began {
				self.backgroundColor = UIColor.lightGrayColor()
			}
		}
	}
	
	func mailComposeController(controller: MFMailComposeViewController,
	                           didFinishWithResult result: MFMailComposeResult,
	                                               error: NSError?) {
		controller.dismissViewControllerAnimated(true, completion: nil)
	}
}
