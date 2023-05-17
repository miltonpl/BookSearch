//
//  MyFavoritesViewController.swift
//  BookCollection
//
//  Created by Milton Palaguachi on 11/17/20.
//  Copyright © 2020 Milton. All rights reserved.
//

import UIKit

class FavoritesBookInfoViewController: UIViewController {

    @IBOutlet private weak var collectionView: UICollectionView!
    var volumes: [VolumeInfoModel] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    private var itemsPerRow: CGFloat = 2.0
    private var edgeInset = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Collection"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.loadDadabase()
        self.collectionView.register(VolumeCollectionViewCell.nib(), forCellWithReuseIdentifier: VolumeCollectionViewCell.identifier)
    }
    
    func loadDadabase() {
        do {
            self.volumes = try DBManager.shared.read()
            print("count volumes: ", self.volumes.count)
        } catch {
            print("error - \(error)")
        }
    }
    
    func removeAllVolues(_ sender: UIBarButtonItem) {
        self.showAlert()
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Delete All Book Info", message: "Are you sure? you want to delete all book info", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete All", style: .destructive, handler: { [unowned self] _ in
            self.volumes = []
            do {
                try DBManager.shared.deleteAll()
            } catch {
                print(error)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDelegate
// cell.configure(model: self.modelView.bookInfoAtIndex(indexAt: indexPath.row))

extension FavoritesBookInfoViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let detailVC = storyboard.instantiateViewController(identifier: "BookDetailsViewController") as? BookDetailsViewController else { fatalError("Unable to instantiate Viewcontroller") }
        
        detailVC.volumeInfo = self.volumes[indexPath.row]
        let navViewController = UINavigationController(rootViewController: detailVC)
        self.navigationController?.present(navViewController, animated: true, completion: nil)
//        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension FavoritesBookInfoViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.volumes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt
        indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VolumeCollectionViewCell", for: indexPath) as? VolumeCollectionViewCell else {
                fatalError("Unable to dequeueReusableCell in VolumeCollectionView")
        }
        let url = URL(string: self.volumes[indexPath.row].bookImageUrl ?? "")
        
        let model = CellModel(url: url, title: self.volumes[indexPath.row].title, subtitle: self.volumes[indexPath.row].subtitle, studentId: self.volumes[indexPath.row].identifier)
        cell.configure(model: model)
        cell.delegate = self
        return cell
    }
}

// MARK: - UICollectionView FlowLayout

extension FavoritesBookInfoViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = self.edgeInset.left * (self.itemsPerRow + 1)
        let availableWith = view.frame.width - paddingSpace
        let widthPerItem = availableWith/self.itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem * 1.5)
        
//        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return .zero}
//       let insets = flowLayout.sectionInset
//        let padding = self.edgeInset.left + self.edgeInset.right + flowLayout.minimumLineSpacing * (self.itemsPerRow - 1.0)
//        let size = (collectionView.frame.width - padding)/self.itemsPerRow
//        return CGSize(width: size, height: size*1.25)
    }
}
// MARK: - Volume CollectionView Cell Delegate
extension FavoritesBookInfoViewController: VolumeCollectionViewCellDelegate {
    
    // MARK: - Remove Volume From Database
    func removeVolume(studentId: Int32) {
        do {
            print("try to removed")
            try DBManager.shared.delete(whereId: studentId)
            self.loadDadabase()
            
        } catch {
            print("error - \(error)")
            
        }
    }
}
