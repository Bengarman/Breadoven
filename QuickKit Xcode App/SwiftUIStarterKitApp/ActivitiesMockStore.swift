//
//  ActivitiesMockStore.swift
//  SwiftUIStarterKitApp
//
//  Created by Osama Naeem on 06/08/2019.
//  Copyright © 2019 NexThings. All rights reserved.
//

import SwiftUI

func getURLAddress(pathName: String, querys: [URLQueryItem] = []) -> String{
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "garmanapps.co.uk"
    urlComponents.path = "/appAPI/fish/" + pathName
    urlComponents.queryItems = querys
    return urlComponents.url!.absoluteString
}

struct ActivitiesData {
    var featuredItems: [CategoryItem]?
    var categoryItems: [CategoryGroup]?
}

class ActivitiesMockStore1 {
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
    
    
    var tempCategorys = [CategoryGroup]()
    var tempFeatured = [CategoryItem]()
    
    func test() {
        
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
    }
    
    
    
    
}

class CartViewModel: ObservableObject{
    @Published var items = [Item]()
}

struct Item : Identifiable{
    var id = UUID().uuidString
    var itemID : Int
    var itemName : String
    var itemPrice : Double
    var itemOptions: [CategoryItemModifier]
    var itemQuantity: Int
    var itemImage: Data
    var offset: CGFloat = 0
    var isSwiped: Bool = false
}
    
