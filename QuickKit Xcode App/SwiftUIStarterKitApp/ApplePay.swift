import SwiftUI
import UIKit
import PassKit

typealias PaymentCompletionHandler = (Bool) -> Void

class PaymentHandler: NSObject {
    
    static let supportedNetworks: [PKPaymentNetwork] = [
        .amex,
        .masterCard,
        .visa
    ]
    
    var paymentController: PKPaymentAuthorizationController?
    var paymentSummaryItems = [PKPaymentSummaryItem]()
    var paymentStatus = PKPaymentAuthorizationStatus.failure
    var completionHandler: PaymentCompletionHandler?
    
    func startPayment(price: Double, completion: @escaping PaymentCompletionHandler) {
        
        let total = PKPaymentSummaryItem(label: "Fish & Chip Co:", amount: NSDecimalNumber(value: price), type: .final)
        
        paymentSummaryItems = [total];
        completionHandler = completion
        
        // Create our payment request
        let paymentRequest = PKPaymentRequest()
        paymentRequest.paymentSummaryItems = paymentSummaryItems
        paymentRequest.merchantIdentifier = "merchant.com.garmanapps.quickkit"
        paymentRequest.merchantCapabilities = .capability3DS
        paymentRequest.countryCode = "GB"
        paymentRequest.currencyCode = "GBP"
        paymentRequest.requiredShippingContactFields = [.phoneNumber, .emailAddress]
        paymentRequest.supportedNetworks = PaymentHandler.supportedNetworks
        
        // Display our payment request
        paymentController = PKPaymentAuthorizationController(paymentRequest: paymentRequest)
        paymentController?.delegate = self
        paymentController?.present(completion: { (presented: Bool) in
            if !presented {
                self.completionHandler!(false)
            }
        })
    }
}

extension PaymentHandler: PKPaymentAuthorizationControllerDelegate {
    
    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        
        // Perform some very basic validation on the provided contact information
        if payment.shippingContact?.emailAddress == nil || payment.shippingContact?.phoneNumber == nil {
            paymentStatus = .failure
        } else {
            // Here you would send the payment token to your server or payment provider to process
            // Once processed, return an appropriate status in the completion handler (success, failure, etc)
            paymentStatus = .success
        }
        
        completion(paymentStatus)
    }
    
    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        controller.dismiss {
            DispatchQueue.main.async {
                if self.paymentStatus == .success {
                    self.completionHandler!(true)
                } else {
                    self.completionHandler!(false)
                }
            }
        }
    }
}


struct PaymentButton: View {
    let paymentHandler = PaymentHandler() //As defined by Taif
    @State var price: Double
    
    var body: some View {
        Button(action: {
            // Using the code from Tarif!
            self.paymentHandler.startPayment(price: price) { success in
                if success {
                    print("Success")
                } else {
                    print("Failed")
                }
            }
        }, label: { EmptyView() } )
        .buttonStyle(PaymentButtonStyle())
    }
}

struct PaymentButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        return PaymentButtonHelper()
    }
}

struct PaymentButtonHelper: View {
    var body: some View {
        PaymentButtonRepresentable()
            .frame(minWidth: 100, maxWidth: 400)
            .frame(height: 40)
            .frame(maxWidth: .infinity)
    }
}

extension PaymentButtonHelper {
    struct PaymentButtonRepresentable: UIViewRepresentable {
        
        var button: PKPaymentButton {
            let button = PKPaymentButton(paymentButtonType: .buy, paymentButtonStyle: .black) /*customize here*/
            button.cornerRadius = 4.0 /* also customize here */
            return button
        }
        
        func makeUIView(context: Context) -> PKPaymentButton {
            return button
        }
        func updateUIView(_ uiView: PKPaymentButton, context: Context) { }
    }
}
