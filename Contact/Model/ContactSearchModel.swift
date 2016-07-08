//
//  ContactSearchModel.swift
//  Contact
//
//  Created by Le Thanh Tan on 6/7/16.
//  Copyright © 2016 Le Thanh Tan. All rights reserved.
//

import Foundation
import Contacts
import ContactsUI

class ContactSearchModel: NSObject {
	var phoneNumber: String!
	var givenName: String!
	var middleName: String!
	var familyName: String!
	
	init(contact: CNContact) {
		super.init()
		let value = contact.phoneNumbers.first!.value as! CNPhoneNumber
		let phoneNumber = value.stringValue
		let givenName = contact.givenName
		let middleName = contact.middleName
		let familyName = contact.familyName
		initCoreVariable(phoneNumber, givenName: givenName, middleName: middleName, familyName: familyName)
	}
	
	private func initCoreVariable (phoneNumber: String, givenName: String, middleName: String, familyName: String) {
		self.phoneNumber = phoneNumber
		self.givenName = givenName
		self.middleName = middleName
		self.familyName = familyName
	}
}