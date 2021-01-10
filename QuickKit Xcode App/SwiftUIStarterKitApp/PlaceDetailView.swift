//
//  PlaceDetailView.swift
//  SwiftUIStarterKitApp
//
//  Created by Osama Naeem on 11/08/2019.
//  Copyright © 2019 NexThings. All rights reserved.
//

import SwiftUI
import Combine

class SelectedPoint: ObservableObject {
    @Published var selectedIndex: Int = 0
}
extension View {
    func Print(_ vars: Any...) -> some View {
        for v in vars { print(v) }
        return EmptyView()
    }
}

struct PlaceDetailView : View {
    @Binding var isShowing: Bool
    @Binding var placeItem: ActivitiesPlaces?
    let defaultPoint = ActivitiesFamousPoints(id: 0, sizeName: "Default", sizePrice: 0, sizeDescription: "Default Description PlaceHolder")
    
    @ObservedObject var selectedPoint = SelectedPoint()
    
    var body: some View {
        GeometryReader { g in
            ZStack {
                Image(self.placeItem?.itemImage ?? "")
                    .resizable()
                    .frame(width: g.size.width, height: g.size.height)
                    .aspectRatio(contentMode: .fit)
                    .opacity(0.3)
                    .background(Color.black)
                    .onDisappear {
                        self.isShowing = false
                }
                
                VStack(alignment: .leading) {
                    Text(self.placeItem?.itemName ?? "")
                        .foregroundColor(Color.white)
                        .font(.system(size: 30, weight: .bold, design: .default))
                        .padding(.top, 34)
                        .padding(.leading, 30)
                    HStack{
                        Spacer()
                    }
                    
                    Spacer()
                    
                    PlacesDetail(placeItems: self.placeItem?.famousPointsArray[self.selectedPoint.selectedIndex] ?? self.defaultPoint)
                        .padding(.bottom, 50)
                    
                    if self.placeItem?.itemDisplaySize == true {
                        ZStack {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack{
                                    ForEach(self.placeItem?.famousPointsArray ?? [], id: \.id) { item in
                                        //PlacesCircleView(placeItems: item, selectedPoint: self.selectedPoint)
                                        
                                        Button(action: {
                                            self.selectedPoint.selectedIndex = item.id
                                        })
                                        {
                                            ZStack {
                                                Image(self.placeItem?.itemImage ?? "").renderingMode(.original)
                                                    .resizable()
                                                    .frame(width: 110, height: 110)
                                                    .background(Color.red)
                                                    .clipShape(Circle())
                                                
                                                if (self.selectedPoint.selectedIndex == item.id) {
                                                       Text("✓")
                                                            .font(.system(size: 30, weight: .bold, design: Font.Design.default))
                                                            .foregroundColor(Color.white)
                                                }
                                            }
                                        }
                                    }
                                }.frame(width: g.size.width, height: 130)
                            }
                        }
                    }
                    
                    Button(action: {
                        let newelement = ActivitiesCartItem(itemID: String(Int.random(in: 6 ..< 100)), itemName: (self.placeItem?.itemName)!, itemPrice: (self.placeItem?.famousPointsArray[self.selectedPoint.selectedIndex].sizePrice)!, itemColor: "", itemManufacturer: (self.placeItem?.famousPointsArray[self.selectedPoint.selectedIndex].sizeName)!, itemImage: (self.placeItem?.itemImage)!)
                            ActivitiesMockStore.shoppingCartData.append(newelement)
                        
                        
                        })
                        {
                            HStack {
                            Text("Add to basket - £" + String((self.placeItem?.famousPointsArray[self.selectedPoint.selectedIndex].sizePrice)!))
                        }
                            .frame(width: g.size.width - 35, height: 40)
                            .foregroundColor(Color.white)
                            .background(Color.blue)
                            .cornerRadius(5)
                            .padding()
                        }.padding(.bottom, 50)
                }
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct PlacesCircleView: View {
    var placeItems: ActivitiesFamousPoints
    @ObservedObject var selectedPoint: SelectedPoint
    
    var body: some View {
        GeometryReader { g in
            
        }
    }
}

struct PlacesDetail: View {
    var placeItems: ActivitiesFamousPoints
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(placeItems.sizeName)
                .foregroundColor(Color.white)
                .font(.system(size: 24, weight: .bold, design: .default))
                .padding(.leading, 30)
            
            Text(placeItems.sizeDescription)
                .foregroundColor(Color.white)
                .font(.system(size: 16, weight: .regular, design: .default))
                .padding(.leading, 30)
                .padding(.trailing, 30)
        }
    }
}
