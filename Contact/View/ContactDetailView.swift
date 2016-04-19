//
//  ContactDetailView.swift
//  Contact
//
//  Created by Le Thanh Tan on 4/16/16.
//  Copyright © 2016 Le Thanh Tan. All rights reserved.
//

import UIKit
import MessageUI

protocol ContactDetailViewDelegate: class {
	func contactDetailView (contactDetailView: ContactDetailView, presentMessageView messageVC: MFMessageComposeViewController)
}

class ContactDetailView: UIView, MFMessageComposeViewControllerDelegate {

	@IBOutlet weak var iconImage: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var callNowButton: UIButton!
	@IBOutlet weak var sendMessageButton: UIButton!
	@IBOutlet weak var bigActionButtonStackView: UIStackView!
	@IBOutlet weak var smallActionButtonStackView: UIStackView!
	@IBOutlet weak var smallCallNowButton: UIButton!
	@IBOutlet weak var smallMessageButton: UIButton!
	
	weak var delegate : ContactDetailViewDelegate!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		callNowButton.layer.cornerRadius = 5
		callNowButton.clipsToBounds = true
		sendMessageButton.layer.cornerRadius = 5
		sendMessageButton.clipsToBounds = true
		self.clipsToBounds = true
		
		// create Gesture Recognizer
//		let singleTap = UITapGestureRecognizer(target: self, action: #selector(ContactDetailView.handleGestureRecognizer(_:)))
//		self.addGestureRecognizer(singleTap)
//		
//		let longTap = UILongPressGestureRecognizer(target: self, action: #selector(ContactDetailView.handleGestureRecognizer(_:)))
//		longTap.minimumPressDuration = 0.1
//		self.addGestureRecognizer(longTap)
	}
	
//	func handleGestureRecognizer(gesture: UIGestureRecognizer) {
//		if let _ = gesture as? UITapGestureRecognizer {
//			callWithNumber(descriptionLabel.text!)
//			
//		} else {
//			if gesture.state == .Began {
//				self.backgroundColor = UIColor.lightGrayColor()
//				
//			} else if gesture.state == .Cancelled {
//				self.backgroundColor = UIColor.lightGrayColor()
//				
//			} else if gesture.state == .Ended {
//				self.backgroundColor = UIColor.clearColor()
//				callWithNumber(descriptionLabel.text!)
//				
//			}
//		}
//	}

	func callWithNumber(number: String) {
		let callNumber = number.stringByReplacingOccurrencesOfString(" ", withString: "")
		if let url = NSURL(string: "tel://\(callNumber)") {
			UIApplication.sharedApplication().openURL(url)
		}
	}
	
	@IBAction func onCallButtonTouchUpInside(sender: UIButton) {
		callWithNumber(descriptionLabel.text!)
	}
	
	@IBAction func onSendMessageTouchUpInside(sender: UIButton) {
		let messageVC = MFMessageComposeViewController()
		messageVC.body = "";
		messageVC.recipients = [descriptionLabel.text!]
		messageVC.messageComposeDelegate = self;
		delegate.contactDetailView(self, presentMessageView: messageVC)
	}
	
	func messageComposeViewController(controller: MFMessageComposeViewController,
	                                  didFinishWithResult result: MessageComposeResult) {
		controller.dismissViewControllerAnimated(true, completion: nil)
	}
}

