//
//  ShopContentView.swift
//  SwiftUIStarterKitApp
//
//  Created by Osama Naeem on 06/08/2019.
//  Copyright © 2019 NexThings. All rights reserved.
//

import SwiftUI
import Combine

struct CategoryItem {
    var id: Int
    var itemDisplaySize: Bool
    var itemName: String
    var itemImage: String
    var itemQuantity: Int = 0
    var itemBasePrice : Double
    var itemDescription: String
    var itemAdditions: [CategoryItemMods]
   
}

struct CategoryItemMods {
    var id: Int
    var modName : String
    var compulsary : Bool
    var selected: Int?
    var modifiers: [CategoryItemModifier]
}

struct CategoryItemModifier {
    var id: Int
    var sizeName: String
    var sizePriceAddition: Double
}

struct CategoryGroup {
    var id: Int
    var resourceName: String
    var resourceDescription: String
    var resources : [CategoryItem]
}


struct ActivitiesData {
    var featuredItems: [CategoryItem]
    var categoryItems: [CategoryGroup]
}



class Activities: ObservableObject {
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    var activitiesCollection : ActivitiesData {
       willSet {
            objectWillChange.send()
        }
    }
    
    init(data: ActivitiesData ) {
        self.activitiesCollection = data
    }
}

class ActivitySelected: ObservableObject {
    @Published var index: Int = 0
}

struct ActivitiesContentView: View {
    @EnvironmentObject var settings: UserSettings
    @ObservedObject var activtiesData : Activities
    @ObservedObject var selectedActivity = ActivitySelected()
    @State var isShowing: Bool = false
    @State var placeItemSelected: CategoryItem? = nil
    
    var body: some View {
        GeometryReader { g in
            if #available(iOS 14.0, *) {
                ScrollView(showsIndicators: false){
                    VStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color(red: 23/255, green: 86/255, blue: 119/255))
                            .frame(width: g.size.width, height: 30)
                        Image("LogoDefault")
                            .resizable()
                            .padding(.top,-10)
                            .frame(width: g.size.width, height: g.size.height / 3)
                        
                        HStack{
                            Spacer()
                            Text("OUR SPECIALS")
                                .font(.custom("Montserrat-Bold", size: 20))
                                .padding(.top, 10)
                                //.foregroundColor(Color(red: 238/255, green: 129/255, blue: 13/255))
                            Spacer()
                        }
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack (spacing: 10) {
                                ForEach(self.activtiesData.activitiesCollection.featuredItems, id: \.id) { item in
                                    Button(action: {
                                        self.placeItemSelected = item
                                        self.isShowing = true
                                    }) {
                                        FeaturedItemsView(featuredItem: item)
                                            .frame(width: 155, height: 225)
                                    }
                                }
                                
                            }.padding(.leading, 30)
                            .padding(.trailing, 30)
                            .padding(.bottom, 10)
                            
                        }
                        
                        VStack (spacing: 20) {
                            ForEach(self.activtiesData.activitiesCollection.categoryItems, id: \.id) { item in
                                ZStack {
                                    VStack (alignment: .leading){
                                        Text(item.resourceName)
                                            .padding(.top, 18)
                                            .padding(.leading, 18)
                                            .font(.system(size: 20, weight: .bold, design: Font.Design.default))
                                            .foregroundColor(Color.black)
                                        Text(item.resourceDescription)
                                            .padding(.leading, 18)
                                            .padding(.trailing, 18)
                                            .font(.system(size: 14))
                                            .foregroundColor(Color.black)
                                        
                                        
                                        ScrollView (.horizontal, showsIndicators: false) {
                                            HStack (spacing: 10) {
                                                ForEach(0..<item.resources.count, id: \.self) { index in
                                                    Button(action: {
                                                        self.placeItemSelected = item.resources[index]
                                                        self.isShowing = true
                                                    })
                                                    {
                                                        CategoryIcon(categoryItem: item.resources[index])
                                                            .frame(width: 150, height: 200)
                                                    }
                                                    
                                                }
                                                
                                                
                                            }.padding(.leading, 18)
                                            .padding(.trailing, 18)
                                            .padding(.top, 25)
                                        }
                                        
                                        Spacer()
                                    }
                                }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                                .background(Color(red: 242 / 255, green: 242 / 255, blue: 242 / 255))
                                .cornerRadius(10)
                                
                            }
                        }.padding(.leading, 20)
                        .padding(.trailing, 20)
                        
                        
                    }
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
                    
                }
                .edgesIgnoringSafeArea(.top)
                .sheet(isPresented: self.$isShowing) { PlaceDetailView(isShowing: self.$isShowing, placeItem: self.$placeItemSelected)}
            } else {
                // Fallback on earlier versions
            }
        }
        .edgesIgnoringSafeArea(.top)

    }

}



struct FeaturedItemsView: View {
    
    var featuredItem: CategoryItem
    
    var body: some View {
            ZStack{
                if #available(iOS 14.0, *) {
                    RemoteImage(url: (featuredItem.itemImage))
                        .frame(width: 155, height: 225)
                        .background(Color.black)
                        .cornerRadius(10)
                        .opacity(0.8)
                }
               
                VStack (alignment: .leading) {
                    
                    Text(featuredItem.itemName)
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 20, weight: .bold, design: Font.Design.default))
                }
                    
                
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
          
    }
}


struct CategoryIcon: View {
    
    var categoryItem: CategoryItem
    
    var body: some View {
        ZStack{
            if #available(iOS 14.0, *) {
                RemoteImage(url: (categoryItem.itemImage))
                    .opacity(0.8)
                    .aspectRatio(contentMode: .fill)
                    .background(Color.black)
            }
            VStack(alignment: .center) {

                Text(categoryItem.itemName)
                    .font(.system(size: 16, weight: .bold, design: Font.Design.default))
                    .frame(width: 150)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
            }
                    
        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .cornerRadius(10)
    }
          
}
