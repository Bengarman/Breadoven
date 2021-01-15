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
    @Binding var placeItem: CategoryItem?
    let defaultPoint = CategoryItemSize(id: 0, sizeName: "Default", sizePrice: 0, sizeDescription: "Default Description PlaceHolder")
    
    @ObservedObject var selectedPoint = SelectedPoint()
    
    var body: some View {
        GeometryReader { g in
            
            ZStack {
                
                ScrollView{
                    VStack(alignment: .center) {
                        Text("Swipe down to return to menu")
                            .foregroundColor(Color(red: 238/255, green: 129/255, blue: 13/255))
                        Spacer()
                        Image(self.placeItem?.itemImage ?? "")
                            .resizable()
                            .frame(width: g.size.width / 2, height: g.size.width / 2)
                            .clipShape(Circle())
                            .onDisappear {
                                self.isShowing = false
                        }
                        
                        VStack(alignment: .leading) {
                            Text(self.placeItem?.itemName ?? "")
                                .font(.system(size: 30, weight: .bold, design: .default))
                                .padding(.top, 50)
                                .padding(.leading, 30)
                            HStack{
                                Spacer()
                            }
                            
                            Spacer()
                            
                            PlacesDetail(placeItems: self.placeItem?.itemSizes[self.selectedPoint.selectedIndex] ?? self.defaultPoint)
                                .padding(.bottom, 50)
                            
                            if self.placeItem?.itemDisplaySize == true {
                                ZStack {
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack{
                                           
                                            ForEach(self.placeItem?.itemSizes ?? [], id: \.id) { item in
                                                if ((self.placeItem?.itemSizes.count)! > 3){
                                                    Print("here")
                                                    PlacesCircleView(placeItems: item, selectedPoint: self.selectedPoint)
                                                }else{
                                                    
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
                                            }
                                        }.frame(width: g.size.width, height: 130)
                                    }
                                }.padding(.bottom, 50)
                            }
                            
                            Button(action: {
                                cartData.items.append(Item(itemName: (self.placeItem?.itemName)!, itemPrice: String((self.placeItem?.itemSizes[self.selectedPoint.selectedIndex].sizePrice)!), itemColor: "", itemManufacturer: (self.placeItem?.itemSizes[self.selectedPoint.selectedIndex].sizeName)!, itemImage: (self.placeItem?.itemImage)!, offset: 0, isSwiped: false))
                                
                                
                                })
                                {
                                    HStack {
                                    Text("Add to basket - £" + String((self.placeItem?.itemSizes[self.selectedPoint.selectedIndex].sizePrice)!))
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
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct PlacesCircleView: View {
    var placeItems: CategoryItemSize
    @ObservedObject var selectedPoint: SelectedPoint
    
    var body: some View {
            GeometryReader { g in
                Button(action: {
                    self.selectedPoint.selectedIndex = self.placeItems.id
                }) {
                    ZStack {
                        Image("burger").renderingMode(.original)
                            .resizable()
                            .frame(width: 90, height: 110)
                            .background(Color.red)
                            .clipShape(Circle())
                        
                        if (self.selectedPoint.selectedIndex == self.placeItems.id) {
                               Text("✓")
                                    .font(.system(size: 30, weight: .bold, design: Font.Design.default))
                                    .foregroundColor(Color.white)
                        }
                    }
                }
            }
        }
    }

struct PlacesDetail: View {
    var placeItems: CategoryItemSize
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(placeItems.sizeName)
                .font(.system(size: 24, weight: .bold, design: .default))
                .padding(.leading, 30)
            
            Text(placeItems.sizeDescription)
                .font(.system(size: 16, weight: .regular, design: .default))
                .padding(.leading, 30)
                .padding(.trailing, 30)
        }
    }
}
