import os
from dotenv import load_dotenv
from pymongo import MongoClient
from pymongo.collection import Collection
from pymongo.database import Database

load_dotenv()

MONGO_HOST = os.getenv("MONGO_HOST", "localhost")
MONGO_PORT = int(os.getenv("MONGO_PORT", "27017"))
MONGO_DB = os.getenv("MONGO_DB", "afilearn_nosql")
MONGO_USER = os.getenv("MONGO_USER", "admin")
MONGO_PASSWORD = os.getenv("MONGO_PASSWORD", "secret_password")

if MONGO_USER and MONGO_PASSWORD:
    MONGO_URI = f"mongodb://{MONGO_USER}:{MONGO_PASSWORD}@{MONGO_HOST}:{MONGO_PORT}/?authSource=admin"
else:
    MONGO_URI = f"mongodb://{MONGO_HOST}:{MONGO_PORT}/"

def get_mongo_client() -> MongoClient:
    """Returns a MongoClient instance connected to the MongoDB server."""
    return MongoClient(MONGO_URI)

def get_mongo_db() -> Database:
    """Returns a handle to the target NoSQL database."""
    client = get_mongo_client()
    return client[MONGO_DB]

def get_mongo_collection(collection_name: str = "student_learning_profiles") -> Collection:
    """Returns a handle to a MongoDB collection."""
    db = get_mongo_db()
    return db[collection_name]
