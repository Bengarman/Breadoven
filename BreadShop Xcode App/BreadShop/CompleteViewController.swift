//
//  CompleteViewController.swift
//  BreadShop
//
//  Created by Ben Garman on 10/12/2019.
//  Copyright © 2019 Ben Garman. All rights reserved.
//

import UIKit

class CompleteViewController: UIViewController {

    @IBOutlet weak var orderNumberText: UILabel!
    @IBOutlet weak var collectionTimeText: UILabel!
    
    @IBOutlet weak var donePressed: UIButton!
    @IBAction func doneClicked(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        orderNumberText.text = "order number: " + payment.orderNumber
        collectionTimeText.text = "collection time: " + payment.collectionTime
        // Do any additional setup after loading the view.
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
