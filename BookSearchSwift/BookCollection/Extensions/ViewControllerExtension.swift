//
//  ExtensionFiles.swift
//  BookCollection
//
//  Created by Milton Palaguachi on 9/23/20.
//  Copyright © 2020 Milton. All rights reserved.

private var aView: UIView?
import UIKit
extension UIViewController {
    func showSpinner() {
        aView = UIView(frame: self.view.bounds)
//        aView?.backgroundColor = .systemBlue
        let activityIndicator = UIActivityIndicatorView(style: .large)
        guard let newView = aView else { fatalError("View unable to unwrapped in extetion")}
        activityIndicator.center = newView.center
        activityIndicator.startAnimating()
        newView.addSubview(activityIndicator)
        self.view.addSubview(newView)
    }
    
    func removeSpinner() {
        aView?.removeFromSuperview()
        aView = nil
    }
    
}
