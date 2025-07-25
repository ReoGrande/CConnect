//
//  UserModel.swift
//  CConnect
//
//  Created by Reo Ogundare on 7/20/25.
//

import Foundation
import SwiftUI
import FirebaseDatabase

struct User: Equatable, Hashable, Codable {
    var id: UUID
    var firstName: String = ""
    var lastName: String = ""
    var attendanceHistory: [UUID] = []

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case firstName = "firstName"
        case lastName = "lastName"
        case attendanceHistory = "attendanceHistory"
    }

    init() {
        self.id = UUID()
    }

    init(id: UUID = UUID(),first: String, last: String, history: [UUID] = []) {
        self.id = id
        self.firstName = first
        self.lastName = last
        self.attendanceHistory = history
        
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.firstName = try container.decode(String.self, forKey: .firstName)
        self.lastName = try container.decode(String.self, forKey: .lastName)
        self.attendanceHistory = try container.decode([UUID].self, forKey: .attendanceHistory)
    }

     func getFullName() -> String {
         if !self.firstName.isEmpty && !self.lastName.isEmpty {
             return "\(self.firstName) \(self.lastName)"
         }
         return ""
    }

    func isSignedin() -> Bool {
        !self.getFullName().isEmpty
    }
}

class UserModel: ObservableObject {
    @Published private(set) var user: User = User() {
        didSet {
            do {
                try encodeToLocal()
            } catch {
                print("Failed to encode user to local")
            }
        }
    }
    
    private var userName: String? {
        user.getFullName()
    }

    var ref: DatabaseReference?
    var _refHandle: DatabaseHandle?

    static let shared = UserModel()
    private init() {} // Prevent creating multiple instances

    deinit {
        if let handle = _refHandle, let r = ref {
            r.child("posts").removeObserver(withHandle: handle)
            print("Observer removed for most recent posts.")
        }
    }

    func setUserName(first: String, last: String) {
        self.user.firstName = first
        self.user.lastName = last
    }

    func addEventToAttendance(_ event: Event) {
        if !self.user.attendanceHistory.contains(event.id) {
            self.user.attendanceHistory.append(event.id)
        }
    }

    func removeEventFromAttendance(_ event: Event) {
        if let index = self.user.attendanceHistory.firstIndex(of: event.id) {
            self.user.attendanceHistory.remove(at: index)
        }
    }
}
// MARK: Local Encoding/Decoding
extension UserModel {
    func encodeToLocal() throws {
        let jsonEncoder = JSONEncoder()
        let userJson = try jsonEncoder.encode(user)

        let url = URL.documentsDirectory.appending(path: "User.txt")
        
        do {
            try userJson.write(to: url, options: [.atomic, .completeFileProtection])

        } catch {
            print(error.localizedDescription)
        }
    }
    
    func decodeFromLocal() async {
        let url = URL.documentsDirectory.appending(path: "User.txt")
        let decoder = JSONDecoder()
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let userData = try decoder.decode(User.self, from: data)
            
            DispatchQueue.main.async {
                self.user = userData
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

// MARK: Remote Encoding/Decoding
extension UserModel {

    func encodeAndSendToDatabase() {
        let jsonEncoder = JSONEncoder()
            do {
                let getUserJson = try jsonEncoder.encode(user) // 'user' is the object you want to save/update
                guard let bookJsonString = String(data: getUserJson, encoding: .utf8) else {
                    print("JSON Failed to convert to user string")
                    return
                }
                
                // Ensure you have a reference to your Firebase Database instance
                // Assuming 'ref' is already defined and points to your root Firebase Realtime Database reference
                // e.g., var ref: DatabaseReference!
                //       ref = Database.database().reference()
                guard let databaseRootRef = ref else {
                    print("Firebase Database reference is not initialized.")
                    return
                }
                
                // 1. Specify the base path for your users
                let usersRef = databaseRootRef.child("cconnect_users")
                
                // 2. IMPORTANT: Get the unique ID of the user you want to modify.
                //    I'm assuming your 'user' object has an 'id' property (e.g., a String)
                //    that matches the key used in the database.
                //    For example, if your User struct looked like:
                //    struct User: Codable {
                //        let id: String // This is the key in the database
                //        let first: String
                //        let last: String
                //    }
                //    Then you would use user.id here.
                let userIdToUpdate = user.id
                
                // 3. Construct the DatabaseReference to the SPECIFIC user entry
                //    Instead of childByAutoId(), we use the known userIdToUpdate
                let specificUserRef = usersRef.child(userIdToUpdate.uuidString)
                
                // 4. Set the value! This will OVERWRITE any existing data at this specific path.
                //    Since bookJsonString represents the entire user object, setValue() is appropriate.
                specificUserRef.setValue(bookJsonString) { (error, ref) in
                    if let error = error {
                        print("User Data could not be updated: \(error.localizedDescription)")
                    } else {
                        print("User Data updated successfully at \(ref.url)!")
                    }
                }
            }
            catch {
                print("Error parsing JSON for user response: \(error.localizedDescription)")
            }
        
//        let jsonEncoder = JSONEncoder()
//        do {
//            let getUserJson = try jsonEncoder.encode(user)
//            guard let bookJsonString = String(data: getUserJson, encoding: .utf8), let ref = ref else {
//                print("JSON Failed to convert to user string")
//                return
//            }
//            
//            // 2. Specify where in your database tree you want to send data
//            // For example, if you want to store it under a "my_items" node
//            let itemsRef = ref.child("cconnect_users")
//            
//            // 3. To add a new, unique item every time, use childByAutoId()
//            // This generates a unique key (like a timestamp-based ID)
//            let newItemRef = itemsRef.childByAutoId()
//            
//            // 4. Set the value! You can pass dictionaries, arrays, strings, numbers, booleans, etc.
//            newItemRef.setValue(bookJsonString) { (error, ref) in
//                if let error = error {
//                    print("User Data could not be saved: \(error.localizedDescription)")
//                } else {
//                    print("User Data saved successfully!")
//                }
//            }
//        }
//        catch {
//            print("Error parsing JSON for user response")
//        }
    }
    
    // Not used currently, needs to store data on remote for all users for later monitoring by admin & dev
    // TODO: DEBUG #000000 TO WHITE WHEN RETRIEVING FROM DATABASE
    func requestAndDecodeFromDatabase(limit: UInt = 1, completion: @escaping (User?) -> Void) { // Default to 100 most recent posts
        guard let ref = ref else { return }
            let decoder = JSONDecoder()
            let postsRef = ref.child("cconnect_users")// Still assuming your posts are under a "posts" node
        var getUser = User()
            
            // 1. Create a query to get only the very last post
            //    (Because push() keys are chronological, 'last' means 'most recent')
            let lastPostQuery = postsRef.queryLimited(toLast: 1)
            
            // 2. Use observeSingleEvent(of: .value) to get the data exactly once.
            lastPostQuery.observeSingleEvent(of: .value, with: { (snapshot) in
                // This 'snapshot' will contain the single last post if one exists,
                // or it will be empty if there are no posts.
                
                if snapshot.exists() {
                    // Since we queried for queryLimited(toLast: 1), this snapshot
                    // will contain one child. We need to iterate its children.
                    for child in snapshot.children {
                        if let childSnapshot = child as? DataSnapshot {
                            do {
                                guard
                                    let postD = childSnapshot.value as? String,
                                    let postObj = postD.data(using: .utf8)
                                else {
                                    print("Error converting Snapshot into User")
                                    return
                                }
                                
                                getUser = try decoder.decode(User.self, from: postObj)
                                completion(getUser)
                            } catch {
                                print("no")
                            }
                        }
                    }
                } else {
                    print("No posts found in the user database.")
                }
                
            }) { (error) in
                print("Error fetching last user post: \(error.localizedDescription)")
            }
    }
}

extension UserModel: Sendable {
    
}
