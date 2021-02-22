//
//  SingleTableViewCell.swift
//  walkingDay
//
//  Created by HongInJun on 2021/02/20.
//

import UIKit

class SingleTableViewCell: UITableViewCell {
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var titleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
