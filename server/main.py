import asyncio
from fastapi import FastAPI, WebSocket
from pydantic_models.chat_body import ChatBody
from services.llm_service import LLMService
from services.sort_source_service import SortSourceService
from services.search_service import SearchService

app = FastAPI()

search_service = None
sort_source_service = None
llm_service = None

@app.on_event("startup")
async def startup_event():
    global search_service, sort_source_service, llm_service
    search_service = SearchService()
    sort_source_service = SortSourceService()
    llm_service = LLMService()
    print(" Services initialized")


# chat websocket
@app.websocket("/ws/chat")
async def websocket_chat_endpoint(websocket: WebSocket):
    await websocket.accept()
    print("🟢 WebSocket connection accepted")

    try:
        await asyncio.sleep(0.1)
        data = await websocket.receive_json()
        print("Received data from websocket: {data}")
        query = data.get("query")
        print(f"🔹 Query extracted: {query}")

        search_results = search_service.web_search(query)
        print(f"Search results: {search_results}")

        sorted_results = sort_source_service.sort_sources(query, search_results)
        print(f"Sorted results: {sorted_results}")

        await asyncio.sleep(0.1)
        await websocket.send_json({"type": "search_result", "data": sorted_results})
        print(" Sent sorted search results")

        for chunk in llm_service.generate_response(query, sorted_results):
            await asyncio.sleep(0.1)
            await websocket.send_json({"type": "content", "data": chunk})
            print(f"📤 Sent chunk: {chunk}")

    except Exception as e:
        print(f" Unexpected error occurred: {e}")
    finally:
        await websocket.close()
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
