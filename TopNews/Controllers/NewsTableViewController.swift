//
//  NewsTableViewController.swift
//  TopNews
//
//  Created by Eduard Galchenko on 7/9/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

import UIKit
import WebKit
import SwiftyJSON
import Alamofire
import AlamofireImage

let imageCache = NSCache<NSString, UIImage>()
let apiKey = "dc0769aa155742cbba74a7cbc2f8dfc7"

// MARK: Alamofire Download Images
extension UIImageView {
    
    func loadImageUsingCacheWithUrlString(_ urlString: String) {
        
        self.image = nil
        
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            
            self.image = cachedImage
            return
        }
        
        Alamofire.request(urlString).responseImage { response in
            
            if let downloadedImage = response.result.value {
                
                imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                self.image = downloadedImage
            }
        }
    }
}

class NewsTableViewController: UITableViewController, UISearchBarDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    
    let newsApiURL = "https://newsapi.org/v2/top-headlines?country=us&sortBy=popularity&apiKey=" + apiKey
    var articles = [Article]()
    var webView: WKWebView!
    var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = WKWebView()
        webView.navigationDelegate = self as? WKNavigationDelegate
        self.searchBar.delegate = self
        
        startAnimating()
        getJSON(newsApiURL)
    }
    
    // MARK: Network Methods
    func getJSON(_ apiUrl: String) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        Alamofire.request(apiUrl).responseJSON { response in
            
            if response.result.value != nil {
                
                let json = JSON(response.result.value!)
                let results = json["articles"].arrayValue
                
                for result in results {
                    
                    let article = Article(title: result["title"].stringValue,
                                          desc: result["description"].stringValue,
                                          image: result["urlToImage"].stringValue,
                                          url: result["url"].url!)
                    
                    self.articles.append(article)
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
                self.stopAnimating()
            }
        }
    }
    
    // MARK: Indicator Methods
    func startAnimating() {
        self.activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        self.activityIndicator.color = UIColor .blue
        view.addSubview(activityIndicator)
        self.activityIndicator.center = self.tableView.center
        self.activityIndicator.startAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func stopAnimating() {
        self.activityIndicator.stopAnimating()
        self.activityIndicator.removeFromSuperview()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    // MARK: - UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print(articles.count)
        
        
        let cell = Bundle.main.loadNibNamed("ArticleTableViewCell", owner: self, options: nil)?.first as! ArticleTableViewCell
        
        let article = self.articles[indexPath.row]
        
        cell.articleTitleLabel.text = article.title
        cell.articleDescriptionLabel.text = article.desc
        cell.articleImageView.loadImageUsingCacheWithUrlString(article.image)
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "sendUrlSegue", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100;
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "sendUrlSegue" {
            
            if let viewController = segue.destination as? ArticleViewController {
                let indexPath = self.tableView.indexPathForSelectedRow
                let article = self.articles[(indexPath?.row)!]
                viewController.url = article.url
            }
        }
    }
    
    // MARK: UISearchBarDelegate
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let searchString = searchBar.text {
            
            let newsApiURL = "https://newsapi.org/v2/everything?q=" + searchString + "&sortBy=popularity&apiKey=" + apiKey
            
            self.articles.removeAll()
            startAnimating()
            getJSON(newsApiURL)
            self.tableView.reloadData()
        }
        
        searchBar.resignFirstResponder()
    }
    
}
