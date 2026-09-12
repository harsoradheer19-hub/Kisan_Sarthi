from pydantic import BaseModel, Field
from typing import List, Dict, Optional, Any
from datetime import datetime

class FarmerProfile(BaseModel):
    id: Optional[str] = None
    name: str
    phone: str
    location: str
    state: Optional[str] = "Maharashtra"
    district: Optional[str] = "Nashik"
    latitude: Optional[float] = None
    longitude: Optional[float] = None
    main_crop: str
    preferred_language: Optional[str] = "en" # en, mr, hi, ta, gu, kn

class CropItem(BaseModel):
    id: str
    name_en: str
    name_hi: Optional[str] = None
    name_mr: Optional[str] = None
    category: str
    water_requirement: Optional[str] = None
    growing_season: Optional[str] = None
    expected_yield: Optional[str] = None
    suitable_soils: List[str] = []
    icon_name: Optional[str] = "eco"

class ProblemCategory(BaseModel):
    id: str
    name_en: str
    name_hi: Optional[str] = None
    name_mr: Optional[str] = None
    icon_name: str
    description: Optional[str] = None
    display_order: int = 0

class QuestionOption(BaseModel):
    id: str
    question_id: str
    option_value: str
    label_en: str
    label_hi: Optional[str] = None
    label_mr: Optional[str] = None
    icon_name: Optional[str] = None
    display_order: int = 0
    next_question_id: Optional[str] = None # For dynamic branching

class Question(BaseModel):
    id: str
    category_id: str
    step_number: int
    question_text_en: str
    question_text_hi: Optional[str] = None
    question_text_mr: Optional[str] = None
    subtitle_en: Optional[str] = None
    subtitle_hi: Optional[str] = None
    param_key: str
    options: List[QuestionOption] = []

class AdvisoryEvaluationRequest(BaseModel):
    category_id: str
    answers: Dict[str, str] # e.g. {"crop": "Tomato", "symptom": "Yellow leaves", "duration": "4-7 days"}
    farmer_id: Optional[str] = None
    location: Optional[str] = "Nashik, Maharashtra"

class AdvisoryResultResponse(BaseModel):
    match_found: bool
    rule_id: Optional[str] = None
    problem_identified: str
    severity: str = "Medium" # Low, Medium, High, Critical
    possible_cause: str
    recommended_actions: List[str]
    precautions: str
    weather_consideration: Optional[str] = None
    collected_inputs: Dict[str, str]

class HourlyForecast(BaseModel):
    time: str
    temp: float
    pop: int # Rain probability %

class DailyForecast(BaseModel):
    day: str
    temp_max: float
    temp_min: float
    condition: str
    rain_probability: int

class WeatherResponse(BaseModel):
    location: str
    district: Optional[str] = "Nashik"
    state: Optional[str] = "Maharashtra"
    temperature: float
    feels_like: float
    humidity: int
    rainfall_mm: float
    rain_probability: int
    wind_speed_kmh: float
    condition: str
    uv_index: float
    sunrise: Optional[str] = "06:15 AM"
    sunset: Optional[str] = "06:45 PM"
    farming_advisory: str
    alert_level: Optional[str] = "Normal" # Normal, Advisory, Severe
    forecast: List[HourlyForecast] = []
    multi_day_forecast: List[DailyForecast] = []
    enso_status: Optional[Dict[str, Any]] = None
    smart_alerts: List[Dict[str, Any]] = []

class CropRecommendationRequest(BaseModel):
    soil_type: str
    location: str
    water_availability: str
    season: str

class RecommendedCropItem(BaseModel):
    crop_name: str
    suitability_score: int
    water_requirement: str
    expected_yield: str
    season_fit: str
    growing_tips: str

class CropRecommendationResponse(BaseModel):
    recommended_crops: List[RecommendedCropItem]
    soil_type: str
    location: str

class PossibleIssueItem(BaseModel):
    name: str
    confidence: float
    reason: str

class DiseaseScanRequest(BaseModel):
    crop_name: Optional[str] = None
    image_base64_or_url: str
    farmer_id: Optional[str] = None
    location: Optional[str] = "Nashik, Maharashtra"
    latitude: Optional[float] = None
    longitude: Optional[float] = None
    language: Optional[str] = "en"

class DiseaseScanResponse(BaseModel):
    scan_id: str
    image_url: Optional[str] = None
    image_quality: str = "good" # good, fair, poor
    crop_name: str
    predicted_issue: str # Primary identified issue name e.g. "Possible Early Blight"
    confidence_score: float # e.g. 78.5%
    uncertainty_level: str # Low, Medium, High
    visible_symptoms: List[str] = []
    possible_issues: List[PossibleIssueItem] = []
    severity: str = "Moderate" # Low, Moderate, High, Critical
    possible_causes: List[str] = []
    recommended_next_steps: List[str] = []
    preventive_measures: List[str] = []
    weather_context: Optional[str] = None
    rule_advisory: Optional[str] = None
    disclaimer: str = "This is an image-based preliminary assessment and is not a confirmed diagnosis."
    requires_expert: bool = False

class ExpertQuestionCreate(BaseModel):
    request_id: str
    question: str
    question_type: str = "multiple_choice" # multiple_choice, text
    options: Optional[List[str]] = None # e.g. ["Slow", "Moderate", "Rapid"]

class ExpertQuestionResponse(BaseModel):
    id: str
    request_id: str
    question: str
    question_type: str
    options: Optional[List[str]] = None
    created_at: str

class ExpertAnswerCreate(BaseModel):
    question_id: str
    user_id: Optional[str] = None
    answer: str

class ExpertAnswerResponse(BaseModel):
    id: str
    question_id: str
    user_id: Optional[str] = None
    answer: str
    created_at: str

class ExpertResponseCreate(BaseModel):
    request_id: str
    expert_id: Optional[str] = "EXP-101"
    expert_name: str
    response: str

class ExpertRequestCreate(BaseModel):
    farmer_id: Optional[str] = None
    farmer_name: str
    phone: Optional[str] = None
    location: str
    crop: str
    problem_category: Optional[str] = None
    description: str
    image_url: Optional[str] = None
    collected_inputs: Optional[Dict[str, str]] = None
    request_type: Optional[str] = "general" # general, disease_scan
    disease_scan_id: Optional[str] = None
    gemini_analysis: Optional[Dict[str, Any]] = None
    weather_context: Optional[str] = None

class ExpertRequestResponse(BaseModel):
    id: str
    farmer_id: Optional[str] = None
    farmer_name: str
    phone: Optional[str] = None
    location: str
    crop: str
    problem_category: Optional[str] = None
    description: str
    image_url: Optional[str] = None
    collected_inputs: Optional[Dict[str, str]] = None
    request_type: str = "general"
    disease_scan_id: Optional[str] = None
    gemini_analysis: Optional[Dict[str, Any]] = None
    weather_context: Optional[str] = None
    priority: Optional[str] = "Normal"
    status: str # Pending, In Review, More Information Required, Resolved
    expert_id: Optional[str] = None
    expert_response: Optional[str] = None
    expert_name: Optional[str] = None
    internal_notes: Optional[str] = None
    questions: List[ExpertQuestionResponse] = []
    answers: List[ExpertAnswerResponse] = []
    created_at: str


class ExpertStatusUpdate(BaseModel):
    status: str # Pending, In Review, Resolved
    internal_notes: Optional[str] = None

class ExpertResponseUpdate(BaseModel):
    expert_name: str
    expert_response: str
    status: str = "Resolved"
    internal_notes: Optional[str] = None

class AppNotification(BaseModel):
    id: str
    farmer_id: Optional[str] = None
    request_id: Optional[str] = None
    title: str
    message: str
    type: str = "status_update"
    is_read: bool = False
    created_at: str

class UserRegister(BaseModel):
    name: str
    phone: str
    password: str
    role: str = "FARMER" # FARMER, EXPERT, ADMIN
    location: Optional[str] = "Nashik, Maharashtra"
    main_crop: Optional[str] = "Tomato"
    preferred_language: Optional[str] = "en"

class UserLogin(BaseModel):
    phone: str
    password: str

class UserResponse(BaseModel):
    id: str
    name: str
    phone: str
    role: str
    location: str
    main_crop: str
    preferred_language: str
    created_at: str

class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    user: UserResponse

# ==================================================
# CLIMATE & ENSO MODULE MODELS
# ==================================================
class ClimateStatusResponse(BaseModel):
    enso_phase: str
    enso_phase_hi: Optional[str] = None
    enso_phase_mr: Optional[str] = None
    risk_level: str
    summary: str
    summary_hi: Optional[str] = None
    summary_mr: Optional[str] = None
    iod_phase: str = "Neutral"
    confidence: str = "High"
    source: str
    updated_at: str

class ClimateRiskBreakdown(BaseModel):
    heat_stress_risk: str
    water_stress_risk: str
    rainfall_variability_risk: str
    disease_conduciveness_risk: str

class CropClimateImpactRequest(BaseModel):
    crop: str = "Tomato"
    location: Optional[str] = "Nashik, Maharashtra"
    growth_stage: Optional[str] = "Vegetative"
    latitude: Optional[float] = None
    longitude: Optional[float] = None

class CropClimateImpactResponse(BaseModel):
    overall_risk_level: str
    enso_phase: str
    iod_phase: str
    risk_breakdown: ClimateRiskBreakdown
    crop_evaluated: str
    growth_stage_evaluated: str
    summary_advisory: str
    potential_risks: List[str]
    recommended_actions: List[str]
    precautionary_guidance: List[str]
    disclaimer: str

class WhatIfScenarioItem(BaseModel):
    id: str
    question: str
    potential_impact: str
    what_to_monitor: str
    recommended_preparation: List[str]

class WhatIfScenarioResponse(BaseModel):
    scenarios: List[WhatIfScenarioItem]
    crop: str
    location: str


