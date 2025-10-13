//
//  RealmHabitPersistence.swift
//  HabitFlow
//
//  Created by Daria Zakharova on 29.07.2025.
//

import Foundation
import RealmSwift

class RealmHabitPersistence: HabitPersistence {
    
    private let realm = try! Realm()
    
    /// Saves habits to Realm asynchronously to avoid blocking the main thread
    func save(_ habits: [Habit]) {
        let realmHabits = habits.map { RealmHabit.from($0) }
        DispatchQueue.global(qos: .background).async {
            autoreleasepool {
                do {
                    let realm = try Realm()
                    try realm.write {
                        // Efficiently insert or update habits by primary key
                        realm.add(realmHabits, update: .modified)
                    }
                } catch {
                    print("❌ Failed to save habits to Realm: \(error)")
                }
            }
        }
    }
    
    func delete(_ habit: Habit) {
        do {
            let realm = try Realm()
            if let objectToDelete = realm.object(ofType: RealmHabit.self, forPrimaryKey: habit.id) {
                try realm.write {
                    realm.delete(objectToDelete)
                }
            }
        } catch {
            print("❌ Failed to delete habit from Realm: \(error)")
        }
    }
    
    // MARK: - Load
    func load() -> [Habit] {
        let realmHabits = realm.objects(RealmHabit.self)
        return realmHabits.map { $0.toHabit() }
    }
}
