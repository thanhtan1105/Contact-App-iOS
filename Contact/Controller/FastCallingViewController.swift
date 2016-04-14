//
//  FastCallingViewController.swift
//  Contact
//
//  Created by Le Thanh Tan on 4/13/16.
//  Copyright © 2016 Le Thanh Tan. All rights reserved.
//

import UIKit


class FastCallingViewController: UIViewController, UIViewControllerTransitioningDelegate {
	// constant
	let heightCell: CGFloat = 50.0
	let maxHeightTableViewCell : CGFloat = 50.0 * 5
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var cancelButton: UIButton!
	
	@IBOutlet weak var heightTableViewConstraint: NSLayoutConstraint!
	weak var contactViewController: ContactsViewController!
	var phoneNumberArr : [String] = []
	var carrierNameArr: [CarrierName]?
	var ownerCarrierName: CarrierName?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func viewDidLayoutSubviews() {
		if CGFloat(phoneNumberArr.count) * heightCell > maxHeightTableViewCell {
			heightTableViewConstraint.constant = maxHeightTableViewCell
			tableView.scrollEnabled = true
		} else {
			heightTableViewConstraint.constant = CGFloat(phoneNumberArr.count) * heightCell
			tableView.scrollEnabled = false
		}
		self.tableView.layoutIfNeeded()
	}
	
	@IBAction func onCancelTouchUpInside(sender: UIButton) {
		self.contactViewController.view.alpha = 1.0
		self.contactViewController.view.backgroundColor = UIColor.whiteColor()
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)!
		modalPresentationStyle = .Custom
		transitioningDelegate = self
	}


	/*
	// MARK: - Navigation

	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
			// Get the new view controller using segue.destinationViewController.
			// Pass the selected object to the new view controller.
	}
	*/
}

extension FastCallingViewController: UITableViewDataSource, UITableViewDelegate {
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("fastCallingCell") as! FastCallingTableViewCell
		
		let isSameCarrier = carrierNameArr![indexPath.row] == ownerCarrierName ? true : false
		cell.configure(phoneNumberArr[indexPath.row], isSameCarrier: isSameCarrier)
		return cell
	}
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return phoneNumberArr.count
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return heightCell
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		if let url = NSURL(string: "tel://\(phoneNumberArr[indexPath.row])") {
			UIApplication.sharedApplication().openURL(url)
		}
		
		
	}
}
