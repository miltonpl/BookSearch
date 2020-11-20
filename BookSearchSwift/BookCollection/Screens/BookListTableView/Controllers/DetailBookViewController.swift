//
//  DetailBookViewController.swift
//  BookCollection
//
//  Created by Milton Palaguachi on 9/22/20.
//  Copyright © 2020 Milton. All rights reserved.
//

import UIKit

class DetailBookViewController: UIViewController {
    
    @IBOutlet private weak var bookImageView: UIImageView!
    @IBOutlet private weak var detailTableView: UITableView! {
        didSet {
            detailTableView.tableFooterView = UIView()
        }
    }
    private var activityIndicator = UIActivityIndicatorView(style: .large)
    
    private var previewLink: String?
    var volumeInfo: VolumeInfo?
    private var nameArray = [TitleLabel]() {
        didSet {
            detailTableView.reloadData()
            }
        }
    private var dictArray = [TitleLabel: String]() {
        didSet {
            detailTableView.reloadData()
            }
        }
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setProperties()
        self.setupDetailTableView()
        self.setupNavigationItem()
        }
    
    // MARK: - ViewDidAppear

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        self.activityIndicator.frame = self.bookImageView.bounds
        self.bookImageView.addSubview(activityIndicator)
        self.activityIndicator.color = .systemBlue
        self.activityIndicator.startAnimating()
        self.setupLink()
        self.downloadImage()
    }
        // MARK: - Set Properties
    @objc func webSearch (_ sender: UIBarButtonItem) {
        guard let url = URL(string: previewLink ?? "") else {return}
        
        UIApplication.shared.open(url)
    }
    
    // MARK: - Setup Right BarButtonItem

    private func setupNavigationItem() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: Constants.safariImage, style: .plain, target: self, action: #selector(webSearch(_:)))
    }
    
    // MARK: - Download Book Image

    private func downloadImage() {
        guard let thumbNail = volumeInfo?.imageLinks?.smallThumbnail, let url = URL(string: thumbNail) else { return }
        self.bookImageView.downloadImage(with: url)
        self.activityIndicator.stopAnimating()
        self.activityIndicator.removeFromSuperview()
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
                dictArray[.title] = title
                nameArray.append(.title)
            }
            if let subtitle = volume.subtitle {
                dictArray[.subtitle] = subtitle
                nameArray.append(.subtitle)
            }
            if let author = volume.authors {
                dictArray[.author] = author.joined(separator: " ")
                nameArray.append(.author)
            }
            if let publisher = volume.publisher {
                dictArray[.publisher] = publisher
                nameArray.append(.publisher)
            }
            if let publishedDate = volume.publishedDate {
                dictArray[.publishedDate] = publishedDate
                nameArray.append(.publishedDate)
            }
            if let description = volume.description {
                dictArray[.description] = description
                nameArray.append(.description)
            }
            if let count = volume.pageCount {
                dictArray[.pageCount] = "\(count)"
                nameArray.append(.pageCount)
            }
            if let averageRating = volume.averageRating {
                dictArray[.averageRating] = "\(averageRating)"
                nameArray.append(.averageRating)
            }
            if let language = volume.language {
                dictArray[.language] = language
                nameArray.append(.language)
            }
    }
    
    // MARK: - TableView Setup
    
    private func setupDetailTableView() {
        detailTableView.rowHeight = UITableView.automaticDimension
        detailTableView.estimatedRowHeight = 50
        detailTableView.allowsSelection = false
        detailTableView.tableFooterView = UIView()
    }
}
 // MARK: - UITableViewDataSource And UITableViewDelegate

extension DetailBookViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        nameArray.count
    }
    
    // MARK: - CellForRowAt Method
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = detailTableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as? DetailTableViewCell else {
            fatalError("Unable to dequeue DetailTableViewCell")
        }
        let type = nameArray[indexPath.row]
        guard let data = dictArray [type] else {fatalError("Fatal Erro")}
        let labelName = type.rawValue
        cell.setupProperties(name: labelName, data: data)
        return cell
    }
}
