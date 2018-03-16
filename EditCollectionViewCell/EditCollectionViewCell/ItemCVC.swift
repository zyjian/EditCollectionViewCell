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
