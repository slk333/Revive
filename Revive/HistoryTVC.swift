import UIKit

class HistoryTVC: UITableViewController {
    
    let myFormatter = DateFormatter()
    let myRelativeFormatter = RelativeDateTimeFormatter()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    let searchController = UISearchController(searchResultsController: nil)
    
    
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         myFormatter.dateFormat = "MMMM dd', 'HH:mm"
        
        
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
        
         }
    
    
    
    
    
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if isFiltering(){
            return tasksManager.filteredSteps.count
        } else{
            return tasksManager.allStepsSorted.count
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)
        
        let i = indexPath.row
        
        let nameLabel = cell.viewWithTag(1) as! UILabel
        
        let (name,step) : (name:String,step:Step)
        if isFiltering(){
            (name,step) = tasksManager.filteredSteps[i]
        } else{
            (name,step) = tasksManager.allStepsSorted[i]
        }
        
        
        nameLabel.text = name
        
        let dateLabel = cell.viewWithTag(2) as! UILabel
        
        
    
      
        dateLabel.text = myFormatter.string(from: step.date) + " [" + myRelativeFormatter.localizedString(for: step.date, relativeTo: Date())  + "]"
     
           
               
     
    
        
        let lastStepLabel = cell.viewWithTag(4) as! UILabel
        lastStepLabel.text = step.comment
        
        
        
        
        
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    
  
    
    
}


extension HistoryTVC:UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        
        filterContentForSearchText(searchController.searchBar.text!)
        tableView.reloadData()
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        tasksManager.filteredSteps  = tasksManager.allStepsSorted.filter({(tuple:(name:String,step:Step)) -> Bool in
            return tuple.name.lowercased().contains(searchText.lowercased())
        })
        
        
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
}

