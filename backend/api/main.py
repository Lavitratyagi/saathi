from datetime import datetime
from typing import List, Any
from pymongo.collection import Collection, Mapping
from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from pymongo import MongoClient
from pydantic import BaseModel
import os


class User(BaseModel):
    aadhar: int
    name: str
    phone_number: str
    password: str
    emergency: List[str]


class Event(BaseModel):
    aadhar: int
    name: str
    phone_number: str
    venue: str
    dates: List[datetime]
    timings: datetime
    capacity: int


class UserPass(BaseModel):
    aadhar: int
    password: str


class Mymongo(FastAPI):
    mongodb_client: MongoClient
    collection_user: Collection[Mapping[str, Any]]
    collection_organiser: Collection[Mapping[str, Any]]


app = Mymongo()


run_enironment = os.environ.get('local')
if run_enironment:
    DB_URL = 'mongodb://127.0.0.1:27017/?directConnection=true&serverSelectionTimeoutMS=2000&appName=mongosh+2.4.0'
else:
    DB_URL = 'mongodb+srv://test:test@cluster0.yvlq9mj.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0'


@app.on_event('startup')
async def startup_client():
    app.mongodb_client = MongoClient(DB_URL)
    app.collection_user = app.mongodb_client['saathi']['user']
    app.collection_organiser = app.mongodb_client['saathi']['organiser']
    print("db got conn")


# event
@app.post('/event/create')
async def event_create(event: Event):
    if (app.collection_organiser.find_one({"aadhar": event.aadhar})):
        return False
    app.collection_user.insert_one({
        'aadhar': event.aadhar,
        'name': event.name,
        'phone_number': event.phone_number,
        'venue': event.venue,
        'dates': event.dates,
        'timings': event.timings,
        'capacity': event.capacity,
    })
    return True


@app.post('/event/login')
async def event_login(): ...


@app.get('/event/')
async def getEvents(): ...


# ACCOUNT

@app.post('/account/create')
async def create(user: User):
    if (app.collection_user.find_one({"aadhar": user.aadhar})):
        return False
    app.collection_user.insert_one({
        'aadhar': user.aadhar,
        'name': user.name,
        'phone_number': user.phone_number,
        'password': user.password,
        'emergency': user.emergency
    })
    return True


@app.get('/account/login')
async def login(aadhar: int, password: str):
    if (app.collection_user.find_one(
        {
            'aadhar': aadhar,
            'password': password
        }
    )):
        return True
    return False


@app.get('/account/info')
async def info(aadhar: int):
    if (usr := app.collection_user.find_one({"aadhar": aadhar})):
        return User(
            aadhar=usr.get("aadhar", ""),
            name=usr.get("name", ""),
            phone_number=usr.get("phone_number", ""),
            password=usr.get("password", ""),
            emergency=usr.get("emergency", ""),
        )
    return {}


@app.on_event("shutdown")
def shutdown_db_client():
    app.mongodb_client.close()


# @app.websocket('/broadcast')
# async def broadcast(ws: WebSocket):
#     data = await ws.accept()
#     while True:
#         await ws.send_text("This is broadcasting")


class ConnectionManager:
    def __init__(self):
        self.active_connections: List[WebSocket] = []

    async def connect(self, websocket: WebSocket):
        await websocket.accept()
        self.active_connections.append(websocket)

    def disconnect(self, websocket: WebSocket):
        if websocket in self.active_connections:
            self.active_connections.remove(websocket)

    async def broadcast_bytes(self, message: bytes, sender: WebSocket | None = None):
        for connection in self.active_connections.copy():
            if connection != sender:
                try:
                    await connection.send_bytes(message)
                except Exception:
                    self.disconnect(connection)

    async def send_personal_message(self, message: str, websocket: WebSocket):
        print('send', message)
        await websocket.send_text(message)

    async def broadcast(self, message: str, sender: WebSocket | None = None):
        for connection in self.active_connections.copy():
            if connection != sender:
                try:
                    await connection.send_text(message)
                except Exception:
                    self.disconnect(connection)


manager = ConnectionManager()


@app.websocket("/broadcast/image")
async def broadcast_endpoint(websocket: WebSocket):
    await manager.connect(websocket)
    try:
        while True:
            image_data = await websocket.receive_bytes()

            await manager.broadcast_bytes(image_data, sender=websocket)
    except WebSocketDisconnect:
        manager.disconnect(websocket)
    except Exception as e:
        manager.disconnect(websocket)
        raise e


@app.websocket("/broadcast/location")
async def broadcast(websocket: WebSocket):
    await manager.connect(websocket)
    try:
        while True:
            data = await websocket.receive_text()
            await manager.broadcast(data)
    except WebSocketDisconnect:
        manager.disconnect(websocket)
    except Exception as e:
        manager.disconnect(websocket)
        raise e


@app.websocket("/broadcast/camera")
async def broadcast_camera(websocket: WebSocket):
    await manager.connect(websocket)
    try:
        while True:
            data = await websocket.receive_text()
            await manager.broadcast(data)
    except WebSocketDisconnect:
        manager.disconnect(websocket)
    except Exception as e:
        manager.disconnect(websocket)
        raise e

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
