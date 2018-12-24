import Foundation
class TasksManager{
    
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
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
