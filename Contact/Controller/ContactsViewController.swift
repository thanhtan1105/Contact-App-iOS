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
	var searchController = UISearchController(searchResultsController: nil)
	var filteredTableData = [ContactModel]()
	@IBOutlet weak var searchView: UIView!
	
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
		tableView.delegate = self
		tableView.dataSource = self
		contactHelper = ContactHelper(contactViewController: self)
		tableView.tableHeaderView = profileView
		
		searchController = ({
			// Setup the Search Controller
			let controller = UISearchController(searchResultsController: nil)
			controller.searchResultsUpdater = self
			controller.searchBar.delegate = self
			definesPresentationContext = true
			controller.dimsBackgroundDuringPresentation = false
			controller.searchBar.barTintColor = UIColor.appColor.primaryColor
			controller.searchBar.tintColor = UIColor.whiteColor()
			let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap))
			tapGesture.cancelsTouchesInView = false
			self.view.addGestureRecognizer(tapGesture)
			searchView.addSubview(controller.searchBar)
			return controller
		})()

	}
	
	func handleSingleTap() {
		searchController.searchBar.endEditing(true)
	}
	
	override func viewWillAppear(animated: Bool) {
//		self.navigationController?.setNavigationBarHidden(false, animated: false)
		
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
		var cell: ContactTableViewCell! =
			tableView.dequeueReusableCellWithIdentifier("contactCell") as? ContactTableViewCell
		
		if cell == nil {
			cell = NSBundle.mainBundle().loadNibNamed("ContactTableViewCell",
			                                          owner: self,
			                                          options: nil)[0] as! ContactTableViewCell
			
		}
		
		// filter mode is on
		if searchController.active && searchController.searchBar.text != "" {
			cell.configurate(filteredTableData[indexPath.row])
			
		} else {
			cell.configurate(contactsDic[alphabetArr[indexPath.section]]![indexPath.row])
		}
		
		
		cell.delegate = self
		return cell
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// filter mode is on
		if searchController.active && searchController.searchBar.text != "" {
			return filteredTableData.count
			
		} else if let contact = contactsDic[alphabetArr[section]] {
			return contact.count
		}
		return 0
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		let cell = tableView.cellForRowAtIndexPath(indexPath) as! ContactTableViewCell
		let storyBoard = UIStoryboard(name: "Main", bundle: nil)
		let detailContactVC =
			storyBoard.instantiateViewControllerWithIdentifier("DetailContactViewController")
			as! DetailContactViewController
		detailContactVC.carrierOwnerName = carrierName
		detailContactVC.contactModel = cell.contactModel
		self.navigationController?.presentViewController(detailContactVC, animated: true, completion: nil)
		
	}
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		// filter mode is on
		if searchController.active && searchController.searchBar.text != "" {
			return 1
		}
		
		return alphabetArr.count
	}
	
	func tableView(tableView: UITableView,
	               heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		// filter mode is on
		if searchController.active && searchController.searchBar.text != "" {
			return 65
			
		} else if contactsDic[alphabetArr[indexPath.section]] != nil {
			return 65
		}
		
		return 0
	}
	
	func tableView(tableView: UITableView,
	               titleForHeaderInSection section: Int) -> String? {
		// filter mode is on
		if searchController.active && searchController.searchBar.text != "" {
			return "Kết quả gần đúng"
			
		} else if contactsDic[alphabetArr[section]] == nil {
			return ""
		}
		
		return alphabetArr[section]
	}
	
	func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
		// filter mode is on
		if searchController.active && searchController.searchBar.text != "" {
			return [""]
		}
		
		return UILocalizedIndexedCollation.currentCollation().sectionTitles
	}
	
	func tableView(tableView: UITableView,
	               sectionForSectionIndexTitle title: String,
								 atIndex index: Int) -> Int {
		// filter mode is on
		if searchController.active && searchController.searchBar.text != "" {
			return 0
		}
		
		return UILocalizedIndexedCollation.currentCollation().sectionForSectionIndexTitleAtIndex(index)
	}
}

// MARK: -  ContactTableViewCellDelegate Method
extension ContactsViewController: ContactTableViewCellDelegate {
	func contactTableViewCell(contactTableViewCell: ContactTableViewCell,
	                          didTapCallAction listPhoneNumber: [String],
	                                           listCarrierName: [CarrierName]) {
		
		if listPhoneNumber.count == 1 {
			// real
//			if let url = NSURL(string: "tel://\(listPhoneNumber.first!)") {
//				UIApplication.sharedApplication().openURL(url)
//			}
			
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

extension ContactsViewController : UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate {
	func updateSearchResultsForSearchController(searchController: UISearchController) {
		// filter mode is on
		if searchController.searchBar.text?.characters.count == 0 {
			self.view.alpha = 0.7
			
		} else {
			self.view.alpha = 1.0
		}


		filterContentForSearchText(searchController.searchBar.text!)
	}
	
	func filterContentForSearchText(searchText: String) {
		filteredTableData.removeAll()
		for i in Array(contactsDic.keys) {
			let contentDataDic = contactsDic[i]! as [ContactModel]
			for contactModel in contentDataDic {
				let familyName = contactModel.familyName?.uppercaseString
				let giveName = contactModel.givenName?.uppercaseString
				let middleName = contactModel.middleName?.uppercaseString
				let jobName = contactModel.jobName?.uppercaseString
				
				if ((familyName?.rangeOfString(searchText.uppercaseString)) != nil ||
					(giveName?.rangeOfString(searchText.uppercaseString)) != nil ||
					(middleName?.rangeOfString(searchText.uppercaseString)) != nil ||
					(jobName?.rangeOfString(searchText.uppercaseString)) != nil ) {
					filteredTableData.append(contactModel)
				}
			}
		}
		
		tableView.reloadData()
		
	}
	
	func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
		print("searchBarTextDidBeginEditing")
		self.view.alpha = 0.7
	}
	
	func searchBarCancelButtonClicked(searchBar: UISearchBar) {
		self.searchController.active = false
		self.view.alpha = 1.0
	}
}





