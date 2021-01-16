//
//  SignUpView.swift
//  SwiftUIStarterKitApp
//
//  Created by Osama Naeem on 03/08/2019.
//  Copyright © 2019 NexThings. All rights reserved.
//

import SwiftUI

struct MovingViewsSwiftUI: View {

    @State private var needToLogin = true
    var body: some View {

        ZStack {
            SignUpView(needToLogin: $needToLogin)
                .opacity(needToLogin ? 1 : 0)

            TabbarView()
                .opacity(needToLogin ? 0 : 1)

        }

    }

}

struct SignUpView: View {
    
    @Binding var needToLogin : Bool
    
    @State var emailAddress: String = ""
    @State var name: String = ""
    @State var phone: String = ""
    @State var password: String = ""
    @State var value : CGFloat = 0
    @State var signup : Bool = true
    
    var body: some View {

    GeometryReader { geometry in
        VStack (alignment: .center){
            Spacer()
            Image("placeholder-image")
            .resizable()
                .frame(width: geometry.size.width - 40, height: 200)
            Spacer()
            
            if self.signup{
                
                Text("Create an Account")
                    .font(.title)
                    .font(.system(size: 14, weight: .bold, design: Font.Design.default))
                    .padding(.bottom, 40)
                TextField("Name", text: self.$name)
                        .frame(width: geometry.size.width - 45, height: 50)
                        .textContentType(.emailAddress)
                        .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
                        .accentColor(.red)
                        .background(Color(red: 242 / 255, green: 242 / 255, blue: 242 / 255))
                        .cornerRadius(5)
                
                TextField("Email", text: self.$emailAddress)
                        .frame(width: geometry.size.width - 45, height: 50)
                        .textContentType(.emailAddress)
                        .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
                        .accentColor(.red)
                        .background(Color(red: 242 / 255, green: 242 / 255, blue: 242 / 255))
                        .cornerRadius(5)
                    
                TextField("Phone", text: self.$phone)
                        .frame(width: geometry.size.width - 45, height: 50)
                        .textContentType(.emailAddress)
                        .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
                        .accentColor(.red)
                        .background(Color(red: 242 / 255, green: 242 / 255, blue: 242 / 255))
                        .cornerRadius(5)
                
                SecureField("Password", text: self.$password)
                        .frame(width: geometry.size.width - 45, height: 50)
                        .textContentType(.emailAddress)
                        .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
                        .accentColor(.red)
                        .background(Color(red: 242 / 255, green: 242 / 255, blue: 242 / 255))
                        .cornerRadius(5)
                
                VStack(spacing: 10){
                    Button(action: {
                        withAnimation(.easeIn){self.signup = true}
                        UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
                        withAnimation(.easeIn){self.needToLogin = false}
                    }) {
                        
                        HStack {
                            Text("Sign up")
                        }
                        .padding()
                        .frame(width: geometry.size.width - 40, height: 40)
                        .foregroundColor(Color.white)
                        .background(Color.blue)
                        .cornerRadius(5)
                    }
                    
                    HStack{
                        Rectangle()
                            .fill(Color.gray)
                            .frame(width: (geometry.size.width / 2) - 40, height: 1)
                            .padding(.top,3)
                        Text("or")
                            .foregroundColor(Color.gray)
                            .font(.system(size: 13))

                        
                        Rectangle()
                            .fill(Color.gray)
                            .frame(width: (geometry.size.width / 2) - 40, height: 1)
                            .padding(.top,3)

                    }
                    Button(action: {
                            withAnimation(.easeIn){self.signup = false}
                        
                    }) {
                        HStack {
                            Text("Log in")
                        }
                        .padding()
                        .frame(width: geometry.size.width - 40, height: 40)
                        .foregroundColor(Color.gray)
                        .cornerRadius(5)
                        .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.gray, lineWidth: 1)
                                )

                    }
                }.padding(.top, 30)
            }else{
                Text("Log Into Your Account")
                    .font(.title)
                    .font(.system(size: 14, weight: .bold, design: Font.Design.default))
                    .padding(.bottom, 40)
                
                TextField("Email", text: self.$emailAddress)
                    .frame(width: geometry.size.width - 45, height: 50)
                    .textContentType(.emailAddress)
                    .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
                    .accentColor(.red)
                    .background(Color(red: 242 / 255, green: 242 / 255, blue: 242 / 255))
                    .cornerRadius(5)
                
                
                SecureField("Password", text: self.$password)
                    .frame(width: geometry.size.width - 45, height: 50)
                    .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
                    .foregroundColor(.red)
                    .background(Color(red: 242 / 255, green: 242 / 255, blue: 242 / 255))
                    .textContentType(.password)
                    .cornerRadius(5)
                
                VStack(spacing: 10){
                    Button(action: {
                        withAnimation(.easeIn){self.signup = false}
                        UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
                        withAnimation(.easeIn){self.needToLogin = false}
                    }) {
                        
                        HStack {
                            Text("Log In")
                        }
                        .padding()
                        .frame(width: geometry.size.width - 40, height: 40)
                        .foregroundColor(Color.white)
                        .background(Color.blue)
                        .cornerRadius(5)
                    }
                    
                    HStack{
                        Rectangle()
                            .fill(Color.gray)
                            .frame(width: (geometry.size.width / 2) - 40, height: 1)
                            .padding(.top,3)
                        Text("or")
                            .foregroundColor(Color.gray)
                            .font(.system(size: 13))

                        
                        Rectangle()
                            .fill(Color.gray)
                            .frame(width: (geometry.size.width / 2) - 40, height: 1)
                            .padding(.top,3)

                    }
                    Button(action: {
                            withAnimation(.easeIn){self.signup = true}
                        
                    }) {
                        HStack {
                            Text("Sign Up")
                        }
                        .padding()
                        .frame(width: geometry.size.width - 40, height: 40)
                        .foregroundColor(Color.gray)
                        .cornerRadius(5)
                        .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.gray, lineWidth: 1)
                                )

                    }
                }.padding(.top, 30)

            }
            
            
            
            
            

            
            
            
            
            
            
        }
        .padding()
        .offset(y: -self.value)
        .animation(.spring())
        .onAppear {
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (noti) in
                let value = noti.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                self.value = value.height / 2
                
            }
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (noti) in
                self.value = 0
                
            }
        }
        }
    }
    
}
