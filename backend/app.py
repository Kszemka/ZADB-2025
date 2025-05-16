import os
import psycopg2
from flask import Flask, jsonify
from flasgger import Swagger

DB_HOST = os.getenv('DB_HOST', 'localhost')
DB_PORT = os.getenv('DB_PORT', '5432')
DB_NAME = os.getenv('DB_NAME', 'db')
DB_USER = os.getenv('DB_USER', 'admin')
DB_PASSWORD = os.getenv('DB_PASSWORD', 'admin')

app = Flask(__name__)
app.config['SWAGGER'] = {
    'title': 'HR API',
    'uiversion': 3
}

swagger_config = {
    'headers': [],
    'specs': [
        {
            'endpoint': 'apispec',
            'route': '/apispec.json',
            'rule_filter': lambda rule: True,
            'model_filter': lambda tag: True,
        }
    ],
    'static_url_path': '/flasgger_static',
    'swagger_ui': True,
    'specs_route': '/swagger/'
}
Swagger(app, config=swagger_config)

def get_connection():
    return psycopg2.connect(
        host=DB_HOST,
        port=DB_PORT,
        dbname=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD
    )

# Funkcja pomocnicza do wykonywania SELECT *
def fetch_all(table_name):
    conn = get_connection()
    try:
        with conn.cursor() as cur:
            cur.execute(f"SELECT * FROM {table_name}")
            cols = [desc[0] for desc in cur.description]
            rows = cur.fetchall()
            return [dict(zip(cols, row)) for row in rows]
    finally:
        conn.close()

# Trasy API dla każdej tabeli z dokumentacją Swagger
@app.route('/departments', methods=['GET'])
def get_departments():
    """
    Get all departments
    ---
    responses:
      200:
        description: List of departments
    """
    return jsonify(fetch_all('department'))

@app.route('/locations', methods=['GET'])
def get_locations():
    """
    Get all locations
    ---
    responses:
      200:
        description: List of locations
    """
    return jsonify(fetch_all('location'))

@app.route('/jobs', methods=['GET'])
def get_jobs():
    """
    Get all jobs
    ---
    responses:
      200:
        description: List of jobs
    """
    return jsonify(fetch_all('job'))

@app.route('/positions', methods=['GET'])
def get_positions():
    """
    Get all positions
    ---
    responses:
      200:
        description: List of positions
    """
    return jsonify(fetch_all('position'))

@app.route('/employees', methods=['GET'])
def get_employees():
    """
    Get all employees
    ---
    responses:
      200:
        description: List of employees
    """
    return jsonify(fetch_all('employee'))

@app.route('/employment_histories', methods=['GET'])
def get_employment_histories():
    """
    Get all employment histories
    ---
    responses:
      200:
        description: List of employment history records
    """
    return jsonify(fetch_all('employment_history'))

@app.route('/compensations', methods=['GET'])
def get_compensations():
    """
    Get all compensations
    ---
    responses:
      200:
        description: List of compensation records
    """
    return jsonify(fetch_all('compensation'))

@app.route('/time_off_requests', methods=['GET'])
def get_time_off_requests():
    """
    Get all time off requests
    ---
    responses:
      200:
        description: List of time off requests
    """
    return jsonify(fetch_all('time_off_request'))

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
