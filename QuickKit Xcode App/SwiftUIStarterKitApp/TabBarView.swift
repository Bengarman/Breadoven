//
//  TabBarView.swift
//  SwiftUIStarterKitApp
//
//  Created by Osama Naeem on 02/08/2019.
//  Copyright © 2019 NexThings. All rights reserved.
//

import SwiftUI

struct TabbarView: View {
    var body: some View {
        TabView {
            NavigationView {
                ActivitiesContentView(activtiesData: Activities(data: ActivitiesMockStore.activityData, items: ActivitiesMockStore.activities))
            }
            .tag(0)
            .tabItem {
                Image(systemName: "doc.plaintext")
                    .resizable()
                Text("Menu")
            }
            
            NavigationView {
                ActivitiesCartViewNav()
            }
            .tag(1)
            .tabItem {
                Image(systemName: "cart")
                Text("Cart")
            }
            NavigationView {
                SignUpView()
            }
            .tag(1)
            .tabItem {
                Image(systemName: "cart")
                Text("Login")
            }
            
            
            
        }
    }
}



