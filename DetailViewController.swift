//
//  DetailViewController.swift
//  finalProject
//
//  Created by 陈泽 on 2018/10/14.
//  Copyright © 2018 ASU. All rights reserved.
//

import UIKit
import CoreData
import Foundation
class DetailViewController: UIViewController {
    var SelectedAddress:String?
    var SelectedName: String?
    var SelectedImage: UIImage?
    
    @IBOutlet weak var rImage: UIImageView!
    @IBOutlet weak var rsa: UILabel!
    @IBOutlet weak var rsn: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        rImage.image=SelectedImage
        rsa.text=SelectedAddress
        rsn.text=SelectedName
        // Do any additional setup after loading the view.
    }

    
    
    @IBAction func online(_ sender: Any) {
        let scheme = "https"
        let host = "www.google.com"
        let path = "/search"
        let queryItem = URLQueryItem(name: "q", value: SelectedName)
        
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = [queryItem]
        
        // let url = NSURL(string: urlComponents.url )!
        UIApplication.shared.openURL(urlComponents.url!)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
