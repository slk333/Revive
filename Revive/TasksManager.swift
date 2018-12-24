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
    var taskDates:[Date] { return tasks.map{
        (task:Task) in return task.steps.last?.date ?? Date()
        }
    }
   
    func taskPriorityForTaskAt(index:Int)->Float{
        let oldestDate = taskDates.min()!
        let biggestInterval = oldestDate.timeIntervalSinceNow
        let date = tasks[index].steps.last!.date
        let age = date.timeIntervalSinceNow
        let proportion = age / biggestInterval
        return Float(proportion)
    }
    
    
    func createNewTask(name:String){
    tasks.append(Task(name: name, steps: [Step(date: Date(), comment: "Ajout de la task")]))
    tasks.sort { (t1, t2) -> Bool in
    t1.steps.last!.date < t2.steps.last!.date
    }
        let data = try! JSONEncoder().encode(tasks)
        // save the tasks if there is no task already
        
        self.localStorage.set(data, forKey: "tasks")
    }
    
    func deleteTask(index:Int){
        tasks.remove(at: index)
        
        let data = try! JSONEncoder().encode(self.tasks)
        // save the tasks if there is no task already
        
        self.localStorage.set(data, forKey: "tasks")
        
    }
    
    func registerStep(index:Int,comment:String){
        
        self.tasks[index].steps.append(Step(date: Date(), comment: comment))
        self.tasks.sort { (t1, t2) -> Bool in
            t1.steps.last!.date < t2.steps.last!.date
        }
        let data = try! JSONEncoder().encode(self.tasks)
        // save the tasks if there is no task already
        
        self.localStorage.set(data, forKey: "tasks")
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    init() {
        
        // retrieve Tasks from LocalStorage
        
        if let tasks = localStorage.data(forKey: "tasks"){
            self.tasks = try! JSONDecoder().decode([Task].self, from: tasks)
        }

        
        // si localStorage est vide
        
        if tasks.isEmpty
        {
            let taskNames = ["Swift","Web","Chinese"]
            for taskName in taskNames{
                tasks.append(Task(name: taskName))
            }
            
        
            
            let data = try! JSONEncoder().encode(tasks)
            
            // save the tasks in localestorage
            
            localStorage.set(data, forKey: "tasks")
        }
        
        
        
        tasks.sort { (t1, t2) -> Bool in
            t1.steps.last!.date < t2.steps.last!.date
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
