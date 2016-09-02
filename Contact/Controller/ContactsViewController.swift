//
//  ContactsViewController.swift
//  Contact
//
//  Created by Le Thanh Tan on 4/11/16.
//  Copyright © 2016 Le Thanh Tan. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI
import AddressBookUI
import GoogleMobileAds

class ContactsViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var avatarImage: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var phoneNumberLabel: UILabel!
	@IBOutlet weak var profileView: UIView!
	@IBOutlet weak var carrierNameLabel: UILabel!
	@IBOutlet weak var searchView: UIView!
  @IBOutlet weak var bannerAds: GADBannerView!
  
	
	
	var searchController = UISearchController(searchResultsController: nil)
	var filteredTableData = [ContactModel]()
	var contactsDic: [String: [ContactModel]] = [:] {
		didSet {
			dispatch_async(dispatch_get_main_queue()) { 
				self.tableView.reloadData()
			}			
		}
	}

	var carrierName: CarrierName = CarrierName.Unidentified {
		didSet {
			dispatch_async(dispatch_get_main_queue(), {
				self.carrierNameLabel.text = "Nhà mạng: \(self.carrierName.description)"
				self.nameLabel.text = DeviceHelper.deviceName
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
	
		/// if true to allow system import contact again
	var isNeedImportContact: Bool = Bool() {
		didSet {
			if isNeedImportContact {
				ContactHelper.sharedInstance.importContactIfNeeded()
			}
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.tableHeaderView = profileView
    tableView.registerNib(UINib(nibName: "ContactTableViewCell", bundle: nil), forCellReuseIdentifier: "contactCell")
    tableView.registerNib(UINib(nibName: "NativeAdsTableViewCell", bundle: nil), forCellReuseIdentifier: "nativeAdsCell")
    
		ContactHelper.sharedInstance.delegate = self
		isNeedImportContact = true
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
		carrierName = ContactHelper.sharedInstance.getOwnerCarrierName()
		carrierName = CarrierName.Mobifone // test dummy
		profileImage = ContactHelper.sharedInstance.getOwnerProfileImage()
    showBannerAds(bannerAds, myViewController: self) // ads
	}
}

// MARK: - IBAction
extension ContactsViewController {
	@IBAction func onAddContact(sender: UIBarButtonItem) {
		ContactHelper.sharedInstance.addContactWithViewController(self)
	}
}

// MARK: - TableView Delegate
extension ContactsViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(tableView: UITableView,
	               cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//    let cell: NativeAdsTableViewCell = tableView.dequeueReusableCellWithIdentifier("nativeAdsCell") as! NativeAdsTableViewCell
//    cell.configureAds(self)
    
		let cell: ContactTableViewCell! =
			tableView.dequeueReusableCellWithIdentifier("contactCell") as? ContactTableViewCell

		// filter mode is on
		if searchController.active && searchController.searchBar.text != "" {
			cell.contactModel = filteredTableData[indexPath.row]

		} else {
			// normal mode is on
			cell.contactModel = contactsDic[alphabetArr[indexPath.section]]![indexPath.row]
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
		return 60
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

// MARK: -  ContactTableViewCell Delegate
extension ContactsViewController: ContactTableViewCellDelegate {
	
	func contactTableViewCell(contactTableViewCell: ContactTableViewCell, didTapCallAction contactModel: ContactModel) {
		
		if contactModel.phoneNumbers?.count == 1 {
			// real
			if let url = NSURL(string: "tel://\(contactModel.phoneNumbers?.first)") {
				UIApplication.sharedApplication().openURL(url)
				return
			}
		} else {
			let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
			let fastCallingVC = mainStoryboard.instantiateViewControllerWithIdentifier("FastCallingViewController") as! FastCallingViewController
			fastCallingVC.contactModel = contactModel
			fastCallingVC.ownerCarrierName = carrierName

			self.view.alpha = 0.6
			self.view.backgroundColor = UIColor.blackColor()

			self.navigationController?.presentViewController(fastCallingVC, animated: true, completion: {
				fastCallingVC.contactViewController = self
			})
		}
	}
}

// MARK: - Search Delegate
extension ContactsViewController: UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate {
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

// MARK: - Contact Helper Delegate
extension ContactsViewController: ContactHelperDelegate {
	func contactHelper(contactHelper: ContactHelper,
	                   didFinishImportContact contactsDic: [String : [ContactModel]]) {
		self.contactsDic.removeAll()
		self.contactsDic = contactsDic
	}
	
	func contactHelper(viewController: CNContactViewController, didCompleteWithContact contact: CNContact?) {
		if contact != nil {
			print("Add contact success")
			self.isNeedImportContact = true
		}
		self.dismissViewControllerAnimated(true, completion: nil)
	}
}
