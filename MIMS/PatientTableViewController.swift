//
//  PatientTableViewController.swift
//  MIMS
//
//  Created by Patrick M. Bush on 4/21/16.
//  Copyright © 2016 UML Lovers. All rights reserved.
//

import UIKit
import ParseUI

class PatientTableViewController: UITableViewController, SWRevealViewControllerDelegate {

    var menuButton: UIButton!
    
    var patients: [Int: Patient]?
    var records = [PatientRecord]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        queryTable()
        
        let nib1 = UINib(nibName: "MIMSCell", bundle: nil)
        tableView.registerNib(nib1, forCellReuseIdentifier: "MIMS")

        menuButton = UIButton(frame: CGRectMake(0, 0, 20, 20))
        menuButton.setBackgroundImage(UIImage(named: "Side menu.png"), forState: .Normal)
        let menuButtonItem = UIBarButtonItem(customView: menuButton)
        self.navigationItem.setLeftBarButtonItem(menuButtonItem, animated: true)
        self.title = "Patients"
        self.navigationController?.navigationBar.translucent = false
        
        if self.revealViewController() != nil {
            menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), forControlEvents: .TouchUpInside)
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            self.revealViewController().delegate = self
        }
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.setNeedsStatusBarAppearanceUpdate()
        self.tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.queryUpdate()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .Default
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard records.count > 0 else { return 0}
        return records.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MIMS", forIndexPath: indexPath) as! MIMSTableViewCell
        
        let tempRecord = records[indexPath.row]
        if let patient = patients![indexPath.row] {
            if !patient.dirty {
            cell.bindPatientWithoutData(patient)
            return cell
            }
        }
        let patient = tempRecord.patient!
        cell.bindPatient(patientToBind: patient) { (patient) in
            self.patients![indexPath.row] = patient
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("Information", sender: self)

    }
    
    func queryPatientRecords() {
        ParseClient.queryPatientRecords("doctor", value: MIMSUser.currentUser()!) { (patientRecords, error) in
            if error == nil && patientRecords != nil
            {
                self.records = patientRecords!
                self.patients = [Int: Patient]()
                self.tableView.reloadData()
            }
        }
    }
    
    func queryTable() {
        self.queryPatientRecords()
    }
    
    func queryUpdate() {
        for record in records {
            if record.dirty {
                self.queryPatientRecords()
            }
        }
    }
    




    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Information" {
            let indexPath:NSIndexPath = self.tableView.indexPathForSelectedRow!
            let detailVC:PatientInformationTableViewController = segue.destinationViewController as! PatientInformationTableViewController
            detailVC.title = patients![indexPath.row]?.name
            detailVC.patient = patients![indexPath.row]
            detailVC.patientRecord = records[indexPath.row]
            
        }
    }

}
