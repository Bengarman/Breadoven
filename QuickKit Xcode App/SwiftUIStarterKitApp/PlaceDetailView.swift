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
    @State var top = UIApplication.shared.windows.last?.safeAreaInsets.top
    @ObservedObject var selectedPoint = SelectedPoint()
    
    var body: some View {
        GeometryReader { g in
            
            ZStack {
                
                ScrollView{
                    VStack(alignment: .center) {
                        Image(self.placeItem?.itemImage ?? "")
                            .resizable()
                            .frame(width: g.size.width, height: g.size.height / 3)
                            .onDisappear {
                                self.isShowing = false
                            }
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(alignment: .leading) {
                                Text(self.placeItem?.itemName ?? "")
                                    .font(.system(size: 30, weight: .bold, design: .default))
                                    .padding(.top, 50)
                                //.padding(.leading, 30)
                                
                                Spacer()
                                
                                VStack(alignment: .leading) {
                                    Text((self.placeItem?.itemSizes[self.selectedPoint.selectedIndex].sizeName)!)
                                        .font(.system(size: 24, weight: .bold, design: .default))
                                    //.padding(.leading, 30)
                                    
                                    Text((self.placeItem?.itemSizes[self.selectedPoint.selectedIndex].sizeDescription)!)
                                        .font(.system(size: 16, weight: .regular, design: .default))
                                        //.padding(.leading, 30)
                                        .padding(.trailing, 30)
                                }.padding(.bottom, 50)
                                
                                
                                if self.placeItem?.itemDisplaySize == true {
                                    ZStack {
                                        ScrollView(.horizontal, showsIndicators: false) {
                                            HStack{
                                                ForEach(self.placeItem?.itemSizes ?? [], id: \.id) { item in
                                                    
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
                                    }.padding(.bottom, 50)
                                }
                                
                                Button(action: {
                                    cartData.items.append(Item(itemName: (self.placeItem?.itemName)!, itemPrice: String((self.placeItem?.itemSizes[self.selectedPoint.selectedIndex].sizePrice)!), itemColor: "", itemManufacturer: (self.placeItem?.itemSizes[self.selectedPoint.selectedIndex].sizeName)!, itemImage: (self.placeItem?.itemImage)!, offset: 0, isSwiped: false))
                                    
                                    
                                    self.isShowing = false
                                    
                                })
                                {
                                    HStack (alignment: .center){
                                        
                                        Text("Add to basket - £" + String((self.placeItem?.itemSizes[self.selectedPoint.selectedIndex].sizePrice)!))
                                    }
                                    .padding()
                                    .frame(width: g.size.width - 35, height: 40)
                                    .foregroundColor(Color.white)
                                    .background(Color.blue)
                                    .cornerRadius(5)
                                }.padding(.bottom, 50)
                                
                            }
                        }
                        .padding()
                        .background(RoundedCorner().fill(Color.white))
                        .padding(.top, -top!)
                        
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
            //.padding(.leading, 30)
            
            Text(placeItems.sizeDescription)
                .font(.system(size: 16, weight: .regular, design: .default))
                //.padding(.leading, 30)
                .padding(.trailing, 30)
        }
    }
}


struct RoundedCorner : Shape {
    
    func path(in rect: CGRect) -> Path {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft,.topRight], cornerRadii: CGSize(width: 35, height: 35))
        
        return Path(path.cgPath)
    }
}



struct Detail : View {
    
    @Binding var show : Bool
    @State var top = UIApplication.shared.windows.last?.safeAreaInsets.top
    @State var count = 0
    
    var body : some View{
        
        VStack(spacing: 0){
            
            Image("header")
                .resizable()
                .frame(height: UIScreen.main.bounds.height / 2.5)
                .edgesIgnoringSafeArea(.top)
                .overlay(
                    
                    VStack{
                        
                        HStack(spacing: 12){
                            
                            Button(action: {
                                
                                self.show.toggle()
                                
                            }) {
                                
                                Image("back").renderingMode(.original)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                
                            }) {
                                
                                Image("download").renderingMode(.original)
                            }
                            
                            Button(action: {
                                
                            }) {
                                
                                Image("Wishlist").renderingMode(.original)
                            }
                            
                        }.padding()
                        
                        Spacer()
                    }
                    
                )
            
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(alignment: .leading,spacing: 15){
                    
                    Text("Seedless Lemon").font(.title)
                    
                    Text("30.00 / kg").foregroundColor(.green)
                    
                    Divider().padding(.vertical, 15)
                    
                    HStack{
                        
                        Image("rp1").renderingMode(.original)
                        
                        Text("Diana Organic Farm")
                        
                        Spacer()
                        
                        Button(action: {
                            
                        }) {
                            
                            Image("chat").renderingMode(.original)
                        }
                    }
                    
                    Text("Organic seedless lemon will enhance the flavor of all your favorite recipes, including chicken, fish, vegetables, and soups without the hassle of picking out the seeds. They are also fantastic in marinades, sauces, and fruit salads.").foregroundColor(.gray)
                    
                    HStack{
                        
                        Text("Reviews (48)")
                        
                        Spacer()
                        
                        Button(action: {
                            
                        }) {
                            
                            Text("More")
                            
                        }.foregroundColor(Color("Color"))
                        
                    }.padding(.vertical, 10)
                    
                    HStack{
                        
                        Image("rp2").renderingMode(.original)
                        
                        VStack(alignment: .leading, spacing: 6){
                            
                            HStack{
                                
                                Text("4")
                                Image(systemName: "star.fill").foregroundColor(.yellow)
                                
                            }
                            
                            Text("Oh Yeon Seo")
                            Text("The Lemon is So Fresh And Delivery is So Speed....")
                        }
                        
                    }.padding()
                    .background(Color("Color1"))
                    .cornerRadius(12)
                    
                    HStack(spacing: 20){
                        
                        Spacer(minLength: 12)
                        
                        Button(action: {
                            
                            self.count += 1
                        }) {
                            
                            Image(systemName: "plus.circle").font(.largeTitle)
                            
                        }.foregroundColor(.green)
                        
                        Text("\(self.count)")
                        
                        Button(action: {
                            
                            if self.count != 0{
                                
                                self.count -= 1
                            }
                            
                        }) {
                            
                            Image(systemName: "minus.circle").font(.largeTitle)
                            
                        }.foregroundColor(.green)
                        
                        Button(action: {
                            
                        }) {
                            
                            Text("Add to Cart").padding()
                            
                        }.foregroundColor(.white)
                        .background(Color("Color"))
                        .cornerRadius(12)
                        
                        Spacer(minLength: 12)
                    }
                }
                
            }.padding()
            .overlay(
                
                
                VStack{
                    
                    HStack{
                        
                        Spacer()
                        
                        HStack{
                            
                            Text("4").foregroundColor(.white)
                            Image(systemName: "star.fill").foregroundColor(.yellow)
                            
                        }.padding()
                        .background(Color.green)
                        .cornerRadius(12)
                    }
                    .padding(.top,-20)
                    .padding(.trailing)
                    
                    
                    Spacer()
                }
                
            )
            .background(RoundedCorner().fill(Color.white))
            .padding(.top, -top! - 25)
            
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
    }
}
