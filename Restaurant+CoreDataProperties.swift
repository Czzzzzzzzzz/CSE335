//
//  Restaurant+CoreDataProperties.swift
//  finalProject
//
//  Created by 陈泽 on 2018/11/14.
//  Copyright © 2018 ASU. All rights reserved.
//
//

import Foundation
import CoreData


extension Restaurant {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Restaurant> {
        return NSFetchRequest<Restaurant>(entityName: "Restaurant")
    }

    @NSManaged public var restImage: NSData?
    @NSManaged public var restAddress: String?
    @NSManaged public var restName: String?

}
