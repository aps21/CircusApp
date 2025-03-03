import SwiftUI

struct FebEasy: View {
    var body: some View {
        VStack {
            HStack {
                Image(.Feb.star)
                    .background {
                        GeometryReader { proxy in
                            Color.clear
                                .onAppear {
                                    vImageHeight = proxy.size.height
                                }
                        }
                    }
                    .overlay(alignment: .bottom) {
                        Color.red
                            .frame(height: vImageHeight * percent, alignment: .bottom)
                            .mask(alignment: .bottom) {
                                Image(.Feb.star)
                            }
                    }

                Image(.Feb.star)
                    .background {
                        GeometryReader { proxy in
                            Color.clear
                                .onAppear {
                                    hImageWidth = proxy.size.width
                                }
                        }
                    }
                    .overlay(alignment: .leading) {
                        Color.red
                            .frame(width: vImageHeight * percent, alignment: .leading)
                            .mask(alignment: .leading) {
                                Image(.Feb.star)
                            }
                    }
            }

            Slider(value: $percent)

            Text(formatter.string(from: NSNumber(value: percent)) ?? "")
        }
        .padding()
    }

    @State private var percent: CGFloat = 0
    @State private var hImageWidth: CGFloat = 0
    @State private var vImageHeight: CGFloat = 0

    private let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        return formatter
    }()
}

#Preview {
    FebEasy()
}
