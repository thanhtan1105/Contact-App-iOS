//
//  Define.swift
//  Contact
//
//  Created by Le Thanh Tan on 4/11/16.
//  Copyright © 216 Le Thanh Tan. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds

let alphabetArr = ["A", "Ă", "Â", "B", "C",
                   "D", "Đ", "E", "Ê", "F",
                   "G", "H", "I", "J", "K",
                   "L", "M", "N", "O", "Ô",
                   "Ơ", "P", "Q", "R", "S",
                   "T", "U", "Ư", "V", "W",
                   "X", "Y", "Z", "#"]


let prefixCarrierNumber = ["90", "93", "122", "126", "121", "128", "12", "91", "94", "123", "125", "127", "96", "97", "98", "162", "163", "164", "165", "166", "167", "168", "169", "95", "92", "186", "188", "92", "186", "188", "199"]
let prefixCarrierName: [String: String] =
	[
		"90" : "Mobifone", "93" : "Mobifone",
		"122" : "Mobifone", "126" : "Mobifone",
		"121" : "Mobifone", "128" : "Mobifone",
		"12" : "Mobifone", "91" : "Vinaphone",
		"94" : "Vinaphone", "123" : "Vinaphone",
		"125" : "Vinaphone", "127" : "Vinaphone",
		"96" : "Viettel", "97" : "Viettel",
		"98" : "Viettel", "162" : "Viettel",
		"163" : "Viettel", "164" : "Viettel",
		"165" : "Viettel", "166" : "Viettel",
		"167" : "Viettel", "168" : "Viettel",
		"169" : "Viettel", "95" : "Sfone",
		"92" : "Vietnamobile", "186" : "Vietnamobile",
		"188" : "Vietnamobile", "199" : "Beeline",
]

// Google Ads
let adUnitID = "ca-app-pub-8272403203330390/2256423065"
func showBannerAds(bannerView: GADBannerView, myViewController: UIViewController) {
  // ads
  bannerView.adUnitID = adUnitID
  bannerView.rootViewController = myViewController
  bannerView.loadRequest(GADRequest())
}

