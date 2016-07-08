//
//  MyTabBarController.swift
//  Contact
//
//  Created by Le Thanh Tan on 6/1/16.
//  Copyright © 2016 Le Thanh Tan. All rights reserved.
//

import UIKit

class MyTabBarController: UITabBarController, UITabBarControllerDelegate {

	@IBOutlet weak var tabbar: UITabBar!
	override func viewDidLoad() {
		super.viewDidLoad()
		self.delegate = self
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	// UITabBarDelegate
	override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
		print("Selected item")
	}

	// UITabBarControllerDelegate
	func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
		print("Selected view controller")
	}

}
