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
            
            CategoryItem(id: 0, itemDisplaySize: true, itemName: "Fish & Chips", itemImage: "f+c", itemBasePrice: 2.00, itemDescription: "Tamarindo is a town in the Guanacaste Province.", itemAdditions: [
                CategoryItemMods(id: 0, modName: "Size", compulsary: true, selected: nil, modifiers: [
                    CategoryItemModifier(id: 0, sizeName: "Small", sizePriceAddition: 0.10),
                    CategoryItemModifier(id: 1, sizeName: "Medium", sizePriceAddition: 0.30),
                    CategoryItemModifier(id: 2, sizeName: "Large", sizePriceAddition: 0.40)
                ])
            ]),
            CategoryItem(id: 1, itemDisplaySize: true, itemName: "Fish & Chips", itemImage: "kebab", itemBasePrice: 2.00, itemDescription: "Tamarindo is a town in the Guanacaste Province.", itemAdditions: [
                CategoryItemMods(id: 0, modName: "Size", compulsary: true, selected: nil, modifiers: [
                    CategoryItemModifier(id: 0, sizeName: "Small", sizePriceAddition: 0.10),
                    CategoryItemModifier(id: 1, sizeName: "Medium", sizePriceAddition: 0.30),
                    CategoryItemModifier(id: 2, sizeName: "Large", sizePriceAddition: 0.40)
                ]),
                CategoryItemMods(id: 1, modName: "Color", compulsary: false, selected: nil, modifiers: [
                    CategoryItemModifier(id: 0, sizeName: "Blue", sizePriceAddition: 0),
                    CategoryItemModifier(id: 1, sizeName: "Green", sizePriceAddition: 0.30),
                    CategoryItemModifier(id: 2, sizeName: "Red", sizePriceAddition: 0.40)
                ]),
                CategoryItemMods(id: 2, modName: "Time", compulsary: false, selected: nil, modifiers: [
                    CategoryItemModifier(id: 0, sizeName: "Blue", sizePriceAddition: 0),
                    CategoryItemModifier(id: 1, sizeName: "Green", sizePriceAddition: 0.30),
                    CategoryItemModifier(id: 2, sizeName: "Red", sizePriceAddition: 0.40)
                ])
            ]),
            CategoryItem(id: 2, itemDisplaySize: true, itemName: "Fish & Chips", itemImage: "burger", itemBasePrice: 2.00, itemDescription: "Tamarindo is a town in the Guanacaste Province.", itemAdditions: [
                CategoryItemMods(id: 0, modName: "Size", compulsary: true, selected: nil, modifiers: [
                    CategoryItemModifier(id: 0, sizeName: "Small", sizePriceAddition: 0.10),
                    CategoryItemModifier(id: 1, sizeName: "Medium", sizePriceAddition: 0.30),
                    CategoryItemModifier(id: 2, sizeName: "Large", sizePriceAddition: 0.40)
                ])
            ])
            ],
            categoryItems:[
                       
                CategoryGroup(id: 0, resourceName: "Fish", resourceDescription: "Placeholder.... Fish is fish", resources:[
                    CategoryItem(id: 0, itemDisplaySize: true, itemName: "Hadock", itemImage: "f+c", itemBasePrice: 2.00, itemDescription: "Tamarindo is a town in the Guanacaste Province.", itemAdditions: [
                        CategoryItemMods(id: 0, modName: "Size", compulsary: true, selected: nil, modifiers: [
                            CategoryItemModifier(id: 0, sizeName: "Small", sizePriceAddition: 0.10),
                            CategoryItemModifier(id: 1, sizeName: "Medium", sizePriceAddition: 0.30),
                            CategoryItemModifier(id: 2, sizeName: "Large", sizePriceAddition: 0.40),
                            CategoryItemModifier(id: 3, sizeName: "X Large", sizePriceAddition: 0.50),
                            CategoryItemModifier(id: 4, sizeName: "X X Large", sizePriceAddition: 0.60)
                        ])
                    ]),
                    CategoryItem(id: 1, itemDisplaySize: true, itemName: "Cod", itemImage: "f+c", itemBasePrice: 2.00, itemDescription: "Tamarindo is a town in the Guanacaste Province.", itemAdditions: [
                        CategoryItemMods(id: 0, modName: "Size", compulsary: true, selected: nil, modifiers: [
                            CategoryItemModifier(id: 0, sizeName: "Small", sizePriceAddition: 0.10),
                            CategoryItemModifier(id: 1, sizeName: "Medium", sizePriceAddition: 0.30),
                            CategoryItemModifier(id: 2, sizeName: "Large", sizePriceAddition: 0.40)
                        ])
                    ]),
                    CategoryItem(id: 2, itemDisplaySize: true, itemName: "Plaice", itemImage: "f+c", itemBasePrice: 2.00, itemDescription: "Tamarindo is a town in the Guanacaste Province.", itemAdditions: [
                        CategoryItemMods(id: 0, modName: "Size", compulsary: true, selected: nil, modifiers: [
                            CategoryItemModifier(id: 0, sizeName: "Small", sizePriceAddition: 0.10),
                            CategoryItemModifier(id: 1, sizeName: "Medium", sizePriceAddition: 0.30),
                            CategoryItemModifier(id: 2, sizeName: "Large", sizePriceAddition: 0.40)
                        ])
                    ]),
                    CategoryItem(id: 3, itemDisplaySize: true, itemName: "Scampi", itemImage: "f+c", itemBasePrice: 2.00, itemDescription: "Tamarindo is a town in the Guanacaste Province.", itemAdditions: [
                        CategoryItemMods(id: 0, modName: "Size", compulsary: true, selected: nil, modifiers: [
                            CategoryItemModifier(id: 0, sizeName: "Small", sizePriceAddition: 0.10),
                            CategoryItemModifier(id: 1, sizeName: "Medium", sizePriceAddition: 0.30),
                            CategoryItemModifier(id: 2, sizeName: "Large", sizePriceAddition: 0.40)
                        ])
                    ]),
                    CategoryItem(id: 4, itemDisplaySize: true, itemName: "Roe", itemImage: "f+c", itemBasePrice: 2.00, itemDescription: "Tamarindo is a town in the Guanacaste Province.", itemAdditions: [
                        CategoryItemMods(id: 0, modName: "Size", compulsary: true,  selected: nil, modifiers: [
                            CategoryItemModifier(id: 0, sizeName: "Small", sizePriceAddition: 0.10),
                            CategoryItemModifier(id: 1, sizeName: "Medium", sizePriceAddition: 0.30),
                            CategoryItemModifier(id: 2, sizeName: "Large", sizePriceAddition: 0.40)
                        ])
                    ])
                ]),
                CategoryGroup(id: 1, resourceName: "Fish", resourceDescription: "Placeholder.... Fish is fish", resources:[
                    CategoryItem(id: 0, itemDisplaySize: true, itemName: "Hadock", itemImage: "f+c", itemBasePrice: 2.00, itemDescription: "Tamarindo is a town in the Guanacaste Province.", itemAdditions: [
                        CategoryItemMods(id: 0, modName: "Size", compulsary: true, selected: nil, modifiers: [
                            CategoryItemModifier(id: 0, sizeName: "Small", sizePriceAddition: 0.10),
                            CategoryItemModifier(id: 1, sizeName: "Medium", sizePriceAddition: 0.30),
                            CategoryItemModifier(id: 2, sizeName: "Large", sizePriceAddition: 0.40)
                        ])
                    ]),
                    CategoryItem(id: 1, itemDisplaySize: true, itemName: "Cod", itemImage: "f+c", itemBasePrice: 2.00, itemDescription: "Tamarindo is a town in the Guanacaste Province.", itemAdditions: [
                        CategoryItemMods(id: 0, modName: "Size", compulsary: true, selected: nil, modifiers: [
                            CategoryItemModifier(id: 0, sizeName: "Small", sizePriceAddition: 0.10),
                            CategoryItemModifier(id: 1, sizeName: "Medium", sizePriceAddition: 0.30),
                            CategoryItemModifier(id: 2, sizeName: "Large", sizePriceAddition: 0.40)
                        ])
                    ]),
                    CategoryItem(id: 2, itemDisplaySize: true, itemName: "Plaice", itemImage: "f+c", itemBasePrice: 2.00, itemDescription: "Tamarindo is a town in the Guanacaste Province.", itemAdditions: [
                        CategoryItemMods(id: 0, modName: "Size", compulsary: true, selected: nil, modifiers: [
                            CategoryItemModifier(id: 0, sizeName: "Small", sizePriceAddition: 0.10),
                            CategoryItemModifier(id: 1, sizeName: "Medium", sizePriceAddition: 0.30),
                            CategoryItemModifier(id: 2, sizeName: "Large", sizePriceAddition: 0.40)
                        ])
                    ]),
                    CategoryItem(id: 3, itemDisplaySize: true, itemName: "Scampi", itemImage: "f+c", itemBasePrice: 2.00, itemDescription: "Tamarindo is a town in the Guanacaste Province.", itemAdditions: [
                        CategoryItemMods(id: 0, modName: "Size", compulsary: true, selected: nil, modifiers: [
                            CategoryItemModifier(id: 0, sizeName: "Small", sizePriceAddition: 0.10),
                            CategoryItemModifier(id: 1, sizeName: "Medium", sizePriceAddition: 0.30),
                            CategoryItemModifier(id: 2, sizeName: "Large", sizePriceAddition: 0.40)
                        ])
                    ]),
                    CategoryItem(id: 4, itemDisplaySize: true, itemName: "Roe", itemImage: "f+c", itemBasePrice: 2.00, itemDescription: "Tamarindo is a town in the Guanacaste Province.", itemAdditions: [
                        CategoryItemMods(id: 0, modName: "Size", compulsary: true, selected: nil, modifiers: [
                            CategoryItemModifier(id: 0, sizeName: "Small", sizePriceAddition: 0.10),
                            CategoryItemModifier(id: 1, sizeName: "Medium", sizePriceAddition: 0.30),
                            CategoryItemModifier(id: 2, sizeName: "Large", sizePriceAddition: 0.40)
                        ])
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
    var itemOptions: String
    var itemQuantity: String
    var itemImage: String
    var offset: CGFloat
    var isSwiped: Bool
}
    
