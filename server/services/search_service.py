from config import Settings
from tavily import TavilyClient
import requests
from bs4 import BeautifulSoup

settings = Settings()
tavily_client = TavilyClient(api_key=settings.TAVILY_API_KEY)


class SearchService:
    def web_search(self, query: str):

        try:
            results = []

            response = tavily_client.search(query, max_results=10)
            search_results = response.get("results", [])

            for result in search_results:
                try:
                    # Fetch content from URL
                    resp = requests.get(result.get("url"), timeout=10)
                    soup = BeautifulSoup(resp.text, 'html.parser')

                    # Remove html scripts
                    for script in soup(["script", "style"]):
                        script.decompose()
                    content = soup.get_text()

                    # Cleaning
                    lines = (line.strip() for line in content.splitlines())
                    chunks = (phrase.strip() for line in lines for phrase in line.split("  "))
                    content = ' '.join(chunk for chunk in chunks if chunk)

                    results.append({
                        "title": result.get("title", ""),
                        "url": result.get("url", ""),
                        "content": content[:5000] or "",  # First 5000 characters
                    })
                except Exception as fetch_error:
                    print(f"Failed to fetch content from {result.get('url')}: {fetch_error}")
                    results.append({
                        "title": result.get("title", ""),
                        "url": result.get("url", ""),
                        "content": result.get("content", ""),
                    })

            return results
        except Exception as e:
            print(f"Search error: {e}")
            return []
