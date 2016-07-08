//
//  NecessaryNumberCountry.swift
//  Contact
//
//  Created by Le Thanh Tan on 6/14/16.
//  Copyright © 2016 Le Thanh Tan. All rights reserved.
//

import Foundation

struct NecessaryNumberCountry {
	var id: String!
	var city: String!
	var data: [NecessaryNumberCategory]! = []
	
	init(dictionary: NSDictionary) {
		self.id = dictionary["id"] as! String
		self.city = dictionary["city"] as! String
		
		let dataList = dictionary["data"] as! [NSDictionary]
		for data in dataList {
			let item = NecessaryNumberCategory(dictionary: data)
			self.data.append(item)
		}
	}
}