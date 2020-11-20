//
//  CellViewModel.swift
//  BookCollection
//
//  Created by Milton Palaguachi on 11/16/20.
//  Copyright © 2020 Milton. All rights reserved.
//

import Foundation
protocol CellModelProtocol {
    var studentId: Int32? { get }
    var url: URL? { get}
    var title: String? { get}
    var subtitle: String? { get}
}

struct CellModel: CellModelProtocol {
    var url: URL?
    var title: String?
    var subtitle: String?
    var studentId: Int32?
}
