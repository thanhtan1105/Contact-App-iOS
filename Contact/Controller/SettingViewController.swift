//
//  SettingViewController.swift
//  Contact
//
//  Created by Le Thanh Tan on 6/9/16.
//  Copyright © 2016 Le Thanh Tan. All rights reserved.
//

import UIKit

class SettingViewController: BaseViewController {

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
				cell.configCellWithIndexPath(indexPath, title: "Số điện thoại cần thiết", descriptions: "Tra cứu SĐT taxi, cứu hộ, tư vấn ....", imageName: "necessaryIcon")
				return cell
			}

			break
      
    case 1:
      if indexPath.row == 0 {
        let cell = tableView.dequeueReusableCellWithIdentifier("settingNessaryCell") as! SettingNessaryCell
        cell.configCellWithIndexPath(indexPath, title: "Liên Hệ", descriptions: "Super Cool App Team", imageName: "ic_about")
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
    if indexPath.section == 0 {
      switch indexPath.row {
      case 0:
        let necessaryVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("NecessaryCallViewController") as! NecessaryCallViewController
        self.navigationController?.pushViewController(necessaryVC, animated: true)
        break
      default:
        break
      }
      
    } else if indexPath.section == 1 {
      switch indexPath.row {
      case 0:
        let necessaryVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("AboutViewController") as! AboutViewController
        self.navigationController?.pushViewController(necessaryVC, animated: true)
        break
      default:
        break
      }
      
    }
	}

	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 2
	}

	func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
    case 0:
      return "Tiện ích"

    case 1:
      return "Về chúng tôi"
    default:
      return ""
    }		
	}

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
}
