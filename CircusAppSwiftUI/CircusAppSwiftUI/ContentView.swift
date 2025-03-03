//
//  ContentView.swift
//  CircusAppSwiftUI
//
//  Created by Tatyana Tepaeva on 03.03.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    ForEach(tasks.indices, id: \.self) { index in
                        let task = tasks[index]

                        Text(task.title)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.title)

                        ForEach(task.items.indices, id: \.self) { vIndex in
                            NavigationLink {
                                switch vIndex {
                                case 0:
                                    FebEasy()
                                        .navigationTitle("FebEasy")
                                case 1:
                                    FebMedium()
                                        .navigationTitle("FebMedium")
                                default:
                                    FebHard()
                                        .navigationTitle("FebHard")
                                }
                            } label: {
                                Text(task.items[vIndex])
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.title3)
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Задания")
        }
    }

    private var tasks = [
        (
            title: "Февраль",
            items: [
                "easy",
                "medium",
                "hard",
            ]
        )
    ]
}

#Preview {
    ContentView()
}
