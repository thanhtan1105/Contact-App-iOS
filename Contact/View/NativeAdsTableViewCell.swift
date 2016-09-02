//
//  NativeAdsTableViewCell.swift
//  Contact
//
//  Created by Le Thanh Tan on 7/9/16.
//  Copyright © 2016 Le Thanh Tan. All rights reserved.
//

import UIKit
import GoogleMobileAds

class NativeAdsTableViewCell: UITableViewCell, GADNativeAppInstallAdLoaderDelegate, GADAdLoaderDelegate {
  @IBOutlet weak var nativeAdsView: GADNativeAppInstallAdView!
  var adLoader: GADAdLoader!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func setSelected(selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)
  }
  
  func configureAds(viewController: UIViewController) {
    adLoader = GADAdLoader(adUnitID: adUnitID, rootViewController: viewController,
                           adTypes: [kGADAdLoaderAdTypeNativeAppInstall], options: nil)
    adLoader.delegate = self
    adLoader.loadRequest(GADRequest())

  }

  func adLoader(adLoader: GADAdLoader!,
                didReceiveNativeAppInstallAd nativeAppInstallAd: GADNativeAppInstallAd!) {
    print("Received native app install ad: \(nativeAppInstallAd)")
    // Associate the app install ad view with the app install ad object. This is required to make
    // the ad clickable.
    nativeAdsView.nativeAppInstallAd = nativeAppInstallAd
    
    // Populate the app install ad view with the app install ad assets.
    // Some assets are guaranteed to be present in every app install ad.
    (nativeAdsView.headlineView as! UILabel).text = nativeAppInstallAd.headline
    (nativeAdsView.iconView as! UIImageView).image = nativeAppInstallAd.icon?.image
    (nativeAdsView.bodyView as! UILabel).text = nativeAppInstallAd.body
    (nativeAdsView.callToActionView as! UIButton).setTitle(
      nativeAppInstallAd.callToAction, forState: UIControlState.Normal)
    
    // In order for the SDK to process touch events properly, user interaction should be disabled.
    (nativeAdsView.callToActionView as! UIButton).userInteractionEnabled = false
  }

  
  func adLoader(adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
    print("\(adLoader) failed with error: \(error.localizedDescription)")
  }

}
