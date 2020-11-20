// BookListViewController.swift
//  BookCollection
//
//  Created by Milton Palaguachi on 9/18/20.
//  Copyright © 2020 Milton. All rights reserved.
//
import UIKit

class BookListViewController: UIViewController {
    
    // MARK: - Outlet Store Properties
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Store Properties
    private var modelView = BooksViewModel()
    private lazy var activityIdicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .black
        activityIndicator.center = self.view.center
        return activityIndicator
    }()
    
    // MARK: - View Life Cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Table View"
        self.modelView.delegate = self
        self.setupItemTabBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = 150
        self.searchBar.showsCancelButton = true
        self.searchBar.delegate = self
        self.searchBar.placeholder = "book search"
    }
    
    func setupItemTabBar() {
        let favoties = UIBarButtonItem(title: "Favorites", style: .plain, target: self, action: #selector(goToMyFavorites(_:)))
        self.navigationItem.rightBarButtonItem = favoties
    }
    
    // MARK: - Go To Favotire View Controller
    @objc func goToMyFavorites(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let favoriteViewController = storyboard.instantiateViewController(identifier: "FavoritesBookInfoViewController") as? FavoritesBookInfoViewController else {
            fatalError("Unable to instantiate view controller with identifier: FavoritesBookInfoViewController")
        }
        self.navigationController?.pushViewController(favoriteViewController, animated: true)
    }
}
      
extension  BookListViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Cell For Row At Method
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as? ListTableViewCell  else { fatalError("Unable to dequeque cell") }
        cell.configure(model: self.modelView.bookInfoAtIndex(indexAt: indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.modelView.numberOfRow()
    }
    
    // MARK: - Did Select Row At Method
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard  let detailVC = storyboard.instantiateViewController(identifier: "BookDetailsViewController") as? BookDetailsViewController else { fatalError("unable to instantiateViewController") }
        detailVC.volumeInfo = self.modelView.bookSelectedAt(indexAt: indexPath.row)
        let navController = UINavigationController(rootViewController: detailVC)
        self.navigationController?.present(navController, animated: true, completion: nil)
    }
}

// MARK: - Book ViewModel Protocol
extension BookListViewController: BooksviewModelProtocol {
    
    func reloadSuccess() {
        self.tableView.reloadData()
    }
    
    func reloadFailure(error: Error) {
        print("error -\(error.localizedDescription)")
    }
    
    func hideLoader() {
        self.activityIdicator.stopAnimating()
        self.activityIdicator.removeFromSuperview()
    }
    
    func showLoader() {
        self.activityIdicator.startAnimating()
        self.view.addSubview(self.activityIdicator)
    }
}
// MARK: - Search Bar Delegation
extension BookListViewController: UISearchBarDelegate {
    
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
