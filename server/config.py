# config.py
import os
from dotenv import load_dotenv

# .env file ko load kar
load_dotenv()

class Settings:
    def __init__(self):
        self.TAVILY_API_KEY = os.getenv("TAVILY_API_KEY", "")
        self.GEMINI_API_KEY = os.getenv("GEMINI_API_KEY", "")

        # Debug ke liye print kar
        print(f"Tavily API Key loaded: {'Yes' if self.TAVILY_API_KEY else 'No'}")
        print(f"Gemini API Key loaded: {'Yes' if self.GEMINI_API_KEY else 'No'}")