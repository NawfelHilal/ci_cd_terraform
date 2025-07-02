from fastapi import FastAPI
import mysql.connector
import os

app = FastAPI()


# Configuration de la base de données
def get_db_connection():
    try:
        connection = mysql.connector.connect(
            host=os.getenv("MYSQL_HOST", "localhost"),
            user=os.getenv("MYSQL_USER", "root"),
            password=os.getenv("MYSQL_ROOT_PASSWORD", "pwd"),
            database=os.getenv("MYSQL_DATABASE", "ynov"),
        )
        return connection
    except Exception as e:
        print(f"Erreur de connexion à la base de données: {e}")
        return None


@app.get("/")
async def root():
    return {"message": "API Python avec FastAPI et MySQL"}


@app.get("/health")
async def health_check():
    db_connection = get_db_connection()
    if db_connection:
        db_connection.close()
        return {"status": "healthy", "database": "connected"}
    else:
        return {"status": "unhealthy", "database": "disconnected"}


@app.get("/users")
async def get_users():
    connection = get_db_connection()
    if not connection:
        return {"error": "Impossible de se connecter à la base de données"}

    try:
        cursor = connection.cursor()
        cursor.execute("SELECT * FROM users LIMIT 10")
        users = cursor.fetchall()
        cursor.close()
        connection.close()
        return {"users": users}
    except Exception as e:
        connection.close()
        return {"error": f"Erreur lors de la récupération des utilisateurs: {e}"}


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(app, host="0.0.0.0", port=8000)
