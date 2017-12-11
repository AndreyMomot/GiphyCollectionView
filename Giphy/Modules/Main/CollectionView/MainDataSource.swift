//
//  MainDataSource.swift
//  Giphy
//
//  Created by Andrei Momot on 12/1/17.
//  Copyright © 2017 Andrey Momot. All rights reserved.
//

import UIKit
import SDWebImage

class MainDataSource: NSObject, UICollectionViewDataSource {
    static let kCellIdentifier = "MainCollectionViewCell"

    weak var cellDelegate: MainCellDelegate?
    private let model: MainModelProtocol

    init(withModel model: MainModelProtocol) {
        self.model = model
    }

    func registerNibsForCollectionView(collectionView: UICollectionView) {
        let cellNib = UINib(nibName: String(describing: MainCollectionViewCell.self), bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: MainDataSource.kCellIdentifier)
    }

    // MARK: - Private methods

    public func configureCell(cell:AnyObject, gif: String) {
        
        guard cell is MainCollectionViewCell else {
            return
        }
        (cell as! MainCollectionViewCell).cellImageView.sd_setShowActivityIndicatorView(true)
        (cell as! MainCollectionViewCell).cellImageView.sd_setIndicatorStyle(.gray)
        let gifURL = URL(string: gif)
        (cell as! MainCollectionViewCell).cellImageView.sd_setImage(with: gifURL, placeholderImage: UIImage(named: "giphy_swift"), options: SDWebImageOptions.retryFailed) { (image, error, cacheType, url) in
            (cell as! MainCollectionViewCell).cellImageView.sd_setShowActivityIndicatorView(false)
        }
    }

    // MARK: - UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.model.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainDataSource.kCellIdentifier, for: indexPath)
        let imageURL = self.model.items[indexPath.row]
        self.configureCell(cell: cell, gif: imageURL)
        
        return cell
    }
}
