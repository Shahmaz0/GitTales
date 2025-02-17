//
//  File.swift
//  GitApp
//
//  Created by Shahma Ansari on 16/02/25.
//
import Foundation

class SharedData: ObservableObject {
    @Published var fileNames: [String] = Array(repeating: "", count: 4)
    @Published var userName: String = ""
}
