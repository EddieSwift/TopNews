//
//  Article.swift
//  TopNews
//
//  Created by Eduard Galchenko on 7/9/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

import UIKit

class Article: NSObject {
    
    let title : String
    let desc : String
    let image : String
    let url : URL
    
    init(title: String, desc: String, image: String, url: URL) {
        self.title = title
        self.desc = desc
        self.image = image
        self.url = url
    }
}
