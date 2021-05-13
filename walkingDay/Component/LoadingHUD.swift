//
//  LoadingHUD.swift
//  walkingDay
//
//  Created by HongInJun on 2021/02/19.
//

class LoadingHUD: NSObject {
    private static let sharedInstance = LoadingHUD()
    private var backgroundView: UIView?
    private var popupView: UIImageView?

    class func show() {
        let backgroundView = UIView(frame: CGRect.init(x: 0, y: 0, width: 100, height: 100))
        let popupView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 90, height: 90))
        popupView.animationImages = LoadingHUD.getAnimationImageArray()
        popupView.animationDuration = 1.0
        popupView.animationRepeatCount = 0

        if let window = UIApplication.shared.keyWindow {
            window.addSubview(backgroundView)
            window.addSubview(popupView)
            
            
            backgroundView.frame = CGRect(x: 0, y: 0, width: window.frame.maxX, height: window.frame.maxY)
            backgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
            
            popupView.center = window.center
            popupView.startAnimating()
            
            sharedInstance.backgroundView?.removeFromSuperview()
            sharedInstance.popupView?.removeFromSuperview()
            sharedInstance.backgroundView = backgroundView
            sharedInstance.popupView = popupView
        }
    }

    class func hide() {
        if let popupView = sharedInstance.popupView, let backgroundView = sharedInstance.backgroundView {
            popupView.stopAnimating()
            backgroundView.removeFromSuperview()
            popupView.removeFromSuperview()
        }
    }

    private class func getAnimationImageArray() -> [UIImage] {
        var animationArray: [UIImage] = []
        animationArray.append(UIImage(named: "loading/loading00000")!)
        animationArray.append(UIImage(named: "loading/loading00001")!)
        animationArray.append(UIImage(named: "loading/loading00002")!)
        animationArray.append(UIImage(named: "loading/loading00003")!)
        animationArray.append(UIImage(named: "loading/loading00004")!)
        animationArray.append(UIImage(named: "loading/loading00005")!)
        animationArray.append(UIImage(named: "loading/loading00006")!)
        animationArray.append(UIImage(named: "loading/loading00007")!)
        animationArray.append(UIImage(named: "loading/loading00008")!)
        animationArray.append(UIImage(named: "loading/loading00009")!)
        animationArray.append(UIImage(named: "loading/loading00010")!)
        animationArray.append(UIImage(named: "loading/loading00011")!)
        animationArray.append(UIImage(named: "loading/loading00012")!)
        animationArray.append(UIImage(named: "loading/loading00013")!)
        animationArray.append(UIImage(named: "loading/loading00014")!)
        animationArray.append(UIImage(named: "loading/loading00015")!)
        animationArray.append(UIImage(named: "loading/loading00016")!)
        animationArray.append(UIImage(named: "loading/loading00017")!)
        animationArray.append(UIImage(named: "loading/loading00018")!)
        animationArray.append(UIImage(named: "loading/loading00019")!)
        animationArray.append(UIImage(named: "loading/loading00020")!)
        animationArray.append(UIImage(named: "loading/loading00021")!)
        animationArray.append(UIImage(named: "loading/loading00022")!)
        animationArray.append(UIImage(named: "loading/loading00023")!)
        animationArray.append(UIImage(named: "loading/loading00024")!)
        animationArray.append(UIImage(named: "loading/loading00025")!)
        animationArray.append(UIImage(named: "loading/loading00026")!)
        animationArray.append(UIImage(named: "loading/loading00027")!)
        animationArray.append(UIImage(named: "loading/loading00028")!)
        animationArray.append(UIImage(named: "loading/loading00029")!)
        return animationArray
    }
}
