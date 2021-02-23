//
//  LocationListTableViewCell.swift
//  walkingDay
//
//  Created by HongInJun on 2021/02/23.
//

class LocationListTableViewCell: UITableViewCell {

    @IBOutlet var starBtn: UIButton!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var contentLbl: UILabel!
    @IBOutlet var deleteBtn: UIButton!
    
    var delegate: UIViewController?
    var alert: UIAlertController!
    
    var starButtonTapHandler: (() -> Void)?
    var deleteButtonTapHandler: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellset()
    }
    
    func cellset() {
        titleLbl.font = UIFont().bold18
        contentLbl.font = UIFont().regular14
        contentLbl.textColor = UIColor().textColor555555
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func starBtnAction(_ sender: UIButton) {
        starButtonTapHandler!()
    }
    
    @IBAction func deleteBtnAction(_ sender: UIButton) {
        //deleteButton 처리
        let message = "삭제하시겠습니까?"
        let alert = UIAlertController(title: "리스트 삭제", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .default, handler: nil)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive, handler: { _ in  self.deleteButtonTapHandler?()})
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        delegate!.present(alert, animated: true, completion: nil)
    }
    
    
}
