//
//  KeypadViewController.swift
//  Contact
//
//  Created by Le Thanh Tan on 6/6/16.
//  Copyright © 2016 Le Thanh Tan. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI
import AddressBookUI

class KeypadViewController: BaseViewController {

	@IBOutlet weak var callButton: UIButton!
	@IBOutlet weak var deleteButton: UIButton!
	@IBOutlet weak var addContactButton: UIButton!
	@IBOutlet weak var numberTextfield: UITextField!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var heightKeyboardConstraint: NSLayoutConstraint!
	@IBOutlet weak var keypadView: UIView!

	var isShowKeyboard: Bool = true
	var contactSearchResult: [CNContact] = [] {
		didSet {
			tableView.hidden = contactSearchResult.count > 0 ? false : true
			tableView.reloadData()
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 70
		tableView.hidden = true
		tableView.registerNib(UINib(nibName: "SearchContactTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchContactCell")

	}

	override func viewWillAppear(animated: Bool) {
		if DeviceHelper.IS_IPHONE_4 {
			heightKeyboardConstraint.constant = 220
		} else if DeviceHelper.IS_IPHONE_6 {
			heightKeyboardConstraint.constant = 258
		} else if DeviceHelper.IS_IPHONE_6P {
			heightKeyboardConstraint.constant = 271
		}
		UIView.animateWithDuration(0.0) {
			self.view.layoutIfNeeded()
		}
	}

	override func viewDidLayoutSubviews() {
		self.navigationController?.setNavigationBarHidden(true, animated: false)
		callButton.imageView?.contentMode = .ScaleAspectFit
		deleteButton.imageView?.contentMode = .ScaleAspectFit
		addContactButton.imageView?.contentMode = .ScaleAspectFit
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	// MARK: - IBAction

	@IBAction func onNumberTapped(sender: UIButton) {
		numberTextfield.text = numberTextfield.text! + sender.currentTitle!
		if numberTextfield.text?.characters.count >= 3 {
			contactSearchResult.removeAll()
			let result = ContactHelper.sharedInstance.searchContactWithNumber(numberTextfield.text!)
			// parse result
			contactSearchResult = parseResultSearch(result)
		}
	}

	@IBAction func onRemoveTapped(sender: UIButton) {
		if numberTextfield.text?.characters.count > 0 {
			numberTextfield.text = String(numberTextfield.text!.characters.dropLast())
			if numberTextfield.text?.characters.count >= 3 {
				contactSearchResult.removeAll()
				let result = ContactHelper.sharedInstance.searchContactWithNumber(numberTextfield.text!)
				// parse result
				contactSearchResult = parseResultSearch(result)
			} else {
				contactSearchResult.removeAll()
			}
		} else {
			numberTextfield.text = ""
		}
	}

	@IBAction func onCallTapped(sender: UIButton) {
		ContactHelper.sharedInstance.callWithNumber(numberTextfield.text!)
	}
	
	@IBAction func onDownKeyboardTapped(sender: UIButton) {
		for constraint in (keypadView.superview?.constraints)! {
			if constraint.identifier == "bottomConstraintKeypad" {
				constraint.constant = isShowKeyboard ? -heightKeyboardConstraint.constant : 0
			}
		}			
		isShowKeyboard = !isShowKeyboard
		UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 10.0, initialSpringVelocity: 0.0, options: [], animations: {
			self.view.layoutIfNeeded()
			}, completion: nil)
	}
	
	@IBAction func onAddContactButton(sender: UIButton) {
		let number = CNLabeledValue(label: CNLabelPhoneNumberMobile,
		                            value: CNPhoneNumber(stringValue: numberTextfield.text!))
		let newContact = CNMutableContact()
		newContact.phoneNumbers = [number]
		ContactHelper.sharedInstance.addContact(newContact, inViewController: self)
	}
}

extension KeypadViewController: UITableViewDelegate, UITableViewDataSource {
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return contactSearchResult.count
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("SearchContactCell") as! SearchContactTableViewCell
		let data = ContactSearchModel(contact: contactSearchResult[indexPath.row])
		cell.contactSearchModel = data
		return cell
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		let cell = tableView.cellForRowAtIndexPath(indexPath) as! SearchContactTableViewCell
		let number = cell.contactSearchModel.phoneNumber
		ContactHelper.sharedInstance.callWithNumber(number)
	}
}

extension KeypadViewController: ContactHelperDelegate {
	func contactHelper(viewController: CNContactViewController, didCompleteWithContact contact: CNContact?) {
		if contact != nil {
			print("Add contact success")
		}
		self.dismissViewControllerAnimated(true, completion: nil)
	}
}


// MARK: - Private function
extension KeypadViewController {
	/**
	Parse from multi phone number in one contact to each phone number in one contact
	
	- parameter contactList: list contact matching search
	
	- returns: orther list contact but each member with only one phone number
	*/
	private func parseResultSearch(contactList: [CNContact]) -> [CNContact] {
		var result: [CNContact] = []
		for contact in contactList {
			for phoneNumber in contact.phoneNumbers {
				let temple = CNMutableContact()
				temple.middleName = contact.middleName
				temple.contactType = CNContactType.Person
				temple.givenName = contact.givenName
				temple.familyName = contact.familyName
				temple.phoneNumbers = [phoneNumber]
				result.append(temple)
			}
		}
		return result
	}
}
