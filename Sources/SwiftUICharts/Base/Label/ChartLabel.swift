import SwiftUI

/// What kind of label - this affects color, size, position of the label
public enum ChartLabelType {
    case title
    case subTitle
    case largeTitle
    case custom(size: CGFloat, padding: EdgeInsets, color: Color)
    case legend
}

/// A chart may contain any number of labels in pre-set positions based on their `ChartLabelType`
public struct ChartLabel: View {
    @EnvironmentObject var chartValue: ChartValue
    @State var keyTextToDisplay: String = ""
    @State var valueTextToDisplay: String = ""
    var format: String = "%.01f"
    var keyFormatter: (String) -> String
    var alwaysShowChartValue: Bool = true

    private var title: String

	/// Label font size
	/// - Returns: the font size of the label
    private var labelSize: CGFloat {
        switch labelType {
        case .title:
            return 32.0
        case .legend:
            return 14.0
        case .subTitle:
            return 24.0
        case .largeTitle:
            return 38.0
        case .custom(let size, _, _):
            return size
        }
    }

	/// Padding around label
	/// - Returns: the edge padding to use based on position of the label
    private var labelPadding: EdgeInsets {
        switch labelType {
        case .title:
            return EdgeInsets(top: 16.0, leading: 8.0, bottom: 0.0, trailing: 8.0)
        case .legend:
            return EdgeInsets(top: 4.0, leading: 8.0, bottom: 0.0, trailing: 8.0)
        case .subTitle:
            return EdgeInsets(top: 8.0, leading: 8.0, bottom: 0.0, trailing: 8.0)
        case .largeTitle:
            return EdgeInsets(top: 24.0, leading: 8.0, bottom: 0.0, trailing: 8.0)
        case .custom(_, let padding, _):
            return padding
        }
    }

	/// Which type (color, size, position) for label
    private let labelType: ChartLabelType

	/// Foreground color for this label
	/// - Returns: Color of label based on its `ChartLabelType`
    private var labelColor: Color {
        switch labelType {
        case .title:
            return Color(UIColor.label)
        case .legend:
            return Color(UIColor.secondaryLabel)
        case .subTitle:
            return Color(UIColor.label)
        case .largeTitle:
            return Color(UIColor.label)
        case .custom(_, _, let color):
            return color
        }
    }

	/// Initialize
	/// - Parameters:
	///   - title: Any `String`
	///   - type: Which `ChartLabelType` to use
    public init (
         _ title: String,
         type: ChartLabelType = .title,
         format: String = "%.01f",
         keyFormatter: @escaping ((String) -> String) = { key in key },
         alwaysShowChartValue: Bool = true
    ) {
        self.title = title
        labelType = type
        self.format = format
        self.keyFormatter = keyFormatter
        self.alwaysShowChartValue = alwaysShowChartValue
    }

	/// The content and behavior of the `ChartLabel`.
	///
	/// Displays current value if chart is currently being touched along a data point, otherwise the specified text.
    public var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(valueTextToDisplay)
                    .font(.system(size: labelSize))
                    .bold()
                    .foregroundColor(self.labelColor)
                    .padding(self.labelPadding)
                    .onAppear {
                        self.valueTextToDisplay = self.title
                    }
                    .onReceive(self.chartValue.objectWillChange) { _ in
                        if (alwaysShowChartValue) {
                            self.valueTextToDisplay = String(format: format, self.chartValue.currentValue)
                        } else {
                            self.valueTextToDisplay = self.chartValue.interactionInProgress ? String(format: format, self.chartValue.currentValue) : self.title
                        }
                        
                    }
                Text(keyTextToDisplay)
                    .font(.system(size: 14.0))
                    .bold()
                    .foregroundColor(.gray)
                    .padding(self.labelPadding)
                    .onAppear {
                        self.keyTextToDisplay = ""
                    }
                    .onReceive(self.chartValue.objectWillChange) { _ in
                        if (alwaysShowChartValue) {
                            self.keyTextToDisplay = keyFormatter(self.chartValue.currentKey)
                        } else {
                            self.keyTextToDisplay = self.chartValue.interactionInProgress ? keyFormatter(self.chartValue.currentKey) : ""
                        }
                    }
            }
            
            if !self.chartValue.interactionInProgress {
                Spacer()
            }
        }
        .frame(height: 50)
    }
}
