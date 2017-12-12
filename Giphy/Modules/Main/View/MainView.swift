//
//  MainView.swift
//  Giphy
//
//  Created by Andrei Momot on 12/1/17.
//  Copyright © 2017 Andrey Momot. All rights reserved.
//

import UIKit

public protocol MainViewDelegate: NSObjectProtocol {}

public protocol MainViewProtocol: NSObjectProtocol {

    weak var delegate: MainViewDelegate? { get set }
    var collectionView: UICollectionView! { get }
    var searchBar: UISearchBar! { get }
    func showNoResult()
    func hideNoResult()
}

public class MainView: UIView, MainViewProtocol{

    // MARK: - MainView interface methods

    weak public var delegate: MainViewDelegate?
    
    @IBOutlet public var searchBar: UISearchBar!
    @IBOutlet public var collectionView: UICollectionView!
    @IBOutlet var noResultLabel: UILabel!
    
    // add view private properties/outlets/methods here
    public func showNoResult() {
        self.noResultLabel.isHidden = false
    }
    
    public func hideNoResult() {
        self.noResultLabel.isHidden = true
    }
    
    // MARK: - Overrided methods

    override public func awakeFromNib() {
        super.awakeFromNib()
        self.noResultLabel.isHidden = true
        // setup view and table view programmatically here
    }
}
