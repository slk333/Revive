import UIKit

class Cell:UITableViewCell{
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let longPressGesture = UILongPressGestureRecognizer(target: self,
                                                      action: #selector(gestureAction))
        addGestureRecognizer(longPressGesture)
    }
    
    
    @objc func gestureAction() {
        print("gesture action")
    }
    
    
    
}


class TableViewController: UITableViewController {
    
    
    struct Step:Codable{
        let date : Date
        let comment : String
    }
    
    
    struct Task:Codable{
        let name : String
        var steps : [Step]
    }
    
    
    let localStorage = UserDefaults.standard
    
   
    var tasks = [Task]()
    var taskDates:[Date] { return tasks.map{
            (task:Task) in return task.steps.last?.date ?? Date()
             }
    }
    
   
   
    
    
    
    
    
    
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // retrieve Tasks from LocalStorage
        
        if let tasks = localStorage.data(forKey: "tasks"){
            self.tasks = try! JSONDecoder().decode([Task].self, from: tasks)
        }
        
        
      
        
        // si localStorage est vide
        
        if tasks.isEmpty
        {
        
        tasks.append(Task(name: "Swift", steps: [Step(date: Date(), comment: "Ajout de la task")]))
        tasks.append(Task(name: "Web", steps: [Step(date: Date(), comment: "Ajout de la task")]))
        tasks.append(Task(name: "review Chinese app", steps: [Step(date: Date(), comment: "Ajout de la task")]))
        tasks.append(Task(name: "phrases de chinois OLD", steps: [Step(date: Date(), comment: "Ajout de la task")]))
        tasks.append(Task(name: "happy Chinese", steps: [Step(date: Date(), comment: "Ajout de la task")]))
        tasks.append(Task(name: "90 lessons de chinois", steps: [Step(date: Date(), comment: "Ajout de la task")]))
        tasks.append(Task(name: "phrases", steps: [Step(date: Date(), comment: "Ajout de la task")]))
        tasks.append(Task(name: "Discover China 4", steps: [Step(date: Date(), comment: "Ajout de la task")]))
        tasks.append(Task(name: "Discover China 3", steps: [Step(date: Date(), comment: "Ajout de la task")]))
        tasks.append(Task(name: "Phrases de Chinois Oral", steps: [Step(date: Date(), comment: "Ajout de la task")]))
        tasks.append(Task(name: "GYM Abdos", steps: [Step(date: Date(), comment: "Ajout de la task")]))
        tasks.append(Task(name: "GYM Adbos Latéraux", steps: [Step(date: Date(), comment: "Ajout de la task")]))
        tasks.append(Task(name: "GYM Haut du Dos", steps: [Step(date: Date(), comment: "Ajout de la task")]))
        tasks.append(Task(name: "GYM Cardio", steps: [Step(date: Date(), comment: "Ajout de la task")]))
        tasks.append(Task(name: "GYM Jambes", steps: [Step(date: Date(), comment: "Ajout de la task")]))
        tasks.append(Task(name: "GYM Dos", steps: [Step(date: Date(), comment: "Ajout de la task")]))
        tasks.append(Task(name: "GYM Dips", steps: [Step(date: Date(), comment: "Ajout de la task")]))
        tasks.append(Task(name: "GYM Epaules", steps: [Step(date: Date(), comment: "Ajout de la task")]))
        tasks.append(Task(name: "GYM Tractions", steps: [Step(date: Date(), comment: "Ajout de la task")]))
        tasks.append(Task(name: "GYM Pectoraux", steps: [Step(date: Date(), comment: "Ajout de la task")]))
        
        
        let data = try! JSONEncoder().encode(tasks)
           
            // save the tasks in localestorage
          
            localStorage.set(data, forKey: "tasks")
            
        }
        
        
        tasks.sort { (t1, t2) -> Bool in
            t1.steps.last!.date < t2.steps.last!.date
        }
        

     
    
        
    
       
        
        
        
       

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
            
            self.tasks.append(Task(name: taskName, steps: [Step(date: Date(), comment: "Ajout de la task")]))
            self.tasks.sort { (t1, t2) -> Bool in
                t1.steps.last!.date < t2.steps.last!.date
            }
            let data = try! JSONEncoder().encode(self.tasks)
            // save the tasks if there is no task already
            
            self.localStorage.set(data, forKey: "tasks")
            
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
        return tasks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)
        
        let i = indexPath.row
        
        let nameLabel = cell.viewWithTag(1) as! UILabel
        nameLabel.text = tasks[i].name
        
        let dateLabel = cell.viewWithTag(2) as! UILabel
        
        let date = tasks[i].steps.last?.date ?? Date()
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "EEEE dd MMMM yyyy', à' HH:mm"
        myFormatter.locale=Locale(identifier: "fr")
        dateLabel.text = myFormatter.string(from: date)
        
        let oldest = taskDates.min()!
        let biggestInterval = oldest.timeIntervalSinceNow
        let age = date.timeIntervalSinceNow
        let proportion = age / biggestInterval
        
        let progressView = cell.viewWithTag(3) as! UIProgressView
        progressView.progress = Float(proportion)
    
        
        
        
        
        

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
            
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            let data = try! JSONEncoder().encode(self.tasks)
            // save the tasks if there is no task already
            
            self.localStorage.set(data, forKey: "tasks")
            
            
            
            
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
            
            self.tasks[indexPath.row].steps.append(Step(date: Date(), comment: comment))
            self.tasks.sort { (t1, t2) -> Bool in
                t1.steps.last!.date < t2.steps.last!.date
            }
            let data = try! JSONEncoder().encode(self.tasks)
            // save the tasks if there is no task already
         
            self.localStorage.set(data, forKey: "tasks")
            
            self.tableView.reloadData()
            
        }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(saveAction)
            alertController.addAction(cancelAction)
            alertController.addTextField(configurationHandler: nil)
        
        
        
        
        
        self.present(alertController, animated: true)
    }
}
