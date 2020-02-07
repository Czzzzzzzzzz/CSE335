//
//  FourthViewController.swift
//  finalProject
//
//  Created by 陈泽 on 2018/10/14.
//  Copyright © 2018 ASU. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class FourthViewController:UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var rm:resraurantModel = resraurantModel()
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var restaurantTable: UITableView!

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // number of rows based on the coredata storage
        return rm.fetchRecord()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // add each row from coredata fetch results
        let cell = tableView.dequeueReusableCell(withIdentifier: "restaurantCell", for:indexPath )as! RestaurantTableViewCell
        let placeItem = rm.fetchResults[indexPath.row]
        
        if let placepicture = UIImage(data: placeItem.restImage! as Data){
            cell.ri?.image = placepicture
            //  cell.myimage?.layer.cornerRadius = cell.myimage.frame.size.width / 2;
            //  cell.myimage?.layer.masksToBounds = true;
        }
        cell.restaurantN?.text = placeItem.restName
        return (cell)
    }
    
    // delete table entry
    // this method makes each row editable
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    // return the table view style as deletable
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell.EditingStyle { return UITableViewCell.EditingStyle.delete }
    
    
    // implement delete function
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete{
            rm.deleteRestaurant(row: indexPath.row)
            restaurantTable.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80;//Choose your custom row height
    }
    
    @IBAction func addR(_ sender: Any) {
        let alert = UIAlertController(title:"Options", message:nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"Take a picture", style:.default,handler:{action in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                self.imagePicker.allowsEditing = false
                self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
                self.imagePicker.cameraCaptureMode = .photo
                self.imagePicker.modalPresentationStyle = .fullScreen
                self.present(self.imagePicker,animated: true, completion: nil)
            }else{
                print("No camera")
            }
        }))
        alert.addAction(UIAlertAction(title:"Add from photo library", style:.default,handler:{action in
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.delegate = self
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        self.present(alert, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            picker.dismiss(animated: true) {
                let alert = UIAlertController(title: "Add City", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                
                alert.addTextField(configurationHandler: { textField in
                    textField.placeholder = "Enter name of the City Here"
                })
                
                alert.addTextField(configurationHandler: { textField in
                    textField.placeholder = "Enter description the City Here"
                })
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    if let name = alert.textFields?.first?.text, let description = alert.textFields?[1].text{
                        self.rm.addRestaurant(na: name, des: description,img: image)
                        self.restaurantTable.reloadData()
                    }
                }))
                self.present(alert, animated: true)
            }
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "todetail" {
            if let des = segue.destination as? DetailViewController {
                let selectedIndex:IndexPath = self.restaurantTable.indexPath(for: sender as! UITableViewCell)!
                let row = selectedIndex.row
                des.SelectedName = rm.getRestaurantObject(row: row).restName
                des.SelectedAddress = rm.getRestaurantObject(row: row).restAddress
                // des.cImage.image = UIImage(data: cm.getCityObject(row: row).cityPicture as! Data)
                des.SelectedImage = rm.getRestaurantObject(row: row).restImage as? UIImage
            }
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

