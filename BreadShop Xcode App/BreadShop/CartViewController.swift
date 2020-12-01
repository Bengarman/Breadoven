//
//  CartViewController.swift
//  BreadShop
//
//  Created by Ben Garman on 03/12/2019.
//  Copyright © 2019 Ben Garman. All rights reserved.
//



import UIKit

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Global.cartDetail.count
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
            Global.cart.remove(at: indexPath.row)
            self.addDetails()
            tableView.reloadData()
            
        }
        delete.backgroundColor = UIColor.red
        
        return [delete]
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! cartTableViewCell
        cell.details.text = Global.cartDetail[indexPath.row].details
        cell.price.text = "£ " + String(format: "%.2f", Global.cartDetail[indexPath.row].price)
        if indexPath.row + 1 == Global.cartDetail.count{
            cell.bottomSlide.isHidden = false
        }
        return cell
    }
    
    

    @IBOutlet weak var subTotalLabel: UILabel!
    fileprivate func addDetails() {
        
        Global.cartDetail.removeAll()
        var price = 0.0
        for x in Global.cart{
            price = price + x.price
            if x.mealDeal == false{
                Global.cartDetail.append(cartInfoDetails(details: x.baguette + "\n" + x.toppings + "\n" + x.sauces , price: x.price, mealDeal: false))
            }else{
                Global.cartDetail.append(cartInfoDetails(details: x.baguette + "\n" + x.toppings + "\n" + x.sauces + "\n" + x.snack + "\n" + x.drink , price: x.price, mealDeal: true))
            }
            
        }
        subTotalLabel.text = "sub total: £" + String(format: "%.2f",price)
        payment.total = price
    }
    
    override func viewDidLoad() {
        addDetails()
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var cartTable: UITableView!
    let collectionTime = "12:30"
    var deviceID = ""
    @IBAction func pahNowPressed(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "collectionViewController") as! collectionViewController
        self.present(newViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func backClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
