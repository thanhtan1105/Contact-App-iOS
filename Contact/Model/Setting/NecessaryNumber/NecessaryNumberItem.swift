//
//  NecessaryNumberItem.swift
//  Contact
//
//  Created by Le Thanh Tan on 6/14/16.
//  Copyright © 2016 Le Thanh Tan. All rights reserved.
//

import Foundation

struct NecessaryNumberItem {
	var id: String!
	var name: String!
	var phone: String!
	var price: String!
	var unit: String!
	
	init(dictionary: NSDictionary) {
		self.id = dictionary["id"] as! String
		self.name = dictionary["name"] as! String
		self.phone = dictionary["phone"] as! String
		self.price = dictionary["price"] as! String
		self.unit = dictionary["unit"] as! String
	}
}