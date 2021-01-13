//
//  ActivitiesMockStore.swift
//  SwiftUIStarterKitApp
//
//  Created by Osama Naeem on 06/08/2019.
//  Copyright © 2019 NexThings. All rights reserved.
//

import SwiftUI

class ActivitiesMockStore {
    
    static let activities: [ActivitiesItem] = [
        ActivitiesItem(id: 0, activityName: "Sandwiches", activityNameLabel: "Sandwiches", activityImage: "surfing", selectedActivity: false),
        ActivitiesItem(id: 1, activityName: "Snacks", activityNameLabel: "Snacks", activityImage: "snowboarding", selectedActivity: false),
        ActivitiesItem(id: 2, activityName: "Drinks", activityNameLabel: "Drinks", activityImage: "hiking", selectedActivity: false)
        
    ]
    
    static let activityData: [ActivitiesData] = [
        
        ActivitiesData(id: 0,
            activitiesPlaces:[
            
                ActivitiesPlaces(id: 0, itemDisplaySize: true, itemName: "Coca Cola", itemImage: "costarica", famousPointsArray: [
                    ActivitiesFamousPoints(id: 0, sizeName: "Small", sizePrice: 2, sizeDescription: "Tamarindo is a town in the Guanacaste Province."),
                                                                                                                           
                    ActivitiesFamousPoints(id: 1, sizeName: "Medium", sizePrice: 3, sizeDescription: "Jacó is a town on the Pacific coast of Costa Rica."),
            
                    ActivitiesFamousPoints(id: 2, sizeName: "Large", sizePrice: 4, sizeDescription: "Dominical is a beach-front town in Bahía Ballena.")
                ]),
             
                ActivitiesPlaces(id: 1, itemDisplaySize: false, itemName: "Balti", itemImage: "bali", famousPointsArray: [
                    ActivitiesFamousPoints(id: 0, sizeName: "Kuta", sizePrice: 2, sizeDescription: "Kuta is a beach and resort area"),
                 
                    ActivitiesFamousPoints(id: 1, sizeName: "Jimbaran", sizePrice: 3, sizeDescription: "Jimbaran Bay has a long beach with calm waters.")
                 ]),
                 
                ActivitiesPlaces(id: 2, itemDisplaySize: true, itemName: "Cape Town", itemImage: "capetown", famousPointsArray: [
                    ActivitiesFamousPoints(id: 0, sizeName: "Muizenberg", sizePrice: 4, sizeDescription: "Surfer’s Corner at Muizenberg is a popular learning spot"),
                     
                    ActivitiesFamousPoints(id: 1, sizeName: "Long Beach", sizePrice: 5, sizeDescription: "Long Beach at Kommetjie is just that, a long, sandy beach")
                 ])
            ],
            activityResources:[
                        
                ActivityResource(id: 0, resourceName: "Lifestyle", resourceDescription: "Explore, Fashion, Food, music, art, photography, travel and more!", resources:[
                    ActivityResourcesItem(id: 0, resourceName: "Yoga for Surfers", resourceImage: "yoga", resourceDescription: "Article"),
                    ActivityResourcesItem(id: 1, resourceName: "Travel for a living", resourceImage: "travel", resourceDescription: "Article"),
                    ActivityResourcesItem(id: 2, resourceName: "Tropical Green Smoothie", resourceImage: "smoothie", resourceDescription: "Tutorial")
                ]),
                
                ActivityResource(id: 1, resourceName: "Equipment", resourceDescription: "Find your dream gear", resources: [
                    ActivityResourcesItem(id: 1, resourceName: "Boards", resourceImage: "surfboard-1", resourceDescription: ""),
                    ActivityResourcesItem(id: 2, resourceName: "Boardshorts", resourceImage: "boardshorts", resourceDescription: ""),
                    ActivityResourcesItem(id: 3, resourceName: "Surfboard Bags", resourceImage: "surfboardbags", resourceDescription: "")
                ]),
                
                ActivityResource(id: 2, resourceName: "Training", resourceDescription: "Best surf training resources", resources: [
                    ActivityResourcesItem(id: 1, resourceName: "Surf Core Training", resourceImage: "boardshorts", resourceDescription: "Video"),
                    ActivityResourcesItem(id: 2, resourceName: "Sri Lanka Surf Camp", resourceImage: "srilankacamp", resourceDescription: "Camp"),
                    ActivityResourcesItem(id: 3, resourceName: "Surf Photography Training", resourceImage: "surfphoto", resourceDescription: "Photography")
                ])
            ]
        ),
       
        ActivitiesData(id: 1,
            activitiesPlaces: [
        
                ActivitiesPlaces(id: 1, itemDisplaySize: true, itemName: "Snowbird", itemImage: "snowbird", famousPointsArray: [
                    ActivitiesFamousPoints(id: 0, sizeName: "Snowbird", sizePrice: 1, sizeDescription: "Just over the mountains to the north")
                ]),
                ActivitiesPlaces(id: 2, itemDisplaySize: true, itemName: "Cervinia", itemImage: "italy", famousPointsArray: [
                    ActivitiesFamousPoints(id: 0, sizeName: "Cervinia", sizePrice: 2, sizeDescription: "Breuil-Cervinia is an Alpine resort")
                ]),
                ActivitiesPlaces(id: 3, itemDisplaySize: true, itemName: "Chamonix", itemImage: "chamonix", famousPointsArray: [
                    ActivitiesFamousPoints(id: 0, sizeName: "Chamonix", sizePrice: 3, sizeDescription: "Chamonix-Mont-Blanc is usually shortened to Chamonix")
                ])
            ],
            
            activityResources:[
                ActivityResource(id: 0, resourceName: "Lifestyle", resourceDescription: "Explore, Fashion, Food, music, art, photography, travel and more!", resources:[
                                    
                    ActivityResourcesItem(id: 0, resourceName: "Peace in Mountains", resourceImage: "mountains", resourceDescription: "Article"),
                    ActivityResourcesItem(id: 1, resourceName: "Travel for a living", resourceImage: "travel", resourceDescription: "Article"),
                    ActivityResourcesItem(id: 2, resourceName: "Mountain top drinks", resourceImage: "drinks", resourceDescription: "Guide")
                ]),
               
                ActivityResource(id: 1, resourceName: "Equipment", resourceDescription: "Find your dream gear", resources: [
                    
                    ActivityResourcesItem(id: 1, resourceName: "Boards", resourceImage: "snowboards", resourceDescription: ""),
                    ActivityResourcesItem(id: 2, resourceName: "Goggles", resourceImage: "goggles", resourceDescription: ""),
                    ActivityResourcesItem(id: 3, resourceName: "Snowboarding boots", resourceImage: "boots", resourceDescription: "")
                ]),
               
               ActivityResource(id: 2, resourceName: "Training", resourceDescription: "Best Snowboarding training resources", resources: [
                                    
                    ActivityResourcesItem(id: 1, resourceName: "Snowboard Training", resourceImage: "snowboarder", resourceDescription: "Video"),
                    ActivityResourcesItem(id: 2, resourceName: "Snowboard Resorts Training", resourceImage: "frenchresort", resourceDescription: "Camp"),
                    ActivityResourcesItem(id: 3, resourceName: "Snowboarding Photography", resourceImage: "snowboardphoto", resourceDescription: "Photography")
               ])
                
            ]
        ),
       
        ActivitiesData(id: 2,
            activitiesPlaces: [
        
                ActivitiesPlaces(id: 1, itemDisplaySize: true, itemName: "Torres del Paine", itemImage: "torresdelpaine", famousPointsArray: [
                    ActivitiesFamousPoints(id: 0, sizeName: "The Fauna Trail", sizePrice: 2, sizeDescription: "This trail is a great hiking option for beginners"),
                    ActivitiesFamousPoints(id: 1, sizeName: "Laguna Azul", sizePrice: 3, sizeDescription: "aguna Azul, which literally translate to blue lagoon.")
                ]),
            
                ActivitiesPlaces(id: 2, itemDisplaySize: true, itemName: "Peru", itemImage: "peru", famousPointsArray: [
                    ActivitiesFamousPoints(id: 0, sizeName: "Inca Trail", sizePrice: 4, sizeDescription: "One thing’s for sure: you absolutely cannot go to Peru"),
                    ActivitiesFamousPoints(id: 1, sizeName: "Santa Cruz Trek", sizePrice: 5, sizeDescription: "The Santa Cruz trek in Peru’s Huascarán National Park.")
                
                ]),
                ActivitiesPlaces(id: 3, itemDisplaySize: true, itemName: "Grand Canyon", itemImage: "grandcanyon", famousPointsArray: [
                    ActivitiesFamousPoints(id: 0, sizeName: "South Rim Trail", sizePrice: 6, sizeDescription: "For many visitors, the South Rim Trail"),
                    ActivitiesFamousPoints(id: 1, sizeName: "Bright Angel Trail", sizePrice: 7, sizeDescription: "An iconic hiking trail of America")

                ])
            ],

            activityResources:[
                ActivityResource(id: 0, resourceName: "Lifestyle", resourceDescription: "Explore, Fashion, Food, music, art, photography, travel and more!", resources:[
                    ActivityResourcesItem(id: 0, resourceName: "Clearing your thoughts", resourceImage: "hikingmental", resourceDescription: "Article"),
                    ActivityResourcesItem(id: 1, resourceName: "Hiking and physical benefits", resourceImage: "hiker", resourceDescription: "Article"),
                    ActivityResourcesItem(id: 2, resourceName: "Hikers Parties", resourceImage: "hikersparties", resourceDescription: "Fun")
                ]),
               
                ActivityResource(id: 1, resourceName: "Equipment", resourceDescription: "Find your dream gear", resources: [
                    ActivityResourcesItem(id: 1, resourceName: "Footwear", resourceImage: "shoes", resourceDescription: ""),
                    ActivityResourcesItem(id: 2, resourceName: "Camping Equipment", resourceImage: "camping", resourceDescription: ""),
                    ActivityResourcesItem(id: 3, resourceName: "Hiking bags", resourceImage: "bags", resourceDescription: "")]),
               
                ActivityResource(id: 2, resourceName: "Photography", resourceDescription: "Best landscape photography resources", resources: [
                    ActivityResourcesItem(id: 1, resourceName: "Camera equipment", resourceImage: "cameras", resourceDescription: "Video"),
                    ActivityResourcesItem(id: 2, resourceName: "Long exposure photography", resourceImage: "longexposure", resourceDescription: "Tutorial"),
                    ActivityResourcesItem(id: 3, resourceName: "Tips for best photography", resourceImage: "photography", resourceDescription: "Photography")])
               ])
       
    ]
    
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
    
