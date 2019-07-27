import Foundation
import Firebase


let tasksManager = TasksManager()
class TasksManager{
    
    
    let firebaseHelper : FirebaseHelper!
    let collectionId = "tasks"
    let localStorage = UserDefaults.standard
    var tasksDictionary = [String:Task]()
    var filteredTasks = [Task]()
    var filteredSteps = [(name:String,step:Step)]()
    
    var tasks : [Task] {
        return(
            tasksDictionary.map{
                $0.value
                }.sorted(by: { (t1, t2) -> Bool in
                    t1.steps.last!.date < t2.steps.last!.date
                })
        )

    }
    
    var allSteps : [(name:String,step:Step)] {
        var stepsArray = [(String,Step)]()
        for task in tasks{
            for step in task.steps{
                stepsArray.append((task.name,step))
            }
        }
        
        return stepsArray
    }
    
    var allStepsSorted : [(name:String,step:Step)]{
        return allSteps.sorted(by: { (tuple1, tuple2) -> Bool in
            // most recently completed steps appear first
            tuple1.step.date > tuple2.step.date
        })
  
    }
    
    
    
    
    
    
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
        
        func stepToDictionary(step:Step)->[String:Any]{
            return  ["comment":step.comment,"date":Timestamp(date: step.date)]
        }
        
        let fields = [
            "steps" : newTask.steps.map(stepToDictionary),
            "name": newTask.name,
            "count": newTask.steps.count-1,
            "lastCompletionDate":Timestamp(date:newTask.steps.last!.date)
            ] as [String : Any]
        
        
        // firebase
        firebaseHelper.createDoc(collectionId: collectionId, docId: newTask.name, fields: fields)
        // firebase fin
        
    }
    
    func deleteTask(name:String){
        tasksDictionary.removeValue(forKey: name)
        saveTasks()
        
        firebaseHelper.delete(collectionId: collectionId, docId: name)
        
    }
    
    func createStep(name:String,comment:String){
        // add a step
        let newStep = Step(comment: comment)
        tasksDictionary[name]!.steps.append(newStep)
        saveTasks()
        
        func stepToDictionary(step:Step)->[String:Any]{
            return  ["comment":step.comment,"date":Timestamp(date: step.date)]
        }
        
        let fields = ["steps": FieldValue.arrayUnion([stepToDictionary(step: newStep)]),
                     "count": FieldValue.increment(1.0),
                     "lastCompletionDate": Timestamp(date:newStep.date)
            ]as [String : Any]
        
        
        // firebase
        firebaseHelper.update(collectionId: collectionId, docId: name, fields: fields)
        
        
        // firebase end
        
       
        
        
    }
    
    func saveTasks(){
        
        
        
        
        
        let data = try! JSONEncoder().encode(tasksDictionary)
        
        // save the tasks in localStorage
        self.localStorage.set(data, forKey: "tasksDictionary")
        
        // and/or save into Tasks.json
        // let url = Bundle.main.url(forResource: "Tasks", withExtension: "json")!
        // try! data.write(to: url)
        
        saveToLocalJSON()
        
        // !! save to FIREBASE database
        
        
        
        
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
        
        firebaseHelper = FirebaseHelper()
        
      
        // if there is data already
        
        
        
        
        if let tasksDictionary = localStorage.data(forKey: "tasksDictionary"){
            self.tasksDictionary = try! JSONDecoder().decode([String:Task].self, from: tasksDictionary)
            print("loaded dictionary from localStorage with success! content: *************")
            
         
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
        
        
        // upload all data to firebase (if firebase gets corrupted
        
        //
        
        // firebase
        func uploadAllData(){
            func stepToDictionary(step:Step)->[String:Any]{
                return  ["comment":step.comment,"date":Timestamp(date: step.date)]
            }
            
            for task in tasks{
                let fields = ["steps" : task.steps.map(stepToDictionary),
                              "name": task.name,
                              "count": task.steps.count-1,
                              "lastCompletionDate":Timestamp(date:task.steps.last!.date)
                    ] as [String : Any]
                
                firebaseHelper.createDoc(collectionId: collectionId, docId: task.name, fields: fields)
                
                
            }
        }
        
        //  uploadAllData()
      
    }
    
}
