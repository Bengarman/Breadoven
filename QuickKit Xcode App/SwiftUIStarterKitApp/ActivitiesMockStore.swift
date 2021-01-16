//
//  ActivitiesMockStore.swift
//  SwiftUIStarterKitApp
//
//  Created by Osama Naeem on 06/08/2019.
//  Copyright © 2019 NexThings. All rights reserved.
//

import SwiftUI

class ActivitiesMockStore {
    
    static let activityData =  ActivitiesData(
        
        featuredItems:[
            
                CategoryItem(id: 0, itemDisplaySize: true, itemName: "Fish & Chips", itemImage: "f+c", itemSizes: [
                    CategoryItemSize(id: 0, sizeName: "Small", sizePrice: 2, sizeDescription: "Tamarindo is a town in the Guanacaste Province."),
                                                                                                                           
                    CategoryItemSize(id: 1, sizeName: "Medium", sizePrice: 3, sizeDescription: "Jacó is a town on the Pacific coast of Costa Rica."),
            
                    CategoryItemSize(id: 2, sizeName: "Large", sizePrice: 4, sizeDescription: "Dominical is a beach-front town in Bahía Ballena.")
                ]),
             
                CategoryItem(id: 1, itemDisplaySize: false, itemName: "Kebab Meat, Chips & Drink", itemImage: "kebab", itemSizes: [
                    CategoryItemSize(id: 0, sizeName: "Kuta", sizePrice: 2, sizeDescription: "Kuta is a beach and resort area"),
                 
                    CategoryItemSize(id: 1, sizeName: "Jimbaran", sizePrice: 3, sizeDescription: "Jimbaran Bay has a long beach with calm waters.")
                 ]),
                 
                CategoryItem(id: 2, itemDisplaySize: true, itemName: "Small Portions", itemImage: "burger", itemSizes: [
                    CategoryItemSize(id: 0, sizeName: "Muizenberg", sizePrice: 4, sizeDescription: "Surfer’s Corner at Muizenberg is a popular learning spot"),
                     
                    CategoryItemSize(id: 1, sizeName: "Long Beach", sizePrice: 5, sizeDescription: "Long Beach at Kommetjie is just that, a long, sandy beach")
                 ])
            ],
            categoryItems:[
                       
                CategoryGroup(id: 0, resourceName: "Fish", resourceDescription: "Placeholder.... Fish is fish", resources:[
                    CategoryItem(id: 0, itemDisplaySize: true, itemName: "Hadock", itemImage: "f+c", itemSizes: [
                        CategoryItemSize(id: 0, sizeName: "test", sizePrice: 9, sizeDescription: "yolo")
                    ]),
                    CategoryItem(id: 1, itemDisplaySize: true, itemName: "Cod", itemImage: "f+c", itemSizes: [
                        CategoryItemSize(id: 0, sizeName: "test", sizePrice: 9, sizeDescription: "yolo")
                    ]),
                    CategoryItem(id: 2, itemDisplaySize: true, itemName: "Plaice", itemImage: "f+c", itemSizes: [
                        CategoryItemSize(id: 0, sizeName: "test", sizePrice: 9, sizeDescription: "yolo")
                    ]),
                    CategoryItem(id: 3, itemDisplaySize: true, itemName: "Scampi", itemImage: "f+c", itemSizes: [
                        CategoryItemSize(id: 0, sizeName: "test", sizePrice: 9, sizeDescription: "yolo")
                    ]),
                    CategoryItem(id: 4, itemDisplaySize: true, itemName: "Roe", itemImage: "f+c", itemSizes: [
                        CategoryItemSize(id: 0, sizeName: "test", sizePrice: 9, sizeDescription: "yolo")
                    ])
                ]),
                
                CategoryGroup(id: 1, resourceName: "Others", resourceDescription: "Placeholder... stuff thats not fish and chips", resources:[
                    CategoryItem(id: 0, itemDisplaySize: true, itemName: "Burgers", itemImage: "burger", itemSizes: [
                        CategoryItemSize(id: 0, sizeName: "test", sizePrice: 9, sizeDescription: "yolo")
                    ]),
                    CategoryItem(id: 1, itemDisplaySize: true, itemName: "Sausages", itemImage: "burger", itemSizes: [
                        CategoryItemSize(id: 0, sizeName: "test", sizePrice: 9, sizeDescription: "yolo")
                    ]),
                    CategoryItem(id: 2, itemDisplaySize: true, itemName: "Chicken", itemImage: "burger", itemSizes: [
                        CategoryItemSize(id: 0, sizeName: "test", sizePrice: 9, sizeDescription: "yolo")
                    ]),
                    CategoryItem(id: 3, itemDisplaySize: true, itemName: "Pies", itemImage: "burger", itemSizes: [
                        CategoryItemSize(id: 0, sizeName: "test", sizePrice: 9, sizeDescription: "yolo")
                    ]),
                    CategoryItem(id: 4, itemDisplaySize: true, itemName: "Vegetarian", itemImage: "burger", itemSizes: [
                        CategoryItemSize(id: 0, sizeName: "test", sizePrice: 9, sizeDescription: "yolo")
                    ])
                ]),
                CategoryGroup(id: 2, resourceName: "Kebabs", resourceDescription: "Placeholder ..... kebab is kebab", resources:[
                    CategoryItem(id: 0, itemDisplaySize: true, itemName: "Donner", itemImage: "kebab", itemSizes: [
                        CategoryItemSize(id: 0, sizeName: "test", sizePrice: 9, sizeDescription: "yolo")
                    ]),
                    CategoryItem(id: 1, itemDisplaySize: true, itemName: "Chicken", itemImage: "kebab", itemSizes: [
                        CategoryItemSize(id: 0, sizeName: "test", sizePrice: 9, sizeDescription: "yolo")
                    ]),
                    CategoryItem(id: 2, itemDisplaySize: true, itemName: "Mixed", itemImage: "kebab", itemSizes: [
                        CategoryItemSize(id: 0, sizeName: "test", sizePrice: 9, sizeDescription: "yolo")
                    ]),
                    CategoryItem(id: 3, itemDisplaySize: true, itemName: "Hasllumi", itemImage: "kebab", itemSizes: [
                        CategoryItemSize(id: 0, sizeName: "test", sizePrice: 9, sizeDescription: "yolo")
                    ])
                ]),
                CategoryGroup(id: 3, resourceName: "Extras", resourceDescription: "Placeholder ..... Extras init", resources:[
                    CategoryItem(id: 0, itemDisplaySize: true, itemName: "Sauces", itemImage: "burger", itemSizes: [
                        CategoryItemSize(id: 0, sizeName: "test", sizePrice: 9, sizeDescription: "yolo")
                    ]),
                    CategoryItem(id: 1, itemDisplaySize: true, itemName: "Sides", itemImage: "burger", itemSizes: [
                        CategoryItemSize(id: 0, sizeName: "test", sizePrice: 9, sizeDescription: "yolo")
                    ]),
                    CategoryItem(id: 2, itemDisplaySize: true, itemName: "Drinks", itemImage: "burger", itemSizes: [
                        CategoryItemSize(id: 0, sizeName: "test", sizePrice: 9, sizeDescription: "yolo")
                    ])
                ])
            ]
        )
    
    
}

class CartViewModel: ObservableObject{
    @Published var items = [Item]()
}

struct Item : Identifiable{
    var id = UUID().uuidString
    var itemName : String
    var itemPrice : String
    var itemColor: String
    var itemManufacturer: String
    var itemImage: String
    var offset: CGFloat
    var isSwiped: Bool
}
    
