//
//  LCBannerView.swift
//  
//
//  Created by Lucky Cart on 27/01/2023.
//

import UIKit
import SDWebImage

public class LCBannerView: LCView {

    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func setNewImageSize(image: UIImage?) -> CGSize {
        guard let image = image else { return CGSize.zero }

        let imageRatio = image.size.height / image.size.width
        let width = (bannerImageView?.frame.width ?? 0)
        let newHeight = width * imageRatio
        let newSize = CGSize(width: width, height: ceil(newHeight))
        bannerImageSize = newSize
        return newSize

    }

    private var bannerImageSize: CGSize = .zero {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.heightConstraint?.constant = self?.bannerImageSize.height ?? 0
            }
        }
    }
    
    public var bannerExperience: LCBannerExperience? {
        didSet {
            guard let bannerExperience = bannerExperience else { return }
            bannerImageView.sd_setImage(with: bannerExperience.imageUrl) { [weak self] image, error, cacheType, url in
                let _ = self?.setNewImageSize(image: image)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.025){
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LuckyCartBannerImageLoadedNotification"), object: nil)
                }
            }
        }
    }
    
    public var gameExperience: LCGamesExperience? {
        didSet {
            guard let gameExperience = gameExperience,
            let imageUrl = gameExperience.images?.mobileUrl else { return }
            bannerImageView.sd_setImage(with: imageUrl) { [weak self] image, error, cacheType, url in
                let _ = self?.setNewImageSize(image: image)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.025){
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LuckyCartBannerImageLoadedNotification"), object: nil)
                }
            }
        }
    }
    
    public var parentViewController: UIViewController?
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if let _ = bannerExperience {
            print("LUCKY CART :: BANNER VIEWED")
            let payload = LCEventPayload(pageType: pageType,
                                         pageId: pageId,
                                         bannerPosition: bannerExperience?.spaceId,
                                         operationId: bannerExperience?.operationId,
                                         storeType: storeType,
                                         storeId: storeId)
            LuckyCart.shared.sendShopperEvent(eventName: .bannerViewed, payload: payload) { isSended in
                print("LUCKY CART :: BANNER VIEWED EVENT :: OK")
            }
        }
    }
    
    public var pageId: String?
    public var pageType: String?
    public var storeId: String?
    public var storeType: String?
    
    @IBAction func didTapBannerView(_ sender: Any) {
        if let _ = bannerExperience {
            print("LUCKY CART :: BANNER CLICKED")
            let payload = LCEventPayload(pageType: pageType,
                                         pageId: pageId,
                                         bannerPosition: bannerExperience?.spaceId,
                                         operationId: bannerExperience?.operationId,
                                         storeType: storeType,
                                         storeId: storeId)
            LuckyCart.shared.sendShopperEvent(eventName: .bannerClicked, payload: payload) { isSended in
                print("LUCKY CART :: BANNER CLICKED EVENT :: OK")
            }
            
            if let shopInShopRedirectMobile = bannerExperience?.shopInShopRedirectMobile,
               let redirectRef = shopInShopRedirectMobile.ref {
                NotificationCenter.default.post(name: NSNotification.Name("LuckyCartBannerInShopAction"),
                                                object: nil,
                                                userInfo: ["shopInShopRedirectMobile" : redirectRef])
                print("LUCKY CART :: REDIRECT to \(redirectRef)")
            }
            else if let helpUrl = bannerExperience?.helpRedirect,
                    let parentViewController = parentViewController {
                let webViewHelpUrlController = LCWebviewViewController.controller()
                webViewHelpUrlController.webUrl = helpUrl
                if #available(iOS 15.0, *) {
                    if let sheet = webViewHelpUrlController.sheetPresentationController {
                        sheet.detents = [.medium(), .large()]
                        sheet.preferredCornerRadius = 20
                        sheet.prefersGrabberVisible = true
                    }
                }
                parentViewController.present(webViewHelpUrlController, animated: true)
                print("LUCKY CART :: REDIRECT to \(helpUrl)")
            }
        }
        else if let gameExperience = gameExperience,
                let experienceUrl = gameExperience.experienceUrl,
                let parentViewController = parentViewController {
            let webViewExperienceController = LCWebviewViewController.controller()
            webViewExperienceController.webUrl = experienceUrl
            if #available(iOS 15.0, *) {
                if let sheet = webViewExperienceController.sheetPresentationController {
                    sheet.detents = [.medium(), .large()]
                    sheet.preferredCornerRadius = 20
                    sheet.prefersGrabberVisible = true
                }
            }
            parentViewController.present(webViewExperienceController, animated: true)
        }
    }
}
