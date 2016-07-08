//
//  ContactDetailModel.swift
//  Contact
//
//  Created by Le Thanh Tan on 6/3/16.
//  Copyright © 2016 Le Thanh Tan. All rights reserved.
//

import Foundation

class ContactDetailModel {
	var phoneNumber: String!
	var carrierName: CarrierName!
	
	init(phoneNumber: String, carrierName: CarrierName) {
		self.phoneNumber = phoneNumber
		self.carrierName = carrierName
	}
}