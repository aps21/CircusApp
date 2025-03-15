import SwiftUI

struct FebHard1Animation: View {
    struct ViewData {
        let text: String
        let didTap: (() -> Void)?
    }

    init(data: ViewData) {
        self.data = data
    }

    struct ButtonNoAnimationStyle: ButtonStyle {
        func makeBody(configuration: Self.Configuration) -> some View {
            configuration.label
                .animation(nil, value: configuration.isPressed)
                .opacity(configuration.isPressed ? 0.5 : 1)
        }
    }

    var body: some View {
        Button {
            data.didTap?()
        } label: {
            ZStack {
                HStack(spacing: spacing) {
                    ForEach(0 ..< count, id: \.self) { _ in
                        Text(data.text)
                            .font(.title3)
                            .foregroundColor(.white)
                            .lineLimit(1)
                            .frame(height: 20)
                    }
                }
                .frame(width: allTextWidth, alignment: .leading)
            }
            .offset(x: initialOffset)
            .offset(x: -animationOffset)
            .frame(maxWidth: .infinity)
            .background(.black)
        }
        .buttonStyle(ButtonNoAnimationStyle())
            .background {
                GeometryReader { parentProxy in
                    Text(data.text)
                        .font(.title3)
                        .fixedSize()
                        .background {
                            GeometryReader { proxy in
                                Color.clear
                                    .onAppear {
                                        let viewWidth = parentProxy.size.width
                                        let textWidth = proxy.size.width + spacing
                                        let duration = textWidth / viewWidth * 5

                                        count = Int((viewWidth / textWidth).rounded(.down)) + 2
                                        allTextWidth = CGFloat(count) * textWidth - spacing
                                        initialOffset = (allTextWidth - viewWidth + spacing) / 2

                                        DispatchQueue.main.async {
                                            withAnimation(.linear(duration: duration).repeatForever(autoreverses: false)) {
                                                animationOffset = textWidth
                                            }
                                        }
                                    }
                            }
                        }
                        .hidden()
                }
            }
//        .disabled(data.didTap == nil)
    }

    private let viewHeight: CGFloat = 20
    private let spacing: CGFloat = 14
    private let data: ViewData

    @State private var initialOffset: CGFloat = 0
    @State private var animationOffset: CGFloat = 0
    @State private var viewWidth: CGFloat = 0
    @State private var textWidth: CGFloat = 0
    @State private var allTextWidth: CGFloat = 0
    @State private var count: Int = 2
    @State private var duration: Double = 10
}

#Preview {
    VStack {
        FebHard1Animation(data: .init(
            text: "ТОЛЬКО   ТОЛЬКО   ТОЛЬКО   ТОЛЬКО   ТОЛЬКО   ТОЛЬКО   ТОЛЬКО   ТОЛЬКО   ТОЛЬКО",
            didTap: nil
        ))

        FebHard1Animation(data: .init(
            text: "ТОЛЬКО",
            didTap: nil
        ))

        FebHard1Animation(data: .init(
            text: "ТОЛЬКО   ТОЛЬКО   ТОЛЬКО   ТОЛЬКО   ТОЛЬКО   ТОЛЬКО   ТОЛЬКО   ТОЛЬКО   ТОЛЬКО",
            didTap: nil
        ))

        FebHard1Animation(data: .init(
            text: "ТОЛЬКО",
            didTap: nil
        ))
        FebHard1Animation(data: .init(
            text: "ТОЛЬКО   ТОЛЬКО   ТОЛЬКО   ТОЛЬКО   ТОЛЬКО   ТОЛЬКО   ТОЛЬКО   ТОЛЬКО   ТОЛЬКО",
            didTap: nil
        ))

        FebHard1Animation(data: .init(
            text: "ТОЛЬКО",
            didTap: nil
        ))
        FebHard1Animation(data: .init(
            text: "ТОЛЬКО   ТОЛЬКО   ТОЛЬКО   ТОЛЬКО   ТОЛЬКО   ТОЛЬКО   ТОЛЬКО   ТОЛЬКО   ТОЛЬКО",
            didTap: nil
        ))

        FebHard1Animation(data: .init(
            text: "ТОЛЬКО",
            didTap: nil
        ))
    }
}
