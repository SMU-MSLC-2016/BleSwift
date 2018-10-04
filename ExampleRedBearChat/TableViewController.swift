//
//  TableViewController.swift
//  ExampleRedBearChat
//
//  Created by Eric Larson on 9/28/17.
//  Copyright © 2017 Eric Larson. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    
    var bleShield = (UIApplication.shared.delegate as! AppDelegate).bleShield
    override func viewDidLoad() {
        super.viewDidLoad()

        let refresh = UIRefreshControl()
        refresh.addTarget(self,
                          action: #selector(scanForDevices),
                          for: .valueChanged)
        
        self.refreshControl = refresh
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bleShield.peripherals.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bleCell", for: indexPath)

        let peripheral = bleShield.peripherals[indexPath.row]
        cell.textLabel?.text = peripheral.name!
        cell.detailTextLabel?.text = peripheral.identifier.uuidString

        return cell
    }
 
    @objc func scanForDevices(){
        // disconnect from any peripherals
        
        for peripheral in bleShield.peripherals {
            if(peripheral.state == .connected){
                bleShield.disconnectFromPeripheral(peripheral: peripheral)
            }
        }
        
        
        //start search for peripherals with a timeout of 3 seconds
        // this is an asynchronous call and will return before search is complete
        if(bleShield.startScanning(timeout: 3.0)){
            // after three seconds, try to connect to first peripheral
            Timer.scheduledTimer(withTimeInterval: 3.0,
                                 repeats: false,
                                 block: self.didFinishScanning)
        }
        
        // give connection feedback to the user
        //self.spinner.startAnimating()
    }
    
    func didFinishScanning(timer:Timer){
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
