//
//  MainView.swift
//  Giphy
//
//  Created by Andrei Momot on 12/1/17.
//  Copyright © 2017 Andrey Momot. All rights reserved.
//

import UIKit

public protocol MainViewDelegate: NSObjectProtocol {

    func viewSomeAction(view: MainViewProtocol)
}

public protocol MainViewProtocol: NSObjectProtocol {

    weak var delegate: MainViewDelegate? { get set }
    var collectionView: UICollectionView! { get }
    var searchBar: UISearchBar! { get }
}

public class MainView: UIView, MainViewProtocol{

    // MARK: - MainView interface methods

    weak public var delegate: MainViewDelegate?
    
    @IBOutlet public var searchBar: UISearchBar!
    @IBOutlet public var collectionView: UICollectionView!
    
    // add view private properties/outlets/methods here

    // MARK: - IBActions

    @IBAction func someButtonAction() {
        self.delegate?.viewSomeAction(view: self)
    }

    // MARK: - Overrided methods

    override public func awakeFromNib() {
        super.awakeFromNib()

        // setup view and table view programmatically here
    }
}
