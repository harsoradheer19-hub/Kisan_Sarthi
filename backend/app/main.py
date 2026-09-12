import os
from typing import List, Optional
from fastapi import FastAPI, HTTPException, Query, Path, Body, Header
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles

from .models import (
    ProblemCategory, Question, AdvisoryEvaluationRequest, AdvisoryResultResponse,
    WeatherResponse, CropRecommendationRequest, CropRecommendationResponse, RecommendedCropItem,
    ExpertRequestCreate, ExpertRequestResponse, ExpertResponseUpdate, ExpertStatusUpdate,
    CropItem, DiseaseScanRequest, DiseaseScanResponse, AppNotification,
    ExpertQuestionCreate, ExpertQuestionResponse, ExpertAnswerCreate, ExpertAnswerResponse, ExpertResponseCreate,
    UserRegister, UserLogin, UserResponse, TokenResponse,
    ClimateStatusResponse, CropClimateImpactRequest, CropClimateImpactResponse, WhatIfScenarioResponse
)
from .database import db
from .advisory_engine import advisory_engine
from .weather_service import WeatherService
from .gemini_vision_service import GeminiVisionService
from .auth import verify_password, create_access_token, verify_access_token

app = FastAPI(
    title="Kisan Sarthi Real-Time Engine API",
    description="Har Kisan Ka Smart Saathi - Agricultural Engine, GPS Weather, Gemini Vision & Expert Agronomist Portal",
    version="2.1.0"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/health")
def health_check():
    return {
        "status": "healthy",
        "service": "Kisan Sarthi Real-Time Production Backend",
        "advisory_engine": "active",
        "disease_scanner": "active",
        "weather_service": "active",
        "database": "persistent"
    }

# ==================================================
# 0. AUTHENTICATION & USER MANAGEMENT
# ==================================================
@app.post("/api/v1/auth/register", response_model=TokenResponse)
def register_user(reg: UserRegister):
    """Registers a new user (FARMER, EXPERT, or ADMIN) and returns access token."""
    try:
        user_res = db.register_user(reg)
        token = create_access_token({"sub": user_res.id, "role": user_res.role, "phone": user_res.phone})
        return TokenResponse(access_token=token, token_type="bearer", user=user_res)
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))

@app.post("/api/v1/auth/login", response_model=TokenResponse)
def login_user(login_data: UserLogin):
    """Authenticates user via phone & password, returning access token."""
    user = db.get_user_by_phone(login_data.phone)
    if not user or not verify_password(login_data.password, user["password_hash"]):
        raise HTTPException(status_code=401, detail="Invalid phone number or password")
    
    user_res = UserResponse(
        id=user["id"], name=user["name"], phone=user["phone"], role=user["role"],
        location=user["location"], main_crop=user["main_crop"],
        preferred_language=user["preferred_language"], created_at=user["created_at"]
    )
    token = create_access_token({"sub": user["id"], "role": user["role"], "phone": user["phone"]})
    return TokenResponse(access_token=token, token_type="bearer", user=user_res)

@app.get("/api/v1/auth/me", response_model=UserResponse)
def get_current_user_profile(authorization: Optional[str] = Header(None)):
    """Fetches profile for authenticated token user."""
    if not authorization or not authorization.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Missing or invalid Bearer token")
    token = authorization.split(" ")[1]
    payload = verify_access_token(token)
    if not payload:
        raise HTTPException(status_code=401, detail="Token expired or invalid signature")
    
    user_res = db.get_user_by_id(payload["sub"])
    if not user_res:
        raise HTTPException(status_code=404, detail="User not found")
    return user_res

# ==================================================
# 1. CATEGORIES & CROPS KNOWLEDGE BASE
# ==================================================
@app.get("/api/v1/categories", response_model=List[ProblemCategory])
def get_categories():
    """Retrieve problem categories for guided selection."""
    return db.categories

@app.get("/api/v1/crops", response_model=List[CropItem])
def get_crops(category: Optional[str] = Query(None, description="Filter by Cereals, Pulses, Oilseeds, Cash Crops, Vegetables, Fruits")):
    """Fetch 17+ crops with optional category filter."""
    if category:
        return [c for c in db.crops if c.category.lower() == category.lower()]
    return db.crops

@app.get("/api/v1/crops/{crop_id}", response_model=CropItem)
def get_crop_detail(crop_id: str = Path(...)):
    """Fetch detailed crop agronomy profile."""
    for c in db.crops:
        if c.id.lower() == crop_id.lower():
            return c
    raise HTTPException(status_code=404, detail="Crop not found in knowledge base")

# ==================================================
# 2. DYNAMIC GUIDED QUESTIONS & ADVISORY EVALUATION
# ==================================================
@app.get("/api/v1/questions/{category_id}", response_model=List[Question])
def get_questions_for_category(category_id: str = Path(...)):
    """Fetch dynamic multi-step questions for a category."""
    return db.questions.get(category_id, db.questions.get("pest_problem", []))

@app.post("/api/v1/advisory/evaluate", response_model=AdvisoryResultResponse)
async def evaluate_advisory(req: AdvisoryEvaluationRequest):
    """Evaluates farmer inputs against Rule Engine & weather context."""
    weather_data = await WeatherService.get_weather(req.location or "Nashik, Maharashtra")
    weather_dict = weather_data.model_dump()
    result = advisory_engine.evaluate(req.category_id, req.answers, weather_dict)
    
    # Save advisory event in database
    db.advisory_history.insert(0, {
        "id": f"ADV-{len(db.advisory_history) + 1}",
        "farmer_id": req.farmer_id,
        "category_id": req.category_id,
        "answers": req.answers,
        "result": result.model_dump()
    })
    db.save_to_disk()
    return result

# ==================================================
# 3. GPS LOCALIZED WEATHER
# ==================================================
@app.get("/api/v1/weather", response_model=WeatherResponse)
async def get_weather(
    location: str = Query("Nashik, Maharashtra", description="City/District name"),
    lat: Optional[float] = Query(None, description="GPS Latitude"),
    lon: Optional[float] = Query(None, description="GPS Longitude")
):
    """Fetch GPS-localized weather with agricultural advisories and multi-day forecasts."""
    return await WeatherService.get_weather(location=location, lat=lat, lon=lon)

# ==================================================
# 4. GEMINI VISION CROP DISEASE SCANNER
# ==================================================
@app.post("/api/v1/disease/scan", response_model=DiseaseScanResponse)
async def scan_crop_disease(req: DiseaseScanRequest):
    """
    Analyzes uploaded crop photo using Gemini Vision API, combines findings with
    GPS weather context and agricultural rule base to deliver safe advisories.
    """
    weather_data = None
    try:
        weather_data = await WeatherService.get_weather(
            location=req.location or "Nashik, Maharashtra",
            lat=req.latitude, lon=req.longitude
        )
    except Exception:
        pass

    weather_summary = f"{weather_data.temperature}°C, {weather_data.condition}, Humidity {weather_data.humidity}%, Rain Prob {weather_data.rain_probability}%" if weather_data else None

    # Call Gemini Vision Service
    gemini_result = await GeminiVisionService.analyze_crop_image(
        image_base64_or_url=req.image_base64_or_url,
        crop_hint=req.crop_name,
        location=req.location,
        weather_summary=weather_summary
    )

    # Hybrid Agronomic Advisory Generation (Gemini + Rule Engine + Weather)
    final_advisory = advisory_engine.evaluate_vision_advisory(
        gemini_data=gemini_result,
        weather_data=weather_data,
        crop_override=req.crop_name
    )

    db.disease_scans.insert(0, final_advisory)
    db.save_to_disk()
    return final_advisory

@app.get("/api/v1/disease-scans/{user_id}", response_model=List[DiseaseScanResponse])
def get_user_disease_scans(user_id: str = Path(...)):
    """Fetch disease scan history for a user."""
    return db.disease_scans

# ==================================================
# 5. CROP RECOMMENDATION ENGINE
# ==================================================
# ==================================================
# 5. CROP RECOMMENDATION ENGINE (WEATHER & CLIMATE AWARE)
# ==================================================
@app.post("/api/v1/crop-recommendation", response_model=CropRecommendationResponse)
async def get_crop_recommendation(req: CropRecommendationRequest):
    """Recommends suitable crops based on soil, season, location, current weather forecast & ENSO climate risk."""
    soil = req.soil_type.lower()
    recommendations = []
    
    # Fetch real-time weather & climate context
    weather_data = await WeatherService.get_weather(req.location or "Nashik, Maharashtra")
    enso_data = await ClimateService.get_enso_status()
    enso_phase = enso_data.get("enso_phase", "Neutral")

    if "black" in soil or "alluvial" in soil:
        recommendations.append(
            RecommendedCropItem(
                crop_name="Cotton (कपास / कापूस)",
                suitability_score=92 if enso_phase == "El Niño" else 95,
                water_requirement="Medium (500-700 mm)",
                expected_yield="12 - 15 Quintals / Acre",
                season_fit="Kharif (May - Nov)",
                growing_tips=f"Thrives in deep black cotton soil. Climate Signal ({enso_phase}): Monitor for whitefly during warm dry spells."
            )
        )
        recommendations.append(
            RecommendedCropItem(
                crop_name="Soybean (सोयाबीन)",
                suitability_score=88 if enso_phase == "El Niño" else 90,
                water_requirement="Medium (450-700 mm)",
                expected_yield="10 - 12 Quintals / Acre",
                season_fit="Kharif (June - Oct)",
                growing_tips="Treat seeds with Rhizobium culture before sowing. Ensure life-saving irrigation at pod development."
            )
        )

    recommendations.append(
        RecommendedCropItem(
            crop_name="Tomato (टमाटर / टोमॅटो)",
            suitability_score=92,
            water_requirement="High / Drip Irrigated",
            expected_yield="25 - 30 Tons / Acre",
            season_fit="Rabi / Late Kharif",
            growing_tips="Use bamboo staking for high fruit yield. High humidity enhances blight risk—use preventive sprays."
        )
    )
    recommendations.append(
        RecommendedCropItem(
            crop_name="Chickpea / Chana (चना / हरभरा)",
            suitability_score=94 if enso_phase == "El Niño" else 88, # Highly drought tolerant
            water_requirement="Low (250-350 mm)",
            expected_yield="8 - 10 Quintals / Acre",
            season_fit="Rabi (Oct - March)",
            growing_tips=f"Excellent fit for lower moisture conditions ({enso_phase} signal). Deep root system utilizes residual soil moisture."
        )
    )

    return CropRecommendationResponse(
        recommended_crops=recommendations,
        soil_type=req.soil_type,
        location=req.location
    )

# ==================================================
# 5B. ADVANCED CLIMATE & EL NIÑO MODULE API
# ==================================================
from .climate_service import ClimateService

@app.get("/api/v1/climate/status", response_model=ClimateStatusResponse)
async def get_climate_status():
    """Fetches real-time regional ENSO / IOD climate signal diagnostic status."""
    return await ClimateService.get_enso_status()

@app.post("/api/v1/climate/crop-impact", response_model=CropClimateImpactResponse)
async def analyze_crop_climate_impact(req: CropClimateImpactRequest):
    """
    Evaluates 'How will current climate conditions affect my crop?'
    Combines Crop + Growth Stage + Location + Weather + Forecast + ENSO.
    """
    location = req.location or "Nashik, Maharashtra"
    weather = await WeatherService.get_weather(location=location, lat=req.latitude, lon=req.longitude)
    enso = await ClimateService.get_enso_status()

    weather_dict = weather.model_dump()
    forecast_list = [f.model_dump() for f in weather.multi_day_forecast]

    res = ClimateService.calculate_climate_risk(
        crop=req.crop,
        growth_stage=req.growth_stage or "Vegetative",
        current_weather=weather_dict,
        forecast=forecast_list,
        enso_data=enso
    )
    return res

@app.post("/api/v1/climate/what-if", response_model=WhatIfScenarioResponse)
def get_what_if_climate_scenarios(
    crop: str = Query("Tomato", description="Selected crop"),
    location: str = Query("Nashik, Maharashtra", description="Farmer location")
):
    """Retrieves decision-support 'What-If' climate scenario simulations."""
    scenarios = ClimateService.get_what_if_scenarios(crop, location)
    return WhatIfScenarioResponse(
        scenarios=scenarios,
        crop=crop,
        location=location
    )

@app.get("/api/v1/climate/alerts")
async def get_smart_climate_alerts(
    location: str = Query("Nashik, Maharashtra", description="Farmer location")
):
    """Retrieves Smart Combined Weather + Climate Alerts."""
    weather = await WeatherService.get_weather(location=location)
    enso = await ClimateService.get_enso_status()
    alerts = ClimateService.get_smart_alerts(weather.model_dump(), enso)
    return alerts


# ==================================================
# 6. EXPERT REQUESTS & WEB EXPERT PORTAL API
# ==================================================
@app.post("/api/v1/expert-requests", response_model=ExpertRequestResponse)
def submit_expert_request(req: ExpertRequestCreate):
    """Submit an unresolved agricultural problem to agronomists."""
    return db.create_expert_request(req)

@app.get("/api/v1/expert-requests", response_model=List[ExpertRequestResponse])
def get_all_expert_requests(status: Optional[str] = Query(None, description="Filter by Pending, In Review, More Information Required, Resolved")):
    """Fetch all expert requests for tracking & Web Expert Portal."""
    all_reqs = [db.get_expert_request_by_id(r.id) or r for r in db.expert_requests]
    if status and status.lower() != "all":
        return [r for r in all_reqs if r.status.lower() == status.lower()]
    return all_reqs

@app.get("/api/v1/expert-requests/{request_id}", response_model=ExpertRequestResponse)
def get_expert_request_detail(request_id: str = Path(...)):
    """Fetch specific request details including Q&A conversation timeline."""
    req = db.get_expert_request_by_id(request_id)
    if not req:
        raise HTTPException(status_code=404, detail="Expert request not found")
    return req

@app.post("/api/v1/expert-requests/{request_id}/questions", response_model=ExpertQuestionResponse)
def create_expert_question(request_id: str, q_create: ExpertQuestionCreate):
    """Web Expert Portal endpoint: Agronomist posts follow-up question to farmer."""
    q_create.request_id = request_id
    q_res = db.create_expert_question(q_create)
    if not q_res:
        raise HTTPException(status_code=404, detail="Expert request not found")
    return q_res

@app.post("/api/v1/expert-questions/{question_id}/answer", response_model=ExpertAnswerResponse)
def answer_expert_question(question_id: str, a_create: ExpertAnswerCreate):
    """Farmer endpoint: Submit response to an agronomist's follow-up question."""
    a_create.question_id = question_id
    a_res = db.answer_expert_question(a_create)
    if not a_res:
        raise HTTPException(status_code=404, detail="Question not found")
    return a_res

@app.patch("/api/v1/expert-requests/{request_id}/status", response_model=ExpertRequestResponse)
def update_expert_request_status(request_id: str, update: ExpertStatusUpdate):
    """Web Expert Portal endpoint to update request status."""
    updated = db.update_expert_request_status(request_id, update.status, update.internal_notes)
    if not updated:
        raise HTTPException(status_code=404, detail="Expert request not found")
    return updated

@app.post("/api/v1/expert-requests/{request_id}/response", response_model=ExpertRequestResponse)
def respond_to_expert_request(request_id: str, update: ExpertResponseUpdate):
    """Web Expert Portal endpoint to submit expert recommendation & mark resolved."""
    req = db.get_expert_request_by_id(request_id)
    if not req:
        raise HTTPException(status_code=404, detail="Expert request not found")
    
    req.expert_name = update.expert_name
    req.expert_response = update.expert_response
    req.status = update.status
    if update.internal_notes:
        req.internal_notes = update.internal_notes
    
    db.notifications.insert(0, AppNotification(
        id=f"NOTIF-{len(db.notifications) + 105}",
        farmer_id=req.farmer_id,
        request_id=request_id,
        title="Expert Recommendation Received!",
        message=f"{update.expert_name} responded to your request #{request_id}.",
        type="expert_reply",
        is_read=False,
        created_at="Just now"
    ))
    db.save_to_disk()
    return req

# ==================================================
# 7. IN-APP NOTIFICATIONS
# ==================================================
@app.get("/api/v1/notifications/{user_id}", response_model=List[AppNotification])
def get_notifications(user_id: str = Path(...)):
    """Fetch notifications for farmer."""
    return db.notifications

# Serve static web frontend
web_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", "web"))
if os.path.exists(web_dir):
    app.mount("/", StaticFiles(directory=web_dir, html=True), name="web")
