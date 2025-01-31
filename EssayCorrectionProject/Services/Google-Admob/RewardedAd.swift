//
//  RewardedAd.swift
//  EssayCorrectionProject
//
//  Created by Bruno Teodoro on 12/11/24.
//

import UIKit
import GoogleMobileAds
import SwiftUI

class RewardedAd: NSObject, GADFullScreenContentDelegate, ObservableObject {
    @Published var rewardedAd: GADRewardedAd? = nil
    @Published var isAdReady: Bool = false

    var rewardEarnedCallback: (() -> Void)?

    override init() {
        super.init()
        loadRewardedAd()
    }

    func loadRewardedAd() {
        rewardedAd = nil
        isAdReady = false
        
        let testAdUnitID = "ca-app-pub-3940256099942544/5224354917"
        GADRewardedAd.load(withAdUnitID: testAdUnitID, request: GADRequest()) { [weak self] ad, error in
            if let error = error {
                print("Failed to load rewarded ad with error: \(error.localizedDescription)")
                return
            }
            
            DispatchQueue.main.async {
                self?.rewardedAd = ad
                self?.rewardedAd?.fullScreenContentDelegate = self
                self?.isAdReady = true
                print("Rewarded ad loaded and ready.")
            }
        }
    }

    func displayRewardedAd() {
        guard isAdReady, let rewardedAd = rewardedAd else {
            print("Ad not ready for presentation.")
            return
        }

        DispatchQueue.main.async {
            if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
                var topController = rootViewController
                while let presentedVC = topController.presentedViewController {
                    topController = presentedVC
                }
                
                rewardedAd.present(fromRootViewController: topController) { [weak self] in
                    print("User rewarded with 1 reward item.")
                    self?.rewardEarnedCallback?()
                    self?.isAdReady = false
                    self?.loadRewardedAd()
                }
            } else {
                print("Failed to fetch the root view controller.")
            }
        }
    }
    
    func rewardedAdRetryMechanism() {
        if isAdReady {
            displayRewardedAd()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                self?.rewardedAdRetryMechanism()  
            }
        }
    }


    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Rewarded ad dismissed.")
        isAdReady = false
        loadRewardedAd()
    }
}



