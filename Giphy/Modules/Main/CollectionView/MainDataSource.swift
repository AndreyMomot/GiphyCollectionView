//
//  MainDataSource.swift
//  Giphy
//
//  Created by Andrei Momot on 12/1/17.
//  Copyright © 2017 Andrey Momot. All rights reserved.
//

import UIKit

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

    public func configureCell(cell:AnyObject) {
        guard cell is MainCollectionViewCell else {
            return
        }
        (cell as! MainCollectionViewCell).cellImageView.image = UIImage.gif(url: self.model.items.first!)
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
        self.configureCell(cell: cell)
        
        return cell
    }
}
