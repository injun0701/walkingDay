//
//  LocationListViewController.swift
//  walkingDay
//
//  Created by HongInJun on 2021/02/23.
//

import UIKit

class LocationListViewController: UIViewController {

    @IBAction func backBtnAction(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
  
    @IBAction func ㅇㅇㅇ(_ sender: Any) {
        let sb = UIStoryboard(name: "Location", bundle: nil)
        guard let navi = sb.instantiateViewController(withIdentifier: "LocationSearchViewController") as? LocationSearchViewController else { return }
      
        self.navigationController?.pushViewController(navi, animated: true)
    }
}
