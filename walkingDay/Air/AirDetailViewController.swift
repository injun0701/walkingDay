//
//  AirDetailViewController.swift
//  walkingDay
//
//  Created by HongInJun on 2021/02/25.
//

import UIKit

class AirDetailViewController: UIViewController {

    @IBOutlet var cityTitleLbl: UILabel!
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var airImgView: UIImageView!
    @IBOutlet var gradeLbl: UILabel!
    @IBOutlet var contentLbl: UILabel!
    @IBOutlet var airCollectionView: UICollectionView!
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func hambergerMenuBtnAction(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Menu", bundle: nil)
        let navi = sb.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        navi.backingImage = self.view.asImage() //현재 화면 캡쳐 이미지
        navigationController?.pushViewController(navi, animated: false)
    }
    
    var cityTitle = ""
    
    //걸음 수 배열
    var air : [AirModle] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        airSet()
        dateLblSet(lbl: dateLbl)
        airCollectionViewSet()
        airCollectionViewData() 
    }
    
    //날씨 배경 이미지 세팅
    func airSet() {
        cityTitleLbl.text = cityTitle
        let ad = UIApplication.shared.delegate as? AppDelegate
        if ad?.pm10Grade == "좋음" {
            gifSet(gifName: "dust01@3x.gif", imgView: airImgView)
            gradeLbl.text = "좋음"
            contentLbl.text = "오늘은 공기가 매우 깨끗해요.  밖에 나가서 놀아볼까요?"
        } else if ad?.pm10Grade == "보통" {
            gifSet(gifName: "dust02@3x.gif", imgView: airImgView)
            gradeLbl.text = "보통"
            contentLbl.text = "미세먼지가 별로 없네요.  산책 다니기 좋아요!"
        } else if ad?.pm10Grade == "나쁨" {
            gifSet(gifName: "dust03@3x.gif", imgView: airImgView)
            gradeLbl.text = "나쁨"
            contentLbl.text = "미세먼지가 좀 있네요.  마스크 필수에요!"
        } else {
            gifSet(gifName: "dust04@3x.gif", imgView: airImgView)
            gradeLbl.text = "매우 나쁨"
            contentLbl.text = "오늘은 미세먼지가 많이 있네요.  환기 시키면 안돼요!"
        }
    }
    
    //컬랙션뷰 세팅
    func airCollectionViewSet() {
        airCollectionView.delegate = self
        airCollectionView.dataSource = self
        airCollectionView.decelerationRate = .fast
        airCollectionView.isPagingEnabled = false
        airCollectionView.register(UINib(nibName: "AirDetailCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AirDetailCollectionViewCell")
    }
    
    //컬랙션뷰 데이터 세팅
    func airCollectionViewData() {
        let ad = UIApplication.shared.delegate as? AppDelegate
        air = [
            AirModle(title: "미세먼지", grade: ad!.pm10Grade, value: ad!.pm10Value),
            AirModle(title: "초미세먼지", grade: ad!.pm25Grade, value: ad!.pm25Value),
            AirModle(title: "이산화질소", grade: ad!.no2Grade, value: ad!.no2Value),
            AirModle(title: "오존", grade: ad!.o3Grade, value: ad!.o3Value),
            AirModle(title: "일산화탄소", grade: ad!.coGrade, value: ad!.coValue),
            AirModle(title: "이황산가스", grade: ad!.so2Grade, value: ad!.so2Value)
        ]
    }
}

//MARK: 콜렉션뷰 구현
extension AirDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return air.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AirDetailCollectionViewCell", for: indexPath) as? AirDetailCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.titleLbl.text = air[indexPath.row].title
        cell.gradeLbl.text = air[indexPath.row].grade
        
        if air[indexPath.row].grade == "좋음" {
            cell.gradeImgView.image = UIImage(named: "dust_ico01")
        } else if air[indexPath.row].grade == "보통" {
            cell.gradeImgView.image = UIImage(named: "dust_ico02")
        } else if air[indexPath.row].grade == "나쁨" {
            cell.gradeImgView.image = UIImage(named: "dust_ico03")
        } else {
            cell.gradeImgView.image = UIImage(named: "dust_ico04")
        }
        
        cell.valueLbl.text = air[indexPath.row].value
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = Int((UIScreen.main.bounds.width-40)/3)
        let height = Int(Double(UIScreen.main.bounds.width)/3 * 1.2)
        return CGSize(width: width, height: height)
    }
    
}

struct AirModle {
    var title: String
    var grade: String
    var value: String
    
    init(title: String, grade: String, value: String) {
        self.title = title
        self.grade = grade
        self.value = value
    }
}
