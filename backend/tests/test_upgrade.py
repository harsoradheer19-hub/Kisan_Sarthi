from fastapi.testclient import TestClient
from backend.app.main import app

client = TestClient(app)

def test_upgraded_health():
    res = client.get("/health")
    assert res.status_code == 200
    assert res.json()["status"] == "healthy"
    assert res.json()["disease_scanner"] == "active"

def test_get_crops_list():
    res = client.get("/api/v1/crops")
    assert res.status_code == 200
    data = res.json()
    assert len(data) >= 20 # 25+ crops in knowledge base

def test_get_crops_by_category():
    res = client.get("/api/v1/crops?category=Cereals")
    assert res.status_code == 200
    data = res.json()
    assert all(c["category"] == "Cereals" for c in data)

def test_gps_weather():
    res = client.get("/api/v1/weather?lat=19.9975&lon=73.7898")
    assert res.status_code == 200
    data = res.json()
    assert "feels_like" in data
    assert "farming_advisory" in data
    assert "multi_day_forecast" in data
    assert len(data["multi_day_forecast"]) == 5

def test_disease_crop_scan_high_confidence():
    payload = {
        "crop_name": "Tomato",
        "image_base64_or_url": "data:image/jpeg;base64,sample_leaf_spots"
    }
    res = client.post("/api/v1/disease/scan", json=payload)
    assert res.status_code == 200
    data = res.json()
    assert "Tomato Early Blight" in data["predicted_issue"]
    assert data["confidence_score"] > 60.0
    assert data["requires_expert"] is False

def test_disease_crop_scan_low_confidence_expert_trigger():
    payload = {
        "crop_name": "Unknown Dragonfruit",
        "image_base64_or_url": "data:image/jpeg;base64,blurry_image"
    }
    res = client.post("/api/v1/disease/scan", json=payload)
    assert res.status_code == 200
    data = res.json()
    assert data["confidence_score"] < 60.0
    assert data["requires_expert"] is True

def test_expert_portal_workflow():
    # 1. Submit Request
    req_payload = {
        "farmer_name": "Vijay Shinde",
        "phone": "9811223344",
        "location": "Nashik",
        "crop": "Cotton",
        "problem_category": "Pest Problem",
        "description": "Whiteflies under leaf surface expanding."
    }
    create_res = client.post("/api/v1/expert-requests", json=req_payload)
    assert create_res.status_code == 200
    req_id = create_res.json()["id"]

    # 2. Expert Updates Status to In Review
    patch_res = client.patch(f"/api/v1/expert-requests/{req_id}/status", json={"status": "In Review", "internal_notes": "Assigned to Dr. Patil"})
    assert patch_res.status_code == 200
    assert patch_res.json()["status"] == "In Review"

    # 3. Expert Submits Recommendation & Resolves
    resp_res = client.post(f"/api/v1/expert-requests/{req_id}/response", json={
        "expert_name": "Dr. Patil (Agronomist)",
        "expert_response": "Spray Pyriproxyfen 10% EC @ 2 ml/L of water.",
        "status": "Resolved"
    })
    assert resp_res.status_code == 200
    assert resp_res.json()["status"] == "Resolved"
    assert resp_res.json()["expert_response"] is not None

def test_farmer_notifications():
    res = client.get("/api/v1/notifications/user_123")
    assert res.status_code == 200
    data = res.json()
    assert len(data) > 0
