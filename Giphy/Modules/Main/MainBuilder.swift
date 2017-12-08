//
//  MainBuilder.swift
//  Giphy
//
//  Created by Andrei Momot on 12/1/17.
//  Copyright © 2017 Andrey Momot. All rights reserved.
//

import UIKit

public class MainBuilder: NSObject {

    public class func viewController() -> MainViewController {
        let view = MainView.create() as MainViewProtocol
        let model: MainModelProtocol = MainModel()
        let dataSource = MainDataSource(withModel: model)
        let router = MainRouter()

        let viewController = MainViewController(withView: view, model: model, router: router, dataSource: dataSource)
        return viewController
    }
}
