//
//  MachineCollectionViewCell.swift
//  ARObjectDetection
//
//  Created by Bahadır Enes Atay on 16.05.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import UIKit

class MachineCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var subView: UIView!
    
    @IBOutlet weak var typeHeader: UILabel!
    @IBOutlet weak var nameHeader: UILabel!
    @IBOutlet weak var serialNoHeader: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var serialNoLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
