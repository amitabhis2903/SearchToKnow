//
//  Content.swift
//  SearchToKnow
//
//  Created by A on 12/07/19.
//  Copyright © 2019 A. All rights reserved.
//

import Foundation

struct TitleInfo: Decodable {
    let thumbnail: Thumbnail?
    let content_urls: Mobile?
    let extract: String?
}


struct Thumbnail: Decodable {
    let source: String?
}

struct Mobile: Decodable {
    let mobile: Pages?
}


struct Pages: Decodable {
    let page: String?
}
