
import Foundation
import RealmSwift

extension List {
    convenience init(array: [Element]) {
        self.init()
        self.append(objectsIn: array)
    }
}
