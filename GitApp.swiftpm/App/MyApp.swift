import SwiftUI

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            NewContentView()
                .preferredColorScheme(.dark)
        }
    }
}
