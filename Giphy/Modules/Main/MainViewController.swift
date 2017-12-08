//
//  MainViewController.swift
//  Giphy
//
//  Created by Andrei Momot on 12/1/17.
//  Copyright © 2017 Andrey Momot. All rights reserved.
//

import UIKit
import GiphyCoreSDK

public typealias MainViewControllerType = MVCViewController<MainModelProtocol, MainViewProtocol, MainRouter>

public class MainViewController: MainViewControllerType, UICollectionViewDelegate, UISearchBarDelegate {

    private var dataSource: MainDataSource!

    // MARK: - Initializers

    convenience init(withView view: MainViewProtocol, model: MainModelProtocol, router: MainRouter, dataSource: MainDataSource) {

        self.init(withView: view, model: model, router: router)

        self.model.delegate = self

        self.dataSource = dataSource
    }

    public required init(withView view: MainViewProtocol!, model: MainModelProtocol!, router: MainRouter?) {
        super.init(withView: view, model: model, router: router)
    }

    // MARK: - View life cycle

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.customView.delegate = self
        self.connectCollectionViewDependencies()
        self.customView.searchBar.delegate = self
        
//        if let img = UIImage.gif(url: "https://media.giphy.com/media/RMonqmwIZagbm/giphy.gif") {
//        self.model.items.append(img)
//            print(self.model.items.count)
//        }
    }

    private func connectCollectionViewDependencies() {

        self.customView.collectionView.delegate = self
        self.dataSource.registerNibsForCollectionView(collectionView: self.customView.collectionView)
        self.customView.collectionView.dataSource = self.dataSource
    }

    // MARK: - Table view delegate
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    // MARK: - SearchBar Delegate methods
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let client = GPHClient(apiKey: "AI4LvDzfyMwmJEwFDah4i6RtIHHezBvw")
        client.search(searchBar.text!) { (response, error) in
            if let error = error {
                print(error)
            } else {
                let result = response?.data
                for img in result! {
                    let url = img.url
                    self.model.items.append(url)
                }
                self.customView.collectionView.reloadData()
                let iii = self.model.items
                print(iii.count)
            }
        }
    }
}

// MARK: - MainViewDelegate

extension MainViewController: MainViewDelegate {

    public func viewSomeAction(view: MainViewProtocol) {
    }
}

// MARK: - MainModelDelegate

extension MainViewController: MainModelDelegate {

    public func modelDidChanged(model: MainModelProtocol) {
    }
}

// MARK: - MainCellDelegate

extension MainViewController: MainCellDelegate {

    func cellDidTapSomeButton(cell: MainCollectionViewCell) {
    }
}
