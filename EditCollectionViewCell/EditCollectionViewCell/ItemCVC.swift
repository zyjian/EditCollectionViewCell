//
//  itemCVC.swift
//  EditCollectionViewCell
//
//  Created by zhu on 2018/3/14.
//  Copyright © 2018年 cn.jy. All rights reserved.
//

import UIKit


protocol ItemCVCProtocl:class {
    func itemCVClongPress(long:UILongPressGestureRecognizer)
}

class ItemCVC: UICollectionViewCell {

    @IBOutlet weak var titleLab: UILabel!
    weak var delegate:ItemCVCProtocl?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let longTap:UILongPressGestureRecognizer = UILongPressGestureRecognizer.init(target: self, action: #selector(longClick(long:)))
        self.addGestureRecognizer(longTap)
    }
    
    @objc func longClick(long:UILongPressGestureRecognizer){
        self.delegate?.itemCVClongPress(long: long)
    }

}

// MARK: ----------- 抖动动画
extension ItemCVC {
    func shakeAnimate(){
        //创建动画对象
        
        let animate:CABasicAnimation = CABasicAnimation.init(keyPath: "transform.rotation.z")
        animate.duration = 0.1 //周期时长
        animate.fromValue = -Double.pi/32
        animate.toValue = Double.pi/32
        
        animate.repeatCount = Float(LONG_MAX)
        animate.autoreverses = true //恢复原样
        
        self.layer.anchorPoint = CGPoint.init(x: 0.5, y: 0.5)
        self.layer.add(animate, forKey: "rotation")
    }
    
    func resetAnimate() {
        self.layer.removeAnimation(forKey: "rotation")
    }
}








