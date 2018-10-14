//
//  Cell.swift
//  DropBall
//
//  Created by Vinitha Vijayan on 2/6/18.
//  Copyright © 2018 Vinitha Vijayan. All rights reserved.
//

import Foundation
import UIKit

class Cell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(data: String, row: Int) {
        switch data {
        case "x":
            label.backgroundColor = UIColor.clear
        case "*":
            label.backgroundColor = UIColor.red
        case "#":
            label.backgroundColor = UIColor.blue
        default:
            label.backgroundColor = UIColor.clear
        }
        
        if row == 0 {
            self.backgroundColor = UIColor.lightGray
        } else {
            self.backgroundColor = UIColor.clear
        }
    }
}
