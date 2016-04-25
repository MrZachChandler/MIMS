//
//  SelectionListTableViewController.swift
//  MIMS
//
//  Created by Zachary Chandler on 4/25/16.
//  Copyright © 2016 UML Lovers. All rights reserved.
//

import UIKit

class SelectionListTableViewController: UITableViewController {

    var flag = 0;
    //0 = symptoms, 1 = test, 2 = treatment, 3 = medication
    var tableData = [String]()
    
    var checked = [Bool]()
    
    let treatment = ["treatment","treatment","treatment","treatment","treatment","treatment","treatment","treatment","treatment"]
    let medication = ["Medication","Medication","Medication","Medication","Medication","Medication","Medication","Medication","Medication"]
    let test = ["test","test","test","test","test","test","test","test","test","test","test","test","test","test","test"]
    let symptoms = ["Symptoms","Symptoms","Symptoms","Symptoms","Symptoms","Symptoms","Symptoms","Symptoms","Symptoms","Symptoms","Symptoms"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch flag {
        case 0:
            tableData = symptoms
        case 1:
            tableData = test
        case 2:
            tableData = treatment
        case 3:
            tableData = medication
        default:
            tableData = medication
        }
        
        let save = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: #selector(SelectionListTableViewController.saveTapped(_:)))
        
        self.navigationItem.setRightBarButtonItem(save, animated: true)

        let sizeArray = [Bool](count: tableData.count, repeatedValue: false)
        checked = sizeArray
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    @IBAction func saveTapped(sender: AnyObject) {
        
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ListCell", forIndexPath: indexPath)
        cell.textLabel?.text = tableData[indexPath.row]
        
        if !checked[indexPath.row] {
            cell.accessoryType = .None
        } else if checked[indexPath.row] {
            cell.accessoryType = .Checkmark
        }

        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            if cell.accessoryType == .Checkmark {
                cell.accessoryType = .None
                checked[indexPath.row] = false
            } else {
                cell.accessoryType = .Checkmark
                checked[indexPath.row] = true
            }
        }    
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
