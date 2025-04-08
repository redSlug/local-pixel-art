import Foundation

struct PixelArt: Codable, Identifiable, Equatable {
    let id: UUID
    var pixels: [[PixelColor]]
    
    init() {
        self.id = UUID()
        self.pixels = Array(repeating: Array(repeating: .white, count: 16), count: 16)
    }
    
    mutating func setPixel(x: Int, y: Int, color: PixelColor) {
        guard x >= 0 && x < 16 && y >= 0 && y < 16 else { return }
        pixels[y][x] = color
    }
    
    func getPixel(x: Int, y: Int) -> PixelColor {
        guard x >= 0 && x < 16 && y >= 0 && y < 16 else { return .white }
        return pixels[y][x]
    }
}

struct PixelColor: Codable, Equatable {
    var red: Double
    var green: Double
    var blue: Double
    var alpha: Double
    
    static let white = PixelColor(red: 1, green: 1, blue: 1, alpha: 1)
    static let black = PixelColor(red: 0, green: 0, blue: 0, alpha: 1)
} 