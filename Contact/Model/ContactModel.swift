//
//  ContactModel.swift
//  Contact
//
//  Created by Le Thanh Tan on 4/12/16.
//  Copyright © 2016 Le Thanh Tan. All rights reserved.
//

import UIKit

protocol ContactProtocol {
	var givenName: String? { get set }
	var middleName: String? { get set }
	var familyName: String? { get set }
	var phoneNumbers: [String]? { get set }
	var emailAddresses: [String]? { get set}
	var profileImage: UIImage? { get set }
	var thumbnailImage: UIImage? { get set }
	var birthday: NSDateComponents? { get set }
	var jobName: String? { get set }
	var orgranizationName: String? { get set }
}

class ContactModel: ContactProtocol {
	var givenName: String?
	var middleName: String?
	var familyName: String?
	var phoneNumbers: [String]?
	var emailAddresses: [String]?
	var profileImage: UIImage?
	var thumbnailImage: UIImage?
	var birthday: NSDateComponents?
	var jobName: String?
	var orgranizationName: String?
	
	typealias buildContactClosure = (ContactModel) -> Void
	
	// Builder Pattern
	init(build:buildContactClosure) {
		build(self)
	}
	
}


