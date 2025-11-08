import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

// MARK: - Color Extensions
fileprivate extension Color {
    static var sysGray6: Color {
        #if canImport(UIKit)
        return Color(UIColor.systemGray6)
        #else
        return Color.gray.opacity(0.12)
        #endif
    }

    static var sysBackground: Color {
        #if canImport(UIKit)
        return Color(UIColor.systemBackground)
        #else
        return Color.white
        #endif
    }
}

// MARK: - Models
struct ChatUser: Identifiable, Equatable {
    let id: UUID
    let name: String
    let avatarEmoji: String
    let color: Color

    init(id: UUID = UUID(), name: String, avatarEmoji: String, color: Color = .purple) {
        self.id = id
        self.name = name
        self.avatarEmoji = avatarEmoji
        self.color = color
    }
}

struct ChatMessage: Identifiable, Equatable {
    let id: UUID
    let sender: ChatUser
    let text: String
    let date: Date
    var isMe: Bool { sender.id == Self.currentUser.id }

    static var currentUser = ChatUser(name: "You", avatarEmoji: "👤")

    init(id: UUID = UUID(), sender: ChatUser, text: String, date: Date = Date()) {
        self.id = id
        self.sender = sender
        self.text = text
        self.date = date
    }
}

struct Conversation: Identifiable {
    let id: UUID
    let title: String
    let subtitle: String?
    let avatarEmoji: String
    var messages: [ChatMessage]
    var unreadCount: Int
}

// MARK: - Sample Data
enum SampleData {
    static let sarah = ChatUser(name: "Sarah Johnson", avatarEmoji: "👩‍💼", color: .pink)
    static let marcus = ChatUser(name: "Marcus Williams", avatarEmoji: "👨‍🔬", color: .yellow)

    static let convoList: [Conversation] = [
        Conversation(id: UUID(), title: "EcoTrack Team", subtitle: "Great progress today!", avatarEmoji: "🌱", messages: [
            ChatMessage(sender: sarah, text: "Hey! Would love to have you on the EcoTrack project."),
            ChatMessage(sender: ChatMessage.currentUser, text: "Thanks! That sounds great."),
            ChatMessage(sender: sarah, text: "Perfect, let's collaborate soon.")
        ], unreadCount: 3),
        Conversation(id: UUID(), title: "Sarah Johnson", subtitle: "Discussing UI design", avatarEmoji: "👩‍💼", messages: [
            ChatMessage(sender: sarah, text: "Would love to discuss the design approach.")
        ], unreadCount: 1)
    ]
}

// MARK: - Components
struct ConversationRow: View {
    let conversation: Conversation

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(LinearGradient(colors: [Color.purple.opacity(0.9), Color.blue.opacity(0.9)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 52, height: 52)
                Text(conversation.avatarEmoji)
                    .font(.system(size: 26))
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(conversation.title)
                        .font(.headline)
                    Spacer()
                    if conversation.unreadCount > 0 {
                        Text("\(conversation.unreadCount)")
                            .font(.caption2)
                            .padding(6)
                            .background(Circle().fill(Color.black))
                            .foregroundColor(.white)
                    }
                }
                Text(conversation.subtitle ?? "")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
        }
        .padding(.vertical, 6)
    }
}

fileprivate extension Date {
    func timeAgoString() -> String {
        let seconds = Int(Date().timeIntervalSince(self))
        if seconds < 60 { return "just now" }
        let minutes = seconds / 60
        if minutes < 60 { return "\(minutes)m ago" }
        let hours = minutes / 60
        if hours < 24 { return "\(hours)h ago" }
        return "\(hours / 24)d ago"
    }
}

// MARK: - Conversation View
struct ConversationView: View {
    @State var conversation: Conversation
    @State private var draft = ""

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(conversation.avatarEmoji)
                    .font(.title)
                    .padding(8)
                    .background(Circle().fill(Color.blue.opacity(0.2)))
                VStack(alignment: .leading) {
                    Text(conversation.title).font(.headline)
                    if let subtitle = conversation.subtitle {
                        Text(subtitle).font(.subheadline).foregroundColor(.gray)
                    }
                }
                Spacer()
            }
            .padding()

            Divider()

            ScrollView {
                ForEach(conversation.messages) { msg in
                    HStack {
                        if msg.isMe { Spacer() }
                        Text(msg.text)
                            .padding(10)
                            .background(msg.isMe ? Color.blue : Color.sysGray6)
                            .foregroundColor(msg.isMe ? .white : .primary)
                            .cornerRadius(12)
                        if !msg.isMe { Spacer() }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 4)
                }
            }

            HStack {
                TextField("Message...", text: $draft)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Send") {
                    if !draft.isEmpty {
                        conversation.messages.append(ChatMessage(sender: ChatMessage.currentUser, text: draft))
                        draft = ""
                    }
                }
            }
            .padding()
        }
    }
}

// MARK: - Main Chat Tab
struct ChatTab: View {
    @Binding var selectedTab: String
    @State private var conversations = SampleData.convoList

    var body: some View {
        VStack(spacing: 0) {
            Text("Chats")
                .font(.largeTitle.bold())
                .padding(.top, 50)

            List {
                ForEach(conversations) { convo in
                    NavigationLink(destination: ConversationView(conversation: convo)) {
                        ConversationRow(conversation: convo)
                    }
                }
            }
            .listStyle(PlainListStyle())
            .padding(.bottom, 60)

            BottomNavBar(selectedTab: $selectedTab)
                .padding(.horizontal)
                .padding(.bottom, 8)
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

// MARK: - Preview
#Preview {
    ChatTab(selectedTab: .constant("Chat"))
}

