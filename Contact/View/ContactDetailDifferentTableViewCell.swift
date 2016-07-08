//
//  ContactDetailDifferentTableViewCell.swift
//  Contact
//
//  Created by Le Thanh Tan on 6/6/16.
//  Copyright © 2016 Le Thanh Tan. All rights reserved.
//

import UIKit
import MessageUI

protocol ContactDetailDifferentTableViewCellDelegate: class {

}

class ContactDetailDifferentTableViewCell: UITableViewCell, ContactDetailNeededFunction {

	@IBOutlet weak var carrierName: UILabel!
	@IBOutlet weak var phoneNumber: UILabel!
	@IBOutlet weak var callNowButton: UIButton!
	@IBOutlet weak var sendMessageButton: UIButton!

	var contactDetailModel: ContactDetailModel! {
		didSet {
			// layout on DIFFERENT VIEW
			carrierName.text = contactDetailModel.carrierName == CarrierName.Unidentified ? "" : "\(contactDetailModel.carrierName.description)"
			phoneNumber.text = contactDetailModel.phoneNumber
		}
	}

	weak var delegate: ContactDetailDifferentTableViewCellDelegate!

	override func awakeFromNib() {
		super.awakeFromNib()
		layout()
	}

	override func setSelected(selected: Bool, animated: Bool) {
			super.setSelected(selected, animated: animated)

			// Configure the view for the selected state
	}

	// Mark: - IBAction
	@IBAction func onCallNowTapped(sender: UIButton) {
		callWithNumber(contactDetailModel.phoneNumber)
	}

	@IBAction func onMessageTapped(sender: UIButton) {
		let messageVC = MFMessageComposeViewController()
		messageVC.body = ""
		messageVC.recipients = [contactDetailModel.phoneNumber]
		messageVC.messageComposeDelegate = self
		UIViewController.topViewController().presentViewController(messageVC,
		                                                           animated: true,
		                                                           completion: nil)

	}

	// Mark: - Function from protocol
	func layout() {
		callNowButton.imageView?.contentMode = .ScaleAspectFit
		sendMessageButton.imageView?.contentMode = .ScaleAspectFit
	}
}

// Mark: - Business Function
extension ContactDetailDifferentTableViewCell: MFMessageComposeViewControllerDelegate {

	@objc internal func messageComposeViewController(controller: MFMessageComposeViewController,
	                                                 didFinishWithResult result: MessageComposeResult) {
		controller.dismissViewControllerAnimated(true, completion: nil)
	}

	private func callWithNumber(number: String) {
		let callNumber = number.stringByReplacingOccurrencesOfString(" ", withString: "")
		ContactHelper.sharedInstance.callWithNumber(callNumber)
	}
}
