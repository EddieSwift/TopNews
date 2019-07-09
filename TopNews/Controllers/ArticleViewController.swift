//
//  ArticleViewController.swift
//  TopNews
//
//  Created by Eduard Galchenko on 7/9/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

import UIKit
import WebKit

class ArticleViewController: UIViewController, WKNavigationDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var articleWebView: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var url: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.articleWebView.translatesAutoresizingMaskIntoConstraints = false
        articleWebView.navigationDelegate = self
        articleWebView.load(URLRequest(url: url))
        articleWebView.allowsBackForwardNavigationGestures = true
    }
    
    // MARK: WKNavigationDelegate
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        stopAnimating()
        print(error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        stopAnimating()
        print(error.localizedDescription)
    }
    
    // MARK: Indicator Methods
    func stopAnimating() {
        activityIndicator.stopAnimating()
        self.activityIndicator.hidesWhenStopped = true
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func startAnimating() {
        activityIndicator.startAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
}
