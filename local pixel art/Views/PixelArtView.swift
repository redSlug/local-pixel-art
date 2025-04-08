import SwiftUI

struct PixelArtView: View {
    @Binding var pixelArt: PixelArt
    @State private var selectedColor: PixelColor = .black
    @State private var isDrawing = false
    
    private let gridSize: CGFloat = 16
    private let cellSize: CGFloat = 20
    
    private func swiftUIColor(from pixelColor: PixelColor) -> SwiftUI.Color {
        SwiftUI.Color(
            red: pixelColor.red,
            green: pixelColor.green,
            blue: pixelColor.blue,
            opacity: pixelColor.alpha
        )
    }
    
    var body: some View {
        VStack {
            HStack {
                ColorPicker("", selection: Binding(
                    get: { swiftUIColor(from: selectedColor) },
                    set: { newColor in
                        var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) = (0, 0, 0, 0)
                        UIColor(newColor).getRed(&components.red, green: &components.green, blue: &components.blue, alpha: &components.alpha)
                        selectedColor = PixelColor(
                            red: components.red,
                            green: components.green,
                            blue: components.blue,
                            alpha: components.alpha
                        )
                    }
                ))
                .labelsHidden()
                .frame(width: 44, height: 44)
                
                Spacer()
                
                Button(action: {
                    pixelArt = PixelArt()
                }) {
                    Image(systemName: "trash")
                        .font(.title2)
                }
            }
            .padding()
            
            Canvas { context, size in
                let cellWidth = size.width / gridSize
                let cellHeight = size.height / gridSize
                
                for y in 0..<Int(gridSize) {
                    for x in 0..<Int(gridSize) {
                        let color = pixelArt.getPixel(x: x, y: y)
                        let rect = CGRect(
                            x: CGFloat(x) * cellWidth,
                            y: CGFloat(y) * cellHeight,
                            width: cellWidth,
                            height: cellHeight
                        )
                        
                        context.fill(
                            Path(rect),
                            with: .color(swiftUIColor(from: color))
                        )
                    }
                }
            }
            .frame(width: gridSize * cellSize, height: gridSize * cellSize)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let cellWidth = gridSize * cellSize / gridSize
                        let cellHeight = gridSize * cellSize / gridSize
                        let x = Int(value.location.x / cellWidth)
                        let y = Int(value.location.y / cellHeight)
                        
                        if x >= 0 && x < Int(gridSize) && y >= 0 && y < Int(gridSize) {
                            pixelArt.setPixel(x: x, y: y, color: selectedColor)
                        }
                    }
            )
        }
    }
} 