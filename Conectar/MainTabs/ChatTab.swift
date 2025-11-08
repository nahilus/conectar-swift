
import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

// Cross-platform color helpers
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

// Chat.swift
// Lightweight, self-contained chat UI with sample data

// Models
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

    static var currentUser = ChatUser(name: "You", avatarEmoji: "👤", color: Color(#colorLiteral(red: 0.101, green: 0.098, blue: 0.145, alpha: 1)))

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

    init(id: UUID = UUID(), title: String, subtitle: String? = nil, avatarEmoji: String = "💬", messages: [ChatMessage] = [], unreadCount: Int = 0) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.avatarEmoji = avatarEmoji
        self.messages = messages
        self.unreadCount = unreadCount
    }
}

// Sample data used for previews and initial view
enum SampleData {
    static let sarah = ChatUser(name: "Sarah Johnson", avatarEmoji: "👩‍💼", color: Color.pink)
    static let marcus = ChatUser(name: "Marcus Williams", avatarEmoji: "👨‍🔬", color: Color.yellow)
    static let ecoTeam = ChatUser(name: "EcoTrack Team", avatarEmoji: "🌱", color: Color.blue)

    static let convoList: [Conversation] = [
        Conversation(title: "EcoTrack Team", subtitle: "Great progress on the ML model today!", avatarEmoji: "🌱", messages: [
            ChatMessage(sender: sarah, text: "Hey! I saw you're interested in the EcoTrack project. Would love to have you on the team!", date: Date().addingTimeInterval(-3600 * 5)),
            ChatMessage(sender: ChatMessage.currentUser, text: "Thanks! The concept looks amazing. I'd love to help with the backend and ML integration.", date: Date().addingTimeInterval(-3600 * 4)),
            ChatMessage(sender: sarah, text: "Perfect! We were just discussing the data pipeline. Your experience with Python would be super valuable.", date: Date().addingTimeInterval(-3600 * 3))
        ], unreadCount: 3),
        Conversation(title: "Sarah Johnson", subtitle: "Would love to discuss the design approach", avatarEmoji: "👩‍💼", messages: [
            ChatMessage(sender: sarah, text: "Would love to discuss the design approach", date: Date().addingTimeInterval(-2800))
        ], unreadCount: 1),
        Conversation(title: "OpenCollab Team", subtitle: "Meeting scheduled for tomorrow at 2pm", avatarEmoji: "🚀", messages: [
            ChatMessage(sender: ChatUser(name: "OpenCollab Team", avatarEmoji: "🚀", color: .purple), text: "Meeting scheduled for tomorrow at 2pm", date: Date().addingTimeInterval(-7200))
        ], unreadCount: 0),
        Conversation(title: "Marcus Williams", subtitle: "Thanks for the feedback on the research!", avatarEmoji: "👨‍🔬", messages: [
            ChatMessage(sender: marcus, text: "Thanks for the feedback on the research!", date: Date().addingTimeInterval(-18000))
        ], unreadCount: 0)
    ]
}

// Helpers
fileprivate extension Date {
    func timeAgoString() -> String {
        let seconds = Int(Date().timeIntervalSince(self))
        if seconds < 60 { return "just now" }
        let minutes = seconds / 60
        if minutes < 60 { return "\(minutes)m ago" }
        let hours = minutes / 60
        if hours < 24 { return "\(hours)h ago" }
        let days = hours / 24
        return "\(days)d ago"
    }
}

// Conversation row for the list
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
                        .foregroundColor(Color.primary)
                    Spacer()
                    if conversation.unreadCount > 0 {
                        Text("\(conversation.unreadCount)")
                            .font(.caption)
                            .padding(8)
                            .background(Circle().fill(Color.black))
                            .foregroundColor(.white)
                    }
                }
                Text(conversation.subtitle ?? "")
                    .font(.subheadline)
                    .foregroundColor(Color.gray)
                    .lineLimit(1)
            }
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
    }
}

// Message bubble
struct MessageBubble: View {
    let message: ChatMessage

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if !message.isMe {
                // avatar
                Text(message.sender.avatarEmoji)
                    .font(.system(size: 22))
                    .frame(width: 36, height: 36)
                    .background(RoundedRectangle(cornerRadius: 10).fill(message.sender.color.opacity(0.2)))
            } else {
                Spacer(minLength: 48)
            }

            VStack(alignment: message.isMe ? .trailing : .leading, spacing: 6) {
                Text(message.text)
                    .font(.body)
                    .foregroundColor(message.isMe ? .white : Color.secondary)
                    .padding(12)
                    .background(message.isMe ? Color.black : Color.sysGray6)
                    .clipShape(RoundedCorner(radius: 16, corners: message.isMe ? Set([.topLeft, .topRight, .bottomLeft]) : Set([.topLeft, .topRight, .bottomRight])))

                Text(message.date.timeAgoString())
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            if message.isMe {
                Text(message.sender.avatarEmoji)
                    .font(.system(size: 18))
                    .frame(width: 36, height: 36)
                    .background(RoundedRectangle(cornerRadius: 10).fill(message.sender.color.opacity(0.2)))
            } else {
                Spacer(minLength: 8)
            }
        }
        .padding(.horizontal, 12)
    }
}

// Input bar
struct ChatInputBar: View {
    @Binding var text: String
    var onSend: (String) -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(action: {
                // attachment action placeholder
            }) {
                Image(systemName: "paperclip")
                    .foregroundColor(.gray)
            }

            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text("Type a message...")
                        .foregroundColor(Color.gray.opacity(0.8))
                }
                TextField("", text: $text)
                    .textFieldStyle(PlainTextFieldStyle())
                    .disableAutocorrection(true)
            }
            .padding(12)
            .background(Color.sysGray6)
            .cornerRadius(14)

            Button(action: {
                let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !trimmed.isEmpty else { return }
                onSend(trimmed)
                text = ""
            }) {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.white)
                    .padding(12)
                    .background(Circle().fill(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Color.gray : Color.blue))
            }
            .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color.sysBackground.shadow(color: Color.black.opacity(0.03), radius: 2, x: 0, y: -1))
    }
}

// Conversation view (detail)
struct ConversationView: View {
    @State var conversation: Conversation
    @State private var draft: String = ""
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack(spacing: 12) {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.primary)
                        .padding(8)
                }
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(LinearGradient(colors: [Color.purple, Color.blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 44, height: 44)
                    Text(conversation.avatarEmoji)
                        .font(.title3)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(conversation.title).font(.headline)
                    if let subtitle = conversation.subtitle {
                        Text(subtitle).font(.subheadline).foregroundColor(.gray)
                    }
                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical, 10)

            Divider()

            // Messages list
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(conversation.messages) { message in
                            MessageBubble(message: message)
                                .id(message.id)
                        }
                        Spacer(minLength: 20)
                    }
                    .padding(.top, 8)
                }
                .onChange(of: conversation.messages.count) { _, _ in
                    if let last = conversation.messages.last {
                        withAnimation(.easeOut) {
                            proxy.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                }
                .background(Color.sysBackground)
            }

            Divider()
            ChatInputBar(text: $draft, onSend: { text in
                let message = ChatMessage(sender: ChatMessage.currentUser, text: text, date: Date())
                conversation.messages.append(message)
            })
            .padding(.bottom, 0)
        }
        #if os(iOS) || targetEnvironment(macCatalyst)
        .navigationBarHidden(true)
        #endif
    }
}

// Conversation list
struct ChatListView: View {
    @State private var conversations: [Conversation] = SampleData.convoList

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                VStack(alignment: .leading) {
                    Text("Messages")
                        .font(.title2).bold()
                        .padding(.horizontal)
                        .padding(.top, 8)

                    // Search placeholder
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search conversations...", text: .constant(""))
                            .disabled(true)
                    }
                    .padding(10)
                    .background(Color.sysGray6)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .padding(.bottom, 6)
                }

                List {
                    ForEach(conversations) { convo in
                        NavigationLink(destination: ConversationView(conversation: convo)) {
                            ConversationRow(conversation: convo)
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
            #if os(iOS) || targetEnvironment(macCatalyst)
            .navigationBarHidden(true)
            #endif
        }
    }
}

// Small utility for rounding specific corners
enum CornerPosition: Hashable {
    case topLeft, topRight, bottomLeft, bottomRight
}

struct RoundedCorner: Shape {
    var radius: CGFloat = 10.0
    var corners: Set<CornerPosition> = [.topLeft, .topRight, .bottomLeft, .bottomRight]

    func path(in rect: CGRect) -> Path {
        let tl = corners.contains(.topLeft) ? radius : 0
        let tr = corners.contains(.topRight) ? radius : 0
        let bl = corners.contains(.bottomLeft) ? radius : 0
        let br = corners.contains(.bottomRight) ? radius : 0

        var path = Path()

        // Start at top-left
        path.move(to: CGPoint(x: rect.minX + tl, y: rect.minY))

        // Top edge
        path.addLine(to: CGPoint(x: rect.maxX - tr, y: rect.minY))

        // Top-right corner
        if tr > 0 {
            path.addArc(center: CGPoint(x: rect.maxX - tr, y: rect.minY + tr), radius: tr, startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)
        }

        // Right edge
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - br))

        // Bottom-right corner
        if br > 0 {
            path.addArc(center: CGPoint(x: rect.maxX - br, y: rect.maxY - br), radius: br, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
        }

        // Bottom edge
        path.addLine(to: CGPoint(x: rect.minX + bl, y: rect.maxY))

        // Bottom-left corner
        if bl > 0 {
            path.addArc(center: CGPoint(x: rect.minX + bl, y: rect.maxY - bl), radius: bl, startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)
        }

        // Left edge
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + tl))

        // Top-left corner
        if tl > 0 {
            path.addArc(center: CGPoint(x: rect.minX + tl, y: rect.minY + tl), radius: tl, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)
        }

        path.closeSubpath()
        return path
    }
}

// MARK: - Previews
struct Chat_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ChatListView()
            ConversationView(conversation: SampleData.convoList[0])
        }
    }
}
