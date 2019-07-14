//
//  ArticleTableViewCell.swift
//  TopNews
//
//  Created by Eduard Galchenko on 7/9/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

import UIKit

final class ArticleTableViewCell: UITableViewCell {
    
    // MARK: Outlets
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var articleDescriptionLabel: UILabel!
    @IBOutlet weak var articleImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureWith(article: Article) {
        
        self.articleTitleLabel.text = article.title
        self.articleDescriptionLabel.text = article.desc
        self.articleImageView.loadImageUsingCacheWithUrlString(article.image)
    }
}
