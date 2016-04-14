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
	
	var carrierName: CarrierName = CarrierName.Unidentified {
		didSet {
			dispatch_async(dispatch_get_main_queue(), {
				self.carrierNameLabel.text = "Nhà mạng: \(self.carrierName)"
				self.nameLabel.text = deviceName
			})
		}
	}
	
	var profileImage: UIImage = UIImage() {
		didSet {
			dispatch_async(dispatch_get_main_queue()) { 
				self.avatarImage.image = self.profileImage
			}
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		contactHelper = ContactHelper(contactViewController: self)
		tableView.tableHeaderView = profileView
	}
	
	override func viewWillAppear(animated: Bool) {		
		contactHelper.importContactIfNeeded()
		carrierName = contactHelper.getOwnerCarrierName()
		profileImage = contactHelper.getOwnerProfileImage()
		
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
		cell.delegate = self
		return cell
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let contact = contactsDic[alphabetArr[section]] {
			return contact.count
		}
		return 0
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
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
	
	func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
		return UILocalizedIndexedCollation.currentCollation().sectionTitles
	}
	
	func tableView(tableView: UITableView,
	               sectionForSectionIndexTitle title: String,
								 atIndex index: Int) -> Int {
		return UILocalizedIndexedCollation.currentCollation().sectionForSectionIndexTitleAtIndex(index)
	}
}

// MARK: -  ContactTableViewCellDelegate Method
extension ContactsViewController: ContactTableViewCellDelegate {
	func contactTableViewCell(contactTableViewCell: ContactTableViewCell, didTapCallAction listPhoneNumber: [String], listCarrierName: [CarrierName]) {
		if listPhoneNumber.count == 1 {
			// real
//			if let url = NSURL(string: "tel://\(listPhoneNumber.first!)") {
//				UIApplication.sharedApplication().openURL(url)
//			}

			// test
			let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
			let fastCallingVC = mainStoryboard.instantiateViewControllerWithIdentifier("FastCallingViewController") as! FastCallingViewController
			fastCallingVC.phoneNumberArr = listPhoneNumber
			fastCallingVC.ownerCarrierName = carrierName
			fastCallingVC.carrierNameArr = listCarrierName
			
			self.view.alpha = 0.6
			self.view.backgroundColor = UIColor.blackColor()
			
			self.navigationController?.presentViewController(fastCallingVC, animated: true, completion: {
				fastCallingVC.contactViewController = self
			})
			
		} else {
			let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
			let fastCallingVC = mainStoryboard.instantiateViewControllerWithIdentifier("FastCallingViewController") as! FastCallingViewController
			fastCallingVC.phoneNumberArr = listPhoneNumber
			fastCallingVC.ownerCarrierName = carrierName
			fastCallingVC.carrierNameArr = listCarrierName
			
			self.view.alpha = 0.6
			self.view.backgroundColor = UIColor.blackColor()
			
			self.navigationController?.presentViewController(fastCallingVC, animated: true, completion: {
				fastCallingVC.contactViewController = self
			})
		}
	}
	
	
}


