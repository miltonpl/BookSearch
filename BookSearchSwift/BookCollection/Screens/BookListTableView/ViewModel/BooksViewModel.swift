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
    func fetchData(query: String)
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
    
    func resetDataSource() {
        self.dataSource = []
    }
    // MARK: - Fetch Data From Server
    
    func fetchData(query: String) {
        DispatchQueue.main.async {
            self.delegate?.showLoader()
        }
        let strUrl = "\(Constants.api)\(Constants.endPoint)\(query)"
        guard let url = URL(string: strUrl) else { return }
        ServiceManager.manager.request(url: url) { (data, error) in
            guard let dataObj = data as? Data else { return }
            do {
                let responseObj = try JSONDecoder().decode(APIResponse.self, from: dataObj)
                DispatchQueue.main.async {
                    self.dataSource = responseObj.items ?? []
                    self.delegate?.hideLoader()
                }
                
            } catch {
                DispatchQueue.main.async {
                    self.delegate?.reloadFailure(error: error)
                    self.delegate?.hideLoader()
                }
            }
        }
    }
    
    func handleBookSearch(text: String) {
        self.fetchDataWorkItem?.cancel()
        self.fetchDataWorkItem = DispatchWorkItem.init(block: {
            self.fetchData(query: text)
        })
        
        guard let workItem = self.fetchDataWorkItem else { return }
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
