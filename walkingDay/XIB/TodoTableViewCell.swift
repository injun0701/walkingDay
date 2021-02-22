//
//  TodoTableViewCell.swift
//  walkingDay
//
//  Created by HongInJun on 2021/02/15.
//

import RealmSwift

class TodoTableViewCell: UITableViewCell {

    @IBOutlet var categoryImg: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var memoLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var cellBackgroundView: UIView!
    
    var deleteButtonTapHandler: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellset()
    }
    
    func cellset() {
        titleLbl.font = UIFont().bold18
        timeLbl.font = UIFont().regular13
        timeLbl.textColor = UIColor().textColor888888
        memoLbl.font = UIFont().regular14
        memoLbl.textColor = UIColor().textColor555555
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    var delegate: UIViewController?
    var alert: UIAlertController!
    
    @IBAction func deleteButtonAction(_ sender: UIButton) {
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
