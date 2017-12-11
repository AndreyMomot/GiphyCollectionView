//
//  MainModel.swift
//  Giphy
//
//  Created by Andrei Momot on 12/1/17.
//  Copyright © 2017 Andrey Momot. All rights reserved.
//

import UIKit

public protocol MainModelDelegate: NSObjectProtocol {

    func modelDidChanged(model: MainModelProtocol)
}

public protocol MainModelProtocol: NSObjectProtocol {

    weak var delegate: MainModelDelegate? { get set }
    var items: [String] { get set }
}

public class MainModel: NSObject, MainModelProtocol {

    override init() {
        self.items = []
        super.init()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - MainModel methods

    weak public var delegate: MainModelDelegate?
    public var items: [String]

    /** Implement MainModel methods here */


    // MARK: - Private methods

    /** Implement private methods here */

}
