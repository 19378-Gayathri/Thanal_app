# Chatbot Application

This is a Flutter-based chatbot application that allows users to interact with a chatbot through a chat interface. The application is structured to manage chat messages and connect to a chatbot service.

## Project Structure

```
chatbot-app
├── lib
│   ├── main.dart                # Entry point of the application
│   ├── screens
│   │   └── chatbot_screen.dart  # Manages the chat interface
│   ├── models
│   │   └── chat_message.dart     # Defines the ChatMessage model
│   ├── services
│   │   └── chatbot_service.dart  # Handles chatbot API logic
│   └── widgets
│       └── message_bubble.dart   # Displays individual chat messages
├── pubspec.yaml                 # Flutter project configuration
└── README.md                    # Project documentation
```

## Features

- User-friendly chat interface
- Real-time messaging with a chatbot
- Styled message bubbles for better readability

## Setup Instructions

1. Clone the repository:
   ```
   git clone <repository-url>
   ```

2. Navigate to the project directory:
   ```
   cd chatbot-app
   ```

3. Install dependencies:
   ```
   flutter pub get
   ```

4. Run the application:
   ```
   flutter run
   ```

## Usage Guidelines

- Open the app and start typing your messages in the chat interface.
- The chatbot will respond based on the input provided.
- Enjoy the interactive chat experience!