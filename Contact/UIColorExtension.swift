//
//  UIColorExtension.swift
//  Contact
//
//  Created by Le Thanh Tan on 4/14/16.
//  Copyright © 2016 Le Thanh Tan. All rights reserved.
//

import UIKit

extension UIColor {
	convenience public init(hex: Int, alpha: CGFloat = 1.0) {
		let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
		let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
		let blue = CGFloat((hex & 0xFF)) / 255.0
		self.init(red:red, green:green, blue:blue, alpha:alpha)
	}
	
	public struct appColor {
		public static let primaryColor = UIColor(hex: 0x4bc2ec)
	}
}
