//
//  SearchContactTableViewCell.swift
//  Contact
//
//  Created by Le Thanh Tan on 6/7/16.
//  Copyright © 2016 Le Thanh Tan. All rights reserved.
//

import UIKit

class SearchContactTableViewCell: UITableViewCell {

	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var phoneNumberLabel: UILabel!
	
	var contactSearchModel: ContactSearchModel! {
		didSet {
			nameLabel.text = "\(contactSearchModel.givenName) \(contactSearchModel.familyName) \(contactSearchModel.middleName)".stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
			phoneNumberLabel.text = contactSearchModel.phoneNumber
		}
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}

	override func setSelected(selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
	}
    
}
