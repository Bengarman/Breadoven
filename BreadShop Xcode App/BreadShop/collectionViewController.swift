//
//  collectionViewController.swift
//  BreadShop
//
//  Created by Ben Garman on 08/12/2019.
//  Copyright © 2019 Ben Garman. All rights reserved.
//

import UIKit
import Foundation
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
    var orderID = ""
    var queryDetails = [URLQueryItem]()

    
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
    func orderComplete(paid: Bool) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        collectionTime = dateFormatter.string(from: datePicker.date)
        
        
        queryDetails = [
            URLQueryItem(name: "deviceID", value: String(UIDevice.current.identifierForVendor!.uuidString)),
            URLQueryItem(name: "collection", value: String(collectionTime)),
            URLQueryItem(name: "amount", value: String(Int(payment.total)))
        ]

        if paid == true{
            queryDetails.append(URLQueryItem(name: "paid", value: "1"))
        }else{
            queryDetails.append(URLQueryItem(name: "paid", value: "0"))
        }
        
        if let url = URL(string: getURLAddress(pathName: "createOrder.php", querys: queryDetails)){
            do {
                orderID = try String(contentsOf: url).replacingOccurrences(of: " ", with: "")
            } catch {}
        } else {
            print("Unable to create Order in database")
        }
        
        for x in Global.cart{
            queryDetails = [
                URLQueryItem(name: "orderID", value: orderID),
                URLQueryItem(name: "foodID", value: String(x.baguetteId).cleanNumb),
                URLQueryItem(name: "extra", value: String(x.toppings).clean),
                URLQueryItem(name: "sauces", value: String(x.sauces).clean)
            ]
            if x.mealDeal == true{
                queryDetails.append(contentsOf:
                [
                    URLQueryItem(name: "meal", value: "TRUE"),
                    URLQueryItem(name: "snack", value: String(x.snackID).cleanNumb),
                    URLQueryItem(name: "drink", value: String(x.drinkID).cleanNumb)
                ])
            }
            if let url = URL(string: getURLAddress(pathName: "addOrderItems.php", querys: queryDetails)){
                do {
                    let content = try String(contentsOf: url)
                    print(content)
                } catch { }
            } else {
                print("Unable to add food item in database")
            }
        }
        
        
        queryDetails = [ URLQueryItem(name: "orderID", value: orderID)]
        if let url = URL(string: getURLAddress(pathName: "notifyShop.php", querys: queryDetails)){
            do {
                let content = try String(contentsOf: url)
                print(content)
            } catch {}
        } else {
            print("Unable to create Order in database")
        }
        
        payment.orderNumber = orderID
        payment.collectionTime = String(collectionTime)
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "done") as! CompleteViewController
        self.present(newViewController, animated: true, completion: nil)
    }
    
    @IBAction func cashOnCollectionPressed(_ sender: Any) {
        orderComplete(paid: false)
    }
    
    @IBAction func backpressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}


extension collectionViewController: PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping ((PKPaymentAuthorizationStatus) -> Void)) {
        completion(PKPaymentAuthorizationStatus.success)
        print("paid")
        orderComplete(paid: true)
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
        print("fail")
    }
}
