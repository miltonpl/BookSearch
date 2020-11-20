//
//  VolumeInfoModel.swift
//  BookCollection
//
//  Created by Milton Palaguachi on 11/17/20.
//  Copyright © 2020 Milton. All rights reserved.
//

import Foundation

struct VolumeInfoModel: Decodable {
    var identifier: Int32 = 0
    var authors: String?
    var title: String?
    var subtitle: String?
    var pageCount: Int?
    var publisher: String?
    var publishedDate: String?
    var description: String?
    var averageRating: Double?
    var ratingsCount: Int?
    var language: String?
    var previewLink: String?
    var bookImageUrl: String?
    
    init(volume: VolumeInfo?) {
        self.authors = volume?.authors?.first
        self.title = volume?.title
        self.subtitle = volume?.subtitle
        self.pageCount = volume?.pageCount
        self.publisher = volume?.publisher
        self.publishedDate = volume?.publishedDate
        self.description = volume?.description
        self.previewLink = volume?.previewLink
        self.language = volume?.language
        self.bookImageUrl = volume?.imageLinks?.smallThumbnail
        self.ratingsCount = volume?.ratingsCount
        self.averageRating = volume?.averageRating
    }
}
