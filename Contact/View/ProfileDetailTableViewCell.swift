//
//  ProfileDetailTableViewCell.swift
//  Contact
//
//  Created by Le Thanh Tan on 4/16/16.
//  Copyright © 2016 Le Thanh Tan. All rights reserved.
//

import UIKit
import MessageUI

protocol ProfileDetailTableViewCellDelegate: class {
	func profileDetailTableViewCell(profileDetailTableViewCell: ProfileDetailTableViewCell, didShowMessageViewController messageVC: MFMessageComposeViewController)
	
	func profileDetailTableViewCell(profileDetailTableViewCell: ProfileDetailTableViewCell, didShowEmailViewController emailVC: MFMailComposeViewController)
}

class ProfileDetailTableViewCell: UITableViewCell {

	enum KindAddContent {
		case Email
		case Phonenumber
	}
	
	// IBOutlet
	@IBOutlet weak var coverImage: UIImageView!
	@IBOutlet weak var avatarImage: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var jobLabel: UILabel!
	@IBOutlet weak var phoneNumberStackView: UIStackView!
	@IBOutlet weak var startFavoriteButton: UIButton!
	@IBOutlet weak var moreButton: UIButton!
	@IBOutlet weak var avatarImageTopConstraint: NSLayoutConstraint!
	
	weak var delegate: ProfileDetailTableViewCellDelegate!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		avatarImage.backgroundColor = UIColor.whiteColor()
		avatarImage.layer.cornerRadius = avatarImage.frame.width / 2
		avatarImage.clipsToBounds = true
		avatarImage.layer.borderWidth = 1
		avatarImage.layer.borderColor = UIColor.blackColor().CGColor
	}

	override func setSelected(selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		// Configure the view for the selected state
		
	}
	
	func configure(contactModel: ContactModel, carrierOwnerName: CarrierName) {
		coverImage.image = UIImage(named: "cover")
		avatarImage.image = contactModel.profileImage
		avatarImage.backgroundColor = UIColor.whiteColor()
		
		if contactModel.givenName == "" && contactModel.familyName == "" && contactModel.middleName == "" {
			nameLabel.text = contactModel.jobName!
			jobLabel.text = ""
			
		} else {
			nameLabel.text = "\(contactModel.givenName!) \(contactModel.familyName!) \(contactModel.middleName!)"
			jobLabel.text = contactModel.jobName!
		}
	
		if let phoneNumberList = contactModel.phoneNumbers {
			for i in 0 ..< phoneNumberList.count {
				let isSameCarrier = contactModel.carrierName![i] == carrierOwnerName ?  true : false
				phoneNumberStackView.addArrangedSubview(
					addContentPhoneNumberToStackView(phoneNumberList[i], carrierName: contactModel.carrierName![i], isSameCarrier: isSameCarrier))
			}
		}
		
		if let emailList = contactModel.emailAddresses {
			for email in emailList {
				phoneNumberStackView.addArrangedSubview(addContentEmailToStackView(email))
			}
		}
	}
}

// MARK: - Private method
extension ProfileDetailTableViewCell {
	
	// For phonenumber
	private func addContentPhoneNumberToStackView (phoneNumber: String, carrierName: CarrierName, isSameCarrier: Bool) -> UIView {
		let view = UIView.loadFromNibNamed("ContactDetailView", bundle: nil) as! ContactDetailView
		view.delegate = self
		view.iconImage.image = UIImage(named: "callon")
		
		if carrierName == CarrierName.Unidentified {
			view.titleLabel.text = "Điện thoại"
		} else {
			view.titleLabel.text = "\(carrierName)"
		}
		
		view.descriptionLabel.text = phoneNumber
		
		if isSameCarrier {
			view.smallActionButtonStackView.hidden = true
			view.bigActionButtonStackView.hidden = false
			
		} else {
			view.smallActionButtonStackView.hidden = false
			view.bigActionButtonStackView.hidden = true
		}
		return view
	}
	
	// For email
	private func addContentEmailToStackView (email: String) -> UIView {
		let view = UIView.loadFromNibNamed("EmailContactDetailView", bundle: nil) as! EmailContactDetailView
		view.delegate = self
		view.emailImage.image = UIImage(named: "email")
		view.titleLabel.text = "Email"
		view.descriptionLabel.text = email
		return view
	}
}

extension ProfileDetailTableViewCell : ContactDetailViewDelegate {
	func contactDetailView(contactDetailView: ContactDetailView, presentMessageView messageVC: MFMessageComposeViewController) {
		delegate.profileDetailTableViewCell(self, didShowMessageViewController: messageVC)
	}
}

extension ProfileDetailTableViewCell : EmailContactDetailViewDelegate {	
	func emailContactDetailView(emailContactDetailView: EmailContactDetailView, presentEmailView emailVC: MFMailComposeViewController) {
		delegate.profileDetailTableViewCell(self, didShowEmailViewController: emailVC)
	}
}
