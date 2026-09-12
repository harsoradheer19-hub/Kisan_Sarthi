from fastapi.testclient import TestClient
from backend.app.main import app

client = TestClient(app)

def test_gemini_vision_disease_scan_cautious_framing():
    payload = {
        "crop_name": "Tomato",
        "image_base64_or_url": "data:image/jpeg;base64,sample_leaf_spot_data",
        "location": "Nashik, Maharashtra"
    }
    res = client.post("/api/v1/disease/scan", json=payload)
    assert res.status_code == 200
    data = res.json()
    
    assert "Possible" in data["predicted_issue"] or "Issue" in data["predicted_issue"]
    assert "confirmed" not in data["predicted_issue"].lower()
    assert "disclaimer" in data
    assert "preliminary assessment" in data["disclaimer"].lower() or "advisory" in data["disclaimer"].lower()
    assert len(data["visible_symptoms"]) > 0
    assert len(data["possible_issues"]) > 0
    assert data["possible_issues"][0]["confidence"] > 0

def test_disease_scan_low_confidence_escalation():
    payload = {
        "crop_name": "Unknown Plant",
        "image_base64_or_url": "data:image/jpeg;base64,blurry_image_data",
        "location": "Pune, Maharashtra"
    }
    res = client.post("/api/v1/disease/scan", json=payload)
    assert res.status_code == 200
    data = res.json()
    
    assert data["confidence_score"] < 65.0 or data["image_quality"] == "poor" or data["requires_expert"] is True
    assert "unable to reliably" in data["disclaimer"].lower() or "consult" in data["disclaimer"].lower()

def test_expert_two_way_qa_workflow():
    # 1. Farmer creates Expert Request
    req_payload = {
        "farmer_name": "Ramesh Patil",
        "phone": "9876543210",
        "location": "Nashik",
        "crop": "Tomato",
        "request_type": "disease_scan",
        "description": "Yellow leaf spots spreading rapidly across lower canopy."
    }
    req_res = client.post("/api/v1/expert-requests", json=req_payload)
    assert req_res.status_code == 200
    request_id = req_res.json()["id"]

    # 2. Agronomist posts a follow-up question
    q_payload = {
        "request_id": request_id,
        "question": "How quickly is the leaf spotting spreading?",
        "question_type": "multiple_choice",
        "options": ["Slowly", "Moderately", "Rapidly (within 2 days)"]
    }
    q_res = client.post(f"/api/v1/expert-requests/{request_id}/questions", json=q_payload)
    assert q_res.status_code == 200
    q_data = q_res.json()
    question_id = q_data["id"]

    # Check request status updated to 'More Information Required'
    detail_res = client.get(f"/api/v1/expert-requests/{request_id}")
    assert detail_res.status_code == 200
    assert detail_res.json()["status"] == "More Information Required"
    assert len(detail_res.json()["questions"]) == 1

    # 3. Farmer responds to question
    a_payload = {
        "question_id": question_id,
        "answer": "Rapidly (within 2 days)"
    }
    a_res = client.post(f"/api/v1/expert-questions/{question_id}/answer", json=a_payload)
    assert a_res.status_code == 200

    # Check request status returned to 'In Review' and answer recorded
    detail_after = client.get(f"/api/v1/expert-requests/{request_id}")
    assert detail_after.status_code == 200
    assert detail_after.json()["status"] == "In Review"
    assert len(detail_after.json()["answers"]) == 1
    assert detail_after.json()["answers"][0]["answer"] == "Rapidly (within 2 days)"
