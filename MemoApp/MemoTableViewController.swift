//
//  MemoTableViewController.swift
//  MemoApp
//
//  Created by Celes Augustus on 4/24/24.
//

import UIKit
import CoreData

class MemoTableViewController: UITableViewController {
    var memos: [NSManagedObject] = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        //loadDataFromDatabase()
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewWillAppear(_ animated: Bool){
        loadDataFromDatabase()
        tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        self.didReceiveMemoryWarning()
    }
    func loadDataFromDatabase(){
        let settings = UserDefaults.standard
        let sortField = settings.string(forKey: Constants.kSortField)
        let sortAscending = settings.bool(forKey: Constants.kSortDirectionAscending)
        
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "Memo")
        let sortDescriptor = NSSortDescriptor(key: sortField, ascending: sortAscending)
        let sortDescriptorArray = [sortDescriptor]
        
        request.sortDescriptors = sortDescriptorArray
        
        do{
            memos = try context.fetch(request)
        } catch let error as NSError{
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return memos.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemosCell", for: indexPath) as! MemoTableViewCell
        
        let memos = memos[indexPath.row] as? Memo
        cell.lblSubject?.text = memos?.subject
        if let date = memos?.date{
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            cell.lblDate?.text = dateFormatter.string(from: date)
            
        }
        if let criticality = memos?.criticality{
            switch(criticality){
            case 1:
                cell.imgCriticality.image = UIImage(systemName: "gauge.with.dots.needle.bottom.50percent")
            case 2:
                cell.imgCriticality.image = UIImage(systemName: "gauge.with.dots.needle.bottom.100percent")
                
            default:
                cell.imgCriticality.image = UIImage(systemName: "gauge.with.dots.needle.bottom.0percent")
            }
        }
        cell.accessoryType = .detailDisclosureButton
        
        
        // Configure the cell...

        return cell
    }
    


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let memo = memos[indexPath.row] as? Memo
            let context = appDelegate.persistentContainer.viewContext
            context.delete(memo!)
            do{
                try context.save()
            } catch{
                fatalError("Erro saving contexxt: \(error)")
            }
            loadDataFromDatabase()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "EditMemo"{
            let memoController = segue.destination as? MemoCreate
            let selectedRow = self.tableView.indexPath(for: sender as! UITableViewCell)?.row
            let selectedMemo = memos[selectedRow!] as? Memo
            memoController?.currentMemo = selectedMemo!
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let selectedMemo = memos[indexPath.row] as? Memo
        let subject = selectedMemo!.subject!
        let actionHandler = { (action: UIAlertAction!) -> Void in self.performSegue(withIdentifier: "EditMemo", sender: tableView.cellForRow(at: indexPath))}
        let alertController = UIAlertController(title: "Memo Selected", message: "Selected row: \(indexPath.row) \(subject)", preferredStyle: .alert)
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let actionDetails = UIAlertAction(title: "Show Details", style: .default, handler: actionHandler)
        alertController.addAction(actionCancel)
        alertController.addAction(actionDetails)
        present(alertController, animated: true, completion: nil)
    }
    

}

