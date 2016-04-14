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
	func getOwnerCarrierName() -> CarrierName {
		let networkInfo = CTTelephonyNetworkInfo()
		let carrier = networkInfo.subscriberCellularProvider
		if let carrierName = carrier?.carrierName {
			var carrier = CarrierName.Unidentified
			switch carrierName {
			case "Mobifone":
				carrier = CarrierName.Mobifone
			case "Vinaphone":
				carrier = CarrierName.Vinaphone
			case "Viettel":
				carrier = CarrierName.Viettel
			case "Sfone":
				carrier = CarrierName.Sfone
			case "Vietnamobile":
				carrier = CarrierName.Vietnamobile
			case "Beeline":
				carrier = CarrierName.Beeline
			default:
				carrier = CarrierName.Unidentified
			}
			return carrier
		}
		return CarrierName.Unidentified
	}
	
	func getOwnerProfileImage() -> UIImage {
		let image = UIImage(named: "profile_image")
		if image == nil {
			return UIImage(named: "avatar")!
		}
		return image!
	}
	
	
	func importContactIfNeeded() {
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
						CNContactBirthdayKey, // done
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
			var carrierName: [CarrierName] = []
			var phoneNumbers: [String] = []
			for phoneNumber in contact.phoneNumbers {
				let value = phoneNumber.value as! CNPhoneNumber
				phoneNumbers.append(value.stringValue)
				
				let carrier = defineCarrierFromPhoneNumber(value.stringValue)
				carrierName.append(carrier)
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
				tem.carrierName = carrierName
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
	
	private func defineCarrierFromPhoneNumber(phoneNumber: String) -> CarrierName {
		print(phoneNumber)
		let tmp = phoneNumber.stringByReplacingOccurrencesOfString(" ", withString: "")
		// we will update more
		let newPhoneNumber = tmp.stringByReplacingOccurrencesOfString("+84", withString: "0")
		var subPhone = newPhoneNumber
		if newPhoneNumber.characters.count > 6 {
			subPhone = (newPhoneNumber as NSString).substringToIndex(6)
		}
		
		for prefixNumber in prefixCarrierNumber {
			if subPhone.rangeOfString(prefixNumber) != nil {
				print(prefixNumber)
				var carrierName = CarrierName.Unidentified
				switch prefixCarrierName[prefixNumber]! {
				case "Mobifone":
					carrierName = CarrierName.Mobifone
				case "Vinaphone":
					carrierName = CarrierName.Vinaphone
				case "Viettel":
					carrierName = CarrierName.Viettel
				case "Sfone":
					carrierName = CarrierName.Sfone
				case "Vietnamobile":
					carrierName = CarrierName.Vietnamobile
				case "Beeline":
					carrierName = CarrierName.Beeline
				default:
					carrierName = CarrierName.Unidentified
				}
				return carrierName
			}
		}		
		return CarrierName.Unidentified
	}
}
