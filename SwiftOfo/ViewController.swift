//
//  ViewController.swift
//  SwiftOfo
//
//  Created by Monstar on 2017/9/12.
//  Copyright © 2017年 Monstar. All rights reserved.
//

import UIKit
class ProfileView: UIView {
    lazy var maskPath        = UIBezierPath()
    lazy var userPhoto       = UIImageView()
    let circleLayer          = CAShapeLayer()
    var pan                  = UISwipeGestureRecognizer()
    let startFrames = NSMutableArray()
    let endFrames = NSMutableArray()
    let btnArr = NSMutableArray()
    typealias SwipeBlock = () -> Void
    var swipeBlock:SwipeBlock?
    
    func downSwipe()  {

        if self.swipeBlock != nil{
            self.swipeBlock!()
        }
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        let circleHeight:CGFloat = 170
        self.backgroundColor = UIColor.clear
        maskPath = UIBezierPath()
        maskPath.move(to: CGPoint(x: 0, y: circleHeight))
        maskPath.addQuadCurve(to: CGPoint(x:self.frame.width , y: circleHeight), controlPoint: CGPoint(x:self.frame.width/2, y: circleHeight*0.4))
        maskPath.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        maskPath.addLine(to: CGPoint(x: 0, y: self.frame.height))
        maskPath.addLine(to: CGPoint(x: 0, y: circleHeight))
        
        circleLayer.frame = self.bounds
        circleLayer.path = maskPath.cgPath
        circleLayer.fillColor = UIColor.white.cgColor
        self.layer.addSublayer(circleLayer)
        
        userPhoto = UIImageView.init(frame: CGRect(x: 45, y: 90, width: 80, height: 80))
        userPhoto.image = UIImage(named: "UserInfo_defaultIcon")
        self.addSubview(userPhoto)
        
        pan = UISwipeGestureRecognizer.init(target: self, action: #selector(downSwipe))
        pan.direction = UISwipeGestureRecognizerDirection.down
        self.addGestureRecognizer(pan)
        let imgArr:NSArray = ["icon_slide_trip2","icon_slide_wallet2","icon_slide_invite2","icon_slide_coupon2","icon_slide_usage_guild2"]
        
        let titleArr:NSArray = ["我的行程","我的钱包","邀请好友","兑优惠券","我的客服"]
        let btnWidth:Int = 150
        let btnHeight:Int = 50
        for i in 0...4 {
            let btn:UIButton = UIButton.init(type: UIButtonType.custom)
            btn.frame = CGRect(x: 25, y: 210+55*i, width: btnWidth, height: btnHeight)
            
            endFrames.add(CGRect(x: 25+btnWidth/2, y: 210+55*i+btnHeight/2, width: btnWidth, height: btnHeight))
            startFrames.add(CGRect(x: 25+btnWidth/2, y: 210 + 90 * i+btnHeight/2 , width: btnWidth, height: btnHeight))
            
            btnArr.add(btn)
            btn.setTitle(titleArr[i] as? String, for: UIControlState.normal)
            btn.setImage(UIImage(named: imgArr[i] as! String), for:  UIControlState.normal)
            btn.setTitleColor(UIColor.black, for: UIControlState.normal)
           
            self.addSubview(btn)
        }
    }
    
    func beginAnimate ()  {
        for i in 0...4 {
            let btn:UIButton = btnArr[i] as! UIButton
            let startPosition:CGRect = startFrames[i] as! CGRect
            let endPosition:CGRect  = endFrames[i] as! CGRect
            print (startFrames[i],endFrames[i])
            let group :CAKeyframeAnimation = groupAnimate(startFrame: startPosition , endFrame:endPosition, t: btn.layer.transform)
            btn.layer.add(group, forKey: "myAnimate1")
        }
    }
    func groupAnimate(startFrame:CGRect,endFrame:CGRect,t:CATransform3D) -> CAKeyframeAnimation {
        let transform:CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "position")
        
        transform.values = [
                            NSValue.init(cgPoint: CGPoint(x: startFrame.origin.x, y:  startFrame.origin.y)),
                            
                            NSValue.init(cgPoint: CGPoint(x: endFrame.origin.x, y:   endFrame.origin.y))]
        transform.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseIn)
        transform.duration = 0.6
        return transform
    }
        
   
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class TopView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 255/255.0, green: 220/255.0, blue: 12/255.0, alpha: 1)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class ViewController: UIViewController,MAMapViewDelegate,AMapSearchDelegate,AMapNaviWalkManagerDelegate {

    var mapView:MAMapView!
    var search:AMapSearchAPI!
    var pin:MAPointAnnotation!
    var nearBySearch = true
    var start,end: CLLocationCoordinate2D!
    var walkManager:AMapNaviWalkManager!
    var animateView:circleView!
    var profileanimateView:ProfileView!
    var topView:TopView!
    lazy var animateTable = UITableView()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        mapView = MAMapView(frame: view.bounds)
        view.addSubview(mapView)
        
        mapView.delegate = self
        mapView.zoomLevel = 17
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        search = AMapSearchAPI()
        search.delegate = self
        
        walkManager = AMapNaviWalkManager()
        walkManager.delegate = self
        
        weak var weakSelf = self
        let selfHeight:CGFloat = UIScreen.main.bounds.size.height*0.4
        let selfWidth:CGFloat = UIScreen.main.bounds.size.width
        let selfY:CGFloat = UIScreen.main.bounds.size.height*0.6
        animateView = circleView.init(frame:CGRect(x: 0, y: selfY, width: selfWidth, height: selfHeight))
        animateView.LeftBtnclicked = {Bool in
           
                UIView.animate(withDuration: 0.4, animations: {
                   var temp:CGRect = (weakSelf?.profileanimateView.frame)!
                    temp.origin.y -= UIScreen.main.bounds.size.height
                    weakSelf?.profileanimateView.frame = temp
                    self.profileanimateView.beginAnimate()
                    
                    var toptemp:CGRect = (weakSelf?.topView.frame)!
                    toptemp.origin.y += 220
                    weakSelf?.topView.frame = toptemp
                    
                })
        }
        
        view.addSubview(animateView)
        
        topView = TopView.init(frame: CGRect(x: 0, y: -220, width: selfWidth, height: 220))
        view.addSubview(topView)
        
        
        profileanimateView=ProfileView.init(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: selfWidth, height: UIScreen.main.bounds.size.height))
        view.addSubview(profileanimateView)
        
        profileanimateView.swipeBlock = {Void  in
            
            
            UIView.animate(withDuration: 0.4, animations: {
                var temp:CGRect = (weakSelf?.profileanimateView.frame)!
                temp.origin.y += UIScreen.main.bounds.size.height
                weakSelf?.profileanimateView.frame = temp
            
                
                var toptemp:CGRect = (weakSelf?.topView.frame)!
                toptemp.origin.y -= 220
                weakSelf?.topView.frame = toptemp
                
            })

        }
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

