
extension String {
    var containsEmoji: Bool {
        return unicodeScalars.contains { $0.properties.isEmoji }
    }   
}