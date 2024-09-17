//
//  ViewController.swift
//  Social Network
//
//  Created by Alex on 23.06.2021.
//

import UIKit
import Alamofire
import WebKit
import SwiftKeychainWrapper


class ViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView! {
        didSet{
            webView.navigationDelegate = self
            if let token = KeychainWrapper.standard.string(forKey: "token"){
                Session.shared.token1 = token
                showMainTabBar()
                return
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    autorization()
        

    }
    func autorization() {
        var urlComponents = URLComponents()
                urlComponents.scheme = "https"
                urlComponents.host = "oauth.vk.com"
                urlComponents.path = "/authorize"
                urlComponents.queryItems = [
                    URLQueryItem(name: "client_id", value: "7822904"),
                    URLQueryItem(name: "display", value: "mobile"),
                    URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
                    URLQueryItem(name: "scope", value: "262150"),
                    URLQueryItem(name: "response_type", value: "token"),
                    URLQueryItem(name: "v", value: "5.68")
                ]
                
                let request = URLRequest(url: urlComponents.url!)
                
        webView.load(request)
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
            
            guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment  else {
                
                decisionHandler(.allow)
                return
            }
            
            let params = fragment
                .components(separatedBy: "&")
                .map { $0.components(separatedBy: "=") }
                .reduce([String: String]()) { result, param in
                    var dict = result
                    let key = param[0]
                    let value = param[1]
                    dict[key] = value
                    return dict
            }
            
        if let token2 = params["access_token"], let userId = params["user_id"] { print("TOKEN = ", token2 as Any)
            Session.shared.token1  = token2
            Session.shared.userID = userId
            showMainTabBar()

        }
            
            decisionHandler(.cancel)
                }
    func showMainTabBar () {
        performSegue(withIdentifier: "showMainView", sender: nil)
    }
   
}


