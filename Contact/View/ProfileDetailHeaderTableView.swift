//
//  ProfileDetailHeaderTableView.swift
//  Contact
//
//  Created by Le Thanh Tan on 6/2/16.
//  Copyright © 2016 Le Thanh Tan. All rights reserved.
//

import UIKit

class ProfileDetailHeaderTableView: UIView {

	// IBOutlet
	@IBOutlet weak var avatarImage: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var jobLabel: UILabel!
	@IBOutlet weak var moreButton: UIButton!
	@IBOutlet weak var favoriteButton: UIButton!
	
	// variable
	var contactModel: ContactModel! {
		didSet {
			avatarImage.image = contactModel.profileImage
			nameLabel.text = "\(contactModel.givenName!) \(contactModel.familyName!) \(contactModel.middleName!)"
			jobLabel.text = contactModel.jobName!
		}
	}
	
	override func awakeFromNib() {
		avatarImage.layer.cornerRadius = 20
			//avatarImage.frame.size.width / 2
		avatarImage.clipsToBounds = true
	}
	
	@IBAction func onMoreTapped(sender: UIButton) {
		UIView.alertViewComingSoon()
	}
	
	@IBAction func onFavoriteTapped(sender: UIButton) {
		UIView.alertViewComingSoon()
	}
}
