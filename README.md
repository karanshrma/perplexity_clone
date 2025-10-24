# Perplexity Clone

A Flutter-based AI-powered question-answering application leveraging **Retrieval-Augmented Generation (RAG)** to fetch relevant online sources and generate context-rich, accurate responses.

Walkthrough Video - https://drive.google.com/file/d/1eWRpJ7hCDLIn3srLNW7LsBOtggF6ZPms/view?usp=sharing

---

## Features

- **RAG-Powered Q&A:** Combines retrieval from online sources with AI-generated answers for precise results.
- **Flutter Frontend:** Smooth navigation and responsive UI for Android devices.
- **FastAPI Backend:** Integrates with Gemini API for AI responses and a custom RAG pipeline.
- **AI & NLP Tools:** Uses `sentence-transformers`, `google-generativeai`, and optional `torch` & `transformers`.
- **WebSocket Support:** Real-time query handling and streaming responses.
- **Authentication & Storage:** Firebase Auth, Google Sign-In, and Shared Preferences support.
- **File Handling:** Supports image and file uploads via `image_picker` and `file_picker`.

---

## Tech Stack

- **Frontend:** Flutter, Dart
- **Backend:** FastAPI, Python
- **AI Libraries:** Google Generative AI, Sentence Transformers, Transformers, Torch
- **Data Retrieval:** Tavily, Trafilatura
- **Real-Time Communication:** WebSocket

---

## Getting Started

### Prerequisites

- Flutter >= 3.9
- Python >= 3.10
- FastAPI, Uvicorn, Pydantic, Python-dotenv
- AI Libraries: `sentence-transformers`, `google-generativeai`, `torch` (optional)

### Setup

#### Backend

1. Clone the repository:

```bash
git clone https://github.com/yourusername/perplexity_clone.git
cd perplexity_clone/backend


**2. Create and activate a virtual environment:**  

```bash
python -m venv venv
source venv/bin/activate # Linux / macOS
venv\Scripts\activate # Windows

**3. Install dependencies:**  
```bash
pip install -r requirements.txt


**4. Run the FastAPI server:**  
```bash
uvicorn main:app --reload


---

#### Frontend  
Navigate to Flutter project:  

Install dependencies:  
```bash
flutter pub get
Run the app on Android:  
```bash
flutter run
```
## Project Structure  
``` text
perplexity_clone/
├─ server/ # FastAPI backend, RAG pipeline
│ ├─ lib/ # Flutter source code
│ ├─ assets/ # Images & fonts
│ └─ pubspec.yaml # Flutter dependencies
├─ requirements.txt # Python dependencies
└─ README.md # Project documentation 
```
