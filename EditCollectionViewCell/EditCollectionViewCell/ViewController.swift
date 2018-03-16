//
//  ViewController.swift
//  EditCollectionViewCell
//
//  Created by zhu on 2018/3/14.
//  Copyright © 2018年 cn.jy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var startPoint:CGPoint = CGPoint()
    private var snapshotView:UIView?
    private var originalCell = UICollectionViewCell()
    private var indexPathP = IndexPath()
    private var nextIndexPathP = IndexPath()
    private var dataArray:NSMutableArray = {
        var array:NSMutableArray = NSMutableArray.init()
        for i in 0..<100 {
            array.add("第\(i)个")
        }
        return array
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let layou = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layou.scrollDirection = .vertical
        layou.minimumLineSpacing = 10
        layou.minimumInteritemSpacing = 10
        layou.sectionInset = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)
        
        collectionView.register(UINib.init(nibName: "ItemCVC", bundle: nil), forCellWithReuseIdentifier: "ItemCVC")
        
    }
}

extension ViewController:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ItemCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCVC", for: indexPath) as! ItemCVC
        cell.backgroundColor = indexPath.item % 2 == 0 ? UIColor.red:UIColor.blue
        cell.titleLab.text = self.dataArray[indexPath.item] as? String
        cell.delegate = self
        
        return cell
    }
    
}

extension ViewController:ItemCVCProtocl {
    func itemCVClongPress(long: UILongPressGestureRecognizer) {
        let cell:ItemCVC = long.view as! ItemCVC
        
        if long.state == .began {//长按开始
            
            //获取截图cell
            snapshotView = cell.snapshotView(afterScreenUpdates: true)!
            snapshotView?.center = cell.center
            collectionView.addSubview(snapshotView!)

            indexPathP = collectionView.indexPath(for: cell)!
            originalCell = cell
            originalCell.isHidden = true
            startPoint = long.location(in: collectionView)
            //colllectionViewAnimateCell(isgo: true)
        }else if(long.state == .changed){
            //移动
            let tranx : CGFloat = long.location(ofTouch: 0, in: collectionView).x - startPoint.x
            let trany : CGFloat = long.location(ofTouch: 0, in: collectionView).y - startPoint.y
            snapshotView?.center = __CGPointApplyAffineTransform((snapshotView?.center)!, CGAffineTransform.init(translationX: tranx, y: trany))
            //更新最新的开始移动
            startPoint = long.location(ofTouch: 0, in: collectionView)
            
            //计算截图和那个cell 交换
            for cell in collectionView.visibleCells {
                //跳过自己本身那个cell
                if collectionView.indexPath(for: cell) == indexPathP {
                    continue;
                }
                //计算中心距
                let space:CGFloat = sqrt(pow(snapshotView!.center.y-cell.center.y,2)+pow(snapshotView!.center.x-cell.center.x,2))
               
                //如果相交一半且两个视图Y的绝对值小于高度的一半就移动
                if space <= snapshotView!.bounds.width * 0.5
                    && (fabs(snapshotView!.center.y - cell.center.y) <= snapshotView!.bounds.height * 0.5) {
                    nextIndexPathP = collectionView.indexPath(for: cell)!
                    if nextIndexPathP.item > indexPathP.item {
                        for  i in indexPathP.item..<nextIndexPathP.item {
                            self.dataArray.exchangeObject(at: i, withObjectAt: i+1)
                        }
                    }else{
                        for  i in (nextIndexPathP.item ..< indexPathP.item).reversed() {
                            self.dataArray.exchangeObject(at: i, withObjectAt: i - 1)
                        }
                    }
                    //移动
                    collectionView.moveItem(at: indexPathP, to: nextIndexPathP)
                    indexPathP = nextIndexPathP;
                    break;

                }
            }
            
        }else if long.state == .ended {
            snapshotView?.removeFromSuperview()
            originalCell.isHidden = false
            //colllectionViewAnimateCell(isgo: false)

        }
    }
}

// MARK: -控制抖动
extension ViewController{
    
    func colllectionViewAnimateCell(isgo:Bool){
        for cell in collectionView.visibleCells {
            let newcell = cell as! ItemCVC
            if isgo{
                newcell.shakeAnimate()
            }else{
                newcell.resetAnimate()
            }
        }
    }
}


