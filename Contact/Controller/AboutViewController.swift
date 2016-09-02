//
//  AboutViewController.swift
//  Contact
//
//  Created by Le Thanh Tan on 7/11/16.
//  Copyright © 2016 Le Thanh Tan. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
}

extension AboutViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("AboutTableViewCell") as! AboutTableViewCell
    switch indexPath.row {
    case 0:
      // Rate US
      cell.configure("ic_rate", titleLabel: "Rate Us")
      break
    case 1:
      // Hot Game
      cell.configure("ic_game", titleLabel: "Hot Game")
    case 2:
      // Like US
      cell.configure("ic_like", titleLabel: "Like Us")
      break
    case 3:
      // About US
      cell.configure("ic_about", titleLabel: "About Us")
      break
    default:
      return UITableViewCell()
    }
    return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    switch indexPath.row {
    case 0:
      UIApplication.sharedApplication().openURL(NSURL(string: "http://itunes.apple.com/us/app/id1122991921?at=11l5Vq")!)
      break
    case 1:
      // Hot Game
      UIApplication.sharedApplication().openURL(NSURL(string: "http://www.bestappsforphone.com/iosgameofthemonth")!)
      break
    case 2:
      // Like US
      UIApplication.sharedApplication().openURL(NSURL(string: "https://www.facebook.com/supercoolappteam?fref=ts")!)
      break
    case 3:
      // About Us
      UIApplication.sharedApplication().openURL(NSURL(string: "https://itunes.apple.com/vn/developer/dang-thanh-xuan/id541350751")!)
      break

    default:
      break
    }
  }
}