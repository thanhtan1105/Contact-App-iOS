//
//  DeviceHelper.swift
//  Contact
//
//  Created by Le Thanh Tan on 6/7/16.
//  Copyright © 2016 Le Thanh Tan. All rights reserved.
//

import UIKit

class DeviceHelper: NSObject {
	
	static var sharedInstance: ContactHelper = {
		return ContactHelper()
	}()

	private static let SCREEN_WIDTH         = UIScreen.mainScreen().bounds.size.width
	private static let SCREEN_HEIGHT        = UIScreen.mainScreen().bounds.size.height
	private static let SCREEN_MAX_LENGTH    = max(SCREEN_WIDTH, SCREEN_HEIGHT)
	private static let SCREEN_MIN_LENGTH    = min(SCREEN_WIDTH, SCREEN_HEIGHT)

//	struct Type {
//	}
	static let IS_IPHONE_4  = UIDevice.currentDevice().userInterfaceIdiom == .Phone && SCREEN_MAX_LENGTH < 568.0
	static let IS_IPHONE_5          = UIDevice.currentDevice().userInterfaceIdiom == .Phone && SCREEN_MAX_LENGTH == 568.0
	static let IS_IPHONE_6          = UIDevice.currentDevice().userInterfaceIdiom == .Phone && SCREEN_MAX_LENGTH == 667.0
	static let IS_IPHONE_6P         = UIDevice.currentDevice().userInterfaceIdiom == .Phone && SCREEN_MAX_LENGTH == 736.0
	static let IS_IPAD              = UIDevice.currentDevice().userInterfaceIdiom == .Pad && SCREEN_MAX_LENGTH == 1024.0
	static let IS_IPAD_PRO          = UIDevice.currentDevice().userInterfaceIdiom == .Pad && SCREEN_MAX_LENGTH == 1366.0
	
	static let deviceName = UIDevice.currentDevice().name
}

