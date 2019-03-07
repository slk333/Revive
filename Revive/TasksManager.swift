import Foundation
class TasksManager{
    
    let localStorage = UserDefaults.standard
    
    struct Step:Codable{
        let date : Date
        let comment : String
        
        init(date:Date = Date(),comment:String = "Task Added") {
            self.date = date
            self.comment = comment
        }
    }
    
    struct Task:Codable{
        
        let name : String
        var steps : [Step]
        var count : Int {return steps.count-1}
        var lactCompletionDate : Date {return steps.last!.date}
        
        
        init(name:String,steps:[Step] = [Step()]){
            
            self.steps = steps
            self.name = name
            
        }
    }
    
    
    
    
    var tasksDictionary = [String:Task]()
    
    
    
    
    var tasks : [Task] {
        return(
            tasksDictionary.map{
                $0.value
                }.sorted(by: { (t1, t2) -> Bool in
                    t1.steps.last!.date < t2.steps.last!.date
                })
        )
        
    }
    
    
    
    var filteredTasks = [Task]()
    
    var taskDates:[Date] { return tasks.map{
        // the date of the task is defined as the date of the last step which was made
        (task:Task) in return task.lactCompletionDate
        }
    }
    
    // the task priority is relative to the oldest task
    func taskPriorityForTaskAt(index:Int)->Float{
        let oldestTaskAge = taskDates.min()!.timeIntervalSinceNow
        let currentTaskAge = tasks[index].lactCompletionDate.timeIntervalSinceNow
        let proportion = currentTaskAge / oldestTaskAge
        return Float(proportion)
    }
    
    
    func createNewTask(name:String){
        // add the task
        guard tasksDictionary[name] == nil else{
            print("A task with that name already exists")
            return
        }
        
        let newTask = Task(name: name)
        tasksDictionary.updateValue(newTask, forKey: name)
        saveTasks()
        
    }
    
    func deleteTask(name:String){
        tasksDictionary.removeValue(forKey: name)
        saveTasks()
        
    }
    
    func createStep(name:String,comment:String){
        // add a step
        
        tasksDictionary[name]!.steps.append(Step(comment: comment))
        saveTasks()
        
    }
    
    func saveTasks(){
        
        
        
        let data = try! JSONEncoder().encode(tasksDictionary)
        
        // save the tasks in localStorage
        self.localStorage.set(data, forKey: "tasksDictionary")
        
        // and/or save into Tasks.json
        // let url = Bundle.main.url(forResource: "Tasks", withExtension: "json")!
        // try! data.write(to: url)
        
        //  saveToLocalJSON()
        
        
        
        
        
    }
    
    
    func saveToLocalJSON(){
        let data = try! JSONEncoder().encode(tasks)
        
        let fileManager = FileManager.default
        
        do {
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
            let fileURL = documentDirectory.appendingPathComponent("tasks.json")
            
            try data.write(to: fileURL)
            
            
        } catch {
            print(error)
        }
    }
    
    
    
    
    
    
    
    
    
    
    init() {
        
        
        // if there is data already
        
        if let tasksDictionary = localStorage.data(forKey: "tasksDictionary"){
            self.tasksDictionary = try! JSONDecoder().decode([String:Task].self, from: tasksDictionary)
            print("loaded dictionary from localStorage with success! content: *************")
            
            for entry in self.tasksDictionary{
                print("\(entry.key)  \(entry.value)")
            }
        }
        
         // if not
        else{
            
            // try migration
            // old data can be at "tasks"
            if let oldArray = localStorage.data(forKey: "tasks"){
                let tasks = try! JSONDecoder().decode([Task].self, from: oldArray)
                print("old array found! content: *************")
                print(tasks)
                for task in tasks{
                    self.tasksDictionary.updateValue(task, forKey: task.name)
                }
                saveTasks()
            }
                
                // if no migration
            else{
                 // create a placeholder task
                
                if tasksDictionary.isEmpty{
                    
                    let name = "Placeholder Task"
                    let placeHolderTask = Task(name: name)
                    tasksDictionary.updateValue(placeHolderTask, forKey: name)
                }
            }
        }
        
        
        
    
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
