//
//  ContactTableViewCell.swift
//  Contact
//
//  Created by Le Thanh Tan on 4/11/16.
//  Copyright © 2016 Le Thanh Tan. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

	@IBOutlet weak var avatarImage: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var jobLabel: UILabel!
	@IBOutlet weak var viewName: UIView!
	@IBOutlet weak var view: UIView!
	@IBOutlet weak var callButton: UIButton!
	
	// layout contrainst
	var fullContraintViewName: NSLayoutConstraint!
	var shortContraintViewName: NSLayoutConstraint!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		avatarImage.layer.cornerRadius = 25
		avatarImage.clipsToBounds = true
		
		fullContraintViewName = NSLayoutConstraint(item: viewName,
		                                           attribute: NSLayoutAttribute.Height,
		                                           relatedBy: NSLayoutRelation.Equal,
		                                           toItem: self.view,
		                                           attribute: NSLayoutAttribute.Height,
		                                           multiplier: 1.0,
		                                           constant: -16)
		
		shortContraintViewName = NSLayoutConstraint(item: viewName,
		                                            attribute: NSLayoutAttribute.Height,
		                                            relatedBy: NSLayoutRelation.Equal,
		                                            toItem: self.view,
		                                            attribute: NSLayoutAttribute.Height,
		                                            multiplier: 0.5,
		                                            constant: -8)
		
	}

	override func setSelected(selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
	
	func configurate(contact: ContactModel) {
		avatarImage.image = contact.profileImage
		nameLabel.text =
			"\(contact.givenName!) \(contact.familyName!)".stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())

		jobLabel.text = "\(contact.jobName!)"
		
		if contact.jobName?.characters.count == 0 {
			self.view.removeConstraint(shortContraintViewName)
			self.view.addConstraint(fullContraintViewName)
		} else {
			self.view.removeConstraint(fullContraintViewName)
			self.view.addConstraint(shortContraintViewName)
			
		}
		
		viewName.layoutIfNeeded()
	}
}
