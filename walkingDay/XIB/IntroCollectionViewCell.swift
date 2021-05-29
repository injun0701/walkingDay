//
//  IntroCollectionViewCell.swift
//  walkingDay
//
//  Created by HongInJun on 2021/02/27.
//

import UIKit

class IntroCollectionViewCell: UICollectionViewCell {

    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var contentLbl: UILabel!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var btn01: UIButton!
    @IBOutlet var btn02: UIButton!
    
    var btn01TapHandler: (() -> Void)?
    var btn02TapHandler: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func btn01Action(_ sender: UIButton) {
        btn01TapHandler?()
    }
    
    @IBAction func btn02Action(_ sender: UIButton) {
        btn02TapHandler?()
    }
}
