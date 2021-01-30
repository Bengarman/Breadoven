//
//  ShopContentView.swift
//  SwiftUIStarterKitApp
//
//  Created by Osama Naeem on 06/08/2019.
//  Copyright © 2019 NexThings. All rights reserved.
//

import SwiftUI
import UIKit
import Combine

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner2(radius: radius, corners: corners) )
    }
}

struct RoundedCorner2: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct CategoryItem {
    var id: Int
    var itemDisplaySize: Bool
    var itemName: String
    var itemImage: Data
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
    var modID: Int
    var sizeName: String
    var sizePriceAddition: Double
}

struct CategoryGroup {
    var id: Int
    var resourceName: String
    var resourceDescription: String
    var resources : [CategoryItem]
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
    @ObservedObject var selectedActivity = ActivitySelected()
    @Binding var selected : Int
    @State var isShowing: Bool = false
    @State var placeItemSelected: CategoryItem? = nil
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(
        entity: ItemCategories.entity(),
        sortDescriptors: [NSSortDescriptor(key: "id", ascending: true)]
      ) var categories: FetchedResults<ItemCategories>
    
    @FetchRequest(
        entity: Items.entity(),
        sortDescriptors: [NSSortDescriptor(key: "id", ascending: true)]
      ) var items: FetchedResults<Items>
    
    @FetchRequest(
        entity: ItemMods.entity(),
        sortDescriptors: [NSSortDescriptor(key: "modID", ascending: true)]
      ) var itemsMods: FetchedResults<ItemMods>
    
    
    
    func test() -> ActivitiesData{
        var tempCategorys = [CategoryGroup]()
        var tempFeatured = [CategoryItem]()
        
        for category in categories{
            //first cat
            var tempItems = [CategoryItem]()
            for item in items{
                //first item
                //check if item belongs to cat
                if item.itemCategoriesID == category.id{
                    //item belongs to cat
                    //now check mods
                    var tempMods = [CategoryItemMods]()
                    for mod in itemsMods{
                        //first mod
                        //check of mod belongs to item
                        if mod.itemID == item.id{
                            //mod belongs to item
                            //split description down
                            let modifiers = mod.modifierString!.split(separator: "|")
                            //create an array of modifiers
                            var tempModifiers = [CategoryItemModifier]()
                            //start a counter
                            var count = 0
                            //loop through each modifier
                            for modifier in modifiers{
                                let modifierDet = modifier.split(separator: ":")
                                tempModifiers.append(CategoryItemModifier(id: count, modID: Int(modifierDet[0])!, sizeName: String(modifierDet[1]), sizePriceAddition: Double(modifierDet[2])!))
                                count += 1
                            }
                            var comp = false
                            if mod.compulsary == 1{
                                comp = true
                            }
                            tempMods.append(CategoryItemMods(id: Int(mod.modID - 1), modName: String(mod.modName!),compulsary: comp, modifiers: tempModifiers))
                        }
                    }
                    tempItems.append(CategoryItem(id: Int(item.id - 1), itemDisplaySize: true, itemName: String(item.itemName!), itemImage: Data(item.itemImage!), itemBasePrice: item.itemBasePrice, itemDescription: String(item.itemDescription!), itemAdditions: tempMods))
                }
            }
            if category.categoryName == "SPECIALS"{
                tempFeatured = tempItems

            }else{
                tempCategorys.append(CategoryGroup(id: Int(category.id - 1), resourceName: String(category.categoryName!), resourceDescription: String(category.categoryDescription!), resources: tempItems))
            }
        }
        return ActivitiesData(featuredItems: tempFeatured, categoryItems: tempCategorys)
        
    }
    
    var body: some View {
        GeometryReader { g in
                let temp1 = test()
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
                                ForEach(temp1.featuredItems!, id: \.id) { item in
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
                            ForEach(temp1.categoryItems!, id: \.id) { item in
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
                .sheet(isPresented: self.$isShowing) { PlaceDetailView(isShowing: self.$isShowing, selected: self.$selected, placeItem: self.$placeItemSelected)}
            
        }
        .edgesIgnoringSafeArea(.top)

    }

}



struct FeaturedItemsView: View {
    
    var featuredItem: CategoryItem
    
    var body: some View {
            ZStack{
                Image(uiImage: UIImage(data: featuredItem.itemImage) ?? UIImage())
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 155, height: 225)
                    .background(Color.black)
                    .cornerRadius(10)
                    .opacity(0.8)
               
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
            Image(uiImage: UIImage(data: categoryItem.itemImage) ?? UIImage())
                .resizable()
                .aspectRatio(contentMode: .fill)
                .opacity(0.8)
                .background(Color.black)
            
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
