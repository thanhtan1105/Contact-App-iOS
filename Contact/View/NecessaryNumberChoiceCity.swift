//
//  NecessaryNumberChoiceCity.swift
//  Contact
//
//  Created by Le Thanh Tan on 6/16/16.
//  Copyright © 2016 Le Thanh Tan. All rights reserved.
//

import UIKit

protocol NecessaryNumberChoiceCityDelegate: class {
	func necessaryNumber(necessaryNumberChoiceCity: NecessaryNumberChoiceCity, didTapCityWithName name: City)
}

enum City {
	case DaNang
	case HaNoi
	case HoChiMinh
	
	var description: String {
		get {
			switch self {
			case .DaNang:
				return "Đà Nẵng"
			case .HaNoi:
				return "Hà Nội"
			case .HoChiMinh:
				return "Hồ Chí Minh"
			}
		}
	}

}

class NecessaryNumberChoiceCity: UIView {

	@IBOutlet weak var hanoiButton: UIButton!
	@IBOutlet weak var danangButton: UIButton!
	@IBOutlet weak var hochiminhButton: UIButton!
	weak var delegate: NecessaryNumberChoiceCityDelegate!

	
	override func drawRect(rect: CGRect) {
	}
	
	@IBAction func onCityTapped(sender: UIButton) {
		switch sender {
		case hanoiButton:
			delegate.necessaryNumber(self, didTapCityWithName: .HaNoi)
			break
		case danangButton:
			delegate.necessaryNumber(self, didTapCityWithName: .DaNang)
			break
		case hochiminhButton:
			delegate.necessaryNumber(self, didTapCityWithName: .HoChiMinh)
			break
		default:
			break
		}
	}
}
