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
    var client: GPHClient!

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
        
        client = GPHClient(apiKey: SOCIAL.GIPHY_API_KEY)
        
//        if let img = UIImage.gif(url: "https://media.giphy.com/media/RMonqmwIZagbm/giphy.gif") {
//        self.model.items.append(img)
//            print(self.model.items.count)
//        }
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
     //   self.customView.keyboardAvoidingView = KeyboardAvoiding.avoidingView
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
    
    // ToDo: - Create API methods for search and others.
    func searchWithText(text: String) {
        client.search(text, media: .gif, offset: 0, limit: 9, rating: .ratedG, lang: .english) { (response, error) in
            
            if let error = error {
                print(error)
            } else {
                var ar: [String] = []
                if let result = response?.data {
                    for img in result {
                        if let url = img.images?.fixedHeightSmall?.gifUrl {
                            ar.append(url)
                            self.model.items = ar
                        }
                    }
                    ar.removeAll()
                    DispatchQueue.main.async {
                        self.customView.collectionView.reloadData()
                    }
                }
            }
        }
    }
    
    // MARK: - SearchBar Delegate methods - do it with filteredItems
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchWithText(text: searchBar.text!)
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 1 {
            searchWithText(text: searchText)
        }
    }
    
    // ToDo: - not working
    public func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        self.model.items.removeAll()
        self.customView.collectionView.reloadData()
    }
    
    // ToDo: - not working
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.model.items.removeAll()
        self.customView.collectionView.reloadData()
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
