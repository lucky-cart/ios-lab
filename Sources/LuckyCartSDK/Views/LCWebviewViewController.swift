//
//  LCWebviewViewController.swift
//  
//
//  Created by Lucky Cart on 27/01/2023.
//

import UIKit
import WebKit

class LCWebviewViewController: UIViewController {
    
    static func controller() -> LCWebviewViewController {
        let viewController = UIStoryboard(name: "LCWebviewViewController", bundle: Bundle.module).instantiateInitialViewController() as! LCWebviewViewController
        return viewController
    }

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshWebview()
    }
    
    var webUrl: URL? {
        didSet {
            refreshWebview()
        }
    }
    
    func refreshWebview() {
        guard let webUrl = webUrl else { return }
        
        let request = URLRequest(url: webUrl)
        webView?.load(request)
    }
    

}
