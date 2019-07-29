import UIKit
import UserNotifications

class ScheduleTVC: UITableViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let searchController = UISearchController(searchResultsController: nil)
    
    
    // ask permission for notifications
    let notificationCenter = UNUserNotificationCenter.current()
    override func viewDidAppear(_ animated: Bool) {
        
        notificationCenter.requestAuthorization(options: [.alert, .sound])
        { (granted, error) in
            print(error ?? "no error")
            print(granted)
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // compute and display the total score
        var scoreTotal = 0
        for task in tasksManager.tasks{
            scoreTotal += (task.steps.count - 1)
        }
        let scoreLabel = UILabel(frame: CGRect())
        scoreLabel.text = "[\(scoreTotal)]"
        scoreLabel.sizeToFit()
        scoreLabel.textColor = .white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: scoreLabel)
        
        
        // setup the searchBar
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Task"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        // setup the add task button
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTask))
        
         
        
        
    }
    
    
    
    @objc func addTask(){
        let alertController=UIAlertController(title: "New recurring task", message: "Pick a name for the task", preferredStyle: UIAlertController.Style.alert)
        
        let saveAction=UIAlertAction(title: "Save", style: .destructive){alertAction in
            
            guard let taskName = alertController.textFields?.first?.text, taskName != "", taskName.contains("/") == false else{
                alertController.textFields?.first?.text = "cannot be empty or have slashs"
                self.present(alertController, animated: true, completion: nil)
                print("There was no input or a slash in the task name!")
                return
            }
            
            
            
            guard tasksManager.tasksDictionary[taskName] == nil  else{
                self.present(alertController, animated: true, completion: nil)
                print("That name is already being used!")
                return
            }
            
            
            
            tasksManager.createNewTask(name: taskName)
            
            self.tableView.insertRows(at: [IndexPath(row: tasksManager.tasks.count-1, section: 0)], with: .automatic)
            
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
            return tasksManager.tasksDictionary.count
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)
        
        let i = indexPath.row
        
        let nameLabel = cell.viewWithTag(1) as! UILabel
        
        let task : Task
        if isFiltering(){
            task = tasksManager.filteredTasks[i]
        } else{
            task = tasksManager.tasks[i]
        }
        
        
        nameLabel.text = task.name
        
        let scoreLabel = cell.viewWithTag(5) as! UILabel
        scoreLabel.text = " [\(task.count)]"
        
        let dateLabel = cell.viewWithTag(2) as! UILabel
        
        let now = Date()
        let myFormatter = DateFormatter()
        // day like Monday is EEEE
        myFormatter.dateFormat = "EEEE', 'MMMM dd', 'HH:mm"
        let myRelativeFormatter = RelativeDateTimeFormatter()
        
        
        dateLabel.text = myFormatter.string(from: task.lastCompletionDate) + " [" + myRelativeFormatter.localizedString(for: task.lastCompletionDate, relativeTo: now) + "]"
        

      
        
        
        
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
            let cell = tableView.cellForRow(at: indexPath)!
            let nameLabel = cell.viewWithTag(1) as! UILabel
            let name = nameLabel.text!
            
            
            tasksManager.deleteTask(name:name)
            if isFiltering(){
                self.filterContentForSearchText((self.navigationItem.searchController?.searchBar.text!)!)
            }
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
        
        let cell = tableView.cellForRow(at: indexPath)!
        let nameLabel = cell.viewWithTag(1) as! UILabel
      
        let name = nameLabel.text!
        
        let alertController=UIAlertController(title: "Save your progress", message: "what did you do ?", preferredStyle: UIAlertController.Style.alert)
        
        let saveAction=UIAlertAction(title: "Save", style: .destructive){alertAction in
            
            guard let comment = alertController.textFields?.first?.text, comment != "" else{
                self.present(alertController, animated: true, completion: nil)
                print("there was no input, or there was a slash, asking again")
                return
            }
            
            // step validated with non-void commit-message
            
   
            
            
            
            // update data
            tasksManager.createStep(name:name,comment:comment)
            
            // save a notification if it's a gym task
            if name.contains("GYM"){
               self.notificationCenter.getNotificationSettings { (notificationSettings) in
                   // Do not schedule notifications if not authorized.
                   guard notificationSettings.authorizationStatus == .authorized else {fatalError("not authorized")}
                   
                   
                   if notificationSettings.alertSetting == .enabled {
                       
                       self.scheduleNotification(name:name,comment:comment)
                
                   }
                 
               }
            }
            
            tableView.deselectRow(at: indexPath, animated: true)
            
            if self.isFiltering(){
                self.filterContentForSearchText((self.navigationItem.searchController?.searchBar.text!)!)
                tableView.moveRow(at : indexPath,
                                  to : IndexPath(row: tasksManager.filteredTasks.count-1, section: 0))
                tableView.reloadRows(at: [IndexPath(row: tasksManager.filteredTasks.count-1, section: 0)], with: .automatic)
            }
            else{
                
                tableView.moveRow(at : indexPath,
                                  to : IndexPath(row: tasksManager.tasks.count-1, section: 0))
                tableView.reloadRows(at: [IndexPath(row: tasksManager.tasks.count-1, section: 0)], with: .automatic)
                
            }
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in tableView.deselectRow(at: indexPath, animated: true)})
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        alertController.addTextField(configurationHandler: nil)
        
        
        
        
        
        
        self.present(alertController, animated: true)
        
    }
    
    
}


// handle the search input
extension ScheduleTVC:UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        
        filterContentForSearchText(searchController.searchBar.text!)
        tableView.reloadData()
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        tasksManager.filteredTasks  = tasksManager.tasks.filter({( task : Task) -> Bool in
            return task.name.lowercased().contains(searchText.lowercased())
        })
        
        
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
}

