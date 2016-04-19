//
//  DetailViewController.swift
//  Contact
//
//  Created by Le Thanh Tan on 4/16/16.
//  Copyright © 2016 Le Thanh Tan. All rights reserved.
//

import UIKit
import MessageUI

class DetailContactViewController: UIViewController {
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var buttonClose: UIButton!
	
	var contactModel: ContactModel!
	var carrierOwnerName: CarrierName!
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.layer.cornerRadius = 12
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 70
		tableView.allowsSelection = false
	}
	
	override func viewDidLayoutSubviews() {
		buttonClose.backgroundColor = UIColor.whiteColor()
		buttonClose.layer.cornerRadius = buttonClose.frame.size.width / 2
		buttonClose.layer.masksToBounds = false
		
		buttonClose.layer.shadowColor = UIColor.blackColor().CGColor
		buttonClose.layer.shadowOpacity = 0.5
		buttonClose.layer.shadowRadius = 5
		buttonClose.layer.shadowOffset = CGSizeMake(1.0, 1.0)
		
		// top, left, bottom, right
		buttonClose.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10.0)
	}
	
	@IBAction func onCloseButtonTouchUpInside(sender: UIButton) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
}

extension DetailContactViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		// profile Cell
		if indexPath.row == 0 {
			let cell = tableView.dequeueReusableCellWithIdentifier("profileDetailCell") as! ProfileDetailTableViewCell
			cell.configure(contactModel, carrierOwnerName: carrierOwnerName)
			cell.delegate = self
			return cell
		}
		return UITableViewCell()
	}
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
}

extension DetailContactViewController : ProfileDetailTableViewCellDelegate {
	func profileDetailTableViewCell(profileDetailTableViewCell: ProfileDetailTableViewCell, didShowMessageViewController messageVC: MFMessageComposeViewController) {
		self.presentViewController(messageVC, animated: true, completion: nil)		
	}
	
	func profileDetailTableViewCell(profileDetailTableViewCell: ProfileDetailTableViewCell, didShowEmailViewController emailVC: MFMailComposeViewController) {
		self.presentViewController(emailVC, animated: true, completion: nil)
	}
}


