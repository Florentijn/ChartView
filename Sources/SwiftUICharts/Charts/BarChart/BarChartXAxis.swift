//
//  SwiftUIView.swift
//  
//
//  Created by Florentijn Hogerwerf on 06/01/2022.
//

import SwiftUI



/// A single row of data, a view in a `BarChart`
public struct BarChartXAxis: View {
    
    @EnvironmentObject var chartData: ChartData
    var formatter: (String) -> String
    
    var axisTitles: [String] {
        
        let nrOfRecordsPerlabel = max(chartData.values.count / 12, 1)
        
        var i = 1
        return chartData.values.map { item in
            if (i < nrOfRecordsPerlabel) {
                i = i + 1
                return ""
            } else {
                i = 1
                return item
            }
        }
    }

    /// The content and behavior of the `BarChartRow`.
    ///
    /// Shows each `BarChartCell` in an `HStack`; may be scaled up if it's the one currently being touched.
    /// Not using a drawing group for optimizing animation.
    /// As touched (dragged) the `touchLocation` is updated and the current value is highlighted.
    public var body: some View {
        
        GeometryReader { geometry in
            HStack(
                alignment: .bottom,
                spacing: geometry.frame(in: .local).width / CGFloat(chartData.data.count * 3)) {
                    ForEach(0..<chartData.data.count, id: \.self) { index in
                        VerticalText(text: formatter(axisTitles[index]))
                    }
            }
                .frame(minHeight: 40)
        }
    }
    
    public init(
        formatter: @escaping ((String) -> String) = { key in key }
    ) {
        self.formatter = formatter
    }
}


struct VerticalText: View {
    
    let text: String
    
    var body: some View {
        
        Text(text)
            
            .font(.system(size: 9.0, weight: .regular))
            .padding(0)
            .lineLimit(1)
            .rotationEffect(.degrees(-70), anchor: .center)
            .fixedSize()
            .frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity
            )
            //.frame(alignment: .trailing)
            //.background(Color.yellow)
    }
}

//struct BarChartRow_Previews: PreviewProvider {
//    static let chartData = ChartData([6, 2, 5, 8, 6])
//    static let chartStyle = ChartStyle(backgroundColor: .white, foregroundColor: .orangeBright)
//    static var previews: some View {
//        BarChartRow(chartData: chartData, style: chartStyle)
//    }
//}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        VerticalText(text: "2021-03-06")
            .frame(width: 30, height: 80)
    }
}


//struct SwiftUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        BarChartXAxis()
//    }
//}
