//
//  HeaderNecessaryTableView.swift
//  Contact
//
//  Created by Le Thanh Tan on 6/14/16.
//  Copyright © 2016 Le Thanh Tan. All rights reserved.
//

import UIKit

protocol HeaderNecessaryViewDelegate: class {
	func headerNecessary(headerNecessaryTableView: HeaderNecessaryTableView, didTapHeader: Bool)
}

class HeaderNecessaryTableView: UITableViewHeaderFooterView {

	@IBOutlet weak var iconImage: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var ncessaryIcon: UIImageView!
	
	weak var delegate: HeaderNecessaryViewDelegate!
	var sectionCell: Int!
	

	override func awakeFromNib() {
		let headerTapGesture = UITapGestureRecognizer()
		headerTapGesture.addTarget(self, action: #selector(singleTap(_:)))
		self.addGestureRecognizer(headerTapGesture)
	}

	func configHeaderWithSection(section: Int, title: String) {
		let background = UIView(frame: self.frame)
		background.backgroundColor = UIColor.whiteColor()
		background.tag = 0
		self.insertSubview(background, belowSubview: self.subviews[0])

		sectionCell = section
		titleLabel.text = title
		switch section {
		case 0:
			iconImage.image = UIImage(named: "cuuHo")
			break
		case 1:
			iconImage.image = UIImage(named: "chamSocKH")
			break
		case 2:
			iconImage.image = UIImage(named: "taxi")
			break
		case 3:
			iconImage.image = UIImage(named: "tuVan")
			break
		case 4:
			iconImage.image = UIImage(named: "bank")
			break
		default:
			break
		}
	}

	func singleTap(gesture: UIGestureRecognizer) {
		print("HERE")		
		delegate.headerNecessary(self, didTapHeader: true)
	}
}
