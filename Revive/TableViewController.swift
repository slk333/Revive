import UIKit
extension UINavigationController {
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
}
class TableViewController: UITableViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let searchController = UISearchController(searchResultsController: nil)
    
    
    
    let tasksManager = TasksManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var scoreTotal = 0
        for task in tasksManager.tasks{
            scoreTotal += (task.steps.count - 1)
        }
        let scoreLabel = UILabel(frame: CGRect())
        scoreLabel.text = "[\(scoreTotal)]"
        scoreLabel.sizeToFit()
        scoreLabel.textColor = .white
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: scoreLabel)
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Task"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
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
            
            self.tableView.insertRows(at: [IndexPath(row: self.tasksManager.tasks.count-1, section: 0)], with: .automatic)
            
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
        if isFiltering(){
             return tasksManager.filteredTasks.count
        } else{
           return tasksManager.tasks.count
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)
        
        let i = indexPath.row
        
        let nameLabel = cell.viewWithTag(1) as! UILabel
        
        let task : TasksManager.Task
        if isFiltering(){
            task = tasksManager.filteredTasks[i]
        } else{
            task = tasksManager.tasks[i]
        }
        
        
        nameLabel.text = task.name + " - \(task.steps.count - 1)"
        
        let dateLabel = cell.viewWithTag(2) as! UILabel
        
        let date = task.steps.last!.date
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "EEEE dd MMMM yyyy', à' HH:mm"
        myFormatter.locale=Locale(identifier: "fr")
        let durationInDays = floor(date.timeIntervalSinceNow * -1 * 10 / (3600 * 24)) / 10
        
        dateLabel.text = myFormatter.string(from: date) + " [\(durationInDays)]"
        
        
        
        
        let relativePriority = tasksManager.taskPriorityForTaskAt(index:i)
        
        let progressView = cell.viewWithTag(3) as! UIProgressView
        progressView.progress = Float(relativePriority)
        
        let lastStepLabel = cell.viewWithTag(4) as! UILabel
        lastStepLabel.text = task.steps.last?.comment
        
        
        
        
        
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
        if isFiltering(){
             tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        
        let alertController=UIAlertController(title: "Save your progress", message: "what did you do ?", preferredStyle: UIAlertController.Style.alert)
        
        let saveAction=UIAlertAction(title: "Save", style: .destructive){alertAction in
            
            guard let comment = alertController.textFields?.first?.text, comment != "" else{
                self.present(alertController, animated: true, completion: nil)
                print("there was no input, asking again")
                return
            }
            
            // step validated with non-void commit-message
            
            // update data
            self.tasksManager.createStep(index:indexPath.row,comment:comment)
            
            tableView.deselectRow(at: indexPath, animated: true)
            
            
            tableView.moveRow(at : indexPath,
                              to : IndexPath(row: self.tasksManager.tasks.count-1, section: 0))
            tableView.reloadRows(at: [IndexPath(row: self.tasksManager.tasks.count-1, section: 0)], with: .automatic)
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in tableView.deselectRow(at: indexPath, animated: true)})
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        alertController.addTextField(configurationHandler: nil)
        
        
        
        
        
        
        self.present(alertController, animated: true)
        
    }
    
    
}


extension TableViewController:UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        print("test")
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        self.tasksManager.filteredTasks  = self.tasksManager.tasks.filter({( task : TasksManager.Task) -> Bool in
            return task.name.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
}

