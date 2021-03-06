//
//  DashboardTableViewController.swift
//  MIMS
//
//  Created by Patrick M. Bush on 4/19/16.
//  Copyright © 2016 UML Lovers. All rights reserved.
//

import UIKit

class DashboardTableViewController: UITableViewController, SWRevealViewControllerDelegate {

    var menuButton: UIButton!
    var appointments: [Appointment]?
    var flag: String!
    //flag 0 = admin, 1 = operational, 2 = technical
    
    let actions0 = ["Admit Patients", "Manage Patients", "Discharge Current Appointment"]
    let actions1 = ["John Doe", "John Handcock", "John Smith"]
    let actions2 = ["Request / Complete Test", "Diagnose Symptoms / Issue Treatment", "Manage Patients"]
    
    let detail00 = ["For appointment at:","Delete, Edit Information","John Doe"]
    let detail01 = ["Tuesday , May 10th, 2016", "Transfer, Check Status, Change Insurence", "Tuesday , May 10th, 2016"]
    let detail02 = ["8am - 10am","Active Patients","8am - 10am"]
    
    let detail10 = ["John Doe","Reggie Raglin","John Smith"]
    let detail11 = ["Tuesday , May 10th, 2016", "Tuesday , May 10th, 2016", "Tuesday , May 10th, 2016"]
    let detail12 = ["8am - 10am","10am - 12pm","12pm - 2pm"]
    
    let detail20 = ["John Doe","John Doe","Delete, Edit Information"]
    let detail21 = ["Tuesday , May 10th, 2016","Tuesday , May 10th, 2016","Transfer, Check Status, Change Insurence"]
    let detail22 = ["8am - 10am","8am - 10am","Active Patients"]
    
    let pendingRequest = ["Chemical Testing","Chemical Testing","Chemical Testing"]
    let pendingDetail0 = ["John Doe","John Doe","John Doe"]
    let pendingDetail1 = ["Blood Testing 3,5","Blood Testing 3,5","Blood Testing 3,5"]
    let pendingDetail2 = ["May 1, 2016","May 1, 2016","May 1, 2016"]
    
    let perscriptionRequest = ["CVS Pharmacy","CVS Pharmacy","CVS Pharmacy"]
    let perscriptionDetail0 = ["John Doe","John Doe","John Doe"]
    let perscriptionDetail1 = ["Albuterol","Albuterol","Albuterol"]
    let perscriptiongDetail2 = ["May 1, 2016","May 1, 2016","May 1, 2016"]
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.queryTable()
        
        menuButton = UIButton(frame: CGRectMake(0, 0, 20, 20))
        menuButton.setBackgroundImage(UIImage(named: "Side menu.png"), forState: .Normal)
        let menuButtonItem = UIBarButtonItem(customView: menuButton)
        self.navigationItem.setLeftBarButtonItem(menuButtonItem, animated: true)
        self.title = ""
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
        
        let nib1 = UINib(nibName: "MIMSCell", bundle: nil)
        tableView.registerNib(nib1, forCellReuseIdentifier: "MIMS")
        
        guard let userType = MIMSUser.currentUser()!.userType else {
            flag = ""
            return
        }
        self.title = userType
        flag = userType
        
        //ParseClient.addPatientData()

    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            if flag == UserTypes.AdminUser.rawValue {
                return 2
            }
            else if flag == UserTypes.OperationalUser.rawValue
            {
                if appointments == nil{
                    print("Returning one from number of rows in section 1")
                    return 1
                }
                print("Returning \(appointments!.count) from number of rows in section 1")
                return (appointments!.count > 0) ? appointments!.count : 1
            }
            return 3
        }
        else if section == 1
        {
            return pendingRequest.count
        }
        else
        {
            return perscriptionRequest.count
        }
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MIMS", forIndexPath: indexPath) as! MIMSTableViewCell
        if flag == UserTypes.AdminUser.rawValue {
            if indexPath.section == 0 {
                cell.titleLabel.text = actions0[indexPath.row]
                cell.detailLabel1.text = detail00[indexPath.row]
                cell.detailLabel2.text = detail01[indexPath.row]
                cell.detailLabel3.text = detail02[indexPath.row]
                cell.sideInformationLabel.text = " ";
                return cell
            }
            if indexPath.section == 1
            {
                cell.userInteractionEnabled = false
                cell.accessoryType = .None
                cell.titleLabel.text = pendingRequest[indexPath.row]
                cell.detailLabel1.text = pendingDetail0[indexPath.row]
                cell.detailLabel2.text = pendingDetail1[indexPath.row]
                cell.detailLabel3.text = pendingDetail2[indexPath.row]
                cell.sideInformationLabel.text = " ";
                return cell
            }
            if indexPath.section == 2
            {
                cell.userInteractionEnabled = false
                cell.accessoryType = .None
                cell.titleLabel.text = perscriptionRequest[indexPath.row]
                cell.detailLabel1.text = perscriptionDetail0[indexPath.row]
                cell.detailLabel2.text = perscriptionDetail1[indexPath.row]
                cell.detailLabel3.text = perscriptiongDetail2[indexPath.row]
                cell.sideInformationLabel.text = " ";
                return cell
            }
        }
        else if flag == UserTypes.OperationalUser.rawValue {
            cell.selectionStyle = .None

            if indexPath.section == 0
            {
                var appointment: Appointment!
                cell.titleLabel.text = "No Current Appointments"
                cell.detailLabel1.text = " "
                cell.detailLabel2.text = " "
                cell.detailLabel3.text = " "
                cell.sideInformationLabel.text = " ";
                cell.accessoryType = .None
                if appointments?.count > 0 {
                    appointment = appointments![indexPath.row]
                    cell.bindAppointment(appointmentToBind: appointment)
                    return cell
                }
                
                
                return cell

            }
            if indexPath.section == 1
            {
                cell.titleLabel.text = pendingRequest[indexPath.row]
                cell.detailLabel1.text = pendingDetail0[indexPath.row]
                cell.detailLabel2.text = pendingDetail1[indexPath.row]
                cell.detailLabel3.text = pendingDetail2[indexPath.row]
                cell.sideInformationLabel.text = "Active";
                
                return cell
            }
            if indexPath.section == 2
            {
                cell.titleLabel.text = perscriptionRequest[indexPath.row]
                cell.detailLabel1.text = perscriptionDetail0[indexPath.row]
                cell.detailLabel2.text = perscriptionDetail1[indexPath.row]
                cell.detailLabel3.text = perscriptiongDetail2[indexPath.row]
                cell.sideInformationLabel.text = "Waiting";
                return cell
            }
        }
        else if flag == UserTypes.TechnicalUser.rawValue {
            if indexPath.section == 0
            {
                cell.titleLabel.text = actions2[indexPath.row]
                cell.detailLabel1.text = detail20[indexPath.row]
                cell.detailLabel2.text = detail21[indexPath.row]
                cell.detailLabel3.text = detail22[indexPath.row]
                cell.sideInformationLabel.text = " ";
                return cell
            }
            if indexPath.section == 1
            {
                cell.titleLabel.text = pendingRequest[indexPath.row]
                cell.detailLabel1.text = pendingDetail0[indexPath.row]
                cell.detailLabel2.text = pendingDetail1[indexPath.row]
                cell.detailLabel3.text = pendingDetail2[indexPath.row]
                cell.sideInformationLabel.text = " ";
                return cell
            }
            if indexPath.section == 2
            {
                cell.titleLabel.text = perscriptionRequest[indexPath.row]
                cell.detailLabel1.text = perscriptionDetail0[indexPath.row]
                cell.detailLabel2.text = perscriptionDetail1[indexPath.row]
                cell.detailLabel3.text = perscriptiongDetail2[indexPath.row]
                cell.sideInformationLabel.text = " ";
                return cell
            }
        }
        else {
            cell.titleLabel.text = actions2[indexPath.row]
            cell.detailLabel1.text = detail20[indexPath.row]
            cell.detailLabel2.text = detail21[indexPath.row]
            cell.detailLabel3.text = detail22[indexPath.row]
            cell.sideInformationLabel.text = " ";
            return cell
        }
    return cell
    }


    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch flag {
        case UserTypes.AdminUser.rawValue:
            if section == 0 {
                return "Action"
            }
            else if section == 1 {
                return "Pending Requests"
            }
            else {
                return "Perscriptions Sent"
            }
        case UserTypes.OperationalUser.rawValue:
            if section == 0 {
                return "Next Appointment"
            }
            else if section == 1 {
                return "Pending Requests"
            }
            else {
                return "Perscriptions Sent"
            }
        case UserTypes.TechnicalUser.rawValue:
            if section == 0 {
                return "Action"
            }
            if section == 1 {
                return "Pending Requests"
            }
            else {
                return "Perscriptions Sent"
            }
        default:
            if section == 0 {
                return "Action"
            }
            if section == 1 {
                return "Pending Requests"
            }
            if section == 2 {
                return "Perscriptions Sent"
            }
        }
        return " "
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if flag == UserTypes.AdminUser.rawValue {
            if indexPath.row == 0 {
                self.performSegueWithIdentifier("AdmitPatient", sender: tableView)
            }
            if indexPath.row == 1 {
                self.performSegueWithIdentifier("manage", sender: tableView)

            }

        }
        if flag == UserTypes.TechnicalUser.rawValue {
            if indexPath.section == 0 {
                self.performSegueWithIdentifier("manage", sender: tableView)
            }
        }
        print("Indexpath.row")
        print(indexPath.row)
    }

    func queryTable() {
        self.queryAppointments()
    }
    
    func queryAppointments() {
        ParseClient.queryAppointments { (appointments, error) in
            if error == nil && appointments != nil {
                self.appointments = appointments
                self.tableView.reloadData()
            }
        }
    }    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AdmitPatient" {
            let detailVC:AdmitPatientTableViewController = segue.destinationViewController as! AdmitPatientTableViewController
            detailVC.title = "Admit New Patient"
            detailVC.navigationItem.backBarButtonItem?.title = "Cancel"
        }
        if segue.identifier == "manage"
        {
            let detailVC:PatientTableViewController = segue.destinationViewController as! PatientTableViewController
            detailVC.navigationItem.backBarButtonItem?.title = "Back"
        }
    }

}
