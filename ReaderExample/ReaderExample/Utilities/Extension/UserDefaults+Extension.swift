//
//  UserDefaults+Extension.swift
//  ReaderExample
//
//  Created by sun on 2021/12/27.
//

import Foundation

extension UserDefaults {
    func saveCustomObject(customObject object: NSSecureCoding, forkey key: String) {
        if #available(iOS 13, *) {
            let encodedObject = try! NSKeyedArchiver.archivedData(withRootObject: object, requiringSecureCoding: true)
            set(encodedObject, forKey: key)
        } else {
            let encodedObject = NSKeyedArchiver.archivedData(withRootObject: object)
            set(encodedObject, forKey: key)
        }
    }
    func getCustomObject<T>(forkey key: String, classType: T.Type) -> AnyObject? where T: NSObject, T: NSSecureCoding {
        let decodedObject = object(forKey: key) as? Data
        if let decoded = decodedObject {
            if #available(iOS 13, *) {
                let object = try? NSKeyedUnarchiver.unarchivedObject(ofClass: classType, from: decoded)
                return object as AnyObject
            } else {
                let object = NSKeyedUnarchiver.unarchiveObject(with: decoded)
                return object as AnyObject
            }
        }
        return nil
    }
}
