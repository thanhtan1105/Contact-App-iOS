//
//  DetailViewController.swift
//  Contact
//
//  Created by Le Thanh Tan on 4/16/16.
//  Copyright © 2016 Le Thanh Tan. All rights reserved.
//

import UIKit
import MessageUI

class DetailContactViewController: BaseViewController {

	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var buttonClose: UIButton!
	@IBOutlet weak var backgroundView: UIView!

	var contactModel: ContactModel!
	var carrierOwnerName: CarrierName!
	var headerViewOnTableView: ProfileDetailHeaderTableView!


	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.layer.cornerRadius = 12
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 70
		tableView.allowsSelection = false

		// load header view for tableview
		headerViewOnTableView = UIView.loadFromNibNamed("ProfileDetailHeaderView", bundle: nil) as! ProfileDetailHeaderTableView
		headerViewOnTableView.contactModel = contactModel
		tableView.tableHeaderView = headerViewOnTableView

		// register nib name for cell
		tableView.registerNib(UINib(nibName: "SameCarrierTableViewCell", bundle: nil), forCellReuseIdentifier: "ContactDetailSameCarrierCell")
		tableView.registerNib(UINib(nibName: "DifferentTableViewCell", bundle: nil), forCellReuseIdentifier: "ContactDetailDifferentCarrierCell")
	}

	override func viewDidLayoutSubviews() {
		buttonClose.backgroundColor = UIColor.whiteColor()
		buttonClose.layer.cornerRadius = buttonClose.frame.size.width / 2
		buttonClose.layer.masksToBounds = false

		buttonClose.layer.shadowColor = UIColor.blackColor().CGColor
		buttonClose.layer.shadowOpacity = 0.5
		buttonClose.layer.shadowRadius = 5
		buttonClose.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)

		backgroundView.layer.cornerRadius = 10

		// top, left, bottom, right
		buttonClose.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10.0)

		// fit header size
		sizeHeaderToFit()
	}

	private func sizeHeaderToFit() {
		let headerView = tableView.tableHeaderView!
		headerView.setNeedsLayout()
		headerView.layoutIfNeeded()

		let height = headerView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
		var frame = headerView.frame
		let minusValue = DeviceHelper.IS_IPHONE_6P ? 40.0 : 70.0
		frame.size.height = height - CGFloat(minusValue)
		headerView.frame = frame

		tableView.tableHeaderView = headerView
	}
}

// MARK: - IBAction
extension DetailContactViewController {
	@IBAction func onCloseButtonTouchUpInside(sender: UIButton) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
}

extension DetailContactViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		var isSamCarrier = true
		let currentPhoneNumber = contactModel.phoneNumbers![indexPath.row]
		let currentCarrierName = contactModel.carrierName![indexPath.row]
		if currentCarrierName != carrierOwnerName ||
			currentCarrierName == CarrierName.Unidentified {
			isSamCarrier = false
		}

		if isSamCarrier {
			/// Cell is same carrier
			let cell = tableView.dequeueReusableCellWithIdentifier("ContactDetailSameCarrierCell") as! ContactDetailSameTableViewCell
			cell.contactDetailModel = ContactDetailModel(phoneNumber: currentPhoneNumber, carrierName: currentCarrierName)
			return cell
		} else {
			/// Cell is different carrier
			let cell = tableView.dequeueReusableCellWithIdentifier("ContactDetailDifferentCarrierCell") as! ContactDetailDifferentTableViewCell
			cell.contactDetailModel = ContactDetailModel(phoneNumber: currentPhoneNumber, carrierName: currentCarrierName)
			return cell
		}
	}

	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return contactModel.phoneNumbers?.count ?? 0
	}
}