//
//  MainTableViewCell.swift
//  Giphy
//
//  Created by Andrei Momot on 12/1/17.
//  Copyright © 2017 Andrey Momot. All rights reserved.
//

import UIKit
import SDWebImage

class MainCollectionViewCell: UICollectionViewCell {

    weak var delegate: MainCellDelegate?
    @IBOutlet var cellImageView: FLAnimatedImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}


protocol MainCellDelegate: NSObjectProtocol {}
