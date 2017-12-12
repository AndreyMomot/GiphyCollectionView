//
//  MainViewController.swift
//  Giphy
//
//  Created by Andrei Momot on 12/1/17.
//  Copyright © 2017 Andrey Momot. All rights reserved.
//

import UIKit

public typealias MainViewControllerType = MVCViewController<MainModelProtocol, MainViewProtocol, MainRouter>

public class MainViewController: MainViewControllerType, UICollectionViewDelegate, UISearchBarDelegate {

    private var dataSource: MainDataSource!
    private let giphy = GiphyService()
    
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
    
    func searchWithText(text: String) {
        giphy.search(withTag: text, limit: 9, success: { (giphyUrls) in
            self.model.items = giphyUrls
            DispatchQueue.main.async {
                self.customView.collectionView.reloadData()
            }
        }) { (error) in
            print(error)
        }
    }
    
    // MARK: - SearchBar Delegate methods - do it with filteredItems
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchWithText(text: searchBar.text!)
        if self.model.items.count == 0 {
            self.customView.showNoResult()
        }
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.customView.hideNoResult()
        if searchText.count > 1 {
            searchWithText(text: searchText)
        }
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.model.items.removeAll()
        self.customView.collectionView.reloadData()
    }
}

// MARK: - MainViewDelegate

extension MainViewController: MainViewDelegate {}

// MARK: - MainModelDelegate

extension MainViewController: MainModelDelegate {}

// MARK: - MainCellDelegate

extension MainViewController: MainCellDelegate {}
