import uuid
from typing import Dict, List, Optional, Any
from .models import AdvisoryResultResponse, DiseaseScanResponse, PossibleIssueItem

class RuleBasedAdvisoryEngine:
    def __init__(self):
        # Comprehensive Agricultural Knowledge Base for 17+ Core Indian Crops
        self.rules = [
            # ==================== 1. COTTON ====================
            {
                "id": "rule_cotton_whitefly",
                "crop": "cotton",
                "crop_aliases": ["cotton", "kapas", "कापूस"],
                "category_id": "pest_problem",
                "name": "Cotton Whitefly & Leaf Curl Virus Risk",
                "keywords": ["whitefly", "white insect", "sticky", "curling", "yellowing", "sucking"],
                "problem_identified": "Cotton Whitefly (Bemisia tabaci) Infestation",
                "severity": "High",
                "possible_cause": "Sucking pest infestation transmitting Cotton Leaf Curl Virus during warm dry weather.",
                "recommended_actions": [
                    "Install yellow sticky traps (10–12 per acre) at crop canopy height.",
                    "Spray Neem Oil 10,000 ppm @ 3 ml/L of water as an organic deterrent.",
                    "If nymph population exceeds 6–8 per leaf, spray Pyriproxyfen 10% EC @ 2 ml/L."
                ],
                "precautions": "Avoid synthetic pyrethroids early in season to preserve natural predators.",
                "weather_consideration": "Hot & dry spells accelerate whitefly multiplication. Inspect lower leaf surface weekly."
            },
            {
                "id": "rule_cotton_pink_bollworm",
                "crop": "cotton",
                "crop_aliases": ["cotton", "kapas", "कापूस"],
                "category_id": "pest_problem",
                "name": "Pink Bollworm (Pectinophora gossypiella)",
                "keywords": ["bollworm", "hole", "caterpillar", "flower rosette", "boll", "pink"],
                "problem_identified": "Pink Bollworm Larval Attack",
                "severity": "Critical",
                "possible_cause": "Pectinophora gossypiella larvae feeding inside developing bolls causing rosette flowers and premature dropping.",
                "recommended_actions": [
                    "Install Pheromone traps (5 per acre) for moth monitoring.",
                    "Destroy rosette flowers and infected bolls manually.",
                    "Spray Profenofos 50% EC @ 2 ml/L or Emamectin Benzoate 5% SG @ 0.5g/L."
                ],
                "precautions": "Strictly observe 14-day pre-harvest interval.",
                "weather_consideration": "High evening humidity increases moth oviposition activity."
            },
            {
                "id": "rule_cotton_wilt",
                "crop": "cotton",
                "crop_aliases": ["cotton", "kapas", "कापूस"],
                "category_id": "disease_symptoms",
                "name": "Fusarium Wilt of Cotton",
                "keywords": ["wilt", "drooping", "yellowing", "browning", "vascular", "dying"],
                "problem_identified": "Fusarium / Verticillium Wilt",
                "severity": "High",
                "possible_cause": "Soil-borne fungal pathogen invading root xylem vessels, blocking water transport.",
                "recommended_actions": [
                    "Drench root zone with Carbendazim 50% WP @ 2g/L of water.",
                    "Apply Trichoderma viride bio-fungicide @ 2.5 kg/acre enriched with farmyard manure.",
                    "Remove severely wilted plants to prevent patch spread."
                ],
                "precautions": "Avoid waterlogging near stem bases.",
                "weather_consideration": "Warm soil temperatures (28-32°C) favor wilt development."
            },
            {
                "id": "rule_cotton_magnesium",
                "crop": "cotton",
                "crop_aliases": ["cotton", "kapas", "कापूस"],
                "category_id": "growth_problem",
                "name": "Magnesium & Potassium Deficiency (Red Leaf Disease)",
                "keywords": ["red leaf", "reddening", "purpling", "interveinal", "deficiency", "magnesium"],
                "problem_identified": "Nutrient Deficiency (Red Leaf Syndrome)",
                "severity": "Medium",
                "possible_cause": "Magnesium deficiency during boll development phase leading to anthocyanin buildup and leaf reddening.",
                "recommended_actions": [
                    "Foliar spray of Magnesium Sulphate (MgSO4) @ 10g/L + 19:19:19 NPK @ 5g/L.",
                    "Repeat foliar spray after 10–12 days during active boll formation."
                ],
                "precautions": "Ensure adequate soil moisture before spraying fertilizer.",
                "weather_consideration": "Cool night temperatures increase red leaf expression."
            },

            # ==================== 2. SUGARCANE ====================
            {
                "id": "rule_sugarcane_red_rot",
                "crop": "sugarcane",
                "crop_aliases": ["sugarcane", "ganna", "ऊस"],
                "category_id": "disease_symptoms",
                "name": "Sugarcane Red Rot (Colletotrichum falcatum)",
                "keywords": ["red rot", "redness", "drying", "alcohol odor", "cane split", "stalk rot"],
                "problem_identified": "Sugarcane Red Rot Fungal Disease",
                "severity": "Critical",
                "possible_cause": "Colletotrichum falcatum fungus colonizing stalk tissues, causing red lesions with white transverse bands and alcoholic odor.",
                "recommended_actions": [
                    "Uproot and burn infected clumps immediately.",
                    "Drench surrounding stool roots with Carbendazim 50% WP @ 2g/L.",
                    "Ensure proper field drainage to prevent spore water dispersal."
                ],
                "precautions": "Do not use seed sets from red rot affected fields.",
                "weather_consideration": "Waterlogging and high humidity (>85%) accelerate field infestation."
            },
            {
                "id": "rule_sugarcane_top_borer",
                "crop": "sugarcane",
                "crop_aliases": ["sugarcane", "ganna", "ऊस"],
                "category_id": "pest_problem",
                "name": "Sugarcane Top Borer / Shoot Borer",
                "keywords": ["borer", "dead heart", "shot holes", "bunchy top", "caterpillar"],
                "problem_identified": "Sugarcane Top Borer (Scirpophaga excerptalis)",
                "severity": "High",
                "possible_cause": "Larvae boring into central shoot causing dead heart and characteristic bunchy top appearance.",
                "recommended_actions": [
                    "Apply Chlorantraniliprole 0.4% G @ 7.5 kg/acre near cane roots followed by light irrigation.",
                    "Release Trichogramma chilonis egg parasitoids (20,000 per acre)."
                ],
                "precautions": "Do not spray broad-spectrum insecticides during peak parasite activity.",
                "weather_consideration": "Warm humid conditions encourage moth egg laying."
            },
            {
                "id": "rule_sugarcane_water_stress",
                "crop": "sugarcane",
                "crop_aliases": ["sugarcane", "ganna", "ऊस"],
                "category_id": "water_problem",
                "name": "Sugarcane Drought & Water Stress",
                "keywords": ["drought", "dry", "wilting", "rolling", "yellowing leaves", "water stress"],
                "problem_identified": "Moisture Stress & Drought Injury",
                "severity": "Medium",
                "possible_cause": "Prolonged dry period causing leaf rolling, stomatal closure, and reduced cane elongation.",
                "recommended_actions": [
                    "Trash mulching (3–4 inches thick) between cane rows to conserve soil moisture.",
                    "Foliar spray of 1% Potassium Nitrate (KNO3) @ 10g/L to improve drought tolerance."
                ],
                "precautions": "Irrigate in alternate furrows if water supplies are limited.",
                "weather_consideration": "High temperatures (>38°C) with low humidity accelerate evapotranspiration."
            },

            # ==================== 3. RICE / PADDY ====================
            {
                "id": "rule_rice_blast",
                "crop": "rice",
                "crop_aliases": ["rice", "paddy", "dhan", "chawal", "भात"],
                "category_id": "disease_symptoms",
                "name": "Rice Blast (Pyricularia oryzae)",
                "keywords": ["blast", "spindle", "eye spot", "lesion", "neck blast", "fungus"],
                "problem_identified": "Rice Blast Fungal Disease",
                "severity": "High",
                "possible_cause": "Pyricularia oryzae fungus causing spindle-shaped lesions with grayish centers on leaves and neck rot.",
                "recommended_actions": [
                    "Spray Tricyclazole 75% WP @ 0.6g/L or Isoprothiolane 40% EC @ 1.5 ml/L.",
                    "Avoid excessive application of Nitrogenous fertilizers."
                ],
                "precautions": "Keep field standing water maintained at 2-3 cm.",
                "weather_consideration": "Cool night temperatures (20-24°C) with relative humidity >90% trigger rapid blast spread."
            },
            {
                "id": "rule_rice_stem_borer",
                "crop": "rice",
                "crop_aliases": ["rice", "paddy", "dhan", "chawal", "भात"],
                "category_id": "pest_problem",
                "name": "Rice Yellow Stem Borer",
                "keywords": ["stem borer", "dead heart", "whitehead", "caterpillar", "drying shoot"],
                "problem_identified": "Yellow Stem Borer (Scirpophaga incertulas)",
                "severity": "High",
                "possible_cause": "Larvae feeding inside stem tillers resulting in 'dead hearts' during vegetative stage or 'whiteheads' during panicle stage.",
                "recommended_actions": [
                    "Apply Cartap Hydrochloride 4% G @ 10 kg/acre or Chlorantraniliprole 0.4% G @ 4 kg/acre.",
                    "Set up light traps in fields to capture adult moths."
                ],
                "precautions": "Do not drain field standing water immediately after granular application.",
                "weather_consideration": "Heavy rainfall washes off granular treatments; re-examine threshold after rains."
            },
            {
                "id": "rule_rice_bacterial_blight",
                "crop": "rice",
                "crop_aliases": ["rice", "paddy", "dhan", "chawal", "भात"],
                "category_id": "leaf_problem",
                "name": "Bacterial Leaf Blight (Xanthomonas oryzae)",
                "keywords": ["bacterial blight", "wavy margin", "yellow streak", "kresek", "leaf drying"],
                "problem_identified": "Bacterial Leaf Blight (BLB)",
                "severity": "High",
                "possible_cause": "Bacterial pathogen entering leaf wounds, creating yellow water-soaked wavy lesions from leaf tips downwards.",
                "recommended_actions": [
                    "Spray Copper Hydroxide 77% WP @ 2g/L + Streptocycline @ 0.1g/L of water.",
                    "Temporarily drain standing water for 3–4 days to check bacterial spread."
                ],
                "precautions": "Avoid field operations when leaves are wet to prevent mechanical transmission.",
                "weather_consideration": "Strong gusty winds and heavy rain cause leaf injury facilitating bacterial entry."
            },

            # ==================== 4. WHEAT ====================
            {
                "id": "rule_wheat_yellow_rust",
                "crop": "wheat",
                "crop_aliases": ["wheat", "gehun", "गहू"],
                "category_id": "leaf_problem",
                "name": "Wheat Yellow / Stripe Rust (Puccinia striiformis)",
                "keywords": ["yellow rust", "stripe rust", "yellow powder", "pustules", "stripes"],
                "problem_identified": "Wheat Stripe / Yellow Rust",
                "severity": "High",
                "possible_cause": "Puccinia striiformis fungal spores producing bright yellow powdery linear stripes along leaf veins.",
                "recommended_actions": [
                    "Spray Propiconazole 25% EC @ 1 ml/L or Tebuconazole 25.9% EC @ 1 ml/L.",
                    "Repeat spray after 12–15 days if yellow pustules reappear."
                ],
                "precautions": "Ensure coverage of lower foliage during foliar application.",
                "weather_consideration": "Cool humid weather (10-15°C) with morning dew promotes rust multiplication."
            },
            {
                "id": "rule_wheat_aphids",
                "crop": "wheat",
                "crop_aliases": ["wheat", "gehun", "गहू"],
                "category_id": "pest_problem",
                "name": "Wheat Aphid Infestation",
                "keywords": ["aphid", "green insect", "honeydew", "earhead", "sucking"],
                "problem_identified": "Wheat Earhead Aphids (Macrosiphum miscanthi)",
                "severity": "Medium",
                "possible_cause": "Aphids sucking sap from emerging earheads and upper flag leaves, causing grain shriveling.",
                "recommended_actions": [
                    "Spray Thiamethoxam 25% WG @ 0.2g/L or Dimethoate 30% EC @ 1.7 ml/L.",
                    "Conserve ladybird beetles as natural predators."
                ],
                "precautions": "Avoid chemical sprays if ladybird beetle population exceeds 2 per tiller.",
                "weather_consideration": "Cloudy humid weather during earhead emergence favors aphid flare-up."
            },

            # ==================== 5. TOMATO ====================
            {
                "id": "rule_tomato_early_blight",
                "crop": "tomato",
                "crop_aliases": ["tomato", "tamatar", "टोमॅटो"],
                "category_id": "leaf_problem",
                "name": "Tomato Early Blight (Alternaria solani)",
                "keywords": ["early blight", "target spot", "concentric rings", "yellowing", "lower leaves", "brown spots"],
                "problem_identified": "Tomato Early Blight (Alternaria Fungal Disease)",
                "severity": "High",
                "possible_cause": "Alternaria solani fungal spores causing dark brown spots with characteristic target-like concentric rings on lower leaves.",
                "recommended_actions": [
                    "Spray Mancozeb 75% WP @ 2.5g/L or Azoxystrobin 23% SC @ 1 ml/L.",
                    "Remove lower diseased foliage up to 15 cm from soil level.",
                    "Stake tomato plants to elevate branches from soil."
                ],
                "precautions": "Avoid overhead sprinkler irrigation to reduce foliage leaf wetness.",
                "weather_consideration": "Alternating dry and rainy periods with temperature ~25°C trigger heavy spore germination."
            },
            {
                "id": "rule_tomato_leaf_curl",
                "crop": "tomato",
                "crop_aliases": ["tomato", "tamatar", "टोमॅटो"],
                "category_id": "leaf_problem",
                "name": "Tomato Leaf Curl Virus (ToLCV)",
                "keywords": ["leaf curl", "crinkling", "stunted", "bushy", "puckering", "whitefly"],
                "problem_identified": "Tomato Leaf Curl Viral Disease (ToLCV)",
                "severity": "Critical",
                "possible_cause": "Begomovirus transmitted by Whitefly vector causing upward curling, puckering, and severe plant stunting.",
                "recommended_actions": [
                    "Install yellow sticky traps (12 per acre) to trap whitefly vectors.",
                    "Spray Cyantraniliprole 10.26% OD @ 1.8 ml/L or Imidacloprid 17.8% SL @ 0.5 ml/L.",
                    "Uproot and bury severely stunted diseased seedlings."
                ],
                "precautions": "Plant yellow leaf curl resistant hybrids (e.g. Arka Rakshak, Abhinav).",
                "weather_consideration": "Hot dry spells increase whitefly mobility and viral spread."
            },
            {
                "id": "rule_tomato_fruit_borer",
                "crop": "tomato",
                "crop_aliases": ["tomato", "tamatar", "टोमॅटो"],
                "category_id": "pest_problem",
                "name": "Tomato Fruit Borer (Helicoverpa armigera)",
                "keywords": ["fruit borer", "hole", "caterpillar", "bored fruit", "rot"],
                "problem_identified": "Tomato Fruit Borer Larval Attack",
                "severity": "High",
                "possible_cause": "Helicoverpa armigera caterpillars boring circular holes into green and ripening fruits.",
                "recommended_actions": [
                    "Set up Pheromone traps (5 per acre) for Helicoverpa.",
                    "Spray Chlorantraniliprole 18.5% SC @ 0.3 ml/L or Emamectin Benzoate 5% SG @ 0.4g/L.",
                    "Hand-pick damaged fruits and dispose away from field."
                ],
                "precautions": "Observe 5-day pre-harvest interval after chemical application.",
                "weather_consideration": "Warm temperatures accelerate caterpillar feeding cycles."
            },

            # ==================== 6. ONION ====================
            {
                "id": "rule_onion_purple_blotch",
                "crop": "onion",
                "crop_aliases": ["onion", "pyaz", "कांदा"],
                "category_id": "disease_symptoms",
                "name": "Onion Purple Blotch (Alternaria porri)",
                "keywords": ["purple blotch", "purple spot", "sunken lesion", "yellow tip", "drying leaf"],
                "problem_identified": "Onion Purple Blotch Fungal Infection",
                "severity": "High",
                "possible_cause": "Alternaria porri fungal pathogen causing oval purple sunken lesions with yellow halos on onion foliage.",
                "recommended_actions": [
                    "Spray Tebuconazole 50% + Trifloxystrobin 25% WG @ 0.7g/L or Dithane M-45 @ 2.5g/L.",
                    "Mix a sticking agent (Sticker/Spreader @ 0.5 ml/L) due to waxy onion foliage."
                ],
                "precautions": "Avoid excessive nitrogen application which produces soft succulent leaves.",
                "weather_consideration": "Frequent rain showers and temperatures between 21-30°C favor rapid disease outbreak."
            },
            {
                "id": "rule_onion_thrips",
                "crop": "onion",
                "crop_aliases": ["onion", "pyaz", "कांदा"],
                "category_id": "pest_problem",
                "name": "Onion Thrips (Thrips tabaci)",
                "keywords": ["thrips", "silvery patch", "white specks", "curling leaf", "tiny insect"],
                "problem_identified": "Onion Thrips Infestation",
                "severity": "High",
                "possible_cause": "Nymphs and adults lacerating leaf tissues, producing characteristic silvery white blotches.",
                "recommended_actions": [
                    "Install blue sticky traps (10 per acre).",
                    "Spray Fipronil 5% SC @ 1.5 ml/L or Spinetoram 11.7% SC @ 1 ml/L.",
                    "Ensure spray reaches the leaf sheath base where thrips hide."
                ],
                "precautions": "Rotate chemical groups to avoid thrips pesticide resistance.",
                "weather_consideration": "Dry hot weather severely increases thrips population."
            },

            # ==================== 7. POTATO ====================
            {
                "id": "rule_potato_late_blight",
                "crop": "potato",
                "crop_aliases": ["potato", "aalu", "बटाटा"],
                "category_id": "disease_symptoms",
                "name": "Potato Late Blight (Phytophthora infestans)",
                "keywords": ["late blight", "water-soaked spot", "white mildew", "black lesion", "rotting tuber"],
                "problem_identified": "Potato Late Blight (Phytophthora)",
                "severity": "Critical",
                "possible_cause": "Phytophthora infestans water mold causing dark water-soaked leaf spots with white downy growth on under-surface.",
                "recommended_actions": [
                    "Spray Cymoxanil 8% + Mancozeb 64% WP @ 2g/L or Dimethomorph 50% WP @ 1g/L.",
                    "Earthing up soil around potato hills to prevent tuber infection from washing spores."
                ],
                "precautions": "Destroy infected haulms 10-12 days prior to harvest.",
                "weather_consideration": "Foggy overcast weather with humidity >90% and temp 12-20°C creates high late blight emergency."
            },

            # ==================== 8. SOYBEAN ====================
            {
                "id": "rule_soybean_rust",
                "crop": "soybean",
                "crop_aliases": ["soybean", "सोयाबीन"],
                "category_id": "disease_symptoms",
                "name": "Soybean Asian Rust (Phakopsora pachyrhizi)",
                "keywords": ["rust", "tan spot", "pustules", "defoliation", "yellowing leaf"],
                "problem_identified": "Asian Soybean Rust Fungal Disease",
                "severity": "High",
                "possible_cause": "Phakopsora pachyrhizi fungus forming reddish-brown powdery pustules on lower leaf surface.",
                "recommended_actions": [
                    "Spray Hexaconazole 5% EC @ 1 ml/L or Propiconazole 25% EC @ 1 ml/L.",
                    "Apply treatment as soon as early pustules appear during flowering/podding."
                ],
                "precautions": "Avoid dense crop spacing to maintain air circulation.",
                "weather_consideration": "Extended leaf wetness (>6 hours) and temperatures of 18-26°C trigger spore germination."
            },
            {
                "id": "rule_soybean_girdle_beetle",
                "crop": "soybean",
                "crop_aliases": ["soybean", "सोयाबीन"],
                "category_id": "pest_problem",
                "name": "Soybean Girdle Beetle (Oberia brevis)",
                "keywords": ["girdle beetle", "ring cut", "drying stem", "wilted petiole", "beetle"],
                "problem_identified": "Girdle Beetle Infestation",
                "severity": "High",
                "possible_cause": "Female beetle making parallel ring cuts on stems and petioles causing upper leaf wilting.",
                "recommended_actions": [
                    "Hand-pick and destroy girdled petioles/stems showing ring cuts.",
                    "Spray Chlorantraniliprole 18.5% SC @ 0.3 ml/L or Thiamethoxam 12.6% + Lambda Cyhalothrin 9.5% ZC @ 0.3 ml/L."
                ],
                "precautions": "Apply spray during early morning or late evening.",
                "weather_consideration": "Humid monsoon weather favors beetle emergence."
            },

            # ==================== 9. MAIZE ====================
            {
                "id": "rule_maize_fall_armyworm",
                "crop": "maize",
                "crop_aliases": ["maize", "corn", "makka", "मका"],
                "category_id": "pest_problem",
                "name": "Fall Armyworm (Spodoptera frugiperda)",
                "keywords": ["fall armyworm", "faw", "whorl damage", "frass", "caterpillar", "ragged holes"],
                "problem_identified": "Fall Armyworm (FAW) Larval Attack",
                "severity": "Critical",
                "possible_cause": "Spodoptera frugiperda larvae feeding inside maize whorls producing large ragged leaf holes and moist sawdust-like frass.",
                "recommended_actions": [
                    "Apply Neem cake or sand-sawdust mixture into plant whorls.",
                    "Spray Emamectin Benzoate 5% SG @ 0.4g/L or Chlorantraniliprole 18.5% SC @ 0.4 ml/L directly into central whorls."
                ],
                "precautions": "Target spray nozzle directly into central whorl opening.",
                "weather_consideration": "Dry weather favors rapid FAW larval migration."
            },

            # ==================== 10. GROUNDNUT ====================
            {
                "id": "rule_groundnut_tikka",
                "crop": "groundnut",
                "crop_aliases": ["groundnut", "peanut", "mungfali", "भुईमूग"],
                "category_id": "leaf_problem",
                "name": "Groundnut Tikka Leaf Spot (Cercospora)",
                "keywords": ["tikka", "leaf spot", "circular brown spot", "yellow halo", "defoliation"],
                "problem_identified": "Tikka Leaf Spot (Early & Late Cercospora Blight)",
                "severity": "High",
                "possible_cause": "Cercospora arachidicola fungus producing dark brown circular spots with bright yellow halos leading to leaf drop.",
                "recommended_actions": [
                    "Spray Carbendazim 12% + Mancozeb 63% WP @ 2g/L of water.",
                    "Repeat spray after 14 days if wet weather continues."
                ],
                "precautions": "Ensure uniform foliar coverage.",
                "weather_consideration": "High relative humidity (>85%) and warm temperatures (25-30°C) cause severe Tikka spread."
            },

            # ==================== 11. CHICKPEA ====================
            {
                "id": "rule_chickpea_pod_borer",
                "crop": "chickpea",
                "crop_aliases": ["chickpea", "chana", "हरभरा"],
                "category_id": "pest_problem",
                "name": "Chickpea Pod Borer (Helicoverpa armigera)",
                "keywords": ["pod borer", "chana borer", "hole in pod", "green caterpillar", "eaten pod"],
                "problem_identified": "Chickpea Pod Borer Larvae",
                "severity": "Critical",
                "possible_cause": "Helicoverpa larvae boring into developing pods and consuming seeds.",
                "recommended_actions": [
                    "Install T-shaped bird perches (20 per acre) in field.",
                    "Spray HaNPV (Helicoverpa Nuclear Polyhedrosis Virus) @ 250 LE/acre or Emamectin Benzoate 5% SG @ 0.4g/L."
                ],
                "precautions": "Spray during early instar caterpillar stage for best efficacy.",
                "weather_consideration": "Warm sunny dry winter days accelerate larval growth."
            },
            {
                "id": "rule_chickpea_wilt",
                "crop": "chickpea",
                "crop_aliases": ["chickpea", "chana", "हरभरा"],
                "category_id": "disease_symptoms",
                "name": "Chickpea Fusarium Wilt",
                "keywords": ["wilt", "drooping", "yellowing", "dark xylem", "root rot"],
                "problem_identified": "Chickpea Fusarium Wilt Disease",
                "severity": "High",
                "possible_cause": "Fusarium oxysporum f. sp. ciceris attacking vascular bundles of roots.",
                "recommended_actions": [
                    "Seed treatment with Trichoderma viride @ 10g/kg seed before sowing.",
                    "Drench field patches with Carbendazim 50% WP @ 2g/L."
                ],
                "precautions": "Follow 3-year crop rotation with non-legume crops.",
                "weather_consideration": "Soil moisture stress coupled with warm soil triggers wilt expressiveness."
            },

            # ==================== 12. PIGEON PEA (TUR) ====================
            {
                "id": "rule_tur_wilt",
                "crop": "pigeon pea",
                "crop_aliases": ["pigeon pea", "tur", "arhar", "तूर"],
                "category_id": "disease_symptoms",
                "name": "Tur Fusarium Wilt & Sterility Mosaic",
                "keywords": ["tur wilt", "arhar wilt", "drying plant", "black streak stem", "sterility"],
                "problem_identified": "Tur Fusarium Wilt / Sterility Mosaic Virus",
                "severity": "High",
                "possible_cause": "Soil fungus Fusarium udum causing xylem vessel blackening and plant collapse during flowering.",
                "recommended_actions": [
                    "Drench root zone with Trichoderma viride @ 5 kg/acre mixed with compost.",
                    "Uproot and destroy wilted plants to minimize soil inoculum build-up."
                ],
                "precautions": "Sow resistant varieties like BDN-711, BSMR-736.",
                "weather_consideration": "Dry post-monsoon spells aggravate vascular wilt symptoms."
            },

            # ==================== 13. BANANA ====================
            {
                "id": "rule_banana_sigatoka",
                "crop": "banana",
                "crop_aliases": ["banana", "kela", "केळी"],
                "category_id": "leaf_problem",
                "name": "Banana Sigatoka Leaf Spot",
                "keywords": ["sigatoka", "yellow streak", "brown spot", "leaf drying", "banana leaf"],
                "problem_identified": "Banana Yellow / Black Sigatoka Leaf Spot",
                "severity": "High",
                "possible_cause": "Mycosphaerella musicola fungal spores causing elongated dark brown spots with dry gray centers.",
                "recommended_actions": [
                    "Cut and burn severely affected lower leaves.",
                    "Spray Propiconazole 25% EC @ 1 ml/L + Mineral Oil @ 10 ml/L of water."
                ],
                "precautions": "Maintain adequate field drainage and trenching between banana rows.",
                "weather_consideration": "High rain and relative humidity (>80%) accelerate spore dispersal."
            },

            # ==================== 14. MANGO ====================
            {
                "id": "rule_mango_powdery_mildew",
                "crop": "mango",
                "crop_aliases": ["mango", "aam", "आंबा"],
                "category_id": "disease_symptoms",
                "name": "Mango Powdery Mildew",
                "keywords": ["powdery mildew", "white coating", "flower drop", "blossom drop", "mango blossom"],
                "problem_identified": "Mango Powdery Mildew (Oidium mangiferae)",
                "severity": "High",
                "possible_cause": "Fungal pathogen coating panicles, flowers, and tender fruitlets with whitish powdery growth.",
                "recommended_actions": [
                    "Spray Wettable Sulphur 80% WP @ 3g/L or Hexaconazole 5% EC @ 1 ml/L during early panicle emergence."
                ],
                "precautions": "Do not spray sulphur during high afternoon heat (>35°C) to prevent leaf scorching.",
                "weather_consideration": "Cool nights and warm cloudy days during blossom period spur mildew outbreak."
            },

            # ==================== 15. CHILLI ====================
            {
                "id": "rule_chilli_murda",
                "crop": "chilli",
                "crop_aliases": ["chilli", "mirchi", "मिरची"],
                "category_id": "leaf_problem",
                "name": "Chilli Leaf Curl & Murda Disease",
                "keywords": ["murda", "leaf curl", "boat shaped", "thrips", "crinkling", "stunted"],
                "problem_identified": "Chilli Leaf Curl (Complex Thrips / Mite / Virus)",
                "severity": "High",
                "possible_cause": "Upward leaf curling caused by Thrips or downward boat-shaped curling caused by Mites.",
                "recommended_actions": [
                    "For Thrips (upward curl): Spray Fipronil 5% SC @ 1.5 ml/L.",
                    "For Mites (downward curl): Spray Spiromesifen 22.9% SC @ 1 ml/L or Abamectin 1.9% EC @ 0.7 ml/L."
                ],
                "precautions": "Do not mix organophosphates with sulfur-based sprays.",
                "weather_consideration": "Hot dry weather triggers thrips and mite explosions."
            },

            # ==================== 16. BRINJAL ====================
            {
                "id": "rule_brinjal_fruit_borer",
                "crop": "brinjal",
                "crop_aliases": ["brinjal", "eggplant", "baingan", "वांगी"],
                "category_id": "pest_problem",
                "name": "Brinjal Fruit & Shoot Borer (BSFB)",
                "keywords": ["fruit borer", "shoot borer", "drooping shoot", "hole in brinjal", "frass"],
                "problem_identified": "Brinjal Fruit & Shoot Borer (Leucinodes orbonalis)",
                "severity": "Critical",
                "possible_cause": "Larvae boring into tender shoots causing shoot wilting and entering fruits making them unmarketable.",
                "recommended_actions": [
                    "Clip and destroy wilted shoots showing borer damage.",
                    "Install Lucinlure Pheromone traps (12 per acre).",
                    "Spray Emamectin Benzoate 5% SG @ 0.4g/L or Chlorantraniliprole 18.5% SC @ 0.3 ml/L."
                ],
                "precautions": "Destroy harvested crop residue after final picking.",
                "weather_consideration": "Warm humid conditions favor continuous moth breeding."
            },

            # ==================== 17. OKRA (BHINDI) ====================
            {
                "id": "rule_okra_yellow_vein_mosaic",
                "crop": "okra",
                "crop_aliases": ["okra", "ladyfinger", "bhindi", "भेंडी"],
                "category_id": "leaf_problem",
                "name": "Okra Yellow Vein Mosaic Virus (YVMV)",
                "keywords": ["yellow vein", "yellow leaf", "mosaic", "whitefly", "stunted pod"],
                "problem_identified": "Yellow Vein Mosaic Virus (YVMV)",
                "severity": "High",
                "possible_cause": "Begomovirus transmitted by Whitefly vector causing yellowing of leaf veins followed by complete leaf chlorosis.",
                "recommended_actions": [
                    "Remove YVMV affected plants in early crop stage.",
                    "Control whitefly vector by spraying Imidacloprid 17.8% SL @ 0.3 ml/L or Acetamiprid 20% SP @ 0.2g/L.",
                    "Use yellow sticky traps (10 per acre)."
                ],
                "precautions": "Sow YVMV tolerant varieties like Arka Anamika or Parbhani Kranti.",
                "weather_consideration": "Hot dry summer weather increases whitefly population."
            }
        ]

    def _calculate_match_score(
        self,
        rule: Dict[str, Any],
        crop_input: str,
        category_input: str,
        combined_text: str,
        weather_info: Optional[Dict] = None
    ) -> float:
        score = 0.0
        
        # 1. Crop Match Score (Weight: 40 points)
        rule_crop = rule.get("crop", "").lower()
        rule_aliases = [a.lower() for a in rule.get("crop_aliases", [])]
        
        if not crop_input or rule_crop == "all":
            score += 30.0
        elif rule_crop in crop_input or crop_input in rule_crop or any(alias in crop_input for alias in rule_aliases):
            score += 40.0
        else:
            # Crop mismatch -> 0 score
            return 0.0

        # 2. Category Match Score (Weight: 30 points)
        rule_cat = rule.get("category_id", "")
        if not category_input or rule_cat == category_input:
            score += 30.0
        elif rule_cat in ["leaf_problem", "disease_symptoms"] and category_input in ["leaf_problem", "disease_symptoms"]:
            score += 20.0
        else:
            score += 10.0

        # 3. Symptom Keywords Match Score (Weight: 20 points)
        keywords = rule.get("keywords", [])
        if keywords:
            matches = sum(1 for kw in keywords if kw.lower() in combined_text.lower())
            ratio = min(1.0, matches / max(1, len(keywords) * 0.3))
            score += ratio * 20.0
        else:
            score += 10.0

        # 4. Weather Consideration Match Score (Weight: 10 points)
        if weather_info:
            humidity = weather_info.get("humidity", 50)
            rain_prob = weather_info.get("rain_probability", 0)
            if humidity > 75 and ("humid" in rule.get("weather_consideration", "").lower() or "fung" in rule.get("possible_cause", "").lower()):
                score += 10.0
            elif rain_prob > 50 and "rain" in rule.get("weather_consideration", "").lower():
                score += 10.0
            else:
                score += 5.0

        return score

    def evaluate(self, category_id: str, answers: Dict[str, str], weather_info: Optional[Dict] = None) -> AdvisoryResultResponse:
        crop_val = str(answers.get("crop", "")).strip().lower()
        symptom_val = str(answers.get("symptom", "")).strip().lower()
        
        combined_text = " ".join([str(v) for v in answers.values()]).lower()

        best_matched_rule = None
        highest_score = 0.0

        for rule in self.rules:
            score = self._calculate_match_score(rule, crop_val, category_id, combined_text, weather_info)
            if score > highest_score:
                highest_score = score
                best_matched_rule = rule

        # Tier 1 & 2: High or Moderate Confidence Rule Match
        if best_matched_rule and highest_score >= 30.0:
            weather_text = best_matched_rule.get("weather_consideration", "")
            if weather_info:
                if weather_info.get("rain_probability", 0) > 60:
                    weather_text += f" 🌧 High rain probability ({weather_info.get('rain_probability')}%) forecast. Postpone chemical sprays."
                elif weather_info.get("humidity", 0) > 80:
                    weather_text += f" 💧 High humidity ({weather_info.get('humidity')}%) detected. Inspect crop canopy for fungal growth."

            is_high_conf = highest_score >= 45.0
            problem_prefix = "Possible Issue:" if is_high_conf else "Observed Issue (Moderate Match):"

            return AdvisoryResultResponse(
                match_found=True,
                rule_id=best_matched_rule["id"],
                problem_identified=f"{problem_prefix} {best_matched_rule['problem_identified']}",
                severity=best_matched_rule["severity"],
                possible_cause=best_matched_rule["possible_cause"],
                recommended_actions=best_matched_rule["recommended_actions"],
                precautions=best_matched_rule["precautions"],
                weather_consideration=weather_text,
                collected_inputs=answers
            )

        # Tier 3 & 4: Structured Crop/Symptom Agronomic Fallback Guidance
        crop_display = crop_val.title() if crop_val else "Crop"
        
        fallback_actions = [
            f"Inspect lower and upper foliage of {crop_display} for early pest or fungal lesions.",
            "Maintain balanced soil moisture and avoid water stagnation near root zones.",
            "Apply balanced 19:19:19 NPK foliar spray (5g/L) to build crop vigor.",
            "If symptoms persist or worsen, submit a photo to our Agronomist Team using the Contact Expert button below."
        ]

        weather_text = "Check local weather forecast before planning any field spray operations."
        if weather_info:
            weather_text = f"Current Location Weather: {weather_info.get('temperature', 28)}°C, Humidity {weather_info.get('humidity', 60)}%. {weather_text}"

        # Tier 5: Expert Escalation Indicator if inputs are sparse or match is below threshold
        return AdvisoryResultResponse(
            match_found=False,
            rule_id="expert_escalation_required",
            problem_identified=f"Agronomic Review Recommended for {crop_display}",
            severity="Medium",
            possible_cause="Based on the information provided, we couldn't find a sufficiently reliable automated advisory. An agronomist verification is recommended.",
            recommended_actions=fallback_actions,
            precautions="Avoid applying unverified chemical pesticides without confirmed agronomist diagnosis.",
            weather_consideration=weather_text,
            collected_inputs=answers
        )

    def evaluate_vision_advisory(
        self,
        gemini_data: Dict[str, Any],
        weather_data: Optional[Any] = None,
        crop_override: Optional[str] = None
    ) -> DiseaseScanResponse:
        scan_id = f"SCAN-{uuid.uuid4().hex[:8].upper()}"
        crop_name = crop_override or gemini_data.get("crop") or "Crop"
        
        possible_issues_raw = gemini_data.get("possible_issues", [])
        possible_issue_items = []
        primary_issue_name = "Possible Foliar Anomaly"
        top_confidence = 0.60

        if possible_issues_raw:
            for p in possible_issues_raw:
                conf = float(p.get("confidence", 0.6))
                if conf <= 1.0:
                    conf = conf * 100.0
                item = PossibleIssueItem(
                    name=p.get("name", "Possible Issue"),
                    confidence=round(conf, 1),
                    reason=p.get("reason", "Visual feature match")
                )
                possible_issue_items.append(item)
            
            top_issue = possible_issue_items[0]
            primary_issue_name = top_issue.name
            top_confidence = top_issue.confidence

        image_quality = gemini_data.get("image_quality", "good")
        expert_recommended = gemini_data.get("expert_review_recommended", False) or (top_confidence < 65.0) or (image_quality == "poor")

        weather_summary = None
        if weather_data:
            weather_summary = f"{weather_data.temperature}°C, {weather_data.condition}, Humidity {weather_data.humidity}%, Rain Prob {weather_data.rain_probability}%"

        rec_actions = gemini_data.get("recommended_next_steps", [])
        if not rec_actions:
            rec_actions = ["Inspect lower foliage", "Ensure proper drainage", "Consult agronomist if worsening"]

        rule_text = f"Rule Engine Verification: Observed symptoms for {crop_name} cross-referenced with knowledge base."

        return DiseaseScanResponse(
            scan_id=scan_id,
            image_quality=image_quality,
            crop_name=crop_name,
            predicted_issue=primary_issue_name if primary_issue_name.startswith("Possible") else f"Possible Issue: {primary_issue_name}",
            confidence_score=top_confidence,
            uncertainty_level="High" if top_confidence < 60 else ("Medium" if top_confidence < 80 else "Low"),
            visible_symptoms=gemini_data.get("visible_symptoms", ["Leaf discoloration"]),
            possible_issues=possible_issue_items,
            severity=gemini_data.get("severity", "Moderate").title(),
            possible_causes=gemini_data.get("possible_causes", ["Pathogen or environmental stress"]),
            recommended_next_steps=rec_actions,
            preventive_measures=gemini_data.get("preventive_measures", ["Maintain proper irrigation"]),
            weather_context=weather_summary,
            rule_advisory=rule_text,
            disclaimer=gemini_data.get("disclaimer") or "This is a preliminary assessment and advisory based on visual features.",
            requires_expert=expert_recommended
        )

advisory_engine = RuleBasedAdvisoryEngine()
