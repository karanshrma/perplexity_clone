AI Q&A App (Perplexity Clone)
An advanced, full-stack, AI-powered question-answering application that mimics the core functionality of Perplexity by grounding responses in real-time information. It uses a Retrieval-Augmented Generation (RAG) architecture to provide context-rich and accurate answers.

This project was developed based on the foundational concepts outlined in Rivaan Ranawat's tutorial.

✨ Key Features
Intelligent Q&A: Users can ask questions and receive answers informed by online sources.

Retrieval-Augmented Generation (RAG): Integrates online source fetching to ground the LLM's response, significantly improving accuracy and reducing hallucinations.

Real-time Streaming: Utilizes WebSocket connections for streaming responses from the backend to the frontend, ensuring a fast and dynamic user experience.

Responsive Flutter UI: Smooth navigation and a fully responsive interface designed for Android devices, ensuring fast query-to-response interaction.

Modular Architecture: Designed for scalability, allowing for the quick addition of new AI models, retrieval sources, or advanced query processing features.

💻 Tech Stack
Component

Technologies Used

Description

Frontend (Client)

Flutter, Dart

Built with a focus on smooth navigation and responsive UI.

Backend (Server)

FastAPI, Python

Provides a lightweight, high-performance foundation for the API.

AI/LLM

Gemini API

Used for powerful language generation and contextual understanding.

Communication

WebSockets

Enables real-time, bidirectional communication for response streaming.

Core Concept

REST & RAG

Standard API design with an advanced Retrieval-Augmented Generation pipeline.

📁 Repository Structure
This repository contains both the mobile client and the API server:

Component

Path within Repository

Frontend (Flutter)

Root directory (/)

Backend (FastAPI)

./server

Repository Link: https://github.com/karanshrma/perplexity_clone

🎓 Based on Tutorial
This project was built as a learning implementation based on the concepts presented in the following video tutorial:

Video: Building a Perplexity AI Clone with Flutter & FastAPI (RAG & WebSocket)
Link: https://youtu.be/vPbNnHEjnFU?si=56ZLvcCVN5oRJLhw

🛠️ Setup and Installation
Prerequisites
Flutter SDK installed

Python (3.8+) and pip installed

1. Clone the Repository
Clone the project which contains both the frontend and backend:

git clone [https://github.com/karanshrma/perplexity_clone.git](https://github.com/karanshrma/perplexity_clone.git)
cd perplexity_clone

2. Backend Setup
Navigate to the server directory:

cd server

Install Python dependencies:

pip install -r requirements.txt

Set up your Gemini API Key as an environment variable (GEMINI_API_KEY).

Run the FastAPI server (often using a command like uvicorn main:app --reload or similar, depending on your entry file).

3. Frontend Setup
Return to the root directory:

cd ..

Install Flutter dependencies:

flutter pub get

Update API Connection:
Ensure the WebSocket connection URL in the Flutter code is correctly pointed to your running FastAPI backend instance (e.g., ws://10.0.2.2:8000/ws for an Android emulator connecting to localhost).

Run the app:
Connect a device or start an emulator/simulator.

flutter run
