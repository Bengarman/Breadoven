//
//  collectionViewController.swift
//  BreadShop
//
//  Created by Ben Garman on 08/12/2019.
//  Copyright © 2019 Ben Garman. All rights reserved.
//

import UIKit
import PassKit


class collectionViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    override func viewDidLoad() {
        /*datePicker.setValue(UIColor.white, forKeyPath: "textColor")
        datePicker.subviews[0].subviews[1].backgroundColor = UIColor.white
        datePicker.subviews[0].subviews[2].backgroundColor = UIColor.white
        datePicker.subviews[0].setNeedsLayout()
        datePicker.subviews[0].layoutIfNeeded()*/
        
        
        let calendar = Calendar.current
        let date2 = Date()
        let calendar2 = Calendar.current
        let year = calendar2.component(.year, from: date2)
        let month = calendar2.component(.month, from: date2)
        let day = calendar2.component(.day, from: date2)
        
        var components = DateComponents()
        components.minute = 15
        let curDate = Calendar.current.date(byAdding: components, to: Date())
        
        var maxDateComponent = DateComponents()
        maxDateComponent.hour = 16
        maxDateComponent.minute = 00
        maxDateComponent.year = year
        maxDateComponent.month = month
        maxDateComponent.day = day
        let maxDate = calendar.date(from: maxDateComponent)
        
        
        
        var minDateComponent = DateComponents()
        minDateComponent.year = year
        minDateComponent.month = month
        minDateComponent.day = day
        minDateComponent.hour = 12
        minDateComponent.minute = 00
        let minDate = calendar.date(from: minDateComponent)
        
        print(minDate)
        print(curDate)
        print(maxDate)
        
        datePicker.minimumDate = minDate! as Date
        datePicker.maximumDate = maxDate! as Date
        datePicker.date = curDate! as Date
        
        super.viewDidLoad()
    }
    var collectionTime = "12:30"
    var deviceID = ""
    
    
    
    let SupportedPaymentNetworks = [PKPaymentNetwork.visa, PKPaymentNetwork.masterCard, PKPaymentNetwork.amex]
    let ApplePayMerchantID = "merchant.com.garmanapps.breadoven"
    
    @IBAction func applePayPressed(_ sender: Any) {
        var productToBuy = [PKPaymentSummaryItem(label: "Meal Deal", amount:  3.50, type: .final)]
        productToBuy.removeAll()
        for x in Global.cartDetail{
            if x.mealDeal == true{
                productToBuy.append(PKPaymentSummaryItem(label: "Meal Deal", amount:  NSDecimalNumber(decimal:Decimal(x.price)), type: .final))
            }else{
                productToBuy.append(PKPaymentSummaryItem(label: "Item", amount:  NSDecimalNumber(decimal:Decimal(x.price)), type: .final))
            }
        }
        let request = PKPaymentRequest()
        request.merchantIdentifier = ApplePayMerchantID
        request.supportedNetworks = SupportedPaymentNetworks
        request.merchantCapabilities = PKMerchantCapability.capability3DS
        request.countryCode = "GB"
        request.currencyCode = "GBP"
        
        productToBuy.append(PKPaymentSummaryItem(label: "Total", amount: NSDecimalNumber(decimal:Decimal(payment.total))))
        request.paymentSummaryItems = productToBuy as! [PKPaymentSummaryItem]
        let applePayController = PKPaymentAuthorizationViewController(paymentRequest: request)
        self.present(applePayController!, animated: true, completion: nil)
        
        applePayController?.delegate = self

    }
    @IBAction func cashOnCollectionPressed(_ sender: Any) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        collectionTime = dateFormatter.string(from: datePicker.date)
        print(collectionTime)
        
        if let url = URL(string: "http://garman.live/BreadShop/code/createOrder.php?deviceID=" + String(UIDevice.current.identifierForVendor!.uuidString) + "&collection=" + String(collectionTime) + "&amount=" + String(Int(payment.total * 100))){
            do {
                deviceID = try String(contentsOf: url)
                deviceID = deviceID.replacingOccurrences(of: " ", with: "")
            } catch {}
        } else {
            print("catch")
        }
        var counter = 0
        //foodID, extra, sauces, snackID, drinkID
        for x in Global.cart{
            if x.mealDeal == true{
                var urlString = "http://garman.live/BreadShop/code/addItems.php?orderID=" + deviceID + "&foodID=" + String(x.baguetteId) + "&snack=" + String(x.snackID) + "&drink=" + String(x.drinkID) + "&extra=" + String(x.toppings) + "&sauces=" + String(x.sauces)
                urlString = urlString.replacingOccurrences(of: "-", with: "")
                urlString = urlString.replacingOccurrences(of: "/ ", with: "- ")
                urlString = urlString.replacingOccurrences(of: "(£0.70)", with: "")
                urlString = urlString.replacingOccurrences(of: "    ", with: "")
                urlString = urlString.replacingOccurrences(of: "(£1.00)", with: "")
                let urlNew:String = urlString.replacingOccurrences(of: " ", with: "%20")
                print(urlNew)
                if let url = URL(string: urlNew ){
                    do {
                        let output = try String(contentsOf: url)
                        if counter == 0{
                            counter = Int(output)!
                        }
                    } catch {}
                } else {
                    print("catch")
                }
            }else{
                var urlString = "http://garman.live/BreadShop/code/addItem.php?orderID=" + deviceID + "&foodID=" + String(x.baguetteId) + "&extra=" + String(x.toppings) + "&sauces=" + String(x.sauces)
                urlString = urlString.replacingOccurrences(of: "-", with: "")
                urlString = urlString.replacingOccurrences(of: "/ ", with: "- ")
                urlString = urlString.replacingOccurrences(of: "(£0.70)", with: "")
                urlString = urlString.replacingOccurrences(of: "    ", with: "")
                urlString = urlString.replacingOccurrences(of: "(£1.00)", with: "")
                let urlNew:String = urlString.replacingOccurrences(of: " ", with: "%20")
                print(urlNew)
                if let url = URL(string: urlNew ){
                    do {
                        let output = try String(contentsOf: url)
                        if counter == 0{
                            counter = Int(output)!
                        }
                    } catch {}
                } else {
                    print("catch")
                }
            }
            
        }
        print(counter)
        payment.orderNumber = String(counter)
        payment.collectionTime = String(collectionTime)
        if let url = URL(string: "http://garman.live/test.php?number=" + String(counter)){
            do {
                let test = try String(contentsOf: url)
            } catch {}
        } else {
            print("catch")
        }
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "done") as! CompleteViewController
        self.present(newViewController, animated: true, completion: nil)
    }
    
    @IBAction func backpressed(_ sender: Any) {
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


extension collectionViewController: PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping ((PKPaymentAuthorizationStatus) -> Void)) {
        completion(PKPaymentAuthorizationStatus.success)
        print("paid")
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
        print("fail")
    }
}
