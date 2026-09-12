import pytest
from fastapi.testclient import TestClient
from backend.app.main import app

client = TestClient(app)

def test_climate_status_endpoint():
    response = client.get("/api/v1/climate/status")
    assert response.status_code == 200
    data = response.json()
    assert "enso_phase" in data
    assert data["enso_phase"] in ["El Niño", "La Niña", "ENSO Neutral", "Unknown"]
    assert "risk_level" in data
    assert "summary" in data

def test_crop_climate_impact_endpoint():
    payload = {
        "crop": "Rice",
        "growth_stage": "Flowering / Blossoming",
        "location": "Nashik, Maharashtra"
    }
    response = client.post("/api/v1/climate/crop-impact", json=payload)
    assert response.status_code == 200
    data = response.json()
    assert data["crop_evaluated"] == "Rice"
    assert data["growth_stage_evaluated"] == "Flowering / Blossoming"
    assert "overall_risk_level" in data
    assert "risk_breakdown" in data
    assert len(data["potential_risks"]) > 0
    assert len(data["recommended_actions"]) > 0

def test_what_if_climate_scenarios_endpoint():
    response = client.post("/api/v1/climate/what-if?crop=Tomato&location=Nashik,%20Maharashtra")
    assert response.status_code == 200
    data = response.json()
    assert "scenarios" in data
    assert len(data["scenarios"]) >= 4
    for scenario in data["scenarios"]:
        assert "question" in scenario
        assert "potential_impact" in scenario
        assert "recommended_preparation" in scenario

def test_smart_climate_alerts_endpoint():
    response = client.get("/api/v1/climate/alerts?location=Nashik,%20Maharashtra")
    assert response.status_code == 200
    alerts = response.json()
    assert isinstance(alerts, list)

def test_weather_endpoint_includes_enso_and_alerts():
    response = client.get("/api/v1/weather?location=Nashik,%20Maharashtra")
    assert response.status_code == 200
    data = response.json()
    assert "enso_status" in data
    assert data["enso_status"] is not None
    assert "smart_alerts" in data
    assert isinstance(data["smart_alerts"], list)

def test_weather_aware_crop_recommendation():
    payload = {
        "soil_type": "Black Cotton Soil",
        "location": "Nashik, Maharashtra",
        "water_availability": "Medium",
        "season": "Kharif"
    }
    response = client.post("/api/v1/crop-recommendation", json=payload)
    assert response.status_code == 200
    data = response.json()
    assert len(data["recommended_crops"]) > 0
    crops = [c["crop_name"] for c in data["recommended_crops"]]
    assert any("Cotton" in c for c in crops)
