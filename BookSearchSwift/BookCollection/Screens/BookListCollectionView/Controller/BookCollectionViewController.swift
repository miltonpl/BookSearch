//
//  BookCollectionViewController.swift
//  BookCollection
//
//  Created by Milton Palaguachi on 9/23/20.
//  Copyright © 2020 Milton. All rights reserved.
//

import UIKit

class BookCollectionViewController: UIViewController {
    
    // MARK: - IBOutles Declaration
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: - Store Private Properties
    private var modelView = BooksViewModel()
    private var itemsPerRow: CGFloat = 2.0
    private var sectionInset = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.backgroundColor = .white
        self.modelView.delegate = self
        self.title = "Collection View"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.searchBar.delegate = self
        self.searchBar.showsCancelButton = true
        self.searchBar.placeholder = "book search"
        self.setupItemTabBar()
    }
    
    func setupItemTabBar() {
        let favoties = UIBarButtonItem(title: "Favorites", style: .plain, target: self, action: #selector(goToMyFavorites(_:)))
        self.navigationItem.rightBarButtonItem = favoties
    }
    // MARK: - Go to Favorite View Controller
    @objc func goToMyFavorites(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let favoriteViewController = storyboard.instantiateViewController(identifier: "FavoritesBookInfoViewController") as? FavoritesBookInfoViewController else {
            fatalError("Unable to instantiate view controller with identifier: FavoritesBookInfoViewController")
        }
        
        self.navigationController?.pushViewController(favoriteViewController, animated: true)
    }
}

// MARK: - UICollectionViewDelegate

extension BookCollectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard  let detailVC = storyboard.instantiateViewController(identifier: "BookDetailsViewController") as? BookDetailsViewController else { fatalError("Unable to instantiate Viewcontroller") }
        
        detailVC.volumeInfo = self.modelView.bookSelectedAt(indexAt: indexPath.row)
        let navController = UINavigationController(rootViewController: detailVC)
        self.navigationController?.present(navController, animated: true, completion: nil)
    }
}

// MARK: - UICollectionView DataSource

extension BookCollectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.modelView.numberOfRow()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt
                            indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCoverCollectionViewCell", for: indexPath) as? BookCoverCollectionViewCell else {
            fatalError("Unable to dequeueReusableCell in CollectionView")
        }
        cell.configure(model: self.modelView.bookInfoAtIndex(indexAt: indexPath.row))
        return cell
    }
}

// MARK: - UICollectionView FlowLayout

extension BookCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return .zero}
        let insets = flowLayout.sectionInset
        let numberOfCell: CGFloat = 2.0
        let padding = insets.left + insets.right + flowLayout.minimumLineSpacing * (numberOfCell - 1.0)
        let size = (collectionView.frame.width - padding)/numberOfCell
        return CGSize(width: size, height: size * 1.5)
        //        let paddingSpace = self.sectionInset.left * (self.itemsPerRow + 1)
        //        let availableWith = view.frame.width - paddingSpace
        //        let widthPerItem = availableWith/self.itemsPerRow
        //        return CGSize(width: widthPerItem, height: widthPerItem * 1.5)
    }
}

// MARK: - Books ViewModel Protocol
extension BookCollectionViewController: BooksviewModelProtocol {
    
    func reloadSuccess() {
        self.collectionView.reloadData()
    }
    func reloadFailure(error: Error) {
        print("error - \(error)")
    }
    
    func hideLoader() {
        self.removeSpinner()
    }
    
    func showLoader() {
        self.showSpinner()
    }
}
// MARK: - Search Bar Delegate
extension BookCollectionViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.text = nil
        self.searchBar.placeholder = "book search"
        self.modelView.resetDataSource()
    }
    
    // MARK: - Text Entered By User
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            self.searchBar.text = nil
            self.searchBar.placeholder = "book search"
            self.modelView.resetDataSource()
            return
        }
        
        if searchText.count >= 4 {
            let text = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
            if let queryUrl = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                self.modelView.handleBookSearch(text: queryUrl)
            }
        }
    }
}
