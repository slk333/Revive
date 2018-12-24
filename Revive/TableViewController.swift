import UIKit

class TableViewController: UITableViewController {
let tasksManager = TasksManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTask))
    }
    
    
    
    @objc func addTask(){
        let alertController=UIAlertController(title: "New recurring task", message: "Pick a name for the task", preferredStyle: UIAlertController.Style.alert)
        
        let saveAction=UIAlertAction(title: "Save", style: .destructive){alertAction in
            
            guard let taskName = alertController.textFields?.first?.text, taskName != "" else{
                self.present(alertController, animated: true, completion: nil)
                print("there was no input, asking again")
                return
            }
            
            self.tasksManager.createNewTask(name: taskName)
           
            self.tableView.reloadData()
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        alertController.addTextField(configurationHandler: nil)
        
        self.present(alertController, animated: true)
    }

    
    
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tasksManager.tasks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)
        
        let i = indexPath.row
        
        let nameLabel = cell.viewWithTag(1) as! UILabel
        nameLabel.text = tasksManager.tasks[i].name
        
        let dateLabel = cell.viewWithTag(2) as! UILabel
        
        let date = tasksManager.tasks[i].steps.last!.date
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "EEEE dd MMMM yyyy', à' HH:mm"
        myFormatter.locale=Locale(identifier: "fr")
        dateLabel.text = myFormatter.string(from: date)
        
       
        
        let relativePriority = tasksManager.taskPriorityForTaskAt(index:i)
        
        let progressView = cell.viewWithTag(3) as! UIProgressView
        progressView.progress = Float(relativePriority)
    
        

        return cell
    }
    
    
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            tasksManager.deleteTask(index: indexPath.row)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertController=UIAlertController(title: "Save your progress", message: "what did you do ?", preferredStyle: UIAlertController.Style.alert)
        
        let saveAction=UIAlertAction(title: "Save", style: .destructive){alertAction in
           
            guard let comment = alertController.textFields?.first?.text, comment != "" else{
                self.present(alertController, animated: true, completion: nil)
                print("there was no input, asking again")
                return
            }
            self.tasksManager.registerStep(index:indexPath.row,comment:comment)
            
         
            self.tableView.reloadData()
            
        }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(saveAction)
            alertController.addAction(cancelAction)
            alertController.addTextField(configurationHandler: nil)
        
        
        
        
        
        self.present(alertController, animated: true)
    }
}
