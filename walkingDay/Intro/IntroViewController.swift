//
//  IntroViewController.swift
//  walkingDay
//
//  Created by HongInJun on 2021/02/27.
//

import UIKit

class IntroViewController: UIViewController {

    @IBOutlet var introCollectionView: UICollectionView!
    
    @IBOutlet var pageNum01: UIView!
    @IBOutlet var pageNum02: UIView!
    @IBOutlet var pageNum03: UIView!
    @IBOutlet var pageNum04: UIView!
    
    //걸음 수 배열
    var intro : [IntroModel] = []
    // 현재페이지 체크 변수 (스크롤할 때 필요)
    var nowPage: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        walkCollectionViewData()
        walkCollectionViewSet()
    }
    
    //컬랙션뷰 데이터 세팅
    func walkCollectionViewData() {
        
        intro = [
            IntroModel(title: "날씨와 미세먼지 정보를 한눈에!", content: "대기 정보를 체크하고 운동하세요.", img: "intro01"),
            IntroModel(title: "걸음 수를 확인하고 10000걸음을 채워보세요!", content: "자세히 보기를 통해 상세정보를 확인할 수 있어요.", img: "intro02"),
            IntroModel(title: "위치를 저장하고 체크해보세요!", content: "해당 지역을 선택해서 대기 정보를 알 수 있어요.", img: "intro03"),
            IntroModel(title: "운동한 내용을 입력해보세요!", content: "달력을 선택하여 운동한 내용을 저장할 수 있어요.", img: "intro04")
       
       ]
    }
    
    //컬랙션뷰 세팅
    func walkCollectionViewSet() {
        introCollectionView.delegate = self
        introCollectionView.dataSource = self
        introCollectionView.decelerationRate = .fast
        introCollectionView.isPagingEnabled = true
        introCollectionView.register(UINib(nibName: "IntroCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "IntroCollectionViewCell")
    }
 
    func introCollectionViewMoveToPrev() {
        // 다음 페이지로 전환
        nowPage -= 1
        introCollectionView.scrollToItem(at: NSIndexPath(item: nowPage, section: 0) as IndexPath, at: .right, animated: true)
    }
    
    func introCollectionViewMoveToNext() {
        // 다음 페이지로 전환
        nowPage += 1
        introCollectionView.scrollToItem(at: NSIndexPath(item: nowPage, section: 0) as IndexPath, at: .right, animated: true)
    }
    
    func nowPageCheck() {
        if nowPage == 0 {
            pageNum01.backgroundColor = UIColor().mainColorOrange
            pageNum02.backgroundColor = UIColor().colorEEEEEE
            pageNum03.backgroundColor = UIColor().colorEEEEEE
            pageNum04.backgroundColor = UIColor().colorEEEEEE
        } else if nowPage == 1 {
            pageNum01.backgroundColor = UIColor().colorEEEEEE
            pageNum02.backgroundColor = UIColor().mainColorOrange
            pageNum03.backgroundColor = UIColor().colorEEEEEE
            pageNum04.backgroundColor = UIColor().colorEEEEEE
        } else if nowPage == 2 {
            pageNum01.backgroundColor = UIColor().colorEEEEEE
            pageNum02.backgroundColor = UIColor().colorEEEEEE
            pageNum03.backgroundColor = UIColor().mainColorOrange
            pageNum04.backgroundColor = UIColor().colorEEEEEE
        } else if nowPage == 3 {
            pageNum01.backgroundColor = UIColor().colorEEEEEE
            pageNum02.backgroundColor = UIColor().colorEEEEEE
            pageNum03.backgroundColor = UIColor().colorEEEEEE
            pageNum04.backgroundColor = UIColor().mainColorOrange
        }
    }
}

//MARK: 콜렉션뷰 구현
extension IntroViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return intro.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IntroCollectionViewCell", for: indexPath) as? IntroCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.titleLbl.text = intro[indexPath.row].title
        cell.contentLbl.text = intro[indexPath.row].content
        cell.ImgView.image = UIImage(named: "\(intro[indexPath.row].img)")
        if indexPath.row == 0 {
            cell.btn01.isHidden = true
            //btn02TapHandler 작성
            cell.btn02.setTitle("다음", for: UIControl.State.normal)
            cell.btn02TapHandler = {
                self.introCollectionViewMoveToNext()
                self.nowPageCheck()
            }
        } else if indexPath.row == intro.count-1 {
            cell.btn01.isHidden = true
            cell.btn02.setTitle("시작하기", for: UIControl.State.normal)
            //btn02TapHandler 작성
            cell.btn02TapHandler = {
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            cell.btn01.isHidden = false
            cell.btn02.setTitle("다음", for: UIControl.State.normal)
            //btn01TapHandler 작성
            cell.btn01TapHandler = {
                self.introCollectionViewMoveToPrev()
                self.nowPageCheck()
            }
            //btn02TapHandler 작성
            cell.btn02TapHandler = {
                self.introCollectionViewMoveToNext()
                self.nowPageCheck()
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: collectionView.bounds.height)
    }
    
    //컬렉션뷰 감속 끝났을 때 현재 페이지 체크
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        nowPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        for cell in introCollectionView.visibleCells {
            if let row = introCollectionView.indexPath(for: cell)?.item {
                print(row)
                nowPage = row
            }
        }
        nowPageCheck()
    }
  
}

struct IntroModel {
    var title: String
    var content: String
    var img: String
    
    
    init(title: String, content: String, img: String) {
        self.title = title
        self.content = content
        self.img = img
    }
}
