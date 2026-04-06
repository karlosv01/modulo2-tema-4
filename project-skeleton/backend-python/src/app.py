from flask import Flask
import json
import os
import psycopg2

app = Flask(__name__)


def get_db_config():
    return {
        "user": os.environ.get("DB_USER", "training"),
        "password": os.environ.get("DB_PASSWORD", os.environ.get("DB_PWD", "trainingpwd")),
        "host": os.environ.get("DB_HOST", "db"),
        "port": os.environ.get("DB_PORT", "5432"),
        "database": os.environ.get("DB_NAME", "trainingdb"),
    }


def favorite_colors():
    connection = psycopg2.connect(**get_db_config())
    cursor = connection.cursor()
    cursor.execute("SELECT name, color FROM favorite_colors ORDER BY name")
    results = [{"name": name, "color": color} for (name, color) in cursor.fetchall()]
    cursor.close()
    connection.close()
    return results


@app.route("/")
def index():
    payload = {"favorite_colors": favorite_colors()}
    return json.dumps(payload)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
