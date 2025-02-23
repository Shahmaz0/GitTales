//
//  File.swift
//  GitApp
//
//  Created by Shahma Ansari on 16/02/25.
//

import Foundation

class SharedData: ObservableObject {
    @Published var currentCommandIndex: Int
    @Published var commandEntries: [(command: String, output: String)]
    @Published var fileNames: [String] = Array(repeating: "", count: 4)
    @Published var username: String = ""
    @Published var projectName: String = ""
    
    init() {
        // Initialize with 4 empty strings for the file names
        self.fileNames = Array(repeating: "", count: 4)
        self.currentCommandIndex = 0
        self.commandEntries = []
    }
}

struct CommandItem: Identifiable {
    let id = UUID()
    let command: String
    let output: String
}
