//
//  FlexibleView.swift
//  My App
//
//  Created by Kailey Liou on 2/23/26.
//

import SwiftUI

struct FlexibleView<Data: Collection, Content: View>: View where Data.Element: Hashable {
    let data: Data
    let spacing: CGFloat
    let alignment: HorizontalAlignment
    let content: (Data.Element) -> Content

    @State private var totalHeight = CGFloat.zero

    init(data: Data, spacing: CGFloat = 8, alignment: HorizontalAlignment = .leading, @ViewBuilder content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.spacing = spacing
        self.alignment = alignment
        self.content = content
    }

    var body: some View {
        GeometryReader { geometry in
            self.generateContent(in: geometry)
        }
        .frame(height: totalHeight)
    }

    private func generateContent(in geometry: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        let items = Array(data)

        return ZStack(alignment: Alignment(horizontal: alignment, vertical: .top)) {
            ForEach(items, id: \.self) { item in
                content(item)
                    .padding([.horizontal, .vertical], spacing / 2)
                    .alignmentGuide(.leading) { d in
                        if (abs(width - d.width) > geometry.size.width) {
                            width = 0
                            height -= d.height + spacing
                        }
                        let result = width
                        width -= d.width + spacing
                        return result
                    }
                    .alignmentGuide(.top) { d in
                        let result = height
                        if item == items.last {
                            width = 0
                        }
                        return result
                    }
            }
        }
        .background(viewHeightReader($totalHeight))
    }

    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        GeometryReader { geo -> Color in
            DispatchQueue.main.async {
                binding.wrappedValue = geo.size.height
            }
            return Color.clear
        }
    }
}

#Preview {
    FlexibleView(data: ["Diabetes", "Hypertension", "Asthma", "Heart Disease", "Allergies"]) { item in
        Text(item)
            .padding(8)
            .background(Color.accentGreen.opacity(0.2))
            .cornerRadius(8)
    }
    .padding()
}
