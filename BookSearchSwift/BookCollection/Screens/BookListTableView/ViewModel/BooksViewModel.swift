//
//  BooksViewModel.swift
//  BookCollection
//
//  Created by Milton Palaguachi on 11/16/20.
//  Copyright © 2020 Milton. All rights reserved.
//

import Foundation
protocol BooksviewModelProtocol: AnyObject {
    func reloadSuccess()
    func reloadFailure(error: Error)
    func hideLoader()
    func showLoader()
}

protocol BookListViewControllerProtocol {
    var fetchDataWorkItem: DispatchWorkItem? { get set }
    func handleBookSearch(text: String)
    func resetDataSource()
    func numberOfRow() -> Int
    func bookInfoAtIndex(indexAt row: Int) -> CellModel
    func bookSelectedAt(indexAt row: Int) -> VolumeInfoModel
    var delegate: BooksviewModelProtocol? { get }
}

class BooksViewModel: BookListViewControllerProtocol {
    
    var fetchDataWorkItem: DispatchWorkItem?
    weak var delegate: BooksviewModelProtocol?
    private var dataSource = [ItemInfo]() {
        didSet {
            self.delegate?.reloadSuccess()
        }
    }

    let service: BookSearchService

    init(service: BookSearchService) {
        self.service = service
    }

    func resetDataSource() {
        self.dataSource = []
    }

    // MARK: - Fetch Data From Server
    
    private func fetchData(query: String) {
        DispatchQueue.main.async {
            self.delegate?.showLoader()
        }

        service.search(query: query) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.dataSource = data.items ?? []
                    self.delegate?.hideLoader()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.delegate?.reloadFailure(error: error)
                    self.delegate?.hideLoader()
                }
            }
        }
    }

    func handleBookSearch(text: String) {
        fetchDataWorkItem?.cancel()
        fetchDataWorkItem = DispatchWorkItem.init(block: { [weak self] in
            self?.fetchData(query: text)
        })
        
        guard let workItem = fetchDataWorkItem else { return }
        DispatchQueue.global().asyncAfter(deadline: .now() + 3.0, execute: workItem)
    }
    
    func numberOfRow() -> Int {
        self.dataSource.count
    }
    
    func bookInfoAtIndex(indexAt row: Int) -> CellModel {
        guard let volume = dataSource[row].volumeInfo else { fatalError("Error getting volume info") }
        let url = URL(string: volume.imageLinks?.smallThumbnail ?? "")
        return CellModel(url: url, title: volume.title, subtitle: volume.subtitle)
    }
    
    func bookSelectedAt(indexAt row: Int) -> VolumeInfoModel {
        guard let volume = dataSource[row].volumeInfo else {
            fatalError("Unable to get Volume Info")
        }
        let model = VolumeInfoModel(volume: volume)
        
        return model
    }
}
