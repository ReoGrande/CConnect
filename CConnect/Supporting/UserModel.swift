//
//  UserModel.swift
//  CConnect
//
//  Created by Reo Ogundare on 7/20/25.
//

import Foundation

struct User: Equatable, Hashable, Codable {
    var id: UUID
    var firstName: String = ""
    var lastName: String = ""
    var attendanceHistory: [Event] = []

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case firstName = "firstName"
        case lastName = "lastName"
        case attendanceHistory = "attendanceHistory"
    }

    init() {
        self.id = UUID()
    }

    init(id: UUID = UUID(),first: String, last: String, history: [Event] = []) {
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
        self.attendanceHistory = try container.decode([Event].self, forKey: .attendanceHistory)
    }

     func getFullName() -> String {
        return "\(self.firstName) \(self.lastName)"
    }
}

class UserModel: ObservableObject {
    private(set) var user: User = User()
    
    private var userName: String? {
        user.getFullName()
    }

    private init() {} // Prevent creating multiple instances

    func setUserName(first: String, last: String) {
        self.user.firstName = first
        self.user.lastName = last
    }

    func addEventToAttendance(_ event: Event) {
        if !self.user.attendanceHistory.contains(event) {
            self.user.attendanceHistory.append(event)
        }
    }

    func removeEventFromAttendance(_ event: Event) {
        if let index = self.user.attendanceHistory.firstIndex(of: event) {
            self.user.attendanceHistory.remove(at: index)
        }
    }
}
