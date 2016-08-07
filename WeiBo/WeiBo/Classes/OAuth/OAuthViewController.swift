//
//  OAuthViewController.swift
//  WeiBo
//
//  Created by 石冬冬 on 16/8/7.
//  Copyright © 2016年 sdd. All rights reserved.
//

import UIKit

class OAuthViewController: UIViewController {
    @IBOutlet weak var customWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let urlStr = "https://api.weibo.com/oauth2/authorize?client_id=3117448573&redirect_uri=http://www.520it.com"
        guard let url = NSURL(string: urlStr) else {
            
            return;
        }
        
        let request = NSURLRequest(URL: url)
        
        customWebView.loadRequest(request)
    }
}
extension OAuthViewController:UIWebViewDelegate {
    
    func  webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        print(request.URL)
        // 判断当前是否是授权回调页
        guard let urlStr = request.URL?.absoluteString else {
            
            return false
        }
        
        if !urlStr.hasPrefix("http://www.520it.com")
        {
            
            return true
            
        }
        // 判断授权回调的地址中是否包含code=
        let key = "code="
        if urlStr.containsString(key)
        {
            let code = request.URL!.query?.substringFromIndex(key.endIndex)
            print("授权成功")
            
            return false
        }
        return false ;
    }
}