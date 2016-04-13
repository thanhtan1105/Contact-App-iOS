//
//  ContactsViewController.swift
//  Contact
//
//  Created by Le Thanh Tan on 4/11/16.
//  Copyright © 2016 Le Thanh Tan. All rights reserved.
//

import UIKit
import Contacts

class ContactsViewController: UIViewController {
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var avatarImage: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var phoneNumberLabel: UILabel!
	@IBOutlet weak var profileView: UIView!
	@IBOutlet weak var carrierNameLabel: UILabel!
	
	
	var contactHelper: ContactHelper!
	var contactsDic : [String: [ContactModel]] = [:] {
		didSet {
			self.tableView.reloadData()
		}
	}
	
	var carrierName: String = "" {
		didSet {
			dispatch_async(dispatch_get_main_queue(), {
				self.carrierNameLabel.text = self.carrierName
				self.nameLabel.text = deviceName
			})
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		contactHelper = ContactHelper(contactViewController: self)
		
		tableView.tableHeaderView = profileView
		
	}
	
	override func viewWillAppear(animated: Bool) {		
		contactHelper.importContactIfNeeded()
		carrierName = contactHelper.networkInfo()
	}
	
	override func didReceiveMemoryWarning() {
			super.didReceiveMemoryWarning()
			// Dispose of any resources that can be recreated.
	}
	
	@IBAction func onAddContact(sender: UIBarButtonItem) {
		
	}
	
	// MARK: - Navigation
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
			// Get the new view controller using segue.destinationViewController.
			// Pass the selected object to the new view controller.
	}
}

extension ContactsViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		var cell: ContactTableViewCell! = tableView.dequeueReusableCellWithIdentifier("contactCell") as? ContactTableViewCell
		
		if cell == nil {
			cell = NSBundle.mainBundle().loadNibNamed("ContactTableViewCell", owner: self, options: nil)[0] as! ContactTableViewCell
		}
		cell.configurate(contactsDic[alphabetArr[indexPath.section]]![indexPath.row])
		
		return cell
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let contact = contactsDic[alphabetArr[section]] {
			return contact.count
		}
		return 0
		
	}
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return alphabetArr.count
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 65
	}
	
	func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if contactsDic[alphabetArr[section]] == nil {
			return ""
		}
		
		return alphabetArr[section]
	}
}

// MARK: - Private Method
extension ContactsViewController {
	
}


