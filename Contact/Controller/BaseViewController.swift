//
//  BaseViewController.swift
//  Contact
//
//  Created by Le Thanh Tan on 7/11/16.
//  Copyright © 2016 Le Thanh Tan. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

  override func viewDidLoad() {
      super.viewDidLoad()

      // Do any additional setup after loading the view.
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
  
  deinit {
    print("\(self) dealloc")
  }
  
  func checkingGoogleAnalytic() {
    print("HERE Google Analytic: ", self.description)
    let tracker = GAI.sharedInstance().defaultTracker
    tracker.set(kGAIScreenName, value: self.description)
    
    let builder = GAIDictionaryBuilder.createScreenView()
    tracker.send(builder.build() as [NSObject : AnyObject])
    
  }

}
