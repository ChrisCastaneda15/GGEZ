//
//  Articles.swift
//  PARSEAPITEST
//
//  Created by Chris Castaneda on 5/6/15.
//  Copyright (c) 2015 Chris Castaneda. All rights reserved.
//

import UIKit



class Article {
    var articleTitle: String
    var articleDateString: String
    var articleImage: String
    var articleURL: String
    var articleDate: NSDate
    
    init (title: String, date: String, image: String, url: String, date1: NSDate) {
        articleTitle = title;
        articleDateString = date;
        articleImage = image;
        articleURL = url;
        articleDate = date1;
    }
}
