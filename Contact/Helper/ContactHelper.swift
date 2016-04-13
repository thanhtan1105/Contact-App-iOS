//
//  ContactHelper.swift
//  Contact
//
//  Created by Le Thanh Tan on 4/12/16.
//  Copyright © 2016 Le Thanh Tan. All rights reserved.
//

import UIKit
import Contacts
import CoreTelephony

class ContactHelper {
	var contacts: [ContactModel] = []
	var contactsDic = Dictionary<String, [ContactModel]>()
	
	private var validContacts: [CNContact] = []
	private let contactStore = CNContactStore()
	
	weak var contactVC: ContactsViewController!
	
	init(contactViewController: ContactsViewController) {
		contactVC = contactViewController
	}
	
	
	
	// MARK: - Public Method
	func networkInfo() -> String {
		let networkInfo = CTTelephonyNetworkInfo()
		let carrier = networkInfo.subscriberCellularProvider
		if let carrierName = carrier?.carrierName {
			print(carrierName)
			return carrierName
		}
		return ""
	}
	
	func importContactIfNeeded() {
		networkInfo()
		if validContacts.count > 0 {
			return
		}
		
		contactStore.requestAccessForEntityType(.Contacts) { (granted: Bool, error: NSError?) in
			if (granted) {
				do {
					// Specify the key fields that you want to be fetched.
					let keys = [
						CNContactGivenNameKey,	// done
						CNContactMiddleNameKey, // done
						CNContactFamilyNameKey, // done
						CNContactEmailAddressesKey, // done
						CNContactPhoneNumbersKey, // done
						CNContactImageDataKey, // done
						CNContactThumbnailImageDataKey, // done
						CNContactSocialProfilesKey,
						CNSocialProfileURLStringKey,
						CNContactJobTitleKey, // done
						CNContactBirthdayKey,
						CNContactOrganizationNameKey // done
					]
					
					let containerId = self.contactStore.defaultContainerIdentifier()
					let predicate = CNContact.predicateForContactsInContainerWithIdentifier(containerId)
					self.validContacts  = try self.contactStore.unifiedContactsMatchingPredicate(predicate, keysToFetch: keys)
					self.importContact()
				} catch let error as NSError {
					print("error fetching contacts \(error)")
				}
			}
		}
	}
	
	
	// MARK: - Private Method
	private func importContact() {
		// Loop through contatcs
		for contact in validContacts {
			var phoneNumbers: [String] = []
			for phoneNumber in contact.phoneNumbers {
				let value = phoneNumber.value as! CNPhoneNumber
				phoneNumbers.append(value.stringValue)
			}
			
			var emailAddresses: [String] = []
			for emailAddress in contact.emailAddresses {
				let value = emailAddress.value as! String
				emailAddresses.append(value)
			}
					
			let contactModel: ContactModel = ContactModel(build: {
				tem in
				tem.phoneNumbers = phoneNumbers
				tem.emailAddresses = emailAddresses
				tem.profileImage = contact.imageData != nil ? UIImage(data: contact.imageData!) : UIImage(named: "avatar")
				tem.thumbnailImage = contact.thumbnailImageData != nil ? UIImage(data: contact.thumbnailImageData!) : UIImage(named: "avatar")
				tem.givenName = contact.givenName
				tem.middleName = contact.middleName
				tem.familyName = contact.familyName
				tem.birthday = contact.birthday
				tem.jobName = contact.jobTitle
				tem.orgranizationName = contact.organizationName
			})
			
			let name = "\(contact.givenName) \(contact.familyName) \(contact.middleName) \(contact.organizationName)".stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
			let firstString: String = (name as NSString).substringToIndex(1).uppercaseString
			if alphabetArr.contains(firstString) {
				addContactToDic(contactModel, firstString: firstString)
			} else {
				addContactToDic(contactModel, firstString: alphabetArr.last!)
			}
		}
		dispatch_async(dispatch_get_main_queue()) {
			self.contactVC.contactsDic = self.contactsDic
		}
	}

	private func addContactToDic(contactModel: ContactModel, firstString: String) {
		if contactsDic[firstString] == nil {
			contactsDic[firstString] = []
		}
		
		var contactArr = contactsDic[firstString]
		contactArr?.append(contactModel)
		contactsDic[firstString] = contactArr
	}
}
