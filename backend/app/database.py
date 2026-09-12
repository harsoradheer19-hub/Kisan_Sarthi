import os
import json
import uuid
from typing import List, Dict, Optional, Any
from datetime import datetime

from .models import (
    ProblemCategory, Question, QuestionOption, ExpertRequestResponse, ExpertRequestCreate,
    CropItem, AppNotification, DiseaseScanResponse, ExpertQuestionCreate, ExpertQuestionResponse,
    ExpertAnswerCreate, ExpertAnswerResponse, ExpertResponseCreate, UserRegister, UserResponse
)
from .auth import hash_password

DB_FILE_PATH = os.path.join(os.path.dirname(__file__), "..", "kisan_sarthi_db.json")

class PersistentDatabase:
    def __init__(self):
        self.db_file = os.path.abspath(DB_FILE_PATH)
        self.users: List[Dict[str, Any]] = []
        self.categories: List[ProblemCategory] = []
        self.crops: List[CropItem] = []
        self.questions: Dict[str, List[Question]] = {}
        self.expert_requests: List[ExpertRequestResponse] = []
        self.notifications: List[AppNotification] = []
        self.disease_scans: List[DiseaseScanResponse] = []
        self.expert_questions: List[ExpertQuestionResponse] = []
        self.expert_answers: List[ExpertAnswerResponse] = []
        self.advisory_history: List[Dict[str, Any]] = []

        self._initialize_seed_data()
        self._load_from_disk()

    def _initialize_seed_data(self):
        """Seed default 25+ crops, categories, dynamic question trees, and default accounts."""
        self.categories = [
            ProblemCategory(id="pest_problem", name_en="Pest Problem", name_hi="कीट समस्या", name_mr="कीट समस्या", icon_name="bug_report", description="Insects, caterpillars, beetles, or worms damaging crops", display_order=1),
            ProblemCategory(id="leaf_problem", name_en="Leaf / Plant Symptoms", name_hi="पत्ती / पौधा समस्या", name_mr="पाने / रोपांची लक्षणे", icon_name="energy_savings_leaf", description="Yellow leaves, dark spots, wilting, or blighted foliage", display_order=2),
            ProblemCategory(id="water_problem", name_en="Water & Soil Stress", name_hi="जल एवं मृदा तनाव", name_mr="पाणी आणि मातीचा ताण", icon_name="water_drop", description="Overwatering, drought, soil compaction, or nutrient deficiency", display_order=3),
            ProblemCategory(id="growth_problem", name_en="Growth & Flowering Issue", name_hi="वृद्धि एवं फूल समस्या", name_mr="वाढ आणि फुलण्याची समस्या", icon_name="potted_plant", description="Stunted growth, flower drop, poor fruit set, or delayed maturity", display_order=4),
            ProblemCategory(id="disease_symptoms", name_en="Fungal & Bacterial Disease", name_hi="रोग के लक्षण", name_mr="बुरशीजन्य आणि जिवाणू रोग", icon_name="coronavirus", description="Fungal coating, rust pustules, rot, or discharge", display_order=5),
            ProblemCategory(id="other", name_en="Other Farming Issue", name_hi="अन्य समस्या", name_mr="इतर शेती समस्या", icon_name="help_outline", description="General agricultural inquiries or unlisted issues", display_order=6)
        ]

        self.crops = [
            # Cereals (5)
            CropItem(id="rice", name_en="Rice / Paddy", name_hi="धान / चावल", name_mr="भात / धान", category="Cereals", water_requirement="High (1200-1400 mm)", growing_season="Kharif (June - Nov)", expected_yield="20-25 Quintals / Acre", suitable_soils=["Clay", "Loamy", "Alluvial"], icon_name="grass"),
            CropItem(id="wheat", name_en="Wheat", name_hi="गेहूं", name_mr="गहू", category="Cereals", water_requirement="Medium (450-650 mm)", growing_season="Rabi (Oct - March)", expected_yield="18-22 Quintals / Acre", suitable_soils=["Alluvial", "Clay Loam"], icon_name="grain"),
            CropItem(id="maize", name_en="Maize / Corn", name_hi="मक्का", name_mr="मका", category="Cereals", water_requirement="Medium (500-750 mm)", growing_season="Kharif / Rabi", expected_yield="25-30 Quintals / Acre", suitable_soils=["Loamy", "Deep Black"], icon_name="grain"),
            CropItem(id="bajra", name_en="Pearl Millet (Bajra)", name_hi="बाजरा", name_mr="बाजरा", category="Cereals", water_requirement="Low (250-400 mm)", growing_season="Kharif (July - Oct)", expected_yield="10-14 Quintals / Acre", suitable_soils=["Sandy", "Light Soil"], icon_name="grain"),
            CropItem(id="jowar", name_en="Sorghum (Jowar)", name_hi="ज्वार", name_mr="ज्वारी", category="Cereals", water_requirement="Low (300-500 mm)", growing_season="Kharif / Rabi", expected_yield="12-16 Quintals / Acre", suitable_soils=["Black Soil", "Clay Loam"], icon_name="grass"),

            # Pulses (4)
            CropItem(id="chickpea", name_en="Chickpea (Chana)", name_hi="चना", name_mr="हरभरा", category="Pulses", water_requirement="Low (250-350 mm)", growing_season="Rabi (Oct - March)", expected_yield="8-10 Quintals / Acre", suitable_soils=["Black Cotton", "Loam"], icon_name="spa"),
            CropItem(id="tur", name_en="Pigeon Pea (Tur / Arhar)", name_hi="अरहर / तुअर", name_mr="तूर", category="Pulses", water_requirement="Medium (400-600 mm)", growing_season="Kharif (June - Jan)", expected_yield="7-9 Quintals / Acre", suitable_soils=["Well Drained Medium Black"], icon_name="eco"),
            CropItem(id="moong", name_en="Green Gram (Moong)", name_hi="मूंग", name_mr="मूग", category="Pulses", water_requirement="Low (300-400 mm)", growing_season="Kharif / Summer", expected_yield="5-7 Quintals / Acre", suitable_soils=["Loamy", "Alluvial"], icon_name="eco"),
            CropItem(id="urad", name_en="Black Gram (Urad)", name_hi="उड़द", name_mr="उडीद", category="Pulses", water_requirement="Low (300-400 mm)", growing_season="Kharif (July - Oct)", expected_yield="5-7 Quintals / Acre", suitable_soils=["Heavy Clay", "Loam"], icon_name="eco"),

            # Oilseeds (4)
            CropItem(id="soybean", name_en="Soybean", name_hi="सोयाबीन", name_mr="सोयाबीन", category="Oilseeds", water_requirement="Medium (450-700 mm)", growing_season="Kharif (June - Oct)", expected_yield="10-12 Quintals / Acre", suitable_soils=["Deep Black", "Loam"], icon_name="grain"),
            CropItem(id="groundnut", name_en="Groundnut / Peanut", name_hi="मूंगफली", name_mr="भुईमूग", category="Oilseeds", water_requirement="Medium (500-600 mm)", growing_season="Kharif / Summer", expected_yield="12-15 Quintals / Acre", suitable_soils=["Sandy Loam", "Red Soil"], icon_name="spa"),
            CropItem(id="mustard", name_en="Mustard", name_hi="सरसों", name_mr="मोहरी", category="Oilseeds", water_requirement="Low (250-400 mm)", growing_season="Rabi (Oct - Feb)", expected_yield="7-9 Quintals / Acre", suitable_soils=["Loam", "Alluvial"], icon_name="eco"),
            CropItem(id="sunflower", name_en="Sunflower", name_hi="सूरजमुखी", name_mr="सूर्यफूल", category="Oilseeds", water_requirement="Medium (500-650 mm)", growing_season="Kharif / Rabi", expected_yield="8-10 Quintals / Acre", suitable_soils=["Black Soil", "Red Soil"], icon_name="filter_vintage"),

            # Cash Crops (2)
            CropItem(id="cotton", name_en="Cotton", name_hi="कपास", name_mr="कापूस", category="Cash Crops", water_requirement="Medium (500-700 mm)", growing_season="Kharif (May - Nov)", expected_yield="12-15 Quintals / Acre", suitable_soils=["Deep Black Cotton Soil"], icon_name="dry_cleaning"),
            CropItem(id="sugarcane", name_en="Sugarcane", name_hi="गन्ना", name_mr="ऊस", category="Cash Crops", water_requirement="High (1500-2500 mm)", growing_season="Annual (12-14 Months)", expected_yield="40-50 Tons / Acre", suitable_soils=["Heavy Clay", "Loam"], icon_name="grass"),

            # Vegetables (6)
            CropItem(id="tomato", name_en="Tomato", name_hi="टमाटर", name_mr="टोमॅटो", category="Vegetables", water_requirement="High (Drip 400-600 mm)", growing_season="Round the Year", expected_yield="25-30 Tons / Acre", suitable_soils=["Sandy Loam", "Red Soil"], icon_name="nutrition"),
            CropItem(id="onion", name_en="Onion", name_hi="प्याज", name_mr="कांदा", category="Vegetables", water_requirement="Medium (350-500 mm)", growing_season="Kharif / Late Kharif / Rabi", expected_yield="10-12 Tons / Acre", suitable_soils=["Deep Red Soil", "Sandy Loam"], icon_name="eco"),
            CropItem(id="potato", name_en="Potato", name_hi="आलू", name_mr="बटाटा", category="Vegetables", water_requirement="Medium (400-500 mm)", growing_season="Rabi (Oct - Feb)", expected_yield="12-15 Tons / Acre", suitable_soils=["Loam", "Alluvial"], icon_name="spa"),
            CropItem(id="chilli", name_en="Chilli", name_hi="मिर्च", name_mr="मिरची", category="Vegetables", water_requirement="Medium (400-600 mm)", growing_season="Kharif / Rabi", expected_yield="6-8 Quintals (Dry) / Acre", suitable_soils=["Black Soil", "Red Loam"], icon_name="eco"),
            CropItem(id="brinjal", name_en="Brinjal / Eggplant", name_hi="बैंगन", name_mr="वांगी", category="Vegetables", water_requirement="Medium (450-600 mm)", growing_season="Round the Year", expected_yield="15-18 Tons / Acre", suitable_soils=["Silt Loam", "Clay Loam"], icon_name="nutrition"),
            CropItem(id="okra", name_en="Okra (Ladyfinger)", name_hi="भिंडी", name_mr="भेंडी", category="Vegetables", water_requirement="Medium (350-500 mm)", growing_season="Kharif / Summer", expected_yield="6-8 Tons / Acre", suitable_soils=["Loam", "Sandy Silt"], icon_name="eco"),

            # Fruits (4)
            CropItem(id="banana", name_en="Banana", name_hi="केला", name_mr="केळी", category="Fruits", water_requirement="High (1800-2000 mm)", growing_season="Perennial (11-12 Months)", expected_yield="30-35 Tons / Acre", suitable_soils=["Deep Rich Soil"], icon_name="eco"),
            CropItem(id="mango", name_en="Mango", name_hi="आम", name_mr="आंबा", category="Fruits", water_requirement="Medium (750-1000 mm)", growing_season="Perennial", expected_yield="5-8 Tons / Acre", suitable_soils=["Deep Alluvial", "Red Loam"], icon_name="eco"),
            CropItem(id="grapes", name_en="Grapes", name_hi="अंगूर", name_mr="द्राक्षे", category="Fruits", water_requirement="High (Drip 600-800 mm)", growing_season="Perennial", expected_yield="12-15 Tons / Acre", suitable_soils=["Well Drained Sandy Loam"], icon_name="wine_bar"),
            CropItem(id="pomegranate", name_en="Pomegranate", name_hi="अनार", name_mr="डाळिंब", category="Fruits", water_requirement="Low-Medium (500-600 mm)", growing_season="Perennial", expected_yield="6-8 Tons / Acre", suitable_soils=["Medium Black", "Loam"], icon_name="eco")
        ]

        # Dynamic Question Trees for all Problem Categories
        crop_options_list = [
            QuestionOption(id="opt_c_1", question_id="q_crop", option_value="Cotton", label_en="Cotton (कपास / कापूस)", label_mr="कापूस", icon_name="dry_cleaning", display_order=1),
            QuestionOption(id="opt_c_2", question_id="q_crop", option_value="Sugarcane", label_en="Sugarcane (गन्ना / ऊस)", label_mr="ऊस", icon_name="grass", display_order=2),
            QuestionOption(id="opt_c_3", question_id="q_crop", option_value="Rice", label_en="Rice (धान / भात)", label_mr="भात", icon_name="grass", display_order=3),
            QuestionOption(id="opt_c_4", question_id="q_crop", option_value="Wheat", label_en="Wheat (गेहूं / गहू)", label_mr="गहू", icon_name="grain", display_order=4),
            QuestionOption(id="opt_c_5", question_id="q_crop", option_value="Tomato", label_en="Tomato (टमाटर / टोमॅटो)", label_mr="टोमॅटो", icon_name="nutrition", display_order=5),
            QuestionOption(id="opt_c_6", question_id="q_crop", option_value="Onion", label_en="Onion (प्याज / कांदा)", label_mr="कांदा", icon_name="eco", display_order=6),
            QuestionOption(id="opt_c_7", question_id="q_crop", option_value="Potato", label_en="Potato (आलू / बटाटा)", label_mr="बटाटा", icon_name="spa", display_order=7),
            QuestionOption(id="opt_c_8", question_id="q_crop", option_value="Soybean", label_en="Soybean (सोयाबीन)", label_mr="सोयाबीन", icon_name="grain", display_order=8),
            QuestionOption(id="opt_c_9", question_id="q_crop", option_value="Maize", label_en="Maize (मक्का / मका)", label_mr="मका", icon_name="grain", display_order=9),
            QuestionOption(id="opt_c_10", question_id="q_crop", option_value="Groundnut", label_en="Groundnut (मूंगफली / भुईमूग)", label_mr="भुईमूग", icon_name="spa", display_order=10),
            QuestionOption(id="opt_c_11", question_id="q_crop", option_value="Chickpea", label_en="Chickpea (चना / हरभरा)", label_mr="हरभरा", icon_name="spa", display_order=11),
            QuestionOption(id="opt_c_12", question_id="q_crop", option_value="Pigeon Pea", label_en="Pigeon Pea (तुअर / तूर)", label_mr="तूर", icon_name="eco", display_order=12),
            QuestionOption(id="opt_c_13", question_id="q_crop", option_value="Banana", label_en="Banana (केला / केळी)", label_mr="केळी", icon_name="eco", display_order=13),
            QuestionOption(id="opt_c_14", question_id="q_crop", option_value="Mango", label_en="Mango (आम / आंबा)", label_mr="आंबा", icon_name="eco", display_order=14),
            QuestionOption(id="opt_c_15", question_id="q_crop", option_value="Chilli", label_en="Chilli (मिर्च / मिरची)", label_mr="मिरची", icon_name="eco", display_order=15),
            QuestionOption(id="opt_c_16", question_id="q_crop", option_value="Brinjal", label_en="Brinjal (बैंगन / वांगी)", label_mr="वांगी", icon_name="nutrition", display_order=16),
            QuestionOption(id="opt_c_17", question_id="q_crop", option_value="Okra", label_en="Okra (भिंडी / भेंडी)", label_mr="भेंडी", icon_name="eco", display_order=17),
        ]

        self.questions = {
            "pest_problem": [
                Question(
                    id="q_pest_1", category_id="pest_problem", step_number=1,
                    question_text_en="Which crop is affected by pest?",
                    question_text_hi="किस फसल पर कीट का प्रकोप है?",
                    question_text_mr="कोणत्या पिकावर किडीचा प्रादुर्भाव आहे?",
                    subtitle_en="Select affected crop", param_key="crop",
                    options=crop_options_list
                ),
                Question(
                    id="q_pest_2", category_id="pest_problem", step_number=2,
                    question_text_en="What pest damage symptom are you seeing?",
                    question_text_hi="कीट का क्या लक्षण दिखाई दे रहा है?",
                    question_text_mr="किडीचे काय लक्षण दिसत आहे?",
                    subtitle_en="Identify how the insect is affecting your crop", param_key="symptom",
                    options=[
                        QuestionOption(id="opt_p2_1", question_id="q_pest_2", option_value="Chewed leaves & visible caterpillars", label_en="Chewed leaves & caterpillars", label_mr="कुतडलेली पाने आणि अळ्या", icon_name="pest_control", display_order=1),
                        QuestionOption(id="opt_p2_2", question_id="q_pest_2", option_value="Whiteflies / Thrips / Sucking insects", label_en="Whiteflies / Thrips under leaf", label_mr="माशी / थ्रिप्स / पांढरी कीड", icon_name="bug_report", display_order=2),
                        QuestionOption(id="opt_p2_3", question_id="q_pest_2", option_value="Stem borer holes / Dead central shoot", label_en="Stem borer / Dead heart shoot", label_mr="खोडाला छिद्रे / मेलेला गाभा", icon_name="grass", display_order=3),
                        QuestionOption(id="opt_p2_4", question_id="q_pest_2", option_value="Holes inside fruit / pod borer rot", label_en="Borer holes in fruit / pod", label_mr="फळ / शेंगा मध्ये छिद्रे", icon_name="spa", display_order=4)
                    ]
                ),
                Question(
                    id="q_pest_3", category_id="pest_problem", step_number=3,
                    question_text_en="How long has the pest issue been visible?",
                    question_text_hi="यह कीट प्रकोप कितने समय से है?",
                    question_text_mr="हा कीड प्रादुर्भाव किती दिवसांपासून दिसत आहे?",
                    subtitle_en="Select duration of infestation", param_key="duration",
                    options=[
                        QuestionOption(id="opt_p3_1", question_id="q_pest_3", option_value="1-3 days", label_en="1–3 days (Early stage)", label_mr="१-३ दिवस (सुरुवातीचा टप्पा)", icon_name="schedule", display_order=1),
                        QuestionOption(id="opt_p3_2", question_id="q_pest_3", option_value="4-7 days", label_en="4–7 days (Moderate spreading)", label_mr="४-७ दिवस (मध्यम प्रसार)", icon_name="date_range", display_order=2),
                        QuestionOption(id="opt_p3_3", question_id="q_pest_3", option_value="More than a week", label_en="More than a week (Severe)", label_mr="एका आठवड्यापेक्षा जास्त (गंभीर)", icon_name="history", display_order=3)
                    ]
                )
            ],
            "leaf_problem": [
                Question(
                    id="q_leaf_1", category_id="leaf_problem", step_number=1,
                    question_text_en="Which crop has leaf symptoms?",
                    question_text_hi="किस फसल की पत्तियों में समस्या है?",
                    question_text_mr="कोणत्या पिकाच्या पानांवर समस्या आहे?",
                    subtitle_en="Select affected crop", param_key="crop",
                    options=crop_options_list
                ),
                Question(
                    id="q_leaf_2", category_id="leaf_problem", step_number=2,
                    question_text_en="What observe on the leaves?",
                    question_text_hi="पत्तियों पर क्या दिखाई दे रहा है?",
                    question_text_mr="पानांवर काय दिसत आहे?",
                    subtitle_en="Select primary leaf symptom", param_key="symptom",
                    options=[
                        QuestionOption(id="opt_l2_1", question_id="q_leaf_2", option_value="Yellowing leaves & chlorosis", label_en="Yellowing / Chlorosis", label_mr="पाने पिवळी पडणे", icon_name="energy_savings_leaf", display_order=1),
                        QuestionOption(id="opt_l2_2", question_id="q_leaf_2", option_value="Dark brown or purple spots with rings", label_en="Dark brown / Purple spots", label_mr="तपकिरी / जांभळे ठिपके", icon_name="blur_on", display_order=2),
                        QuestionOption(id="opt_l2_3", question_id="q_leaf_2", option_value="Upward or downward leaf curling", label_en="Leaf curling & crinkling", label_mr="पाने गुंडाळणे / चुरडा-मुरडा", icon_name="gesture", display_order=3),
                        QuestionOption(id="opt_l2_4", question_id="q_leaf_2", option_value="Wilting & drying foliage", label_en="Wilting & drooping leaves", label_mr="पाने सुकणे व कोमेजणे", icon_name="water_drop", display_order=4)
                    ]
                ),
                Question(
                    id="q_leaf_3", category_id="leaf_problem", step_number=3,
                    question_text_en="Which part of the plant is most affected?",
                    question_text_hi="पौधे का कौन सा भाग सबसे ज्यादा प्रभावित है?",
                    question_text_mr="झाडाचा कोणता भाग सर्वाधिक प्रभावित आहे?",
                    subtitle_en="Select location of leaf symptoms", param_key="affected_area",
                    options=[
                        QuestionOption(id="opt_l3_1", question_id="q_leaf_3", option_value="Lower older leaves", label_en="Lower older leaves", label_mr="खालची जुनी पाने", icon_name="vertical_align_bottom", display_order=1),
                        QuestionOption(id="opt_l3_2", question_id="q_leaf_3", option_value="Top new shoots", label_en="Top young shoots", label_mr="वरचे नवीन कोंब", icon_name="vertical_align_top", display_order=2),
                        QuestionOption(id="opt_l3_3", question_id="q_leaf_3", option_value="Whole canopy spreading", label_en="Whole plant canopy", label_mr="संपूर्ण रोप", icon_name="select_all", display_order=3)
                    ]
                )
            ],
            "water_problem": [
                Question(
                    id="q_water_1", category_id="water_problem", step_number=1,
                    question_text_en="Which crop is facing soil or water stress?",
                    question_text_hi="किस फसल में पानी या मिट्टी का तनाव है?",
                    question_text_mr="कोणत्या पिकात पाणी किंवा मातीचा ताण आहे?",
                    subtitle_en="Select crop facing stress", param_key="crop",
                    options=crop_options_list
                ),
                Question(
                    id="q_water_2", category_id="water_problem", step_number=2,
                    question_text_en="What water or soil condition is observed?",
                    question_text_hi="क्या जल या मृदा की स्थिति है?",
                    question_text_mr="पाण्याची किंवा मातीची काय परिस्थिती आहे?",
                    subtitle_en="Select moisture condition", param_key="symptom",
                    options=[
                        QuestionOption(id="opt_w2_1", question_id="q_water_2", option_value="Waterlogging & stagnant water", label_en="Waterlogging / Stagnant water", label_mr="पाणी साचणे", icon_name="water_drop", display_order=1),
                        QuestionOption(id="opt_w2_2", question_id="q_water_2", option_value="Drought & soil moisture deficiency", label_en="Severe drought / Soil cracking", label_mr="दुष्काळ / मातीला भेगा", icon_name="sunny", display_order=2),
                        QuestionOption(id="opt_w2_3", question_id="q_water_3", option_value="Leaf tip burning & salinity stress", label_en="Leaf tip burning / Salinity", label_mr="पानांची टोके जळणे", icon_name="local_fire_department", display_order=3)
                    ]
                )
            ],
            "growth_problem": [
                Question(
                    id="q_growth_1", category_id="growth_problem", step_number=1,
                    question_text_en="Which crop has growth or flowering issues?",
                    question_text_hi="किस फसल में वृद्धि या फूल झड़ने की समस्या है?",
                    question_text_mr="कोणत्या पिकात वाढ किंवा फुलधारणेची समस्या आहे?",
                    subtitle_en="Select crop", param_key="crop",
                    options=crop_options_list
                ),
                Question(
                    id="q_growth_2", category_id="growth_problem", step_number=2,
                    question_text_en="What specific growth anomaly is present?",
                    question_text_hi="वृद्धि में क्या असामान्यता है?",
                    question_text_mr="वाढीत काय अडचण दिसत आहे?",
                    subtitle_en="Identify growth issue", param_key="symptom",
                    options=[
                        QuestionOption(id="opt_g2_1", question_id="q_growth_2", option_value="Stunted plant height & short nodes", label_en="Stunted growth / Short height", label_mr="झाडाची वाढ खुंटणे", icon_name="height", display_order=1),
                        QuestionOption(id="opt_g2_2", question_id="q_growth_2", option_value="Excessive flower drop & poor fruit set", label_en="Flower drop / Poor fruit set", label_mr="फूले गळणे / फळधारणा न होणे", icon_name="local_florist", display_order=2),
                        QuestionOption(id="opt_g2_3", question_id="q_growth_2", option_value="Reddening or purpling of leaves (Magnesium)", label_en="Reddening / Purpling leaves", label_mr="पाने तांबडी / जांभळी होणे", icon_name="color_lens", display_order=3)
                    ]
                )
            ],
            "disease_symptoms": [
                Question(
                    id="q_dis_1", category_id="disease_symptoms", step_number=1,
                    question_text_en="Which crop shows disease signs?",
                    question_text_hi="किस फसल में रोग के लक्षण हैं?",
                    question_text_mr="कोणत्या पिकावर रोगाचे लक्षण आहे?",
                    subtitle_en="Select crop", param_key="crop",
                    options=crop_options_list
                ),
                Question(
                    id="q_dis_2", category_id="disease_symptoms", step_number=2,
                    question_text_en="What disease coating or rot is visible?",
                    question_text_hi="रोग का क्या लक्षण दिखाई दे रहा है?",
                    question_text_mr="रोगाचे काय लक्षण दिसत आहे?",
                    subtitle_en="Select fungal or bacterial sign", param_key="symptom",
                    options=[
                        QuestionOption(id="opt_d2_1", question_id="q_dis_2", option_value="White or gray powdery coating on leaves", label_en="White / Gray powdery mildew", label_mr="पांढरी किंवा करडी बुरशी", icon_name="grain", display_order=1),
                        QuestionOption(id="opt_d2_2", question_id="q_dis_2", option_value="Bright yellow or orange rust pustules", label_en="Yellow / Orange rust spots", label_mr="तांबेरा / पिवळे ठिपके", icon_name="palette", display_order=2),
                        QuestionOption(id="opt_d2_3", question_id="q_dis_2", option_value="Dark water-soaked rot with bad smell", label_en="Water-soaked rot / Stem rot", label_mr="पाणी साचून खोड कुजणे", icon_name="coronavirus", display_order=3)
                    ]
                )
            ],
            "other": [
                Question(
                    id="q_oth_1", category_id="other", step_number=1,
                    question_text_en="Select crop for query:",
                    question_text_hi="फसल चुनें:",
                    question_text_mr="पीक निवडा:",
                    subtitle_en="Select crop", param_key="crop",
                    options=crop_options_list
                ),
                Question(
                    id="q_oth_2", category_id="other", step_number=2,
                    question_text_en="What type of farming advice is needed?",
                    question_text_hi="किस प्रकार की सलाह चाहिए?",
                    question_text_mr="कोणत्या प्रकारचा सल्ला हवा आहे?",
                    subtitle_en="Select topic", param_key="symptom",
                    options=[
                        QuestionOption(id="opt_o2_1", question_id="q_oth_2", option_value="Fertilizer dose & nutrient schedule", label_en="Fertilizer & Nutrient Schedule", label_mr="खत व्यवस्थापन", icon_name="science", display_order=1),
                        QuestionOption(id="opt_o2_2", question_id="q_oth_2", option_value="Organic pest control & bio-pesticides", label_en="Organic / Bio-Pesticide Advice", label_mr="जैविक किटकनाशक सल्ला", icon_name="eco", display_order=2),
                        QuestionOption(id="opt_o2_3", question_id="q_oth_2", option_value="Yield enhancement & fruit sizing", label_en="Yield Enhancement & Quality", label_mr="उत्पादन वाढ व दर्जा", icon_name="trending_up", display_order=3)
                    ]
                )
            ]
        }

        self.expert_requests = [
            ExpertRequestResponse(
                id="KS-8921",
                farmer_name="Ramesh Patil",
                phone="9876543210",
                location="Nashik, Maharashtra",
                crop="Tomato",
                problem_category="Leaf / Plant Symptoms",
                description="Leaves turning dark yellow with concentric brown rings. Lower foliage affected rapidly.",
                image_url=None,
                collected_inputs={"crop": "Tomato", "symptom": "Yellow leaves", "duration": "4-7 days"},
                priority="High",
                status="In Review",
                expert_response="Agronomist Dr. V. K. Sharma reviewing leaf sample details.",
                expert_name="Dr. V. K. Sharma (Senior Agronomist)",
                internal_notes="High humidity area near Niphad. Check for early blight spores.",
                created_at="2026-09-08 10:30 AM"
            )
        ]

        self.notifications = [
            AppNotification(
                id="NOTIF-101",
                farmer_id=None,
                request_id="KS-8921",
                title="Expert Request Assigned",
                message="Your request #KS-8921 has been assigned to Dr. V. K. Sharma (Status: In Review).",
                type="status_update",
                is_read=False,
                created_at="2026-09-08 10:35 AM"
            )
        ]

        self.users = [
            {
                "id": "USR-FARMER-1",
                "name": "Ramesh Patil",
                "phone": "9876543210",
                "password_hash": hash_password("farmer123"),
                "role": "FARMER",
                "location": "Nashik, Maharashtra",
                "main_crop": "Tomato",
                "preferred_language": "en",
                "created_at": "2026-09-01 10:00 AM"
            }
        ]

    def _load_from_disk(self):
        if os.path.exists(self.db_file):
            try:
                with open(self.db_file, "r", encoding="utf-8") as f:
                    data = json.load(f)
                    if "users" in data:
                        self.users = data["users"]
                    if "expert_requests" in data:
                        self.expert_requests = [ExpertRequestResponse(**r) for r in data["expert_requests"]]
                    if "notifications" in data:
                        self.notifications = [AppNotification(**n) for n in data["notifications"]]
                    if "disease_scans" in data:
                        self.disease_scans = [DiseaseScanResponse(**s) for s in data["disease_scans"]]
                    if "expert_questions" in data:
                        self.expert_questions = [ExpertQuestionResponse(**q) for q in data["expert_questions"]]
                    if "expert_answers" in data:
                        self.expert_answers = [ExpertAnswerResponse(**a) for a in data["expert_answers"]]
            except Exception as e:
                print(f"Error loading Kisan Sarthi database: {e}")

    def save_to_disk(self):
        try:
            data = {
                "users": self.users,
                "expert_requests": [r.model_dump() for r in self.expert_requests],
                "notifications": [n.model_dump() for n in self.notifications],
                "disease_scans": [s.model_dump() for s in self.disease_scans],
                "expert_questions": [q.model_dump() for q in self.expert_questions],
                "expert_answers": [a.model_dump() for a in self.expert_answers],
                "updated_at": datetime.now().isoformat()
            }
            with open(self.db_file, "w", encoding="utf-8") as f:
                json.dump(data, f, indent=2, ensure_ascii=False)
        except Exception as e:
            print(f"Error saving Kisan Sarthi database: {e}")

    def register_user(self, reg: UserRegister) -> UserResponse:
        existing = self.get_user_by_phone(reg.phone)
        if existing:
            raise ValueError("User with this phone number already registered.")
        
        user_id = f"USR-{uuid.uuid4().hex[:8].upper()}"
        created_at = datetime.now().strftime("%Y-%m-%d %I:%M %p")
        user_dict = {
            "id": user_id,
            "name": reg.name,
            "phone": reg.phone,
            "password_hash": hash_password(reg.password),
            "role": reg.role.upper(),
            "location": reg.location or "Nashik, Maharashtra",
            "main_crop": reg.main_crop or "Tomato",
            "preferred_language": reg.preferred_language or "en",
            "created_at": created_at
        }
        self.users.append(user_dict)
        self.save_to_disk()

        return UserResponse(
            id=user_id,
            name=user_dict["name"],
            phone=user_dict["phone"],
            role=user_dict["role"],
            location=user_dict["location"],
            main_crop=user_dict["main_crop"],
            preferred_language=user_dict["preferred_language"],
            created_at=created_at
        )

    def get_user_by_phone(self, phone: str) -> Optional[Dict[str, Any]]:
        for u in self.users:
            if u["phone"] == phone.strip():
                return u
        return None

    def get_user_by_id(self, user_id: str) -> Optional[UserResponse]:
        for u in self.users:
            if u["id"] == user_id:
                return UserResponse(
                    id=u["id"], name=u["name"], phone=u["phone"], role=u["role"],
                    location=u["location"], main_crop=u["main_crop"],
                    preferred_language=u["preferred_language"], created_at=u["created_at"]
                )
        return None

    def create_expert_request(self, req: ExpertRequestCreate) -> ExpertRequestResponse:
        req_id = f"KS-{len(self.expert_requests) + 8922}"
        new_item = ExpertRequestResponse(
            id=req_id,
            farmer_id=req.farmer_id,
            farmer_name=req.farmer_name,
            phone=req.phone or "9876543210",
            location=req.location,
            crop=req.crop,
            problem_category=req.problem_category or "Agricultural Query",
            description=req.description,
            image_url=req.image_url,
            collected_inputs=req.collected_inputs,
            request_type=req.request_type or "general",
            disease_scan_id=req.disease_scan_id,
            gemini_analysis=req.gemini_analysis,
            weather_context=req.weather_context,
            priority="High" if "urgent" in req.description.lower() or "severe" in req.description.lower() else "Normal",
            status="Pending",
            expert_response=None,
            expert_name=None,
            internal_notes=None,
            questions=[],
            answers=[],
            created_at=datetime.now().strftime("%Y-%m-%d %I:%M %p")
        )
        self.expert_requests.insert(0, new_item)

        self.notifications.insert(0, AppNotification(
            id=f"NOTIF-{len(self.notifications) + 103}",
            farmer_id=req.farmer_id,
            request_id=req_id,
            title="Expert Request Submitted",
            message=f"Request #{req_id} for {req.crop} submitted successfully. An agronomist will review shortly.",
            type="status_update",
            is_read=False,
            created_at=datetime.now().strftime("%Y-%m-%d %I:%M %p")
        ))
        self.save_to_disk()
        return new_item

    def get_expert_request_by_id(self, request_id: str) -> Optional[ExpertRequestResponse]:
        for req in self.expert_requests:
            if req.id.upper() == request_id.upper():
                req.questions = [q for q in self.expert_questions if q.request_id.upper() == request_id.upper()]
                question_ids = [q.id for q in req.questions]
                req.answers = [a for a in self.expert_answers if a.question_id in question_ids]
                return req
        return None

    def create_expert_question(self, q_create: ExpertQuestionCreate) -> Optional[ExpertQuestionResponse]:
        req = self.get_expert_request_by_id(q_create.request_id)
        if not req:
            return None
        
        q_id = f"EQ-{uuid.uuid4().hex[:8].upper()}"
        q_obj = ExpertQuestionResponse(
            id=q_id,
            request_id=q_create.request_id,
            question=q_create.question,
            question_type=q_create.question_type,
            options=q_create.options,
            created_at=datetime.now().strftime("%Y-%m-%d %I:%M %p")
        )
        self.expert_questions.append(q_obj)
        
        req.status = "More Information Required"
        
        self.notifications.insert(0, AppNotification(
            id=f"NOTIF-{len(self.notifications) + 200}",
            request_id=req.id,
            title="Expert Question Received",
            message=f"Agronomist asked a question regarding Request #{req.id}: '{q_create.question}'",
            type="expert_reply",
            is_read=False,
            created_at=datetime.now().strftime("%Y-%m-%d %I:%M %p")
        ))
        self.save_to_disk()
        return q_obj

    def answer_expert_question(self, a_create: ExpertAnswerCreate) -> Optional[ExpertAnswerResponse]:
        a_id = f"EA-{uuid.uuid4().hex[:8].upper()}"
        a_obj = ExpertAnswerResponse(
            id=a_id,
            question_id=a_create.question_id,
            user_id=a_create.user_id,
            answer=a_create.answer,
            created_at=datetime.now().strftime("%Y-%m-%d %I:%M %p")
        )
        self.expert_answers.append(a_obj)
        
        for q in self.expert_questions:
            if q.id == a_create.question_id:
                req = self.get_expert_request_by_id(q.request_id)
                if req:
                    req.status = "In Review"
                break

        self.save_to_disk()
        return a_obj

    def update_expert_request_status(self, request_id: str, status: str, internal_notes: Optional[str] = None) -> Optional[ExpertRequestResponse]:
        for req in self.expert_requests:
            if req.id.upper() == request_id.upper():
                req.status = status
                if internal_notes:
                    req.internal_notes = internal_notes
                
                self.notifications.insert(0, AppNotification(
                    id=f"NOTIF-{len(self.notifications) + 104}",
                    request_id=request_id,
                    title=f"Request Status: {status}",
                    message=f"Your Expert Request #{request_id} is now '{status}'.",
                    type="status_update",
                    is_read=False,
                    created_at=datetime.now().strftime("%Y-%m-%d %I:%M %p")
                ))
                self.save_to_disk()
                return req
        return None

db = PersistentDatabase()
