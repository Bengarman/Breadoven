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
    urlComponents.scheme = "http"
    urlComponents.host = "garmanapps.co.uk"
    urlComponents.path = "/appAPI/fish/" + pathName
    urlComponents.queryItems = querys
    return urlComponents.url!.absoluteString
}


func getCategories() -> ActivitiesData{
    //Get categories
    var queryDetails = [URLQueryItem]()
    var tempCategorys = [CategoryGroup]()
    var tempFeatured = [CategoryItem]()
    if let url = URL(string: getURLAddress(pathName: "getCategories.php")){
        do {
            let contentcategories = try String(contentsOf: url).split(separator: "^")
            for category in contentcategories {
                let categories = category.split(separator: ",")
                queryDetails = [ URLQueryItem(name: "itemCategoriesID", value: String(categories[0]))]
                var tempItems = [CategoryItem]()
                if let url = URL(string: getURLAddress(pathName: "getItems.php", querys: queryDetails)){
                    do {
                        let items = try String(contentsOf: url).split(separator: "^")
                        for item in items {
                            let itemDets = item.split(separator: ",")
                            queryDetails = [ URLQueryItem(name: "itemsID", value: String(itemDets[0]))]
                            var tempMods = [CategoryItemMods]()
                            if let url = URL(string: getURLAddress(pathName: "getMods.php", querys: queryDetails)){
                                do {
                                    let mods = try String(contentsOf: url).split(separator: "^")
                                    for item in mods {
                                        let mods1 = item.split(separator: ",")
                                        let modifiers = mods1[3].split(separator: "|")
                                        var tempModifiers = [CategoryItemModifier]()
                                        var count = 0
                                        for modifier in modifiers{
                                            let modifierDet = modifier.split(separator: ":")
                                            tempModifiers.append(CategoryItemModifier(id: count, modID: Int(modifierDet[0])!, sizeName: String(modifierDet[1]), sizePriceAddition: Double(modifierDet[2])!))
                                            count += 1
                                        }
                                        print(tempModifiers)
                                        tempMods.append(CategoryItemMods(id: Int(mods1[0])! - 1, modName: String(mods1[1]), compulsary: Int(mods1[2])! == 1 ? true : false, selected: nil, modifiers: tempModifiers))
                                        
                                    }
                                } catch {}
                            }
                            tempItems.append(CategoryItem(id: Int(itemDets[0])! - 1, itemDisplaySize: true, itemName: String(itemDets[1]), itemImage: String(itemDets[4]), itemBasePrice: Double(itemDets[3])!, itemDescription: String(itemDets[2]), itemAdditions: tempMods))
                        }
                    } catch {}
                }
                if categories[1] == "SPECIALS"{
                    tempFeatured = tempItems

                }else{
                    tempCategorys.append(CategoryGroup(id: Int(categories[0])! - 1, resourceName: String(categories[1]), resourceDescription: String(categories[2]), resources: tempItems))
                }
            }
        } catch {}
    }
    return ActivitiesData(featuredItems: tempFeatured, categoryItems: tempCategorys)
    
}

class ActivitiesMockStore {
    
    static let activityData =  getCategories()
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
    var itemImage: String
    var offset: CGFloat = 0
    var isSwiped: Bool = false
}
    
