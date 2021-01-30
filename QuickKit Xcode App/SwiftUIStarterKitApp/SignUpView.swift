//
//  SignUpView.swift
//  SwiftUIStarterKitApp
//
//  Created by Osama Naeem on 03/08/2019.
//  Copyright © 2019 NexThings. All rights reserved.
//

import SwiftUI
import CoreData

struct MovingViewsSwiftUI: View {
    
    @State private var needToLogin = true
    
    let hasLaunchedBefore = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
    var body: some View {
        if !hasLaunchedBefore {
            ZStack {
                SignUpView(needToLogin: $needToLogin)
                    .opacity(needToLogin ? 1 : 0)
                
                TabbarView()
                    .opacity(needToLogin ? 0 : 1)
                
            }
        }
        else{
            TabbarView()
        }
        
    }
    
}

struct SignUpView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext

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
                            var result = createUser(email: self.emailAddress, name: self.name, phone: self.phone, password: self.password)
                            if (result == "Email Taken"){
                                Print("fucked")
                            }else{
                                result = String(result.split(separator: "\n")[0])
                                UserDefaults.standard.set(Int(result)!, forKey: "userID")
                                UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
                                getData()
                                withAnimation(.easeIn){self.needToLogin = false}
                            }
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
                            let result = checkLogin(username: self.emailAddress, password: self.password)
                            if (result == "Not Recognised"){
                                Print("fucked")
                            }else{
                                UserDefaults.standard.set(Int(result)!, forKey: "userID")
                                UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
                                getData()
                                withAnimation(.easeIn){self.needToLogin = false}
                            }
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
    func checkLogin(username: String, password: String) -> String{
        var queryDetails = [
            URLQueryItem(name: "emailAddress", value: username),
            URLQueryItem(name: "password", value: password)
        ]
        var details = String()
        if let url = URL(string: getURLAddress(pathName: "checkLoginDetails.php", querys: queryDetails)){
            do {
                details = try String(contentsOf: url).replacingOccurrences(of: " ", with: "")
                
            } catch {}
        } else {
            print("Unable to create Order in database")
        }
        
        return details
        
    }
    
    func createUser(email: String, name: String, phone: String, password: String) -> String{
        var queryDetails = [
            URLQueryItem(name: "emailAddress", value: email),
            URLQueryItem(name: "name", value: name),
            URLQueryItem(name: "phoneNumber", value: phone),
            URLQueryItem(name: "password", value: password)
        ]
        var details = String()
        if let url = URL(string: getURLAddress(pathName: "createNewUser.php", querys: queryDetails)){
            do {
                details = try String(contentsOf: url).replacingOccurrences(of: " ", with: "")
                
            } catch {}
        } else {
            print("Unable to create Order in database")
        }
        
        return details
        
    }
    
    
    func getData() {
        deleteAllData("ItemCategories")
        if let url = URL(string: getURLAddress(pathName: "getCategories.php")){
            do {
                let categories = try String(contentsOf: url).split(separator: "^")
                for categoryString in categories{
                    let categoryArray = categoryString.split(separator: ",")
                    let newCategory = ItemCategories(context: managedObjectContext)
                    newCategory.id = Int32(categoryArray[0])!
                    newCategory.categoryName = String(categoryArray[1])
                    newCategory.categoryDescription = String(categoryArray[2])
                    newCategory.categoryDisplayed = Int32(categoryArray[3])!
                    
                }
                saveContext()
            } catch {}
        }
        deleteAllData("Items")
        if let url = URL(string: getURLAddress(pathName: "getItems.php")){
            do {
                let items = try String(contentsOf: url).split(separator: "^")
                for itemString in items{
                    let itemArray = itemString.split(separator: ",")
                    let newItem = Items(context: managedObjectContext)
                    newItem.id = Int32(itemArray[0])!
                    newItem.itemCategoriesID = Int32(itemArray[1])!
                    newItem.itemName = String(itemArray[2])
                    newItem.itemDescription = String(itemArray[3])
                    newItem.itemBasePrice = Double(itemArray[4])!
                    
                    let url = URL(string: String(itemArray[5]))!
                    if let data = try? Data(contentsOf: url) {
                        let imageTemp = UIImage(data: data)!
                        newItem.itemImage = imageTemp.jpegData(compressionQuality: 1.0)!
                    }
                }
                saveContext()
            } catch {}
        }
        deleteAllData("ItemMods")
        if let url = URL(string: getURLAddress(pathName: "getMods.php")){
            do {
                let mods = try String(contentsOf: url).split(separator: "^")
                for modString in mods{
                    let modArray = modString.split(separator: ",")
                    let newMod = ItemMods(context: managedObjectContext)
                    newMod.itemID = Int32(modArray[0])!
                    newMod.modID = Int32(modArray[1])!
                    newMod.modName = String(modArray[2])
                    newMod.compulsary = Int32(modArray[3])!
                    newMod.modifierString = String(modArray[4])
                    
                }
                saveContext()
            } catch {}
        }
        
    }
    func saveContext() {
      do {
        try managedObjectContext.save()
      } catch {
        print("Error saving managed object context: \(error)")
      }
    }
    func deleteAllData(_ entity:String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.includesPropertyValues = false
        do {
            let items = try managedObjectContext.fetch(fetchRequest) as! [NSManagedObject]
            for item in items {
                managedObjectContext.delete(item)
            }
            try managedObjectContext.save()
        } catch {
        }
    }
    
}
