//
//  NativeAd.swift
//  EssayCorrectionProject
//
//  Created by Bruno Teodoro on 12/11/24.
//

import UIKit
import SwiftUI
import GoogleMobileAds

class GADNativeViewController: UIViewController {
    
    var heightConstraint: NSLayoutConstraint?
    
    var adLoader: GADAdLoader!
    
    var nativeAdView: GADNativeAdView!
    
    //MARK: Essa aqui é a key de teste, tem que ser substituída depois
    let adUnitID = "ca-app-pub-3940256099942544/3986624511"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard
            let nibObjects = Bundle.main.loadNibNamed("NativeAdView", owner: nil, options: nil),
            let adView = nibObjects.first as? GADNativeAdView
        else {
            assert(false, "Could not load nib file for adView")
        }
        setAdView(adView)
        refreshAd()
    }
    
    func setAdView(_ view: GADNativeAdView) {
        
        nativeAdView = view
        self.view.addSubview(nativeAdView)
        nativeAdView.translatesAutoresizingMaskIntoConstraints = false
        
        let viewDictionary = ["_nativeAdView": nativeAdView!]
        self.view.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|[_nativeAdView]|",
                options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary)
        )
        self.view.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|[_nativeAdView]|",
                options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary)
        )
    }
    
    // MARK: - Actions
    
    func refreshAd() {
        adLoader = GADAdLoader(
            adUnitID: adUnitID, rootViewController: self,
            adTypes: [.native], options: nil)
        adLoader.delegate = self
        adLoader.load(GADRequest())
    }
    
    func imageOfStars(from starRating: NSDecimalNumber?) -> UIImage? {
        guard let rating = starRating?.doubleValue else {
            return nil
        }
        if rating >= 5 {
            return UIImage(named: "stars_5")
        } else if rating >= 4.5 {
            return UIImage(named: "stars_4_5")
        } else if rating >= 4 {
            return UIImage(named: "stars_4")
        } else if rating >= 3.5 {
            return UIImage(named: "stars_3_5")
        } else {
            return nil
        }
    }
}

extension GADNativeViewController: GADVideoControllerDelegate {
    
    func videoControllerDidEndVideoPlayback(_ videoController: GADVideoController) {
        print("Video playback has ended.")
    }
}

extension GADNativeViewController: GADNativeAdLoaderDelegate {
    
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        
        nativeAd.delegate = self
        
        heightConstraint?.isActive = false
        
        (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline
        nativeAdView.mediaView?.mediaContent = nativeAd.mediaContent
        
        let mediaContent = nativeAd.mediaContent
        if mediaContent.hasVideoContent {
            
            mediaContent.videoController.delegate = self
            print("Ad contains a video asset.")
        } else {
            print("Ad does not contain a video.")
        }
        
        
        if let mediaView = nativeAdView.mediaView, nativeAd.mediaContent.aspectRatio > 0 {
            heightConstraint = NSLayoutConstraint(
                item: mediaView,
                attribute: .height,
                relatedBy: .equal,
                toItem: mediaView,
                attribute: .width,
                multiplier: CGFloat(1 / nativeAd.mediaContent.aspectRatio),
                constant: 0)
            heightConstraint?.isActive = true
        }
        
        (nativeAdView.bodyView as? UILabel)?.text = nativeAd.body
        nativeAdView.bodyView?.isHidden = nativeAd.body == nil
        
        (nativeAdView.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)
        nativeAdView.callToActionView?.isHidden = nativeAd.callToAction == nil
        
        (nativeAdView.iconView as? UIImageView)?.image = nativeAd.icon?.image
        nativeAdView.iconView?.isHidden = nativeAd.icon == nil
        
        (nativeAdView.starRatingView as? UIImageView)?.image = imageOfStars(from: nativeAd.starRating)
        nativeAdView.starRatingView?.isHidden = nativeAd.starRating == nil
        
        (nativeAdView.storeView as? UILabel)?.text = nativeAd.store
        nativeAdView.storeView?.isHidden = nativeAd.store == nil
        
        (nativeAdView.priceView as? UILabel)?.text = nativeAd.price
        nativeAdView.priceView?.isHidden = nativeAd.price == nil
        
        (nativeAdView.advertiserView as? UILabel)?.text = nativeAd.advertiser
        nativeAdView.advertiserView?.isHidden = nativeAd.advertiser == nil
        
        nativeAdView.callToActionView?.isUserInteractionEnabled = false
        
        nativeAdView.nativeAd = nativeAd
    }
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        print("\(adLoader) failed with error: \(error.localizedDescription)")
    }
}

// MARK: - GADNativeAdDelegate implementation

extension GADNativeViewController: GADNativeAdDelegate {
    
    func nativeAdDidRecordClick(_ nativeAd: GADNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdDidRecordImpression(_ nativeAd: GADNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdWillPresentScreen(_ nativeAd: GADNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdWillDismissScreen(_ nativeAd: GADNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdDidDismissScreen(_ nativeAd: GADNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdIsMuted(_ nativeAd: GADNativeAd) {
        print("\(#function) called")
    }
}

//MARK: Para mostrar o NativeAD, basta chamar essa view.
struct NativeAdView : UIViewControllerRepresentable {

  func makeUIViewController(context: Context) -> UIViewController {
    let viewController = GADNativeViewController()
    return viewController
  }

  func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }

}
