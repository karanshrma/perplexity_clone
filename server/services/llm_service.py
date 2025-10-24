import google.generativeai as genai
from config import Settings
from PIL import Image
import io

settings = Settings()


class LLMService:
    def __init__(self):
        genai.configure(api_key=settings.GEMINI_API_KEY)
        self.model = genai.GenerativeModel("gemini-2.0-flash-exp")

    def generate_response(self, query: str, search_results: list[dict], history: list[dict] = None):
        """
        history: List of previous messages in the format:
                 [{"role": "user", "content": "..."}, {"role": "assistant", "content": "..."}]
        """
        # Format conversation history
        history_text = ""
        if history:
            for turn in history:
                role = turn['role']
                content = turn['content']
                history_text += f"{role.capitalize()}: {content}\n"

        # Format search results
        context_text = "\n\n".join(
            [
                f"Source {i + 1} ({result['url']}):\n{result['content']}"
                for i, result in enumerate(search_results)
            ]
        )

        full_prompt = f"""
        Conversation history:
        {history_text}
        
        Context from web search:
        {context_text}
        
        User query: {query}
        
        Please provide a comprehensive, detailed, well-cited accurate response using the conversation history and the above context. 
        Think and reason deeply. Ensure it answers the query the user is asking. Do not use your knowledge until it is absolutely necessary.
                """

        # Generate response from Gemini model
        response = self.model.generate_content(full_prompt, stream=True)

        for chunk in response:
            yield chunk.text

    # def _generate_multimodal_response(self, query: str, context_text: str, image_data: bytes, image_filename: str):
    #     """Generate response using both image and text context"""
    #     try:
    #         # Convert bytes to PIL Image
    #         image = Image.open(io.BytesIO(image_data))
    #
    #         # Create multimodal prompt
    #         full_prompt = f"""
    #         I have uploaded an image ({image_filename}) along with the following query: "{query}"
    #
    #         Context from web search:
    #         {context_text}
    #
    #         Please analyze the uploaded image and provide a comprehensive response that:
    #         1. Describes what you see in the image
    #         2. Relates the image content to the user's query
    #         3. Uses the web search context to provide additional relevant information
    #         4. Gives a detailed, well-cited answer
    #
    #         Think and reason deeply about both the visual content and the textual context.
    #         """
    #
    #         # Generate content with both text and image
    #         response = self.model.generate_content([full_prompt, image], stream=True)
    #         for chunk in response:
    #             yield chunk.text
    #
    #     except Exception as e:
    #         print(f"Error processing image: {e}")
    #         # Fallback to text-only response
    #         yield f"I couldn't process the uploaded image ({image_filename}), but here's a response based on your query and web search:\n\n"
    #         yield from self._generate_text_response(query, context_text)
    #
    # def generate_image_description(self, image_data: bytes, image_filename: str):
    #     """Generate a description of the uploaded image for search query enhancement"""
    #     try:
    #         image = Image.open(io.BytesIO(image_data))
    #
    #         prompt = """
    #         Please provide a detailed description of this image that could be used to enhance a web search query.
    #         Focus on:
    #         - Main objects, people, or scenes visible
    #         - Text content if any
    #         - Context or setting
    #         - Any notable details that might be relevant for search
    #
    #         Keep the description concise but comprehensive.
    #         """
    #
    #         response = self.model.generate_content([prompt, image])
    #         return response.text
    #
    #     except Exception as e:
    #         print(f"Error generating image description: {e}")
    #         return f"Uploaded image: {image_filename}"
