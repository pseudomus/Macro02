//
//  RewardedAd.swift
//  EssayCorrectionProject
//
//  Created by Bruno Teodoro on 12/11/24.
//

import UIKit
import GoogleMobileAds

class RewardedAd: NSObject, GADFullScreenContentDelegate, ObservableObject {
    @Published var rewardedAd: GADRewardedAd?
    //MARK: Essa é a função chamada quando o usuário assiste o vídeo até o final.
    var rewardEarnedCallback: (() -> Void)?

    override init() {
        super.init()
        loadRewardedAd()
    }

    func loadRewardedAd() {
        rewardedAd = nil
        let testAdUnitID = "ca-app-pub-3940256099942544/5224354917"
        
        GADRewardedAd.load(withAdUnitID: testAdUnitID, request: GADRequest()) { [weak self] ad, error in
            if let error = error {
                print("Failed to load rewarded ad with error: \(error.localizedDescription)")
                return
            }
            self?.rewardedAd = ad
            self?.rewardedAd?.fullScreenContentDelegate = self
            print("Rewarded ad loaded.")
        }
    }
    
    //MARK: Para mostrar o add com recompensa, basta criar uma instância dessa classe e chamar essa função
    func displayRewardedAd() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            self.showRewardedAd(from: rootVC)
        }
    }

    func showRewardedAd(from rootViewController: UIViewController) {
        guard let rewardedAd = rewardedAd else {
            print("Rewarded ad wasn't ready.")
            return
        }
        
        rewardedAd.present(fromRootViewController: rootViewController) { [weak self] in
            print("User rewarded with 1 reward item.")
            self?.rewardEarnedCallback?()
        }
    }

    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Rewarded ad dismissed.")
        loadRewardedAd()
    }
}

