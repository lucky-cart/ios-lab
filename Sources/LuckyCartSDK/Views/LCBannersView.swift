//
//  LCBannersView.swift
//  
//
//  Created by Lucky Cart on 05/02/2023.
//

import UIKit

public class LCBannersView: LCView, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    public var pageId: String?
    public var pageType: String?
    public var storeId: String?
    public var storeType: String?
    
    public var bannerExperiences: [LCBannerExperience]? {
        didSet {
            guard let _ = bannerExperiences else { return }
            configureScrollView()
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    func configureScrollView() {
        let numberOfPages: Int = bannerExperiences?.count ?? 0
        let pageHeight: CGFloat = 191
        let pageWidth: CGFloat = UIScreen.main.bounds.width
        
        var x: CGFloat = 0
        
        for pageIndex in 0...(numberOfPages - 1) {
            let view = LCBannerView.load(owner: self)
            view.storeId = storeId
            view.pageId = pageId
            view.pageType = pageType
            view.storeType = storeType
            view.bannerExperience = bannerExperiences?[pageIndex]
            view.frame = CGRect(x: x, y: 0, width: pageWidth, height: pageHeight)
            scrollView.addSubview(view)
            x = view.frame.origin.x + pageWidth
        }
        
        scrollView.contentSize = CGSize(width: x, height: pageHeight)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.y = 0
    }
}
