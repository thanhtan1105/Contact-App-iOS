//
//  SettingViewController.swift
//  Contact
//
//  Created by Le Thanh Tan on 6/9/16.
//  Copyright © 2016 Le Thanh Tan. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		switch indexPath.section {
		case 0:
			if indexPath.row == 0 {
				let cell = tableView.dequeueReusableCellWithIdentifier("settingNessaryCell") as! SettingNessaryCell
				cell.configCellWithIndexPath(indexPath, title: "Số điện thoại cần thiết", descriptions: "Tra cứu SĐT taxi, cứu hộ, tư vấn ....")
				return cell
			}

			break
		default:
			break
		}

		return UITableViewCell()
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
	}

	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}

	func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return "Tiện ích"
	}

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
}
