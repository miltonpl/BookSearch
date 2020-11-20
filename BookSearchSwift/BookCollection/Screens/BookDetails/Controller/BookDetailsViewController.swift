//
//  BookDetailsViewController.swift
//  BookCollection
//
//  Created by Milton Palaguachi on 11/16/20.
//  Copyright © 2020 Milton. All rights reserved.
//

import UIKit

class BookDetailsViewController: UIViewController {
    
    @IBOutlet private weak var bookImageView: UIImageView!
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.tableFooterView = UIView()
            self.tableView.register(DetailTableViewCell.nib(), forCellReuseIdentifier: DetailTableViewCell.identifier)
        }
    }
        
    private var previewLink: String?
    var volumeInfo: VolumeInfoModel?
    typealias Detail = (type: DetailType, info: String)
    private var bookDetils: [Detail] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setProperties()
        self.setupDetailTableView()
        self.setupNavigationItem()
        self.downloadImage()
    }
    
    // MARK: - ViewDidAppear
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.setupLink()
    }
    
    // MARK: - Set Properties
    @objc func webSearch (_ sender: UIBarButtonItem) {
        guard let url = URL(string: previewLink ?? "") else {return}
        
        UIApplication.shared.open(url)
    }
    
    // MARK: - Setup Right BarButtonItem
    
    private func setupNavigationItem() {
        
        let safari = UIBarButtonItem(image: Constants.safariImage, style: .plain, target: self, action: #selector(webSearch(_:)))
        let save = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveVolumeToDadaBase(_:)))
        self.navigationItem.rightBarButtonItems = [save, safari]
    }
    
    // MARK: - Download Book Image
    
    private func downloadImage() {
        guard let thumbNail = volumeInfo?.bookImageUrl, let url = URL(string: thumbNail) else { return }
        self.bookImageView.downloadImage(with: url)
    }
    
    @objc func saveVolumeToDadaBase(_ sender: UIBarButtonItem) {
        if let volume = self.volumeInfo {
            do {
                try DBManager.shared.insert(volume: volume)
            } catch {
                print("error - \(error)")
            }
        }
        
    }
    
    // MARK: - Setup Link for book
    
    private func setupLink() {
        if let previewLink = volumeInfo?.previewLink {
            self.previewLink = previewLink
        }
    }
    
    // MARK: - Append Data to dictArray
    
    private func setProperties() {
        
        guard let volume = volumeInfo else { return }
        if let title = volume.title {
            self.bookDetils.append((.title, title))
        }
        if let subtitle = volume.subtitle {
            self.bookDetils.append((.subtitle, subtitle))
        }
        
        if let author = volume.authors {
            self.bookDetils.append((.author, author))
        }
        
        if let publisher = volume.publisher {
            self.bookDetils.append((.publisher, publisher ))
        }
        
        if let publishedDate = volume.publishedDate {
            self.bookDetils.append((.publishedDate, publishedDate))
        }
        
        if let description = volume.description {
            self.bookDetils.append((.description, description ))
        }
        
        if let count = volume.pageCount {
            self.bookDetils.append((.pageCount, "\(count)" ))
        }
        
        if let averageRating = volume.averageRating {
            self.bookDetils.append((.averageRating, "\(averageRating)" ))
        }
        
        if let language = volume.language {
            self.bookDetils.append((.language, language))
        }
    }
    
    // MARK: - TableView Setup
    
    private func setupDetailTableView() {
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 50
        self.tableView.allowsSelection = false
    }
}

// MARK: - UITableViewDataSource And UITableViewDelegate

extension BookDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.bookDetils.count
    }
    
    // MARK: - CellForRowAt Method
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let detail = self.bookDetils[indexPath.row]
        let cellModel = CellModel( title: detail.type.rawValue, subtitle: detail.info)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as? DetailTableViewCell else {
            fatalError("Unable to dequeue DetailTableViewCell")
        }
        cell.configure(model: cellModel)
        return cell
    }
}
