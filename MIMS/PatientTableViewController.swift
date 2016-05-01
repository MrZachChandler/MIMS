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
    var patientArray: [Patient]?
    var filteredPatients: [Patient]?
    var filteredRecords = [PatientRecord]()
    var records = [PatientRecord]()
    
    var searchController = UISearchController(searchResultsController: nil)
    

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
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.scopeButtonTitles = []
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.sizeToFit()
        definesPresentationContext = true
        self.setNeedsStatusBarAppearanceUpdate()
        self.tableView.tableFooterView = UIView()
        self.extendedLayoutIncludesOpaqueBars = true
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if searchController.active {
//            searchController.active = false
//            self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Top, animated: true)
            self.tableView.reloadData()
        }
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
        if searchController.active && searchController.searchBar.text != "" {
            return filteredRecords.count
        }
        
        guard records.count > 0 else { return 0}
        return records.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MIMS", forIndexPath: indexPath) as! MIMSTableViewCell
        var tempRecord: PatientRecord
        var patient: Patient
        if searchController.active && searchController.searchBar.text != "" {
            tempRecord = filteredRecords[indexPath.row]
        } else {
            tempRecord = records[indexPath.row]
        }
        
        patient = tempRecord.patient!
        if let patientToDisplay = patients![indexPath.row] {
            if patient == patientToDisplay && !patient.dirty {
            cell.bindPatientWithoutData(patient)
            return cell
            }
        }
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
                self.patientArray = [Patient]()
                for record in self.records {
                    self.patientArray?.append(record.patient!)
                }
                self.tableView.reloadData()
            }
        }
    }
    
    func queryTable() {
        self.queryPatientRecords()
    }
    
    func queryUpdate() {
        for record in records {
            if record.attendingPhysician != MIMSUser.currentUser() {
                self.queryPatientRecords()
                break
            }
        }
    }
    




    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Information" {
            let indexPath:NSIndexPath = self.tableView.indexPathForSelectedRow!
            let detailVC:PatientInformationTableViewController = segue.destinationViewController as! PatientInformationTableViewController
            if searchController.active && searchController.searchBar.text != "" {
                let patientRecord = filteredRecords[indexPath.row]
                if let indexOfPatient = filteredPatients?.indexOf({ $0.objectId == patientRecord.patient!.objectId }) {
                    let patient = filteredPatients![indexOfPatient]
                    detailVC.title = patient.name
                    detailVC.patient = patient
                    detailVC.patientRecord = patientRecord
                }
            } else {
            detailVC.title = patients![indexPath.row]?.name
            detailVC.patient = patients![indexPath.row]
            detailVC.patientRecord = records[indexPath.row]
            }
        }
    }

}

extension PatientTableViewController: UISearchControllerDelegate, UISearchResultsUpdating {
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredRecords.removeAll()
        filteredRecords = records.filter({ (record) -> Bool in
            return record.patient!.name.lowercaseString.containsString(searchText.lowercaseString)
        })
        tableView.reloadData()
    }
    
    func filterOtherContentForSearchText(searchText: String) {
        filteredPatients?.removeAll()
        filteredPatients = patients?.values.filter({ (patient) -> Bool in
            return patient.name.lowercaseString.containsString(searchText.lowercaseString)
        })
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(self.searchController.searchBar.text!)
        filterOtherContentForSearchText(self.searchController.searchBar.text!)
    }
    
}
