import Foundation
import Firebase

class FirebaseHelper{
    var db : Firestore!
    
    
    
    
  

    
    
    func createDoc(collectionId:String,docId:String,fields:[String:Any]){
        
        db.collection(collectionId).document(docId).setData(fields) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    
    
    
    
    
    func update(collectionId:String,docId:String,fields:[String:Any]){
        
        db.collection(collectionId).document(docId).updateData(fields) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
        
        
        
    }
    
    
    
    func delete(collectionId:String,docId:String){
            
            db.collection(collectionId).document(docId).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                }
            }
    }
   
    
    init() {
        
        FirebaseApp.configure()
        db = Firestore.firestore()
    }
    
    
    
    
    
    
    
}
