//
//  FastCallingViewController.swift
//  Contact
//
//  Created by Le Thanh Tan on 4/13/16.
//  Copyright © 2016 Le Thanh Tan. All rights reserved.
//

import UIKit


class FastCallingViewController: BaseViewController, UIViewControllerTransitioningDelegate {
	// constant
	let heightCell: CGFloat = 50.0
	let maxHeightTableViewCell : CGFloat = 50.0 * 5
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var cancelButton: UIButton!
	@IBOutlet weak var fastCallLabel: UILabel!
	@IBOutlet weak var heightTableViewConstraint: NSLayoutConstraint!
	
	weak var contactViewController: ContactsViewController!
	var contactModel: ContactModel!
	var ownerCarrierName: CarrierName!

	override func viewDidLoad() {
		super.viewDidLoad()
		let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap))
		self.view.addGestureRecognizer(singleTap)
		
		// Fast calling
		fastCallLabel.text = "Gọi nhanh cho " + "\(contactModel.givenName!) \(contactModel.familyName!)"
	}
	
	func handleSingleTap() {
		self.contactViewController.view.alpha = 1.0
		self.contactViewController.view.backgroundColor = UIColor.whiteColor()
		self.dismissViewControllerAnimated(true, completion: nil)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func viewDidLayoutSubviews() {
		if CGFloat((contactModel?.phoneNumbers!.count)!) * heightCell > maxHeightTableViewCell {
			heightTableViewConstraint.constant = maxHeightTableViewCell
			tableView.scrollEnabled = true
		} else {
			heightTableViewConstraint.constant = CGFloat(contactModel!.phoneNumbers!.count) * heightCell
			tableView.scrollEnabled = false
		}
		self.tableView.layoutIfNeeded()
	}
	
	@IBAction private func onCancelTouchUpInside(sender: UIButton) {
		self.contactViewController.view.alpha = 1.0
		self.contactViewController.view.backgroundColor = UIColor.whiteColor()
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)!
		modalPresentationStyle = .Custom
		transitioningDelegate = self
	}
}

extension FastCallingViewController: UITableViewDataSource, UITableViewDelegate {
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("fastCallingCell") as! FastCallingTableViewCell
		
		let isSameCarrier = contactModel?.carrierName![indexPath.row] == ownerCarrierName ? true : false
		cell.configure(contactModel!.phoneNumbers![indexPath.row], isSameCarrier: isSameCarrier)
		return cell
	}
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return contactModel!.phoneNumbers!.count
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return heightCell
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		ContactHelper.sharedInstance.callWithNumber(contactModel!.phoneNumbers![indexPath.row])
	}
}
