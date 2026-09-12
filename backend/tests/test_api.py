from fastapi.testclient import TestClient
from backend.app.main import app

client = TestClient(app)

def test_health_check():
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json()["status"] == "healthy"

def test_get_categories():
    response = client.get("/api/v1/categories")
    assert response.status_code == 200
    data = response.json()
    assert len(data) >= 5
    assert data[0]["id"] == "pest_problem"

def test_get_questions():
    response = client.get("/api/v1/questions/pest_problem")
    assert response.status_code == 200
    data = response.json()
    assert len(data) >= 3
    assert data[0]["param_key"] == "crop"

def test_advisory_evaluation_match():
    payload = {
        "category_id": "pest_problem",
        "answers": {
            "crop": "Tomato",
            "symptom": "Chewed leaves & visible caterpillars"
        },
        "location": "Nashik, Maharashtra"
    }
    response = client.post("/api/v1/advisory/evaluate", json=payload)
    assert response.status_code == 200
    data = response.json()
    assert data["match_found"] is True
    assert "Tomato Fruit Borer" in data["problem_identified"]
    assert len(data["recommended_actions"]) > 0

def test_advisory_evaluation_no_match():
    payload = {
        "category_id": "other",
        "answers": {
            "crop": "Dragonfruit",
            "symptom": "Unusual purple stripes"
        },
        "location": "Nashik, Maharashtra"
    }
    response = client.post("/api/v1/advisory/evaluate", json=payload)
    assert response.status_code == 200
    data = response.json()
    assert data["match_found"] is False

def test_weather_endpoint():
    response = client.get("/api/v1/weather?location=Nashik")
    assert response.status_code == 200
    data = response.json()
    assert "temperature" in data
    assert "humidity" in data
    assert "farming_advisory" in data

def test_expert_request_flow():
    payload = {
        "farmer_name": "Suresh Patel",
        "location": "Pune, Maharashtra",
        "crop": "Wheat",
        "problem_category": "Growth Problem",
        "description": "Plants turning pale yellow at root tips."
    }
    create_res = client.post("/api/v1/expert-requests", json=payload)
    assert create_res.status_code == 200
    req_data = create_res.json()
    req_id = req_data["id"]
    assert req_data["status"] == "Pending"

    list_res = client.get("/api/v1/expert-requests")
    assert list_res.status_code == 200
    assert any(r["id"] == req_id for r in list_res.json())
