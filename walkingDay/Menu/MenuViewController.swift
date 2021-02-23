//
//  MenuViewController.swift
//  walkingDay
//
//  Created by HongInJun on 2021/02/20.
//

class MenuViewController: UIViewController {
    
    @IBOutlet var backingImageView: UIImageView!
    var backingImage: UIImage?
    
    @IBOutlet var menuView: UIView!
    @IBOutlet var bgBlackView: UIImageView!
    @IBOutlet var menuViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet var closeBtnRightConstraint: NSLayoutConstraint!
    @IBOutlet var menuTableView: UITableView!
    
    @IBAction func closeBtnAction(_ sender: UIButton) {
        closePageBackgroundViewTransition()
        closePage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //전 화면 캡쳐 이미지
        backingImageView.image = backingImage
        menuTableViewSet()
        menuTableViewData()
    }

    override func viewDidAppear(_ animated: Bool) {
        //백그라운드 시작 트랜지션
        backgroundViewTransition()
    }
    
    var menu : [Menu] = []
    let menuTitleHome = "홈으로 가기"
    let menuTitleWeather = "날씨 보기"
    let menuTitleDust = "미세먼지 보기"
    let menuTitleMemo = "메모로 가기"
    let menuTitleSettings = "설정 보기"
    
    //테이블뷰 세팅
    func menuTableViewSet() {
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.separatorStyle = .none
        menuTableView.register(UINib(nibName: "SingleTableViewCell", bundle: nil), forCellReuseIdentifier: "SingleTableViewCell")
    }
    //테이블뷰 데이터 세팅
    func menuTableViewData() {
        menu = [
            Menu(title: menuTitleHome, img: "menu1"),
            Menu(title: menuTitleWeather, img: "menu2"),
            Menu(title: menuTitleDust, img: "menu3"),
            Menu(title: menuTitleMemo, img: "menu4"),
            Menu(title: menuTitleSettings, img: "menu5")
       ]
    }
    
    //백그라운드 시작 트랜지션
    private func backgroundViewTransition() {
        view.layoutIfNeeded()
        menuView.alpha = 1
        bgBlackView.alpha = 0
        let screenWidth = UIScreen.main.bounds.width
        menuViewLeftConstraint.constant = CGFloat(Double(-screenWidth) - 40.0)
        closeBtnRightConstraint.constant = screenWidth
        
        backgroundViewAlphaTransition(alpha: 0.4)
        UIViewPropertyAnimator(duration: 0.4, curve: .easeInOut) {
            self.view.layoutIfNeeded()
            self.menuViewLeftConstraint.constant = 0
            self.closeBtnRightConstraint.constant = 20
        }.startAnimation()
    }
    
    //백그라운드 알파값 트랜지션
    func backgroundViewAlphaTransition(alpha: Double) {
        UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut) {
            self.bgBlackView.alpha = CGFloat(alpha)
        }.startAnimation()
    }
    
    //백그라운드 끝 트랜지션
    func closePageBackgroundViewTransition() {
        backgroundViewAlphaTransition(alpha: 0.0)
        UIViewPropertyAnimator(duration: 0.4, curve: .easeInOut) {
            let screenWidth = UIScreen.main.bounds.width
            self.closeBtnRightConstraint.constant = CGFloat(Double(-screenWidth) - 40.0)
            self.menuViewLeftConstraint.constant = screenWidth
            self.view.layoutIfNeeded()
        }.startAnimation()
    }
    
    //페이지 닫기 함수
    func closePage() {
        //딜레이
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            //전 네이게이션 페이지로 이동
            self.navigationController?.popViewController(animated: false)
        }
    }
    
}
extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SingleTableViewCell", for: indexPath) as? SingleTableViewCell else {
            return UITableViewCell()
        }
        cell.contentLbl.isHidden = true
        cell.titleLbl.text = menu[indexPath.row].title
        cell.imageView?.image = UIImage(named: menu[indexPath.row].img)
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if menu[indexPath.row].title == menuTitleHome  {
            closePageBackgroundViewTransition()
            //딜레이
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.navigationController?.popToRootViewController(animated: false)
            }
        } else if menu[indexPath.row].title == menuTitleMemo  {
            closePageBackgroundViewTransition()
            //딜레이
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                if self.navigationController?.previousViewController() is TodoListViewController {
                    self.navigationController?.popViewController(animated: false)
                    print("toback")
                } else {
                    let sb = UIStoryboard(name: "Todo", bundle: nil)
                    guard let navi = sb.instantiateViewController(withIdentifier: "TodoListViewController") as? TodoListViewController else { return }
                    self.navigationController?.pushViewController(navi, animated: false)
                    print("tomemo")
                }
                
            }
          
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

struct Menu {
    var title: String
    var img: String
    
    init(title: String, img: String) {
        self.title = title
        self.img = img
    }
}
