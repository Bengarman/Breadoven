//
//  SignUpView.swift
//  SwiftUIStarterKitApp
//
//  Created by Osama Naeem on 03/08/2019.
//  Copyright © 2019 NexThings. All rights reserved.
//

import SwiftUI
import PassKit

struct CheckoutView: View {
    
    @Binding var isShowing: Bool
    @State var price: Double
    @State var cartData : CartViewModel
    
    @State private var selectedDate = Date()
    let paymentHandler = PaymentHandler()
    @State var completeStatus = false
    @State var orderNUmber = ""
    
    
    var body: some View {
        GeometryReader { geometry in
            if completeStatus{
                VStack{
                    VStack{
                        HStack(alignment: .top){
                            Text("Order Complete")
                                .font(.custom("Montserrat-Bold", size: 20))
                        }.frame(alignment: .top)
                        .padding()
                        Spacer()
                    }
                    VStack{
                        Spacer()
                        VStack(alignment: .center){
                            Text("Please go to Quick Kit at " + getTime(time: selectedDate))
                                .lineLimit(nil)
                            Spacer()
                            Text("Order Number: " + self.orderNUmber)
                        }.frame(alignment: .center)
                        .padding()
                        Spacer()
                    }
                    VStack{
                        Spacer()
                        HStack(alignment: .bottom){
                            Button(action: {
                                self.isShowing = false
                            }) {
                                Text("Go Home")
                            }
                            .padding()
                        }.frame(alignment: .bottom)
                        
                    }
                }
                .background(RoundedRectangle(cornerRadius: 10)
                                .fill(Color(red: 200 / 255, green: 200 / 255, blue: 200 / 255))
                                .frame(width: geometry.size.width, height: geometry.size.width))
                .frame(width: geometry.size.width, height: geometry.size.width)
            }else{
                VStack{
                    VStack{
                        HStack(alignment: .top){
                            Text("Check Out")
                                .font(.custom("Montserrat-Bold", size: 20))
                        }.frame(alignment: .top)
                        .padding()
                        Spacer()
                    }
                    VStack{
                        Spacer()
                        HStack(alignment: .center){
                            DatePicker("Please set collection time: ", selection: $selectedDate, in: ...Date(), displayedComponents: .hourAndMinute)
                                .font(.custom("Montserrat-Bold", size: 15))
                        }.frame(alignment: .center)
                        .padding()
                        Spacer()
                    }
                    VStack{
                        Spacer()
                        HStack(alignment: .bottom){
                            VStack(spacing: 10){
                                PaymentButton(price: price)
                                Button(action: {
                                    self.orderNUmber = sendServer(selectedDate: selectedDate, paid: false, price: price, cartData: cartData)
                                    self.completeStatus = true
                                    
                                }){
                                    ZStack{
                                        
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(Color.black)
                                            .frame(minWidth: 100, maxWidth: 400)
                                            .frame(height: 40)
                                            .frame(maxWidth: .infinity)
                                        Text("Cash On Collection")
                                            .foregroundColor(Color.white)
                                            .font(.system(size:17, weight: .semibold, design: .rounded))
                                    }
                                    
                                }
                            }
                            .padding()
                        }.frame(alignment: .bottom)
                        
                    }
                }
                .background(RoundedRectangle(cornerRadius: 10)
                                .fill(Color(red: 200 / 255, green: 200 / 255, blue: 200 / 255))
                                .frame(width: geometry.size.width, height: geometry.size.width))
                .frame(width: geometry.size.width, height: geometry.size.width)
            }
        }
        
    }
    
}

func sendServer(selectedDate: Date, paid: Bool, price: Double, cartData: CartViewModel) -> String {
    let userID = String(UserDefaults.standard.integer(forKey: "userID"))
    let deviceID = String(UIDevice.current.identifierForVendor!.uuidString)
    let collectionTime = getTime(time: selectedDate)
    
    var queryDetails = [URLQueryItem]()
    var orderID = ""
    
    
    queryDetails = [
        URLQueryItem(name: "userID", value: userID),
        URLQueryItem(name: "deviceID", value: deviceID),
        URLQueryItem(name: "collection", value: String(collectionTime)),
        URLQueryItem(name: "comment", value: ""),
        URLQueryItem(name: "amount", value: String(price))
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
    
    for item in cartData.items{
        
        var tempMods = ""
        for mods in item.itemOptions{
            tempMods += String(mods.modID) + ", "
        }
        tempMods.removeLast(2)
        queryDetails = [
            URLQueryItem(name: "orderID", value: orderID),
            URLQueryItem(name: "itemID", value: String(item.itemID)),
            URLQueryItem(name: "quantity", value: String(item.itemQuantity)),
            URLQueryItem(name: "mods", value: tempMods)
        ]
        if let url = URL(string: getURLAddress(pathName: "addOrderLine.php", querys: queryDetails)){
            
            do {                _  = try String(contentsOf: url)
            } catch {}
        } else {
            print("Unable to add items to order in database")
        }
        queryDetails = [ URLQueryItem(name: "orderID", value: orderID)]
        if let url = URL(string: getURLAddress(pathName: "notifyShop.php", querys: queryDetails)){
            do {
                let content = try String(contentsOf: url)
                print(content)
            } catch {}
        } else {
            print("Unable to notify shop")
        }
        
    }
    return orderID
}
func getTime(time: Date) -> String{
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    return formatter.string(from: time)
}
