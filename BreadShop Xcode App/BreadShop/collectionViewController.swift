//
//  collectionViewController.swift
//  BreadShop
//
//  Created by Ben Garman on 08/12/2019.
//  Copyright © 2019 Ben Garman. All rights reserved.
//

import UIKit
import PassKit

//View controller for click and collect and deciding how to pay
class collectionViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    override func viewDidLoad() {
        
        //THIS NEEDS A COMPLETE REDESIGN
        //WHAT WAS I THINKING LOL
        
        
        /*datePicker.setValue(UIColor.white, forKeyPath: "textColor")
        datePicker.subviews[0].subviews[1].backgroundColor = UIColor.white
        datePicker.subviews[0].subviews[2].backgroundColor = UIColor.white
        datePicker.subviews[0].setNeedsLayout()
        datePicker.subviews[0].layoutIfNeeded()*/
        
        
        //Calendar that is used for date picker
        let calendar = Calendar.current
        
        //Getting the current year, month, day
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
        
        datePicker.minimumDate = minDate! as Date
        datePicker.maximumDate = maxDate! as Date
        datePicker.date = curDate! as Date
        
        super.viewDidLoad()
    }
    
    
    
    //Set the default start time and create variables
    var collectionTime = "12:30"
    var deviceID = ""
    
    
    //Apple pay vaild cards
    let SupportedPaymentNetworks = [PKPaymentNetwork.visa, PKPaymentNetwork.masterCard, PKPaymentNetwork.amex]
    //Merchant ID
    let ApplePayMerchantID = "merchant.com.garmanapps.breadoven"
    
    @IBAction func applePayPressed(_ sender: Any) {
        //Apple pay pressed
        //Setting up the product to be purchased with blank array
        var productToBuy = [PKPaymentSummaryItem]()
        //Loop through each item in cart and append to array
        for x in Global.cartDetail{
            if x.mealDeal == true{
                productToBuy.append(PKPaymentSummaryItem(label: "Meal Deal", amount:  NSDecimalNumber(decimal:Decimal(x.price)), type: .final))
            }else{
                productToBuy.append(PKPaymentSummaryItem(label: "Baguette", amount:  NSDecimalNumber(decimal:Decimal(x.price)), type: .final))
            }
        }
        //Append the total price at end
        productToBuy.append(PKPaymentSummaryItem(label: "Total", amount: NSDecimalNumber(decimal:Decimal(payment.total))))

        //Setup payment request details
        let request = PKPaymentRequest()
        request.merchantIdentifier = ApplePayMerchantID
        request.supportedNetworks = SupportedPaymentNetworks
        request.merchantCapabilities = PKMerchantCapability.capability3DS
        //Pounds
        request.countryCode = "GB"
        request.currencyCode = "GBP"
        
        //Put payment summary in the details
        request.paymentSummaryItems = productToBuy
        //Create the controller and present it
        let applePayController = PKPaymentAuthorizationViewController(paymentRequest: request)
        self.present(applePayController!, animated: true, completion: nil)
        
        applePayController?.delegate = self

    }
    @IBAction func cashOnCollectionPressed(_ sender: Any) {
        //Cash on collection payment
        
        //Get date from ticker
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        collectionTime = dateFormatter.string(from: datePicker.date)

        //Create the order using php script
        //Gets the device id for later identification
        //Gets the collection time and price
        if let url = URL(string: "http://garman.live/BreadShop/code/createOrder.php?deviceID=" + String(UIDevice.current.identifierForVendor!.uuidString) + "&collection=" + String(collectionTime) + "&amount=" + String(Int(payment.total * 100))){
            do {
                //Gets the order id bvut calls it device id
                deviceID = try String(contentsOf: url)
                deviceID = deviceID.replacingOccurrences(of: " ", with: "")
            } catch {}
        } else {
            print("catch")
        }
        
        
        //I just looked and implemented this shit
        // Currently sends the first order and then checks the hoghest and assigns all of the products
        // really shit as two could order and fuck it up
        //Needs reimplementaion
        
        
        
        var counter = 0
        for x in Global.cart{
            if x.mealDeal == true{
                var urlString = "http://garman.live/BreadShop/code/addItems.php?orderID=" + deviceID + "&foodID=" + String(x.baguetteId) + "&snack=" + String(x.snackID) + "&drink=" + String(x.drinkID) + "&extra=" + String(x.toppings) + "&sauces=" + String(x.sauces)
                urlString = urlString.replacingOccurrences(of: "-", with: "")
                urlString = urlString.replacingOccurrences(of: "/ ", with: "- ")
                urlString = urlString.replacingOccurrences(of: "(£0.70)", with: "")
                urlString = urlString.replacingOccurrences(of: "    ", with: "")
                urlString = urlString.replacingOccurrences(of: "(£1.00)", with: "")
                let urlNew:String = urlString.replacingOccurrences(of: " ", with: "%20")
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
