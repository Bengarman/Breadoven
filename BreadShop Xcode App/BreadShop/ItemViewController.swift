//
//  ItemViewController.swift
//  BreadShop
//
//  Created by Ben Garman on 03/10/2019.
//  Copyright © 2019 Ben Garman. All rights reserved.
//




import UIKit

class ItemOptionCollection : UICollectionViewCell{
    @IBOutlet weak var optionImage: UIImageView!
    @IBOutlet weak var selectionImage: UIImageView!
    
}

class BreadCollectionCell : UICollectionViewCell{
    @IBOutlet weak var breadImage: UIImageView!
    @IBOutlet weak var selectionIndicator: UIImageView!
    
}

class ItemViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        partoptions.removeAll()
        for each in optionsData.options{
            if each.type == currentScreen{
                partoptions.append(each)
            }
        }
        return partoptions.count
        
    }
    @IBOutlet weak var breadTypeSelector: UIImageView!
    @IBOutlet weak var breadCollection: UICollectionView!
    @IBOutlet weak var makeItAMeal: UIButton!
    @IBOutlet weak var onlyBaguette: UIButton!
    
    func hideLastSlide(){
        breadTypeSelector.isHidden = true
        breadCollection.isHidden = true
        makeItAMeal.isHidden = true
        onlyBaguette.isHidden = true
        //optionsCollectionView.isHidden = false
    }
    func showLastSlide(){
        breadCollection.reloadData()
        breadTypeSelector.isHidden = false
        breadCollection.isHidden = false
        makeItAMeal.isHidden = false
        onlyBaguette.isHidden = false
        //optionsCollectionView.isHidden = true
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath as IndexPath) as! ItemOptionCollection
            cell.optionImage.image = partoptions[indexPath.row].url
            cell.selectionImage.isHidden = true
            if currentScreen == 1{
                for x in optionsData.freeOptions{
                    if partoptions[indexPath.row].name == x.name{
                        cell.selectionImage.image = UIImage(named: "FREE_FILLING")
                        cell.selectionImage.isHidden = false
                        partoptions[indexPath.row].selected = true
                    }
                }
                for x in optionsData.paidOptions{
                    if partoptions[indexPath.row].name == x.name{
                        cell.selectionImage.image = UIImage(named: "PAID_FILLING")
                        cell.selectionImage.isHidden = false
                        partoptions[indexPath.row].selected = true
                    }
                }
            }else if currentScreen == 2{
                for x in optionsData.freeSauce{
                    if partoptions[indexPath.row].name == x.name{
                        cell.selectionImage.image = UIImage(named: "FREE_SAUCE")
                        cell.selectionImage.isHidden = false
                        partoptions[indexPath.row].selected = true
                    }
                }
                for x in optionsData.paidSauce{
                    if partoptions[indexPath.row].name == x.name{
                        cell.selectionImage.image = UIImage(named: "PAID_SAUCE")
                        cell.selectionImage.isHidden = false
                        partoptions[indexPath.row].selected = true
                    }
                }
            }
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "breadCell", for: indexPath as IndexPath) as! BreadCollectionCell
            
            cell.breadImage.image = partoptions[indexPath.row].url
            return cell

            
        }
    }
    @IBAction func backButtonPressed(_ sender: Any) {
        optionsData.freeOptions.removeAll()
        optionsData.freeSauce.removeAll()
        optionsData.paidOptions.removeAll()
        optionsData.paidSauce.removeAll()
        optionsData.bread = ""
        performSegue(withIdentifier: "backtoItem", sender: nil)
    }
    var optionsText = "- "
    var saucesText = "- "
    
    func getText(){
        for x in optionsData.freeOptions{
            optionsText = optionsText + x.name + " / "
        }
        for x in optionsData.paidOptions{
            optionsText = optionsText + x.name + "(£0.70) / "
        }
        optionsText = String(optionsText.dropLast(2))
        
        
        for x in optionsData.freeSauce{
            saucesText = saucesText + x.name + " / "
        }
        for x in optionsData.paidSauce{
            saucesText = saucesText + x.name + "(£1.00) / "
        }
        optionsData.freeOptions.removeAll()
        optionsData.freeSauce.removeAll()
        optionsData.paidSauce.removeAll()
        optionsData.paidOptions.removeAll()
        saucesText = String(saucesText.dropLast(2))
    }
    @IBAction func makeAMealPressed(_ sender: Any) {
        if breadType != ""{
            getText()
            Global.tempcart.baguette = Global.tempcart.baguette + " on " + breadType
            Global.tempcart.mealDeal = true
            Global.tempcart.sauces = saucesText
            Global.tempcart.toppings = optionsText
            performSegue(withIdentifier: "makeAMealLink", sender: nil)
        }else{
            let alert = UIAlertController(title: "Bread Type", message: "Please select your bread type before continuing.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        
    }
    
    @IBAction func onlyBaguettePressed(_ sender: Any) {
        if breadType != ""{
            getText()
            Global.tempcart.baguette = Global.tempcart.baguette + " on " + breadType
            Global.tempcart.mealDeal = false
            Global.tempcart.sauces = saucesText
            Global.tempcart.toppings = optionsText
            Global.cart.append(Global.tempcart)
            Global.tempcart = cartItem()
            performSegue(withIdentifier: "backtoMain", sender: nil)
        }else{
            let alert = UIAlertController(title: "Bread Type", message: "Please select your bread type before continuing.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        
    }
    
    @IBAction func cartPressed(_ sender: Any) {
        
        let calendar = Calendar.current
        let now = Date()
        let eight_today = calendar.date(bySettingHour: 11, minute: 0, second: 0, of: now)!
        let four_thirty_today = calendar.date(bySettingHour: 16, minute: 00, second: 0, of: now)!
        if (now >= eight_today) && (now <= four_thirty_today){
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "cartViewController") as! CartViewController
            self.present(newViewController, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Time Error", message: "We're sorry but the Bread Oven is currently closed. Try again tomorrow between 11:30 and 4:00.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if collectionView.tag == 0{
            let cell = collectionView.cellForItem(at: indexPath) as! ItemOptionCollection
            print(partoptions)
            if partoptions[indexPath.row].selected == false{
                if currentScreen == 1{
                    if optionsData.freeOptions.count >= 4{
                        partoptions[indexPath.row].selected = true
                        optionsData.paidOptions.append(partoptions[indexPath.row])
                        Global.tempcart.price = Global.tempcart.price + 0.7
                        cell.selectionImage.isHidden = false
                        if currentScreen == 1{
                            cell.selectionImage.image = UIImage(named: "PAID_FILLING")
                        }else if currentScreen == 2{
                            cell.selectionImage.image = UIImage(named: "PAID_SAUCE")
                        }
                        
                    }else{
                        partoptions[indexPath.row].selected = true
                        optionsData.freeOptions.append(partoptions[indexPath.row])
                        cell.selectionImage.isHidden = false
                        if currentScreen == 1{
                            cell.selectionImage.image = UIImage(named: "FREE_FILLING")
                        }else if currentScreen == 2{
                            cell.selectionImage.image = UIImage(named: "FREE_SAUCE")
                        }
                    }
                }else{
                    if optionsData.freeSauce.count >= 2{
                        partoptions[indexPath.row].selected = true
                        optionsData.paidSauce.append(partoptions[indexPath.row])
                        cell.selectionImage.isHidden = false
                        Global.tempcart.price = Global.tempcart.price + 1
                        if currentScreen == 1{
                            cell.selectionImage.image = UIImage(named: "PAID_FILLING")
                        }else if currentScreen == 2{
                            cell.selectionImage.image = UIImage(named: "PAID_SAUCE")
                        }
                        
                    }else{
                        partoptions[indexPath.row].selected = true
                        optionsData.freeSauce.append(partoptions[indexPath.row])
                        cell.selectionImage.isHidden = false
                        if currentScreen == 1{
                            cell.selectionImage.image = UIImage(named: "FREE_FILLING")
                        }else if currentScreen == 2{
                            cell.selectionImage.image = UIImage(named: "FREE_SAUCE")
                        }
                    }
                }
                
            }else{
                if currentScreen == 1{
                    if let index = optionsData.paidOptions.firstIndex(where: { $0.name == partoptions[indexPath.row].name }){
                        partoptions[indexPath.row].selected = false
                        optionsData.paidOptions.remove(at: index)
                        Global.tempcart.price = Global.tempcart.price - 0.7
                        cell.selectionImage.isHidden = true
                        
                    }else{
                        partoptions[indexPath.row].selected = false
                        let index = optionsData.freeOptions.firstIndex(where: { $0.name == partoptions[indexPath.row].name })
                        optionsData.freeOptions.remove(at: index!)
                        cell.selectionImage.isHidden = true
                        if optionsData.paidOptions.count >= 1{
                            Global.tempcart.price = Global.tempcart.price - 0.7
                            optionsData.freeOptions.append(optionsData.paidOptions[0])
                            optionsData.paidOptions.remove(at: 0)
                            let index2 = partoptions.firstIndex(where: { $0.name == optionsData.freeOptions[3].name })
                            let cell2 = optionsCollectionView.cellForItem(at: IndexPath(row: index2!, section: 0)) as! ItemOptionCollection
                            cell2.selectionImage.image = UIImage(named: "FREE_FILLING")
                        }
                    }
                    
                }else{
                    if let index = optionsData.paidSauce.firstIndex(where: { $0.name == partoptions[indexPath.row].name }){
                        partoptions[indexPath.row].selected = false
                        optionsData.paidSauce.remove(at: index)
                        cell.selectionImage.isHidden = true
                        Global.tempcart.price = Global.tempcart.price - 1
                        
                    }else{
                        partoptions[indexPath.row].selected = false
                        let index = optionsData.freeSauce.firstIndex(where: { $0.name == partoptions[indexPath.row].name })
                        optionsData.freeSauce.remove(at: index!)
                        cell.selectionImage.isHidden = true
                        if optionsData.paidSauce.count >= 1{
                            Global.tempcart.price = Global.tempcart.price - 1
                            optionsData.freeSauce.append(optionsData.paidSauce[0])
                            optionsData.paidSauce.remove(at: 0)
                            let index2 = partoptions.firstIndex(where: { $0.name == optionsData.freeSauce[1].name })
                            let cell2 = optionsCollectionView.cellForItem(at: IndexPath(row: index2!, section: 0)) as! ItemOptionCollection
                            cell2.selectionImage.image = UIImage(named: "FREE_SAUCE")
                        }
                    }
                }
            }
        }else{
            let cell = collectionView.cellForItem(at: indexPath) as! BreadCollectionCell
            if indexPath.row == 0{
                cell.selectionIndicator.image = UIImage(named: "selected")
                optionsData.bread = partoptions[indexPath.row].name
                breadType = "Brown"
                let cell2 = collectionView.cellForItem(at: IndexPath(row: 1, section: 0)) as! BreadCollectionCell
                cell2.selectionIndicator.image = UIImage(named: "notSelected")
            }else{
                cell.selectionIndicator.image = UIImage(named: "selected")
                optionsData.bread = partoptions[indexPath.row].name
                breadType = "White"
                let cell2 = collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as! BreadCollectionCell
                cell2.selectionIndicator.image = UIImage(named: "notSelected")
            }
        }
        
        refreshPrice()
        
        return false
    }
    var breadType = ""
    func refreshPrice(){
        itemLabel.text = Global.tempcart.baguette + " - £" + String(format: "%.2f",Global.tempcart.price)
    }
    
    var currentScreen = 1
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                if currentScreen != 1{
                    currentScreen = currentScreen - 1
                }
                if currentScreen == 2{
                    
                    UIView.transition(with: optionsCollectionView,
                                      duration: 0.35,
                                      options: .transitionCrossDissolve,
                                      animations: { self.optionsCollectionView.alpha = 1; self.hideLastSlide(); self.optionsCollectionView.reloadData()})
                    
                    print("Swiped right")
                    
                }else{
                    UIView.transition(with: optionsCollectionView,
                                      duration: 0.35,
                                      options: .transitionCrossDissolve,
                                      animations: { self.optionsCollectionView.reloadData()})
                    
                    print("Swiped right")
                }
                
            case UISwipeGestureRecognizer.Direction.left:
                
                if currentScreen != 3{
                    currentScreen = currentScreen + 1
                }
                if currentScreen == 3{
                    showLastSlide()
                    UIView.transition(with: optionsCollectionView,
                                      duration: 0.35,
                                      options: .transitionCrossDissolve,
                                      animations: { self.optionsCollectionView.alpha = 0 })
                    
                    print("Swiped right")
                }else{
                    UIView.transition(with: optionsCollectionView,
                                      duration: 0.35,
                                      options: .transitionCrossDissolve,
                                      animations: { self.optionsCollectionView.reloadData() })
                    print("Swiped left")
                    
                }
                    
                
            default:
                
                break
            }
        }
    }
    
    var partoptions = [Options()]
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var itemDescription: UILabel!
    @IBOutlet weak var optionsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        optionsCollectionView.dataSource = self
        optionsCollectionView.delegate = self
        itemLabel.text = Global.tempcart.baguette + " - £" + String(format: "%.2f",Global.tempcart.price)
       
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
        
        
        partoptions.removeAll()
        for each in optionsData.options{
            if each.type == currentScreen{
                partoptions.append(each)
            }
        }
    }

}
