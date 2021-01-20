//
//  ActivitiesCartView.swift
//  SwiftUIStarterKitApp
//
//  Created by Osama Naeem on 03/08/2019.
//  Copyright © 2019 NexThings. All rights reserved.
//

import SwiftUI
import Combine

var cartData = CartViewModel()


struct ActivitiesCartViewNav: View {
    var body: some View {
        if #available(iOS 14.0, *) {
            ActivitiesCartView(cartData: cartData)
        } else {
            // Fallback on earlier versions
        }
        
    }
}


@available(iOS 14.0, *)
struct ActivitiesCartView: View {
    @StateObject var cartData : CartViewModel
    @State var top = UIApplication.shared.windows.last?.safeAreaInsets.top

    var body: some View {
        GeometryReader { geometry in
            VStack {
                
                    HStack {
                        Text("\(cartData.items.count) items")
                            .font(.system(size: 24, weight: .bold, design: .default))
                            .padding(.leading, 12)
                            .padding(.top, 30)
                        
                        Spacer()
                        
                    }
                    .navigationBarTitle("Shopping Cart")
                    
                
                ScrollView (.vertical, showsIndicators: false) {
                    VStack (alignment: .leading) {
                        ForEach(cartData.items){item in
                            ItemView(shoppingCartItem: $cartData.items[getIndex(item: item)],shoppingCartItems: $cartData.items)
                                .frame(width: geometry.size.width - 24, height: 80)
                        }
                    }
                }
                .frame(height: geometry.size.height - 270)
                
                HStack (alignment: .bottom){
                    VStack (alignment: .leading){
                        Spacer()
                        HStack {
                            Spacer()
                        }
                        Text("Shipping to the United Kingdom")
                            .font(.system(size: 12))
                        Text("from £2.25")
                            .font(.system(size: 12))
                    }.frame(width: geometry.size.width / 2 - 12)

                    VStack(alignment: .trailing) {
                        Spacer()
                        HStack {
                            Spacer()
                        }
                        Text("\(cartData.items.count) items on")
                            .font(.system(size: 14))
                            .foregroundColor(Color.gray)
                        Text("\(calculateTotalPrice())")
                            .font(.system(.title))
                    }.frame(width: geometry.size.width / 2 - 12)
                    
                    
                }
                .padding()
                Button(action: {
                    UserDefaults.standard.set(false, forKey: "hasLaunchedBefore")
                }) {

                        HStack {
                        Text("Checkout")
                    }
                    .padding()
                    .frame(width: geometry.size.width - 24, height: 40)
                    .foregroundColor(Color.white)
                    .background(Color.blue)
                    .cornerRadius(5)
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 20)
          
            }
        }
    }
        
    func getIndex(item: Item)->Int{
            
        return cartData.items.firstIndex { (item1) -> Bool in
            return item.id == item1.id
        } ?? 0
    }
    
    func additem(item: Item){
            
        cartData.items.append(item)
    }
    
    func calculateTotalPrice()->String{
        
        var tot = 0.0
        for item in cartData.items {
            tot += item.itemPrice
        }
        
        
        return getPrice(value: tot)
    }
}


struct ItemView: View {
    // FOr Real Time Updates...
    @Binding var shoppingCartItem : Item
    @Binding var shoppingCartItems : [Item]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                HStack{
                    Spacer()
                    Button(action: {
                        withAnimation(.easeIn){deleteItem()}
                    }){
                        
                        Image(systemName: "trash")
                            .font(.title)
                            .frame(width: 90, height: 50)
                            .foregroundColor(Color.red)
                    }
                }

                
                HStack (spacing: 10) {
                    Image("\(shoppingCartItem.itemImage)")
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 40)
                        .aspectRatio(contentMode: ContentMode.fit)
                        .padding(.trailing, 5)
                        .padding(.leading, 5)
                    
                    VStack(alignment: .leading, spacing: 3) {
                        HStack {
                            Spacer()
                        }
                        Text("\(shoppingCartItem.itemName)")
                            .lineLimit(nil)
                            .foregroundColor(.primary)
                        Text("\(shoppingCartItem.itemOptions)")
                            .foregroundColor(.primary)
                            .font(.system(size: 12))
                            .foregroundColor(Color.gray)
                        Text("\(shoppingCartItem.itemQuantity)")
                            .foregroundColor(.primary)
                            .font(.system(size: 12))
                            .foregroundColor(Color.gray)
                            .padding(.bottom, 10)
                    }.frame(width: geometry.size.width - 150)
                     .padding(.top, 8)
                    VStack(alignment: .trailing){
                        //Spacer()
                        HStack {
                            Spacer()
                        }
                        Text("£" + String(format: "%.2f",shoppingCartItem.itemPrice))
                            .font(.system(size: 16))
                            .foregroundColor(Color.black)
                            .padding(.trailing, 15)
                           
                          
                    }.padding(.bottom, 10)
                }
                .background(Color(red: 242 / 255, green: 242 / 255, blue: 242 / 255))
                .contentShape(Rectangle())
                .offset(x: shoppingCartItem.offset)
                .gesture(DragGesture().onChanged(onChanged(value:)).onEnded(onEnd(value:)))
                
                
            }
            
            
        }.background(Color(red: 242 / 255, green: 242 / 255, blue: 242 / 255))
        .cornerRadius(10)
        
    }
    func onChanged(value: DragGesture.Value){
        if value.translation.width < 0{
            
            if shoppingCartItem.isSwiped{
                shoppingCartItem.offset = value.translation.width - 90
            }
            else{
                shoppingCartItem.offset = value.translation.width
            }
        }
    }
    
    
    func onEnd(value: DragGesture.Value){
        
        withAnimation(.easeOut){
            if value.translation.width < 0{
                if -value.translation.width > UIScreen.main.bounds.width / 2{
                    
                    shoppingCartItem.offset = -1000
                    deleteItem()
                }
                else if -shoppingCartItem.offset > 50{
                    // updating is Swipng...
                    shoppingCartItem.isSwiped = true
                    shoppingCartItem.offset = -90
                }
                else{
                    shoppingCartItem.isSwiped = false
                    shoppingCartItem.offset = 0
                }
            }else{
                shoppingCartItem.isSwiped = false
                shoppingCartItem.offset = 0
            }
        }
    }
    
    func deleteItem(){
        shoppingCartItems.removeAll { (item) -> Bool in
            return self.shoppingCartItem.id == item.id
        }
        
    }
}

func getPrice(value: Double)->String{
    
    return "£" + String(format: "%.2f",value)
}

