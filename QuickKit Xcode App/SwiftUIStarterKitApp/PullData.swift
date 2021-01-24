//
//  PullData.swift
//  SwiftUIStarterKitApp
//
//  Created by Ben Garman on 23/01/2021.
//  Copyright © 2021 NexThings. All rights reserved.
//

import SwiftUI

struct RetrieveData: View {
    @Environment(\.managedObjectContext) var managedObjectContext

    var body: some View {
        Button(action: {
            getData()
            
        }){
            Text("click here")
        }
    }
    
    func getData() {
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


}

