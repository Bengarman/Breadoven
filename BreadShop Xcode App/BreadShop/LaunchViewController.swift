//
//  LaunchViewController.swift
//  BreadShop
//
//  Created by Ben Garman on 09/10/2019.
//  Copyright © 2019 Ben Garman. All rights reserved.
//
struct Options {
    var name = ""
    var url = UIImage()
    var type = 0
    var selected = false
}
struct categoryItems{
    var id = 0
    var name = ""
    var url = ""
}
struct menuItems{
    var id = 0
    var name = ""
    var url = ""
}
struct mealDeal{
    var name = ""
    var url = UIImage()
}
struct cartItem{
    var mealDeal = false
    var baguette = ""
    var baguetteId = 0
    var toppings = ""
    var sauces = ""
    var snack = ""
    var snackID = 0
    var drink = ""
    var drinkID = 0
    var price = 0.0
}
struct cartInfoDetails{
    var details = ""
    var price = 0.0
    var mealDeal = true
}
struct Global{
    static var cartDetail = [cartInfoDetails()]
    static var menuPage = ""
    static var menuID = 0
    static var menu = [menuItems()]
    static var category = [categoryItems()]
    static var drinks = [mealDeal()]
    static var snacks = [mealDeal()]
    static var cart = [cartItem()]
    static var tempcart = cartItem()
    static var baguetteDesc = ""
    static var baguetteImage = ""
}
struct payment{
    static var collectionTime = ""
    static var orderNumber = ""
    static var paid = true
    static var total = 0.0
}
struct optionsData{
    static var freeOptions = [Options()]
    static var paidOptions = [Options()]
    static var freeSauce = [Options()]
    static var paidSauce = [Options()]
    static var bread = ""
    static var options = [Options()]
    
}

import UIKit

class LaunchViewController: UIViewController {

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        Global.cart.removeAll()
        optionsData.freeOptions.removeAll()
        optionsData.paidOptions.removeAll()
        optionsData.freeSauce.removeAll()
        optionsData.paidSauce.removeAll()
        
        optionsData.options.removeAll()
        if let url = URL(string: "http://garman.live/BreadShop/options/options.php"){
            do {
                let contents = try String(contentsOf: url)
                let feed = contents.components(separatedBy: "\n")
                for thing in feed{
                    let feedItems = thing.components(separatedBy: "\t")
                    if feedItems[0] != ""{
                        let url = URL(string: feedItems[1])
                        let data = try? Data(contentsOf: url!)
                        
                        optionsData.options.append(Options(name: feedItems[0], url: UIImage(data: data!)!, type: Int(feedItems[2])! ,selected: false))
                    }
                    
                }
            } catch {}
        } else {
            print("catch")
        }
        
        Global.drinks.removeAll()
        Global.snacks.removeAll()
        
        if let url = URL(string: "http://garman.live/BreadShop/menu/sides.php"){
            do {
                let contents = try String(contentsOf: url)
                let feed = contents.components(separatedBy: "\n")
                for thing in feed{
                    
                    let feedItems = thing.components(separatedBy: "\t")
                    
                    if feedItems[0] != ""{
                        if feedItems[1] == "Drinks"{
                            let url = URL(string: feedItems[2])
                            let data = try? Data(contentsOf: url!)
                            Global.drinks.append(mealDeal(name: feedItems[0] + " - " + feedItems[3], url: UIImage(data: data!)!))
                        }else{
                            let url = URL(string: feedItems[2])
                            let data = try? Data(contentsOf: url!)
                            Global.snacks.append(mealDeal(name: feedItems[0] + " - " + feedItems[3], url: UIImage(data: data!)!))
                        }
                    }
                }
            } catch {}
        } else {
            print("catch")
        }
        
        Global.menu.removeAll()
        Global.category.removeAll()
        if let url = URL(string: "http://garman.live/BreadShop/categorys/menu.php"){
            do {
                
                let contents = try String(contentsOf: url)
                print(contents)
                let feed = contents.components(separatedBy: "\n")
                for thing in feed{
                    let feedItems = thing.components(separatedBy: "\t")
                    if feedItems[0] != ""{
                        Global.menu.append(menuItems(id: Int(feedItems[0])!, name: feedItems[1].lowercased(), url: feedItems[2]))
                    }
                    
                }
            } catch {}
        } else {
            print("catch")
        }
        
        if let url = URL(string: "http://garman.live/BreadShop/categorys/category.php"){
            do {
                
                let contents = try String(contentsOf: url)
                print(contents)
                let feed = contents.components(separatedBy: "\n")
                for thing in feed{
                    let feedItems = thing.components(separatedBy: "\t")
                    if feedItems[0] != ""{
                        Global.category.append(categoryItems(id: Int(feedItems[0])!, name: feedItems[1].lowercased(), url: feedItems[2]))
                    }
                    
                }
            } catch {}
        } else {
            print("catch")
        }
        
        performSegue(withIdentifier: "launcher", sender: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
