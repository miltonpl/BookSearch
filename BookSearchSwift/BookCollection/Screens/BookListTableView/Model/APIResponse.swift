//
//  APIResponse.swift
//  BookCollection
//
//  Created by Milton Palaguachi on 9/18/20.
//  Copyright © 2020 Milton. All rights reserved.
//

import Foundation

struct APIResponse: Decodable {
    
    var bookKind: String?
    var totalItems: Int?
    var items: [ItemInfo]?
    
    enum CodingKeys: String, CodingKey {
        case bookKind = "kind"
        case totalItems
        case items
    }
}
struct ItemInfo: Decodable {
    
    var itemKind: String?
    var itemId: String?
    var eTag: String?
    var selfLink: String?
    var volumeInfo: VolumeInfo?
    var accessInfo: AccessInfo?
    
    enum CodingKeys: String, CodingKey {
       case itemKind = "kind"
       case itemId = "id"
       case eTag = "etag"
       case selfLink
       case volumeInfo
       case accessInfo
       }
}

struct VolumeInfo: Decodable {
    var title: String?
    var subtitle: String?
    var authors: [String]?
    var pageCount: Int?
    var publisher: String?
    var publishedDate: String?
    var description: String?
    var averageRating: Double?
    var ratingsCount: Int?
    var language: String?
    var imageLinks: ImageLink?
    var previewLink: String?
}

struct ImageLink: Decodable {
    var smallThumbnail: String?
    var trumbnail: String?
    
}

struct AccessInfo: Decodable {
    var pdfInfo: PdfInfo?
    var webReaderLink: String?
    
    enum Codingkeys: String, CodingKey {
        case pdfInfo = "pdf"
        case webReaderLink
    }
}

struct PdfInfo: Decodable {
    var acsTokenLink: String?
}
