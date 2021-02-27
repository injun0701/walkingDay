//
//  SingleTableViewCell.swift
//  walkingDay
//
//  Created by HongInJun on 2021/02/20.
//

class SingleTableViewCell: UITableViewCell {
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var contentLbl: UILabel!
    @IBOutlet var leftImgView: UIImageView!
    @IBOutlet var rightImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellset()
    }
    
    func cellset() {
        titleLbl.font = UIFont().regular16
        titleLbl.textColor = UIColor().textColor555555
        contentLbl.font = UIFont().regular16
        contentLbl.textColor = UIColor().textColor555555
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
