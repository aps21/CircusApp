import SwiftUI

struct FebMedium: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                Color.gray
                    .aspectRatio(aspectRatio, contentMode: .fill)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .background {
                        GeometryReader { proxy in
                            Color.clear
                                .onAppear {
                                    contentWidth = proxy.size.width
                                }
                        }
                    }
                    .overlay(alignment: .bottom) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(colors.indices, id: \.self) { index in
                                    colors[index]
                                        .frame(
                                            width: contentWidth * itemAspectWidth,
                                            height: contentWidth / itemAspectHeight
                                        )
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                            }
                            .padding(.horizontal, 12)
                            .padding(.bottom, 12)
                        }
                        .fixedSize(horizontal: false, vertical: true)
                    }

                Color.gray
                    .aspectRatio(aspectRatio, contentMode: .fill)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .background {
                        GeometryReader { proxy in
                            Color.clear
                                .onAppear {
                                    contentWidth = proxy.size.width
                                }
                        }
                    }
                    .overlay(alignment: .bottom) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(colors.indices, id: \.self) { index in
                                    colors[index]
                                        .frame(
                                            width: contentWidth * itemAspectWidth,
                                            height: contentWidth / itemAspectHeight
                                        )
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                            }
                            .padding(.horizontal, 12)
                            .padding(.bottom, 12)
                        }
                        .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.horizontal, 12)
            }
        }
    }

    @State private var contentWidth: CGFloat = 0
    private let aspectRatio: CGFloat = 369 / 472
    private let itemAspectHeight: CGFloat = 393 / 91
    private let itemAspectWidth: CGFloat = 294 / 393
    private var colors = [
        Color.red,
        .green
    ]
}

#Preview {
    FebMedium()
}
