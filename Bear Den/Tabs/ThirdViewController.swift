//
//  ThirdViewController.swift
//  Bear Den
//
//  Created by Genevieve Garrison on 2/20/19.
//  Copyright © 2019 Gabaro 2019. All rights reserved.
//

import UIKit
import WebKit
class ThirdViewController: UIViewController, UIWebViewDelegate
{

    @IBOutlet weak var WebView: WKWebView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        WebView.uiDelegate = self as? WKUIDelegate
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear( animated )
        
        
        let urlString = "https://lcmhs.lcmcisd.org/page/page_calendar?calID=15947"
        let url = URL(string: urlString)
        let requ = URLRequest(url: url!)
        WebView.load(requ)
    }
    
    @IBAction func goFoward(_ sender: UIButton!) {
        print("Error 0")
        if (WebView.canGoForward){
            WebView.goForward()
        }
    }
    
    @IBAction func goBackward(_ sender: UIButton!) {
        print("Error 1")
        if(WebView.canGoBack){
            WebView.goBack()
        }
    }
    
    
}
