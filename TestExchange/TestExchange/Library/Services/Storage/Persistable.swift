//
//  Persistable.swift
//  TestExchange
//
//  Created by Nikolai Lipski on 20.06.25.
//

import CoreData

protocol Persistable {
    associatedtype DBType: NSManagedObject
    static var entityName: String { get }

    func createDB(in context: NSManagedObjectContext) -> DBType
    static func from(_ model: DBType) throws -> Self
}

extension Persistable {
    func createPersistanceObject(_ context: NSManagedObjectContext, entityName: String) -> DBType {
        guard let entity = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as? DBType else {
            fatalError("Can't find model \(DBType.self)")
        }
        return entity
    }
}
