import Foundation
class TasksManager{
    
    struct Step:Codable{
        let date : Date
        let comment : String
        
        init(date:Date = Date(),comment:String = "Ajout de la task") {
            self.date = date
            self.comment = comment
        }
    }
    
    struct Task:Codable{
        let name : String
        var steps : [Step]
        init(name:String,steps:[Step] = [Step()]) {
            self.name = name
            self.steps = steps
        }
    }
    
    
    let localStorage = UserDefaults.standard
    
    
    var tasks = [Task]()
    var filteredTasks = [Task]()
    
    var taskDates:[Date] { return tasks.map{
        // the date of the task is defined as the date of the last step which was made
        (task:Task) in return task.steps.last?.date ?? Date()
        }
    }
    
    // the task priority is relative to the oldest task
    func taskPriorityForTaskAt(index:Int)->Float{
        let oldestDate = taskDates.min()!
        let biggestInterval = oldestDate.timeIntervalSinceNow
        let date = tasks[index].steps.last!.date
        let age = date.timeIntervalSinceNow
        let proportion = age / biggestInterval
        return Float(proportion)
    }
    
    
    func createNewTask(name:String){
        // add the task
        tasks.append(Task(name: name, steps: [Step()]))
        tasks.sort { (task1, task2) -> Bool in
            task1.steps.last!.date < task2.steps.last!.date
            // a smaller date is an older date
        }
        saveTasks()
        
    }
    
    func deleteTask(index:Int){
        tasks.remove(at: index)
        
        saveTasks()
        
    }
    
    func createStep(index:Int,comment:String){
        // add a step
        
        self.tasks[index].steps.append(Step(date: Date(), comment: comment))
        self.tasks.sort { (t1, t2) -> Bool in
            t1.steps.last!.date < t2.steps.last!.date
        }
        saveTasks()
        
    }
    
    func saveTasks(){
       
        let data = try! JSONEncoder().encode(tasks)
        
         // save the tasks in localStorage
        self.localStorage.set(data, forKey: "tasks")
        
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
        
        // load Tasks from LocalStorage into tasks
        
        if let tasks = localStorage.data(forKey: "tasks"){
            self.tasks = try! JSONDecoder().decode([Task].self, from: tasks)
        }
        
        
        // if LocalStorage is empty, fill it with placeholder content
        
        if tasks.isEmpty{
            tasks.append(Task(name: "Placeholder Task"))
            saveTasks()
        }
        
        // trie les tasks, dans le cas où elles ne sont pas sauvegardées dans le bon ordre
        tasks.sort { (t1, t2) -> Bool in
            t1.steps.last!.date < t2.steps.last!.date
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
