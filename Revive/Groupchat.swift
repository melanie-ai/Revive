import SwiftUI

struct Messagek: Identifiable {
    let id = UUID()
    let content: String
    let isFromCurrentUser: Bool
    let timestamp: Date
    let avatar: String
}

struct ChatMessageView: View {
    let message: Message
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if !message.isFromCurrentUser {
                Avatar(image: message.avatar)
            }
            
            VStack(alignment: message.isFromCurrentUser ? .trailing : .leading, spacing: 4) {
                BubbleMessage(message: message)
                
                Text(formatTimestamp(message.timestamp))
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 4)
            }
            
            if message.isFromCurrentUser {
                Spacer()
                    .frame(width: 8)
                Avatar(image: message.avatar)
            }
        }
        .padding(.vertical, 4)
        .padding(.horizontal)
    }
    
    private func formatTimestamp(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct BubbleMessage: View {
    let message: Message
    
    var body: some View {
        Text(message.content)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(message.isFromCurrentUser ? Color.blue : Color(.systemGray6))
            .foregroundColor(message.isFromCurrentUser ? .white : .primary)
            .cornerRadius(16)
    }
}

struct Avatar: View {
    let image: String
    
    var body: some View {
        Image(image)
            .resizable()
            .frame(width: 36, height: 36)
            .clipShape(Circle())
    }
}

struct ChatListView: View {
    @State private var messages: [Message] = [
        Message(content: "Hey, how are you doing?", isFromCurrentUser: false, timestamp: Date().addingTimeInterval(-3600), avatar: "avatar1"),
        Message(content: "I'm good, thanks! Just finished that project we were working on.", isFromCurrentUser: true, timestamp: Date().addingTimeInterval(-3400), avatar: "avatar2"),
        Message(content: "That's great news! Can you send me the files when you get a chance?", isFromCurrentUser: false, timestamp: Date().addingTimeInterval(-3200), avatar: "avatar1"),
        Message(content: "Sure thing! I'll email them to you later today.", isFromCurrentUser: true, timestamp: Date().addingTimeInterval(-3000), avatar: "avatar2")
    ]
    
    @State private var newMessage: String = ""
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack {
                    ForEach(messages) { message in
                        ChatMessageView(message: message)
                    }
                }
            }
            
            HStack {
                TextField("Type a message", text: $newMessage)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(20)
                
                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.blue)
                        .padding(10)
                }
            }
            .padding()
        }
    }
    
    private func sendMessage() {
        guard !newMessage.isEmpty else { return }
        
        let message = Message(
            content: newMessage,
            isFromCurrentUser: true,
            timestamp: Date(),
            avatar: "avatar2"
        )
        
        messages.append(message)
        newMessage = ""
    }
}

struct ChatListView_Previews: PreviewProvider {
    static var previews: some View {
        ChatListView()
    }
}
