//
//  FastCallingTableViewCell.swift
//  Contact
//
//  Created by Le Thanh Tan on 4/13/16.
//  Copyright © 2016 Le Thanh Tan. All rights reserved.
//

import UIKit

class FastCallingTableViewCell: UITableViewCell {

	@IBOutlet weak var numberLabel: UILabel!
	@IBOutlet weak var recommendImage: UIImageView!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}

	override func setSelected(selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		// Configure the view for the selected state
	}
	
	func configure(phoneNumber: String, isSameCarrier: Bool) {
		if isSameCarrier {
			let attrs = [NSFontAttributeName : UIFont.boldSystemFontOfSize(17)]
			let boldString = NSMutableAttributedString(string:phoneNumber, attributes:attrs)
			numberLabel.attributedText = boldString
		} else {
			numberLabel.text = phoneNumber
		}
		recommendImage.hidden = !isSameCarrier
	}

}
