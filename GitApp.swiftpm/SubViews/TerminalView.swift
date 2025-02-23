//
//  SwiftUIView.swift
//  GitApp
//
//  Created by Shahma Ansari on 19/02/25.
//
import SwiftUI


struct TerminalView: View {
    @Binding var textInput: String
    @Binding var commandHistory: [String]
    @ObservedObject var sharedData: SharedData
    var onSubmit: () -> Void
    
    // Predefined commands and their outputs combined
    private let predefinedCommands: [CommandItem] = [
        CommandItem(
            command: "git init",
            output: "Initialized empty Git repository in ~/demo_Project/"
        ),
        CommandItem(
            command: "git branch photoStudio",
            output: "Created branch 'photoStudio'"
        ),
        CommandItem(
            command: "git checkout photoStudio",
            output: "Switched to branch 'photoStudio'"
        ),
        CommandItem(
            command: "git status",
            output: """
                On branch photoStudio
                No commits yet
                nothing to commit (create/copy files and use "git add" to track)
                Changes not staged for commit:
                    added: 4 files
                """
        ),
        CommandItem(
            command: "git add .",
            output: "Changes staged for commit"
        ),
        CommandItem(
            command: "git commit -m 'photos clicked'",
            output: """
                [photoStudio (root-commit) f7d2a3b] photos clicked
                4 files changed, 120 insertions(+)
                create mode 100644 file1.swift
                create mode 100644 file2.xib
                create mode 100644 file3.gitignore
                create mode 100644 file4.swift
                """
        ),
        CommandItem(command: "git push", output: """
                    Enumerating objects: 4, done.
                    Counting objects: 100% (4/4), done.
                    Delta compression using up to 8 threads
                    Compressing objects: 100% (3/3), done.
                    Writing objects: 100% (3/3), 350 bytes | 350.00 KiB/s, done.
                    Total 3 (delta 2), reused 0 (delta 0)
                    remote: Resolving deltas: 100% (2/2), 
                    completed with 2 local objects.
                    To https://github.com/username/repository.git
                       abc1234..def5678  photoStudio -> main
                    """
                   )
    ]
    
    private var currentCommand: CommandItem? {
        guard sharedData.currentCommandIndex < predefinedCommands.count else { return nil }
        return predefinedCommands[sharedData.currentCommandIndex]
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 2) {
                        
                        ForEach(sharedData.commandEntries.indices, id: \.self) { index in
                            CommandEntryView(entry: sharedData.commandEntries[index])
                                .id(index)
                        }
                    
                        if let command = currentCommand {
                            CurrentCommandView(
                                command: command.command,
                                executeAction: {
                                    executeCommand()
                                    scrollToBottom(proxy)
                                }
                            )
                            .id("current")
                        }
                    }
                }
                .frame(height: 117)
            }
        }
        .frame(width: 450)
        .padding()
        .background(Color.black)
        .cornerRadius(30)
        .overlay(
            RoundedRectangle(cornerRadius: 30)
                .stroke(Color.white, lineWidth: 1)
        )
    }
    
    private func scrollToBottom(_ proxy: ScrollViewProxy) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation {
                proxy.scrollTo(sharedData.commandEntries.count - 1, anchor: .bottom)
            }
        }
    }
    
    private func executeCommand() {
        guard let command = currentCommand else { return }
        
        sharedData.commandEntries.append((command: command.command, output: command.output))
        
        textInput = command.command
        onSubmit()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                sharedData.currentCommandIndex += 1
            }
        }
    }
}

// MARK: - Supporting Views
struct CommandEntryView: View {
    let entry: (command: String, output: String)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(spacing: 0) {
                PromptView()
                Text(entry.command)
                    .foregroundColor(.white)
                    .font(.system(size: 12, design: .monospaced))
            }
            
            Text(entry.output)
                .foregroundColor(.green)
                .font(.system(size: 12, design: .monospaced))
                .padding(.leading, 10)
        }
    }
}

struct CurrentCommandView: View {
    let command: String
    let executeAction: () -> Void
    
    var body: some View {
        HStack(spacing: 0) {
            PromptView()
            Text(command)
                .foregroundColor(.white)
                .font(.system(size: 12, design: .monospaced))
            
            Spacer()
            
            Button(action: executeAction) {
                Image(systemName: "arrow.right.circle.fill")
                    .foregroundColor(.green)
                    .font(.system(size: 20))
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}
