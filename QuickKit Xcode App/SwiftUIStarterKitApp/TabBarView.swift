//
//  TabBarView.swift
//  SwiftUIStarterKitApp
//
//  Created by Osama Naeem on 02/08/2019.
//  Copyright © 2019 NexThings. All rights reserved.
//

import SwiftUI

struct TabbarView: View {
    @State var selected = 0
    var body: some View {
        ZStack(alignment: .bottom){
            VStack{
                if self.selected == 0{
                    
                    NavigationView {
                        ActivitiesContentView(activtiesData: Activities(data: ActivitiesMockStore.activityData))
                            .offset(y: -65)
                    }
                    
                }
                else if self.selected == 1{
                    
                    NavigationView {
                        ActivitiesCartViewNav()
                            .offset(y: -40)
                    }
                    
                }
                else{
                    AccountView()
                }
            }
            FloatingTabbar(selected: self.$selected)
        }
        //SignUpView()
        /*
        TabView {
            NavigationView {
                ActivitiesContentView(activtiesData: Activities(data: ActivitiesMockStore.activityData))
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
            
            
            
        }*/
    }
}

struct FloatingTabbar : View {
    @Binding var selected : Int
    var body : some View{
        HStack{
            HStack{
                Button(action: {
                    self.selected = 0
                }) {
                    Image(systemName: "doc.plaintext").foregroundColor(self.selected == 0 ? .black : .gray).padding(.horizontal)
                }
                Spacer(minLength: 15)
                Button(action: {
                    self.selected = 1
                }) {
                    Image(systemName: "cart").foregroundColor(self.selected == 1 ? .black : .gray).padding(.horizontal)
                }
                Spacer(minLength: 15)
                Button(action: {
                    self.selected = 2
                    
                }) {
                    Image(systemName: "person").foregroundColor(self.selected == 2 ? .black : .gray).padding(.horizontal)
                }
                
                
                
            }
            .padding(.vertical,20)
            .padding(.horizontal, 35)
            .background(Color(red: 242 / 255, green: 242 / 255, blue: 242 / 255))
            .clipShape(Capsule())
            //.padding(22)
            .padding(.leading, 22)
            .padding(.trailing, 22)
            .padding(.bottom, -8)
            .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.6, blendDuration: 0.6))
            Spacer(minLength: 10)

        }
    }
}


