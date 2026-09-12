import pytest
from fastapi.testclient import TestClient
from backend.app.main import app

client = TestClient(app)

def test_admin_request_list():
    response = client.get("/api/v1/expert-requests")
    assert response.status_code == 200
    data = response.json()
    assert isinstance(data, list)
    assert len(data) >= 1

def test_admin_status_update_generates_notification():
    reqs = client.get("/api/v1/expert-requests").json()
    assert len(reqs) > 0
    req_id = reqs[0]["id"]

    payload = {"status": "In Review", "internal_notes": "Assigned to Dr. Sharma"}
    response = client.patch(f"/api/v1/expert-requests/{req_id}/status", json=payload)
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "In Review"

def test_admin_follow_up_question_workflow():
    reqs = client.get("/api/v1/expert-requests").json()
    assert len(reqs) > 0
    req_id = reqs[0]["id"]

    q_payload = {
        "request_id": req_id,
        "question": "How quickly is the leaf yellowing spreading across your field?",
        "question_type": "multiple_choice",
        "options": ["Slow", "Moderate", "Rapid"]
    }
    q_res = client.post(f"/api/v1/expert-requests/{req_id}/questions", json=q_payload)
    assert q_res.status_code == 200
    q_data = q_res.json()
    assert q_data["question"] == q_payload["question"]
    q_id = q_data["id"]

    # Farmer answers follow-up question
    a_payload = {
        "question_id": q_id,
        "user_id": "FARMER-101",
        "answer": "Moderate (spreading over 3 days)"
    }
    a_res = client.post(f"/api/v1/expert-questions/{q_id}/answer", json=a_payload)
    assert a_res.status_code == 200
    assert a_res.json()["answer"] == a_payload["answer"]

def test_admin_expert_response_and_resolution():
    reqs = client.get("/api/v1/expert-requests").json()
    assert len(reqs) > 0
    req_id = reqs[0]["id"]

    resp_payload = {
        "expert_name": "Dr. V. K. Sharma (Senior Agronomist)",
        "expert_response": "Spray Copper Hydroxide 77% WP @ 2g/L. Maintain drip irrigation interval.",
        "status": "Resolved",
        "internal_notes": "Fungal early blight confirmed."
    }
    res = client.post(f"/api/v1/expert-requests/{req_id}/response", json=resp_payload)
    assert res.status_code == 200
    data = res.json()
    assert data["status"] == "Resolved"
    assert data["expert_response"] == resp_payload["expert_response"]
