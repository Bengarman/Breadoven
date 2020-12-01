//
//  MealDealViewController.swift
//  BreadShop
//
//  Created by Ben Garman on 15/10/2019.
//  Copyright © 2019 Ben Garman. All rights reserved.
//

import UIKit
import InfiniteScrollCollectionView
class snackCollectionCell: UICollectionViewCell{
    @IBOutlet weak var imageView: UIImageView!
}
class drinkCollectionCell: UICollectionViewCell{
    @IBOutlet weak var imageView: UIImageView!
}
extension UICollectionView {
    func scrollToNearestVisibleCollectionViewCell() {
        self.decelerationRate = UIScrollView.DecelerationRate.fast
        let visibleCenterPositionOfScrollView = Float(self.contentOffset.x + (self.bounds.size.width / 2))
        var closestCellIndex = -1
        var closestDistance: Float = .greatestFiniteMagnitude
        for i in 0..<self.visibleCells.count {
            let cell = self.visibleCells[i]
            let cellWidth = cell.bounds.size.width
            let cellCenter = Float(cell.frame.origin.x + cellWidth / 2)
            
            // Now calculate closest cell
            let distance: Float = fabsf(visibleCenterPositionOfScrollView - cellCenter)
            if distance < closestDistance {
                closestDistance = distance
                closestCellIndex = self.indexPath(for: cell)!.row
            }
        }
        if closestCellIndex != -1 {
            self.scrollToItem(at: IndexPath(row: closestCellIndex, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
}
class SnappingCollectionViewLayout: UICollectionViewFlowLayout {
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity) }
        
        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        let horizontalOffset = proposedContentOffset.x + collectionView.contentInset.left
        
        let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)
        
        let layoutAttributesArray = super.layoutAttributesForElements(in: targetRect)
        
        layoutAttributesArray?.forEach({ (layoutAttributes) in
            let itemOffset = layoutAttributes.frame.origin.x
            if fabsf(Float(itemOffset - horizontalOffset)) < fabsf(Float(offsetAdjustment)) {
                offsetAdjustment = itemOffset - horizontalOffset
            }
        })
        
        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
    }
}
class MealDealViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, InfiniteScrollCollectionViewDelegatge {
    func uniformItemSizeIn(collectionView: UICollectionView) -> CGSize {
        return CGSize(width: 75, height: 40)
    }
    func indexPathForCellAtPoint(_ point : CGPoint, collectionView : UICollectionView) -> IndexPath? {
        return collectionView.indexPathForItem(at: self.view.convert(point, to: collectionView))
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.snackCollectionView.scrollToNearestVisibleCollectionViewCell()
        self.drinksCollectionView.scrollToNearestVisibleCollectionViewCell()
        
        var temp1 = self.indexPathForCellAtPoint(CGPoint(x: 170, y: 376), collectionView: self.snackCollectionView)
        var count1 = 171
        while temp1 == nil{
            temp1 = self.indexPathForCellAtPoint(CGPoint(x: count1, y: 376), collectionView: self.snackCollectionView)
            count1 = count1 + 1
        }
        var temp2 = self.indexPathForCellAtPoint(CGPoint(x: 170, y: 583), collectionView: self.drinksCollectionView)//189
        var count2 = 171
        while temp2 == nil{
            temp2 = self.indexPathForCellAtPoint(CGPoint(x: count2, y: 583), collectionView: self.drinksCollectionView)//189
            count2 = count2 + 1
        }
        
        self.collectionView(snackCollectionView, didSelectItemAt: temp1!)
        self.collectionView(drinksCollectionView, didSelectItemAt: temp2!)
        let selectionFeedbackGenerator = UIImpactFeedbackGenerator(style: UIImpactFeedbackGenerator.FeedbackStyle.heavy)
        selectionFeedbackGenerator.impactOccurred()
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.snackCollectionView.scrollToNearestVisibleCollectionViewCell()
            self.drinksCollectionView.scrollToNearestVisibleCollectionViewCell()
            
            var temp1 = self.indexPathForCellAtPoint(CGPoint(x: 170, y: 376), collectionView: self.snackCollectionView)
            var count1 = 171
            while temp1 == nil{
                temp1 = self.indexPathForCellAtPoint(CGPoint(x: count1, y: 376), collectionView: self.snackCollectionView)
                count1 = count1 + 1
            }
            var temp2 = self.indexPathForCellAtPoint(CGPoint(x: 170, y: 583), collectionView: self.drinksCollectionView)//189
            var count2 = 171
            while temp2 == nil{
                temp2 = self.indexPathForCellAtPoint(CGPoint(x: count2, y: 583), collectionView: self.drinksCollectionView)//189
                count2 = count2 + 1
            }
            
            self.collectionView(snackCollectionView, didSelectItemAt: temp1!)
            self.collectionView(drinksCollectionView, didSelectItemAt: temp2!)
            let selectionFeedbackGenerator = UIImpactFeedbackGenerator(style: UIImpactFeedbackGenerator.FeedbackStyle.heavy)
            selectionFeedbackGenerator.impactOccurred()
        }
    }
    @IBOutlet weak var snackButton: UIButton!
    @IBOutlet weak var drinkButton: UIButton!
    @IBAction func drinkSelector(_ sender: UIButton) {
        let selectionFeedbackGenerator = UIImpactFeedbackGenerator(style: UIImpactFeedbackGenerator.FeedbackStyle.heavy)
        selectionFeedbackGenerator.impactOccurred()
        if sender.imageView?.image == UIImage(named: "DrinksSelected"){
            self.drinks = Global.snacks
            self.drinksCollectionView.reloadData()
            UIView.transition(with: sender,
                              duration: 0.25,
                              options: .transitionCrossDissolve,
                              animations: {
                                sender.setImage(UIImage(named: "SnacksSelected"), for: .normal)
                              },
                              completion: nil)
        }else{
            self.drinks = Global.drinks
            self.drinksCollectionView.reloadData()
            UIView.transition(with: sender,
                              duration: 0.25,
                              options: .transitionCrossDissolve,
                              animations: {
                                sender.setImage(UIImage(named: "DrinksSelected"), for: .normal)
                              },
                              completion: nil)
        }
        self.drinks = snackCollectionView.prepareDataSourceForInfiniteScroll(array: self.drinks) as! [mealDeal]

    }
    @IBAction func snackSelector(_ sender: UIButton) {
        let selectionFeedbackGenerator = UIImpactFeedbackGenerator(style: UIImpactFeedbackGenerator.FeedbackStyle.heavy)
        selectionFeedbackGenerator.impactOccurred()
        if sender.imageView?.image == UIImage(named: "DrinksSelected"){
            self.snacks = Global.snacks
            self.snackCollectionView.reloadData()
            UIView.transition(with: sender,
                              duration: 0.25,
                              options: .transitionCrossDissolve,
                              animations: {
                                sender.setImage(UIImage(named: "SnacksSelected"), for: .normal)
                              },
                              completion: nil)
        }else{
            self.snacks = Global.drinks
            self.snackCollectionView.reloadData()
            UIView.transition(with: sender,
                              duration: 0.25,
                              options: .transitionCrossDissolve,
                              animations: {
                                sender.setImage(UIImage(named: "DrinksSelected"), for: .normal)
            },
                              completion: nil)
        }
        self.snacks = snackCollectionView.prepareDataSourceForInfiniteScroll(array: self.snacks) as! [mealDeal]
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0{
            return snacks.count
        }else{
            return drinks.count
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        snackCollectionView.infiniteScrollViewDidScroll(scrollView: scrollView)
        drinksCollectionView.infiniteScrollViewDidScroll(scrollView: scrollView)

    }
    var count = 0
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0{
            if indexPath.row == snackid{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "snacks", for: indexPath as IndexPath) as! snackCollectionCell
                cell.imageView.image = snacks[indexPath.row].url
                cell.imageView.alpha = 1
                return cell
            }else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "snacks", for: indexPath as IndexPath) as! snackCollectionCell
                cell.imageView.image = snacks[indexPath.row].url
                cell.imageView.alpha = 1
                return cell
            }
            
            
        }else{
            if indexPath.row == drinkid{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "drinks", for: indexPath as IndexPath) as! drinkCollectionCell
                cell.imageView.image = drinks[indexPath.row].url
                cell.imageView.alpha = 1
                
                return cell
            }else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "drinks", for: indexPath as IndexPath) as! drinkCollectionCell
                cell.imageView.image = drinks[indexPath.row].url
                cell.imageView.alpha = 1
                return cell
            }
            
        }
    }
    var selectedSnack = Int()
    var selectedDrink = Int()
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 0{
            snackid = indexPath.row
            snackSelection.text = String(snacks[indexPath.row].name.dropLast(5))
            snackIndex = Int(String(snacks[indexPath.row].name.suffix(2)))!
            snackCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            let cell = collectionView.cellForItem(at: indexPath) as! snackCollectionCell
            cell.imageView.alpha = 1
        }else{
            drinkid = indexPath.row
            drinkSelection.text = String(drinks[indexPath.row].name.dropLast(5))
            drinkIndex = Int(String(drinks[indexPath.row].name.suffix(2)))!
            drinksCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            let cell = collectionView.cellForItem(at: indexPath) as! drinkCollectionCell
            cell.imageView.alpha = 1
        }
        
    }
    @IBOutlet weak var snackSelection: UILabel!
    @IBOutlet weak var drinkSelection: UILabel!
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        if collectionView.tag == 0{
            let temparily = collectionView.indexPathsForVisibleItems
            for xx in temparily{
                let cell = collectionView.cellForItem(at: xx) as! snackCollectionCell
                cell.imageView.alpha = 1
            }
        }else{
            let temparily = collectionView.indexPathsForVisibleItems
            for xx in temparily{
                let cell = collectionView.cellForItem(at: xx) as! drinkCollectionCell
                cell.imageView.alpha = 1
            }
        }
    }
    
    @IBAction func addToCartPressed(_ sender: Any) {
        Global.tempcart.drink = drinkSelection.text!
        Global.tempcart.snack = snackSelection.text!
        Global.tempcart.drinkID = drinkIndex
        Global.tempcart.snackID = snackIndex
        Global.cart.append(Global.tempcart)
        Global.tempcart = cartItem()
        performSegue(withIdentifier: "cartComplete", sender: nil)
    }
    
    @IBOutlet weak var drinksCollectionView: InfiniteScrollCollectionView!
    @IBOutlet weak var snackCollectionView: InfiniteScrollCollectionView!
    var drinkid = 0
    var snackid = 0
    var snacks = Global.snacks
    var drinks = Global.drinks
    
    var drinkIndex = 0
    var snackIndex = 0
    
    override func viewDidLoad() {
        drinkid = drinks.count + 10
        snackid = snacks.count + 10
        super.viewDidLoad()
        snackCollectionView.infiniteScrollDelegate = self
        snacks = snackCollectionView.prepareDataSourceForInfiniteScroll(array: snacks) as! [mealDeal]
        drinksCollectionView.infiniteScrollDelegate = self
        drinks = drinksCollectionView.prepareDataSourceForInfiniteScroll(array: drinks) as! [mealDeal]
        drinksCollectionView.reloadData()
        drinkButton.setImage(UIImage(named: "DrinksSelected"), for: .normal)
        snackButton.setImage(UIImage(named: "SnacksSelected"), for: .normal)
        snackCollectionView.reloadData()/*
        snackCollectionView.scrollToItem(at: IndexPath(row: 2, section: 0), at: .centeredHorizontally, animated: true)
        drinksCollectionView.scrollToItem(at: IndexPath(row: 2, section: 0), at: .centeredHorizontally, animated: true)*/
        
        //let cell = snackCollectionView.cellForItem(at: IndexPath(row: 7, section: 0)) as! snackCollectionCell
        //cell.imageView.alpha = 1
    }
    
}
