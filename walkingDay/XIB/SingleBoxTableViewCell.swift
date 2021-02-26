//
//  SingleBoxTableViewCell.swift
//  walkingDay
//
//  Created by HongInJun on 2021/02/26.
//

import UIKit

class SingleBoxTableViewCell: UITableViewCell {
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
