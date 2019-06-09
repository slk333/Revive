import Foundation
import Firebase

class FirebaseHelper{
    var db : Firestore!
    
    
    
    
    
    func getAll(){
        db.collection("tasks").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                for document in querySnapshot!.documents {
                    // document.data()
                    // document.documentID
                    
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
        
    }
    
    
    func getDocument(documentName:String){
        let docRef = db.collection("tasks").document(documentName)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
            } else {print("Document does not exist")
                
            }
            
        }
        
    }
    
    
    
    
    
    
    
    
    
    
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
