//
//  NecessaryNumberCategory.swift
//  Contact
//
//  Created by Le Thanh Tan on 6/14/16.
//  Copyright © 2016 Le Thanh Tan. All rights reserved.
//

import Foundation

struct NecessaryNumberCategory {
	var name: String!
	var data: [NecessaryNumberItem]! = []
	var avatart: String!
	
	init(dictionary: NSDictionary) {
		self.name = dictionary["name"] as! String
		switch name {
		case "Cứu hộ":
			avatart = "cuuho"
			break
		case "Chăm sóc khách hàng":
			avatart = "chamsockhanhhang"
			break
		case "Taxi":
			avatart = "taxi"
			break
		case "Tư Vấn":
			avatart = "tuvan"
			break
		case "Ngân hàng":
			avatart = "nganhang"
			break
		default:
			avatart = ""
			break
		}
		
		let dataList = dictionary["data"] as! [NSDictionary]
		for data in dataList {
			let item = NecessaryNumberItem(dictionary: data)
			self.data.append(item)
		}
	}
}