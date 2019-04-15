import Foundation

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
