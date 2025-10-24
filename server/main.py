import asyncio
from fastapi import FastAPI, WebSocket
from pydantic_models.chat_body import ChatBody
from services.llm_service import LLMService
from services.sort_source_service import SortSourceService
from services.search_service import SearchService
from typing import List
app = FastAPI()

search_service = SearchService()
sort_source_service = SortSourceService()
llm_service = LLMService()

conversation_histories: dict[WebSocket, List[dict]] = {}

@app.on_event("startup")
async def startup_event():
    global search_service, sort_source_service, llm_service
    search_service = SearchService()
    sort_source_service = SortSourceService()
    llm_service = LLMService()
    print(" Services initialized")


@app.websocket("/ws/chat")
async def websocket_chat_endpoint(websocket: WebSocket):
    await websocket.accept()
    print("🟢 WebSocket connection accepted")

    conversation_histories[websocket] = []  # initialize history

    try:
        while True:  # keep connection open for multiple messages
            data = await websocket.receive_json()

            query = data.get("query")
            print(query)
            if not query:
                await websocket.send_json({"type": "error", "message": "No query provided"})
                continue

            # Append user's message to history
            conversation_histories[websocket].append({"role": "user", "content": query})

            # Search & sort results (same as before)
            loop = asyncio.get_event_loop()
            search_results = await loop.run_in_executor(None, search_service.web_search, query)
            sorted_results = await loop.run_in_executor(None, sort_source_service.sort_sources, query, search_results)

            await websocket.send_json({"type": "search_result", "data": sorted_results})

            # Generate LLM response using **full conversation history**
            response_chunks = llm_service.generate_response(
                query,
                sorted_results,
                conversation_histories[websocket]
            )
            llm_text = ""

            for chunk in response_chunks:
                print("LLM chunk:", chunk)
                await websocket.send_json({"type": "content", "data": chunk})
                llm_text = llm_text + chunk

            # Append LLM response to history
            conversation_histories[websocket].append({"role": "assistant", "content": llm_text})

    except Exception as e:
        print(f"Unexpected error occurred: {e}")
        await websocket.send_json({"type": "error", "message": str(e)})
    finally:
        conversation_histories.pop(websocket, None)
    try:
        await websocket.close()
    except RuntimeError:
        pass
    print(" WebSocket connection closed")


# chat endpoint
@app.post("/chat")
def chat_endpoint(body: ChatBody):
    print(f" Received POST /chat request with body: {body}")

    search_results = search_service.web_search(body.query)
    print(f" Search results: {search_results}")

    sorted_results = sort_source_service.sort_sources(body.query, search_results)
    print(f" Sorted results: {sorted_results}")

    response = llm_service.generate_response(body.query, sorted_results)
    print(f" Response generated: {response}")

    return response


if __name__ == "__main__":
    import uvicorn
    print(" Starting FastAPI server")
    uvicorn.run("main:app", host="0.0.0.0", port=8001, reload=True)
