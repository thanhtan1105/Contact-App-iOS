//
//  SettingNessaryCell.swift
//  Contact
//
//  Created by Le Thanh Tan on 6/10/16.
//  Copyright © 2016 Le Thanh Tan. All rights reserved.
//

import UIKit

class SettingNessaryCell: UITableViewCell {

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var imageCell: UIImageView!



	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}

	override func setSelected(selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
	}


	func configCellWithIndexPath(indexPath: NSIndexPath, title: String, descriptions: String) {
		titleLabel.text = title
		descriptionLabel.text = descriptions
		imageCell.image = UIImage(named: "necessaryIcon")
	}
}
