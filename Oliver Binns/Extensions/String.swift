import Foundation

extension String {
    var isValidURL: Bool {
        let regEx = "((?:http|https)://)?(?:www\\.)?[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?"
        let predicate = NSPredicate(format: "SELF MATCHES %@", argumentArray: [regEx])
        return predicate.evaluate(with: self)
    }

    func removePrefix(_ prefix: String) -> String? {
        guard hasPrefix(prefix) else { return nil }
        return String(suffix(from: index(startIndex, offsetBy: prefix.count)))
    }
}
