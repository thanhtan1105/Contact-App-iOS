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
import AddressBookUI
import ContactsUI

protocol ContactHelperDelegate: ContactHelperOptionalDelegate {

}

protocol ContactHelperOptionalDelegate: class {
	func contactHelper(viewController: CNContactViewController,
	                   didCompleteWithContact contact: CNContact?)
	func contactHelper(contactHelper: ContactHelper,
	                   didFinishImportContact contactsDic: [String: [ContactModel]])

}

extension ContactHelperOptionalDelegate {
	func contactHelper(viewController: CNContactViewController,
	                   didCompleteWithContact contact: CNContact?) {
		// NOTHING TO-DO
	}

	func contactHelper(contactHelper: ContactHelper,
	                   didFinishImportContact contactsDic: [String: [ContactModel]]) {
		// NOTHING TO-DO
	}
}


class ContactHelper: NSObject {
  
	var contacts: [ContactModel] = []
	var contactsDic: [String: [ContactModel]] = [:]
	private var validContacts: [CNContact] = []
	private let contactStore = CNContactStore()
	weak var delegate: ContactHelperDelegate?

  let keys = [
    CNContactGivenNameKey,	// done
    CNContactMiddleNameKey, // done
    CNContactFamilyNameKey, // done
    CNContactEmailAddressesKey, // done
    CNContactPhoneNumbersKey, // done
    CNContactImageDataKey, // done
    CNContactThumbnailImageDataKey, // done
    CNContactJobTitleKey, // done
    CNContactBirthdayKey, // done
    CNContactOrganizationNameKey // done
  ]
  
	static var sharedInstance: ContactHelper = {
		return ContactHelper()
	}()

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
			return UIImage(named: "avatar_me")!
		}
		return image!
	}

	func importContactIfNeeded() {
		contactStore.requestAccessForEntityType(.Contacts) { (granted: Bool, error: NSError?) in
			if (granted) {
				do {
					let fetchRequest = CNContactFetchRequest(keysToFetch: self.keys)
					CNContact.localizedStringForKey(CNLabelPhoneNumberiPhone)
					fetchRequest.mutableObjects = false
					fetchRequest.unifyResults = true
					fetchRequest.sortOrder = .UserDefault
					let contactStoreID = CNContactStore().defaultContainerIdentifier()
					print("\(contactStoreID)")
					do {
						try CNContactStore().enumerateContactsWithFetchRequest(fetchRequest) { (let contact, let stop) -> Void in
							self.validContacts.append(contact)
						}
					} catch let e as NSError {
						print(e.localizedDescription)
					}
					print("Total contact: \(self.validContacts.count)")
					self.importContact()
				}
			}
		}
	}

	// MARK: - Add contact Function
	func addContactWithViewController(viewController: UIViewController) {
		let pickerVC = CNContactViewController.init(forNewContact: CNContact())
		pickerVC.delegate = self
		let newNavigation = UINavigationController(rootViewController: pickerVC)
		viewController.presentViewController(newNavigation, animated: true, completion: nil)
	}

	func addContact(newContact: CNMutableContact, inViewController viewController: UIViewController) {
		let pickerVC = CNContactViewController.init(forNewContact: newContact)

		pickerVC.delegate = self
		let newNavigation = UINavigationController(rootViewController: pickerVC)
		viewController.presentViewController(newNavigation, animated: true, completion: nil)
	}

	/**
	Search contact with number

	- parameter number: String

	- returns: list CNContact
	*/
	func searchContactWithNumber(numberLabel: String) -> [CNContact] {
		let keysToFetch = [CNContactFormatter.descriptorForRequiredKeysForStyle(.FullName), CNContactPhoneNumbersKey]
		let fetchRequest = CNContactFetchRequest( keysToFetch: keysToFetch)

		var contacts = [CNContact]()
		CNContact.localizedStringForKey(CNLabelPhoneNumberiPhone)
		fetchRequest.mutableObjects = false
		fetchRequest.unifyResults = true
		fetchRequest.sortOrder = .UserDefault
		let contactStoreID = CNContactStore().defaultContainerIdentifier()
		print("\(contactStoreID)")
		do {

			try CNContactStore().enumerateContactsWithFetchRequest(fetchRequest) { (let contact, let stop) -> Void in
				if contact.phoneNumbers.count > 0 {
					contacts.append(contact)
				}
			}
		} catch let e as NSError {
			print(e.localizedDescription)
		}

		// filter number again
		var newContact: [CNContact] = []
		for contact in contacts {
			for number in contact.phoneNumbers {
				if String(number.value as! CNPhoneNumber).containsString(numberLabel) {
					newContact.append(contact)
					break
				}
			}
		}
		return newContact
	}

	/**
	Search contact with Name

	- parameter name: String

	- returns: List of CNContact
	*/
	func searchContactWithName(name: String) -> [CNContact] {

		let keysToFetch = [CNContactFormatter.descriptorForRequiredKeysForStyle(.FullName), keys]

		let fetchRequest = CNContactFetchRequest( keysToFetch: keysToFetch as! [CNKeyDescriptor])
		fetchRequest.predicate = CNContact.predicateForContactsMatchingName(name)
		var contacts = [CNContact]()
		CNContact.localizedStringForKey(CNLabelPhoneNumberiPhone)
		fetchRequest.mutableObjects = false
		fetchRequest.unifyResults = true
		fetchRequest.sortOrder = .UserDefault
		let contactStoreID = CNContactStore().defaultContainerIdentifier()
		print("\(contactStoreID)")
		do {

			try CNContactStore().enumerateContactsWithFetchRequest(fetchRequest) { (let contact, let stop) -> Void in
				contacts.append(contact)
			}
		} catch let e as NSError {
			print(e.localizedDescription)
		}
		return contacts
	}

	/**
	Calling with number

	- parameter number: String
	*/
	func callWithNumber(number: String) {
		if let url = NSURL(string: "tel://\(number)") {
			UIApplication.sharedApplication().openURL(url)
		}
	}
}

extension ContactHelper: CNContactViewControllerDelegate {
	func contactViewController(viewController: CNContactViewController, didCompleteWithContact contact: CNContact?) {
		delegate?.contactHelper(viewController, didCompleteWithContact: contact)
	}
}

// MARK: - Private Method
extension ContactHelper {

	/**
	import contact
	*/
	private func importContact() {
		// Loop through contatcs
		contactsDic = [:] // reset all data before new import
		for contact in validContacts {
			// contact have phoneNumber they will add to data
			if contact.phoneNumbers.count != 0 {
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
					tem.profileImage = contact.imageData != nil ? UIImage(data: contact.imageData!) : UIImage(named: "avatar_guest")
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
				var firstString: String!
				if name.characters.count > 0 {
					firstString = (name as NSString).substringToIndex(1).uppercaseString
				} else {
					firstString = " "
				}
				
				if alphabetArr.contains(firstString) {
					addContactToDic(contactModel, firstString: firstString)
				} else {
					addContactToDic(contactModel, firstString: alphabetArr.last!)
				}
			}
		}
		delegate!.contactHelper(self, didFinishImportContact: contactsDic)
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
		var tmp = phoneNumber.stringByReplacingOccurrencesOfString("(", withString: "")
		tmp = tmp.stringByReplacingOccurrencesOfString(")", withString: "")
		tmp = tmp.stringByReplacingOccurrencesOfString("-", withString: "")
		tmp = tmp.stringByReplacingOccurrencesOfString(" ", withString: "")
		print("TMP: \(tmp)")
		// we will update more
		let newPhoneNumber = tmp.stringByReplacingOccurrencesOfString("+84", withString: " ").stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())

		var subPhone = newPhoneNumber
		if newPhoneNumber.characters.count > 4 {
			subPhone = (newPhoneNumber as NSString).substringToIndex(4)
			subPhone = subPhone.removeWhitespace()
		}

		for prefixNumber in prefixCarrierNumber {
			if subPhone.containsString(prefixNumber) {
				var carrierName = CarrierName.Unidentified
				print(prefixNumber)
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
          break
				}
				return carrierName
			}
		}
		return CarrierName.Unidentified
	}

}
