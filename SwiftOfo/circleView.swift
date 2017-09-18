//
//  circleView.swift
//  SwiftOfo
//
//  Created by Monstar on 2017/9/12.
//  Copyright © 2017年 Monstar. All rights reserved.
//

import Foundation


class circleView: UIView {
    
   lazy var maskPath        = UIBezierPath()
   let circleLayer          = CAShapeLayer()
   lazy var middleBtn       = UIButton()
   lazy var middleBigBtn    = UIButton()
   lazy var leftbottomBtn   = UIButton()
   lazy var rightbottomBtn  = UIButton()
    
   typealias closureBlock = (Bool) -> Void
   var LeftBtnclicked:closureBlock?
   
    override init(frame: CGRect) {
        
        let circleHeight:CGFloat = 40
    
       
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        maskPath = UIBezierPath()
        maskPath.move(to: CGPoint(x: 0, y: circleHeight))
        maskPath.addQuadCurve(to: CGPoint(x:self.frame.width , y: circleHeight), controlPoint: CGPoint(x:self.frame.width/2, y: circleHeight * -1.2))
        maskPath.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        maskPath.addLine(to: CGPoint(x: 0, y: self.frame.height))
        maskPath.addLine(to: CGPoint(x: 0, y: self.frame.height))
        maskPath.addLine(to: CGPoint(x: 0, y: circleHeight))
        
        circleLayer.frame = self.bounds
        circleLayer.path = maskPath.cgPath
        circleLayer.fillColor = UIColor.white.cgColor
        circleLayer.shadowOffset = CGSize(width: 0, height: -3)
        circleLayer.shadowRadius = 3
        circleLayer.shadowOpacity = 0.1
        self.layer.addSublayer(circleLayer)
        
        middleBtn = UIButton(type: UIButtonType.custom)
        middleBtn.frame = CGRect(x: self.frame.width/2-20, y: 5, width: 40, height: 40)
        middleBtn.setImage(UIImage(named: "arrowdown"), for:UIControlState.normal)
        middleBtn.setImage(UIImage(named: "arrowup"), for:UIControlState.selected)
        middleBtn.addTarget(self, action:#selector(btnClicked) , for: UIControlEvents.touchUpInside)
        self.addSubview(middleBtn)
        
        middleBigBtn = UIButton(type: UIButtonType.custom)
        middleBigBtn.frame = CGRect(x: self.frame.width/2-80, y: 60, width: 160, height: 160)
        middleBigBtn.backgroundColor = UIColor(red: 253/255.0, green: 210/255.0, blue: 10/255.0, alpha: 1)
        middleBigBtn.layer.cornerRadius = 80
        middleBigBtn.layer.masksToBounds = true
        middleBigBtn.setBackgroundImage(UIImage(named: "bigbtn"), for:UIControlState.normal)
        middleBigBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
        self.addSubview(middleBigBtn)
        
        
        leftbottomBtn = UIButton(type: UIButtonType.custom)
        leftbottomBtn.frame = CGRect(x:15, y: self.frame.height-50, width: 25, height: 25)
        leftbottomBtn.setBackgroundImage(UIImage(named: "user_center_icon"), for:UIControlState.normal)
        leftbottomBtn.addTarget(self, action:#selector(leftbottombtnClicked) , for: UIControlEvents.touchUpInside)
        self.addSubview(leftbottomBtn)
        
        rightbottomBtn = UIButton(type: UIButtonType.custom)
        rightbottomBtn.frame = CGRect(x:self.frame.width-40, y: self.frame.height-50, width: 25, height: 25)
        rightbottomBtn.setBackgroundImage(UIImage(named: "gift_icon"), for:UIControlState.normal)
        self.addSubview(rightbottomBtn)
    }
   
    
    func leftbottombtnClicked(bt:UIButton)  {
        if bt.isSelected == true {
            bt.isSelected = false
        }else{
            bt.isSelected = true
        }
      
        if self.LeftBtnclicked != nil{
          self.LeftBtnclicked!(bt.isSelected)
        }
        
        
    }
    func btnClicked(bt :UIButton){
        if bt.isSelected == true {
            bt.isSelected = false
            UIView.animate(withDuration: 0.418, animations: {
                var begin:CGRect = self.frame
                begin.origin.y -= self.frame.height-60
                self.frame = begin
            })
            UIView.animate(withDuration: 0.8, animations: {
                var beginLeft:CGRect = self.leftbottomBtn.frame
                beginLeft.origin.y -= 40
                self.leftbottomBtn.frame = beginLeft
                
                var beginRight:CGRect = self.rightbottomBtn.frame
                beginRight.origin.y -= 40
                self.rightbottomBtn.frame = beginRight
            })
            
        }else{
            bt.isSelected = true
            UIView.animate(withDuration: 0.418, animations: {
                var begin:CGRect = self.frame
                begin.origin.y += self.frame.height-60
                self.frame = begin
            })
            UIView.animate(withDuration: 0.8, animations: {
                var beginLeft:CGRect = self.leftbottomBtn.frame
                beginLeft.origin.y += 40
                self.leftbottomBtn.frame = beginLeft
                
                var beginRight:CGRect = self.rightbottomBtn.frame
                beginRight.origin.y += 40
                self.rightbottomBtn.frame = beginRight
            })
        }
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension circleView{


}
