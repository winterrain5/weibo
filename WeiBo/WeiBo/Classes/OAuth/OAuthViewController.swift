//
//  OAuthViewController.swift
//  WeiBo
//
//  Created by 石冬冬 on 16/8/7.
//  Copyright © 2016年 sdd. All rights reserved.
//

import UIKit
import SVProgressHUD

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
    
    func webViewDidStartLoad(webView: UIWebView) {
        
        SVProgressHUD.showInfoWithStatus("加载中...")
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.Dark)
        
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        SVProgressHUD.dismiss()
        
    }
    
    func  webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        print(request)
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
        guard let str = request.URL!.query else {
            
            return false
        }
        if str.hasPrefix(key)
        {
            let code = str.substringFromIndex(key.endIndex)
            
            loadAccessToken(code)
            
            return false
        }
        return false ;
    }
    // 利用requestToken换取AccessToken
    private func loadAccessToken(codeStr:String?) {
        
        guard let code = codeStr else {
            
            return
        }
        
        let url = "oauth2/access_token"
        
        let parameters = ["client_id":"3117448573","client_secret":"be62a97f1ae78613ed3f5cba6ee4c9ba","grant_type":"authorization_code","code":code,"redirect_uri":"http://www.520it.com"]
        
        NetworkTool.shareInstance.POST(url, parameters: parameters, success:{ (task:NSURLSessionDataTask, objc:AnyObject?) -> Void in
            /*
            "access_token" = "2.001wXBtCbmUy5D3546e230b9Xd5pEE";
            "expires_in" = 157679999;
            "remind_in" = 157679999;
            uid = 2645332940;
            */
            
            print(objc)
            let userModel = UserAccountModel(dict: objc as! [String : AnyObject])
            print(userModel)
            userModel.saveAccount()
            // 获取用户信息
            userModel.loadUserInfo({ (account, error) -> () in
                
                account?.saveAccount()
                
            })
            
            }) { (task:NSURLSessionDataTask?, error:NSError) -> Void in
                
                print(error)
        }
    }
}