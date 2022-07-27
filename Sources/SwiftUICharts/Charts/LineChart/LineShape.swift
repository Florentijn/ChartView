import SwiftUI

struct LineShape: Shape {
    var data: [Double]
    func path(in rect: CGRect) -> Path {
        
        let offset = computeOffset(data: data)
        
        let path = Path.quadCurvedPathWithPoints(points: data, step: CGPoint(x: 1.0, y: 1.0), globalOffset: offset)
        return path
    }
}

struct LineShape_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GeometryReader { geometry in
                LineShape(data: [0, 0.5, 0.8, 0.6, 1])
                    .transform(CGAffineTransform(scaleX: geometry.size.width / 4.0, y: geometry.size.height))
                    .stroke(Color.red)
                    .rotationEffect(.degrees(180), anchor: .center)
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
            }
            GeometryReader { geometry in
                LineShape(data: [0, -0.5, 0.8, -0.6, 1])
                    .transform(CGAffineTransform(scaleX: geometry.size.width / 4.0, y: geometry.size.height / 1.6))
                    .stroke(Color.blue)
                    .rotationEffect(.degrees(180), anchor: .center)
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
            }
        }
    }
}

func computeOffset(data: [Double]) -> Double? {
    var allTheSame = true
    data.forEach{ num in
        if num != data[0] {
            allTheSame = false
        }
    }
    
    var offset: Double? = nil
    if allTheSame {
        offset = 0.5
    }
    
    return offset
}
