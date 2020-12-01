//
//  MenuViewController.swift
//  BreadShop
//
//  Created by Ben Garman on 02/10/2019.
//  Copyright © 2019 Ben Garman. All rights reserved.
//

import UIKit
extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

class menuTableCell : UITableViewCell{
    @IBOutlet weak var labelMenu: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
}

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath as IndexPath) as! menuTableCell
        cell.labelMenu.text = items[indexPath.row]
        cell.priceLabel.text = "£ " + priceArray[indexPath.row] + "  "
        return cell
    }
    
    var items = [String()]
    var priceArray = [String()]
    var idArray = [String()]
    var descArray = [String()]
    var imageArray = [String()]
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Global.tempcart.baguette = String(items[indexPath.row].dropFirst(2))
        Global.tempcart.price = Double(priceArray[indexPath.row])!
        Global.tempcart.baguetteId = Int(idArray[indexPath.row])!
        Global.baguetteDesc = String(descArray[indexPath.row])
        Global.baguetteImage = String(imageArray[indexPath.row])
        performSegue(withIdentifier: "showItem", sender: nil)
    }

    @IBOutlet weak var titleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.attributedText = NSAttributedString(string: Global.menuPage, attributes:
            [.underlineStyle: NSUnderlineStyle.single.rawValue])
        //titleLabel.text = Global.menuPage
        items.removeAll()
        priceArray.removeAll()
        idArray.removeAll()
        descArray.removeAll()
        imageArray.removeAll()
        if let url = URL(string: "http://garman.live/BreadShop/menu/menu.php?category=" + String(Global.menuID)){
            do {
                
                let contents = try String(contentsOf: url)
                print(contents)
                let feed = contents.components(separatedBy: "\n")
                for thing in feed{
                    let feedItems = thing.components(separatedBy: "\t")
                    if feedItems[0] != ""{
                        let price = Double(feedItems[1])!
                        
                        let formatted = String(format: "%.2f", price)
                        items.append("- " + feedItems[0])
                        priceArray.append(formatted)
                        idArray.append(feedItems[2])
                        descArray.append(feedItems[3])
                        imageArray.append(feedItems[4])
                    }
                    
                }
            } catch {}
        } else {
            print("catch")
        }
        
        // Do any additional setup after loading the view.
    }
    @IBAction func cartPressed(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "cartViewController") as! CartViewController
        self.present(newViewController, animated: true, completion: nil)
        let calendar = Calendar.current
        let now = Date()
        let eight_today = calendar.date(bySettingHour: 11, minute: 0, second: 0, of: now)!
        let four_thirty_today = calendar.date(bySettingHour: 16, minute: 00, second: 0, of: now)!
        if (now >= eight_today) && (now <= four_thirty_today){
            
        }else{
            let alert = UIAlertController(title: "Time Error", message: "We're sorry but the Bread Oven is currently closed. Try again tomorrow between 11:30 and 4:00.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
