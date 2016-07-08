//
//  ContactDetailView.swift
//  Contact
//
//  Created by Le Thanh Tan on 4/16/16.
//  Copyright © 2016 Le Thanh Tan. All rights reserved.
//

import UIKit
import MessageUI

protocol ContactDetailTableViewCellDelegate: class {

}

protocol ContactDetailNeededFunction {
	func layout()
}

class ContactDetailSameTableViewCell: UITableViewCell, ContactDetailNeededFunction, ContactDetailCellProtocol {

	// MARK: Layout variable
	// ON SAME VIEW
	@IBOutlet weak var carrierName: UILabel!
	@IBOutlet weak var phoneNumber: UILabel!
	@IBOutlet weak var sendMessageButton: UIButton!
	@IBOutlet weak var callNowButton: UIButton!

	// ON DIFFERENT VIEW

	// MARK: ContactModel
	var contactDetailModel: ContactDetailModel! {
		didSet {
			// layout on SAME VIEW
			carrierName.text = contactDetailModel.carrierName == CarrierName.Unidentified ? "" : "\(contactDetailModel.carrierName.description)"
			phoneNumber.text = contactDetailModel.phoneNumber
		}
	}

	// MARK: Delegate
	weak var delegate: ContactDetailTableViewCellDelegate!
	
	// MARK: Layout Function
	override func awakeFromNib() {
		super.awakeFromNib()
		layout()
	}

	// Mark: IBAction Function
	@IBAction func onCallButtonTouchUpInside(sender: UIButton) {
		callWithNumber(contactDetailModel.phoneNumber)
	}

	@IBAction func onSendMessageTouchUpInside(sender: UIButton) {
		let messageVC = MFMessageComposeViewController()
		messageVC.body = ""
		messageVC.recipients = [contactDetailModel.phoneNumber]
		messageVC.messageComposeDelegate = self
		UIViewController.topViewController().presentViewController(messageVC,
		                                                           animated: true,
		                                                           completion: nil)
	}

	func layout() {
		callNowButton.backgroundColor = UIColor.whiteColor()
		callNowButton.layer.cornerRadius = 15
		callNowButton.imageView?.contentMode = .ScaleAspectFit
		callNowButton.layer.borderColor = UIColor(hex: 0x4BC2EC).CGColor
		callNowButton.layer.borderWidth = 1.5

		sendMessageButton.backgroundColor = UIColor.whiteColor()
		sendMessageButton.layer.cornerRadius = 15
		sendMessageButton.imageView?.contentMode = .ScaleAspectFit
		sendMessageButton.layer.borderColor = UIColor(hex: 0x4BC2EC).CGColor
		sendMessageButton.layer.borderWidth = 1.5
	}
}

// Mark: - Business Function
extension ContactDetailSameTableViewCell: MFMessageComposeViewControllerDelegate {

	@objc internal func messageComposeViewController(controller: MFMessageComposeViewController,
	                                  didFinishWithResult result: MessageComposeResult) {
		controller.dismissViewControllerAnimated(true, completion: nil)
	}
}
