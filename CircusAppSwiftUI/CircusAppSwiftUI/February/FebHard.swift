import SwiftUI

struct FebHard: View {
    var body: some View {
        ScrollView {
            FebHardTimer()

            FebHardAnimation()
            FebHardAnimation(itemWidth: 16)
            FebHardAnimation(itemWidth: 16, duration: 4)
            FebHardAnimation(itemWidth: 16, offset: 20, duration: 4)
        }
    }
}

struct FebHardAnimation: View {
    private let itemWidth: CGFloat
    private let offset: CGFloat
    private var duration: Double

    init(itemWidth: CGFloat = 32, offset: CGFloat = 50, duration: Double = 1) {
        self.itemWidth = itemWidth
        self.offset = offset
        self.duration = duration
    }

    var body: some View {
        let width: CGFloat = 200
        let height: CGFloat = 50
        let count = Int((width / itemWidth).rounded(.down) + 2 * (offset / itemWidth).rounded(.up))
        let frame = CGRect(
            x: 0,
            y: 0,
            width: itemWidth + offset,
            height: height
        )

        ZStack {
            HStack(spacing: 0) {
                ForEach(0..<count, id: \.self) { index in
                    Path { path in
                        path.move(to: CGPoint(x: frame.minX + offset, y: frame.minY))
                        path.addLine(to: CGPoint(x: frame.maxX, y: frame.minY))
                        path.addLine(to: CGPoint(x: frame.maxX - offset, y: frame.maxY))
                        path.addLine(to: CGPoint(x: frame.minX, y: frame.maxY))
                        path.closeSubpath()
                    }
                    .fill(index % 2 == 0 ? .yellow : .black)
                }
            }
            .frame(width: CGFloat(count) * itemWidth, height: height)
        }
        .offset(x: -itemWidth * 2)
        .offset(x: animationOffset)
        .frame(width: width, height: height)
        .clipped()
        .onAppear {
            withAnimation(.linear(duration: duration).repeatForever(autoreverses: false)) {
                animationOffset = itemWidth * 2
            }
        }
    }

    @State private var animationOffset: CGFloat = 0
}

struct FebHardTimer: View {
    init() {
        timerFinishDate = Date.now.addingTimeInterval(timerDefault)
        _timerCellDate = .init(initialValue: Date(timeIntervalSince1970: timerDefault))
        _timerCellPrevDate = .init(initialValue: Date(timeIntervalSince1970: timerDefault))
    }

    //    Прикольная, но бесполезная именно тут штука
    //    .contentTransition(.numericText())
    var body: some View {
        HStack(spacing: 3) {
            TimerLabel(
                showMain: $showMain,
                showAdditional: $showAdditional,
                timerCellPrevDate: $timerCellPrevDate,
                timerCellDate: timerCellDate,
                text: { formatted(unit: hours(timer: $0)) }
            )

            Text(":")

            TimerLabel(
                showMain: $showMain,
                showAdditional: $showAdditional,
                timerCellPrevDate: $timerCellPrevDate,
                timerCellDate: timerCellDate,
                text: { formatted(unit: minutes(timer: $0)) }
            )

            Text(":")

            TimerLabel(
                showMain: $showMain,
                showAdditional: $showAdditional,
                timerCellPrevDate: $timerCellPrevDate,
                timerCellDate: timerCellDate,
                text: { formatted(unit: second(timer: $0)) }
            )
        }
        .frame(height: 50)
        .onAppear {
            tick()
        }
        .onDisappear {
            currentTask?.cancel()
        }
    }

    private struct TimerLabel: View {
        @Binding var showMain: Bool
        @Binding var showAdditional: Bool
        @Binding var timerCellPrevDate: Date
        var timerCellDate: Date
        var text: (Date) -> String

        var body: some View {
            ZStack {
                let prevDate = text(timerCellDate)
                let date = text(timerCellPrevDate)
                if showMain || date == prevDate {
                    Text(date)
                        .font(Font.title3.monospacedDigit())
                        .frame(maxHeight: .infinity)
                        .transition(
                            .asymmetric(
                                insertion: .identity,
                                removal: .move(edge: .top)
                            )
                        )
                }

                if showAdditional, date != prevDate {
                    Text(prevDate)
                        .font(Font.title3.monospacedDigit())
                        .transition(
                            .asymmetric(
                                insertion: .move(edge: .bottom),
                                removal: .identity
                            )
                        )
                        .task {
                            try? await Task.sleep(for: .seconds(0.5))
                            showMain = true
                            timerCellPrevDate = timerCellDate
                            withAnimation {
                                showAdditional = false
                            }
                        }
                }
            }
            .frame(maxHeight: .infinity)
            .padding(.horizontal, 6)
            .background {
                Color.gray
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .clipped()
        }
    }

    private let timerDefault: Double = 8 * 60 * 60 + 0 * 60 + 5
    private let timerFinishDate: Date
    @State private var currentTask: Task<Void, Never>?
    @State private var timerCellPrevDate: Date
    @State private var timerCellDate: Date
    @State private var showMain = true
    @State private var showAdditional = false

    private var calendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        return calendar
    }()

    private func tick() {
        currentTask = Task {
            try? await Task.sleep(for: .seconds(1))
            let date = timerFinishDate.addingTimeInterval(-Date.now.timeIntervalSince1970)
            if date.timeIntervalSince1970 < 0 {
                currentTask?.cancel()
                return
            }
            guard !Task.isCancelled else { return }
            timerCellDate = date
            withAnimation {
                showMain = false
                showAdditional = true
            }
            tick()
        }
    }

    private func formatted(unit: Int) -> String {
        String(format: "%02d", unit)
    }

    private func hours(timer: Date) -> Int {
        let components = calendar.dateComponents(
            [.hour],
            from: timer
        )
        return components.hour ?? 0
    }

    private func minutes(timer: Date) -> Int {
        let components = calendar.dateComponents(
            [.minute],
            from: timer
        )
        return components.minute ?? 0
    }

    private func second(timer: Date) -> Int {
        let components = calendar.dateComponents(
            [.second],
            from: timer
        )
        return components.second ?? 0
    }
}

#Preview {
    FebHard()
}
