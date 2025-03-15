//
//  FloatingTopViewSUI.swift
//  CircusAppSwiftUI
//
//  Created by Tatyana Tepaeva on 12.03.2025.
//
import SwiftUI


struct FloatingTopViewSUI: ViewModifier {
    @State private var frame: CGRect = .zero
    @State private var isVisible = true

    var isSticking: Bool {
        frame.minY < 0
    }

    var offset: CGFloat {
        if isVisible {
            return frame.minY < 0 ? -frame.minY : 0
        } else {
            return frame.maxY < 0 ? -frame.minY - frame.height : 0
        }
    }

    func body(content: Content) -> some View {
        content
            .offset(y: offset)
            .zIndex(isSticking ? .infinity : 0)
            .overlay(GeometryReader { proxy in
                let f = proxy.frame(in: .named(floatingTopViewContainerCoordinateSpace))
                Color.clear
                    .onAppear { frame = f }
                    .onChange(of: f) {
                        let prevFrame = frame
                        let change = { isVisible = prevFrame.minY < frame.minY }
                        frame = $0

                        withAnimation { change() }
                    }
            })
    }
}

public extension View {
    func floatingTopView() -> some View {
        modifier(FloatingTopViewSUI())
    }

    func floatingTopViewContainer() -> some View {
        coordinateSpace(name: floatingTopViewContainerCoordinateSpace)
    }
}

private let floatingTopViewContainerCoordinateSpace = "floatingTopViewContainerCoordinateSpace"

struct ContentView_Previews: PreviewProvider {
    @ViewBuilder static var contents: some View {
        Image(systemName: "globe")
            .imageScale(.large)
            .foregroundColor(.accentColor)
            .padding()

        Text("Floating Top View")
            .font(.title)
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .floatingTopView()

        ForEach(0 ..< 50) { _ in
            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce ut turpis tempor, porta diam ut, iaculis leo. Phasellus condimentum euismod enim fringilla vulputate. Suspendisse sed quam mattis, suscipit ipsum vel, volutpat quam. Donec sagittis felis nec nulla viverra, et interdum enim sagittis. Nunc egestas scelerisque enim ac feugiat. ")
                .padding()
        }
    }

    static var previews: some View {
        ScrollView {
            contents
        }
        .border(Color.green, width: 1)
        .floatingTopViewContainer()
    }
}
