//
//  ViewController.swift
//  BreadShop
//
//  Created by Ben Garman on 01/10/2019.
//  Copyright © 2019 Ben Garman. All rights reserved.
//

import UIKit

class MenuCell: UICollectionViewCell {
    @IBOutlet weak var menuImage: UIImageView!
    @IBOutlet weak var menuLabel: UILabel!
}

class CategoryCell: UICollectionViewCell {
    @IBOutlet weak var categoriesImage: UIImageView!
    @IBOutlet weak var categoriesLabel: UILabel!
}

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    func prefersHomeIndicatorAutoHidden() -> Bool {
        return true
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1{ return Global.category.count } else{ return Global.menu.count }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuCell", for: indexPath as IndexPath) as! MenuCell
            cell.menuLabel.text = Global.menu[indexPath.row].name
            let url = URL(string: Global.menu[indexPath.row].url)
            let data = try? Data(contentsOf: url!)
            cell.menuImage.image = UIImage(data: data!)
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoriesCell", for: indexPath as IndexPath) as! CategoryCell
            cell.categoriesLabel.text = Global.category[indexPath.row].name
            let url = URL(string: Global.category[indexPath.row].url)
            let data = try? Data(contentsOf: url!)
            cell.categoriesImage.image = UIImage(data: data!)
            
            return cell
            
            
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 0{
            Global.menuPage = Global.menu[indexPath.row].name
            Global.menuID = Global.menu[indexPath.row].id
        }
        performSegue(withIdentifier: "menuItem", sender: nil)
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
    
    @IBOutlet weak var categoriesCollection: UICollectionView!
    @IBOutlet weak var menuCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //categoriesCollection.reloadData()
        //menuCollection.reloadData()
    }
    
    
}

