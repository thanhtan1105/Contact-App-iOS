//
//  NecessaryNumberCell.swift
//  Contact
//
//  Created by Le Thanh Tan on 6/15/16.
//  Copyright © 2016 Le Thanh Tan. All rights reserved.
//

import UIKit

class NecessaryNumberCell: UITableViewCell {

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var phoneNumberLabel: UILabel!
	var necessaryNumberModel: NecessaryNumberItem! {
		didSet {
			titleLabel.text = necessaryNumberModel.name
			phoneNumberLabel.text = necessaryNumberModel.phone
		}
	}

	override func awakeFromNib() {
		super.awakeFromNib()
	}

	override func setSelected(selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
	}

}
