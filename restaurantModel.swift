//
//  restaurantModel.swift
//  finalProject
//
//  Created by 陈泽 on 2018/11/19.
//  Copyright © 2018 ASU. All rights reserved.
//

import Foundation
import UIKit
import CoreData
class resraurantModel{
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //this is the array to store Fruit entities from the coredata
    var   fetchResults =   [Restaurant]()
    func fetchRecord() -> Int {
        // Create a new fetch request using the FruitEntity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Restaurant")
        var x   = 0
        // Execute the fetch request, and cast the results to an array of FruitEnity objects
        fetchResults = ((try? managedObjectContext.fetch(fetchRequest)) as? [Restaurant])!
        x = fetchResults.count
        print(x)
        // return howmany entities in the coreData
        return x
    }
    func getRestaurantObject(row:Int)->Restaurant{
        
        return fetchResults[row]
    }
    func addRestaurant(na:String, des:String, img:UIImage){
        let ent = NSEntityDescription.entity(forEntityName: "Restaurant", in: managedObjectContext)
        let newItem = Restaurant(entity: ent!, insertInto:self.managedObjectContext)
        newItem.restName = na
        newItem.restAddress = des
        newItem.restImage = NSData(data:img.jpegData(compressionQuality: 0.5)!)
        
        
        do{
            try managedObjectContext.save()
        }
        catch{
            
        }
    }
    
    func deleteRestaurant(row:Int){
        managedObjectContext.delete(fetchResults[row])
        fetchResults.remove(at: row)
        do {
            // save the updated managed object context
            try managedObjectContext.save()
        } catch {
            
        }
    }
}
