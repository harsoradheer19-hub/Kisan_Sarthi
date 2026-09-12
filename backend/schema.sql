-- Kisan Sarthi PostgreSQL Schema (Supabase compatible) - Upgraded Version

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. Public Profiles Table (Supabase Auth Compatible)
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    full_name TEXT,
    phone TEXT,
    role TEXT DEFAULT 'farmer',
    language TEXT DEFAULT 'en',
    location_name TEXT,
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS and add safe policies for public.profiles
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies WHERE tablename = 'profiles' AND policyname = 'Users can view their own profile'
    ) THEN
        CREATE POLICY "Users can view their own profile" ON public.profiles FOR SELECT USING (id = auth.uid());
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM pg_policies WHERE tablename = 'profiles' AND policyname = 'Users can insert their own profile'
    ) THEN
        CREATE POLICY "Users can insert their own profile" ON public.profiles FOR INSERT WITH CHECK (id = auth.uid());
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM pg_policies WHERE tablename = 'profiles' AND policyname = 'Users can update their own profile'
    ) THEN
        CREATE POLICY "Users can update their own profile" ON public.profiles FOR UPDATE USING (id = auth.uid());
    END IF;
END $$;

-- Automatic Profile Creation Trigger for Supabase Auth
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, full_name, phone, role, language, location_name, latitude, longitude, created_at)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'full_name', 'Farmer'),
    COALESCE(NEW.raw_user_meta_data->>'phone', ''),
    'farmer',
    COALESCE(NEW.raw_user_meta_data->>'language', 'en'),
    COALESCE(NEW.raw_user_meta_data->>'location_name', 'Nashik, Maharashtra'),
    COALESCE(NULLIF(NEW.raw_user_meta_data->>'latitude', '')::double precision, 19.9975),
    COALESCE(NULLIF(NEW.raw_user_meta_data->>'longitude', '')::double precision, 73.7898),
    NOW()
  )
  ON CONFLICT (id) DO UPDATE SET
    full_name = EXCLUDED.full_name,
    phone = EXCLUDED.phone,
    language = EXCLUDED.language,
    location_name = EXCLUDED.location_name;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();


-- 1b. Farmer Profiles (Legacy/Internal)
CREATE TABLE IF NOT EXISTS farmer_profiles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID UNIQUE REFERENCES auth.users(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    location VARCHAR(255) NOT NULL,
    state VARCHAR(100) DEFAULT 'Maharashtra',
    district VARCHAR(100) DEFAULT 'Nashik',
    latitude FLOAT,
    longitude FLOAT,
    main_crop VARCHAR(100) DEFAULT 'General',
    preferred_language VARCHAR(10) DEFAULT 'en',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Crops Knowledge Base Table
CREATE TABLE IF NOT EXISTS crops (
    id VARCHAR(50) PRIMARY KEY,
    name_en VARCHAR(100) NOT NULL,
    name_hi VARCHAR(100),
    name_mr VARCHAR(100),
    name_ta VARCHAR(100),
    name_gu VARCHAR(100),
    name_kn VARCHAR(100),
    category VARCHAR(50) NOT NULL, -- Cereals, Pulses, Oilseeds, Cash Crops, Vegetables, Fruits
    water_requirement VARCHAR(100),
    growing_season VARCHAR(100),
    expected_yield VARCHAR(100),
    suitable_soils JSONB,
    growth_stages JSONB,
    common_pests JSONB,
    common_diseases JSONB,
    icon_name VARCHAR(50)
);

-- 3. Problem Categories
CREATE TABLE IF NOT EXISTS problem_categories (
    id VARCHAR(50) PRIMARY KEY,
    name_en VARCHAR(100) NOT NULL,
    name_hi VARCHAR(100),
    name_mr VARCHAR(100),
    icon_name VARCHAR(50) NOT NULL,
    description TEXT,
    display_order INT DEFAULT 0
);

-- 4. Dynamic Questions
CREATE TABLE IF NOT EXISTS questions (
    id VARCHAR(50) PRIMARY KEY,
    category_id VARCHAR(50) REFERENCES problem_categories(id) ON DELETE CASCADE,
    step_number INT NOT NULL,
    question_text_en TEXT NOT NULL,
    question_text_hi TEXT,
    question_text_mr TEXT,
    subtitle_en TEXT,
    subtitle_hi TEXT,
    subtitle_mr TEXT,
    param_key VARCHAR(50) NOT NULL
);

-- 5. Question Options
CREATE TABLE IF NOT EXISTS question_options (
    id VARCHAR(50) PRIMARY KEY,
    question_id VARCHAR(50) REFERENCES questions(id) ON DELETE CASCADE,
    option_value VARCHAR(100) NOT NULL,
    label_en VARCHAR(100) NOT NULL,
    label_hi VARCHAR(100),
    label_mr VARCHAR(100),
    icon_name VARCHAR(50),
    display_order INT DEFAULT 0
);

-- 6. Advisory Rules
CREATE TABLE IF NOT EXISTS advisory_rules (
    id VARCHAR(50) PRIMARY KEY,
    category_id VARCHAR(50) REFERENCES problem_categories(id),
    rule_name VARCHAR(255) NOT NULL,
    conditions JSONB NOT NULL,
    problem_identified TEXT NOT NULL,
    severity VARCHAR(20) DEFAULT 'Medium',
    possible_cause TEXT NOT NULL,
    recommended_actions JSONB NOT NULL,
    precautions TEXT NOT NULL,
    weather_consideration TEXT,
    is_active BOOLEAN DEFAULT TRUE
);

-- 7. Disease Scans Table (Image AI Analysis History)
CREATE TABLE IF NOT EXISTS disease_scans (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    farmer_id UUID REFERENCES farmer_profiles(id),
    farmer_name VARCHAR(255),
    crop_name VARCHAR(100) NOT NULL,
    image_url TEXT NOT NULL,
    predicted_issue VARCHAR(255) NOT NULL,
    confidence_score FLOAT NOT NULL,
    uncertainty_level VARCHAR(20) DEFAULT 'Medium', -- Low, Medium, High
    recommended_action TEXT,
    requires_expert BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 8. Expert Requests
CREATE TABLE IF NOT EXISTS expert_requests (
    id VARCHAR(20) PRIMARY KEY,
    farmer_id UUID REFERENCES farmer_profiles(id),
    farmer_name VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    location VARCHAR(255) NOT NULL,
    crop VARCHAR(100) NOT NULL,
    problem_category VARCHAR(100),
    description TEXT NOT NULL,
    image_url TEXT,
    collected_inputs JSONB,
    request_type VARCHAR(50) DEFAULT 'general', -- general, disease_scan
    disease_scan_id UUID REFERENCES disease_scans(id),
    priority VARCHAR(20) DEFAULT 'Normal', -- Normal, High, Urgent
    status VARCHAR(20) DEFAULT 'Pending', -- Pending, In Review, More Information Required, Resolved
    expert_id VARCHAR(100),
    expert_name VARCHAR(100),
    expert_response TEXT,
    internal_notes TEXT,
    resolved_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 8b. Expert Questions (Expert asking farmer follow-up questions)
CREATE TABLE IF NOT EXISTS expert_questions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    request_id VARCHAR(20) REFERENCES expert_requests(id) ON DELETE CASCADE,
    question TEXT NOT NULL,
    question_type VARCHAR(50) DEFAULT 'multiple_choice', -- multiple_choice, text
    options JSONB, -- Array of string options e.g. ["Slow", "Moderate", "Rapid"]
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 8c. Expert Answers (Farmer responding to expert question)
CREATE TABLE IF NOT EXISTS expert_answers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    question_id UUID REFERENCES expert_questions(id) ON DELETE CASCADE,
    user_id UUID REFERENCES farmer_profiles(id),
    answer TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 8d. Expert Responses (Formal resolution / advice from expert)
CREATE TABLE IF NOT EXISTS expert_responses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    request_id VARCHAR(20) REFERENCES expert_requests(id) ON DELETE CASCADE,
    expert_id VARCHAR(100),
    response TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 9. In-App Notifications
CREATE TABLE IF NOT EXISTS notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    farmer_id UUID REFERENCES farmer_profiles(id),
    request_id VARCHAR(20) REFERENCES expert_requests(id),
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    type VARCHAR(50) DEFAULT 'status_update', -- status_update, weather_alert, expert_reply
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ==================================================
-- SEED DATA FOR 25+ CROPS
-- ==================================================
INSERT INTO crops (id, name_en, name_hi, name_mr, category, water_requirement, growing_season, expected_yield, suitable_soils, icon_name) VALUES
-- Cereals
('rice', 'Rice / Paddy', 'धान / चावल', 'भात / धान', 'Cereals', 'High (1200-1400 mm)', 'Kharif (June - Nov)', '20-25 Quintals / Acre', '["Clay", "Loamy", "Alluvial"]', 'grass'),
('wheat', 'Wheat', 'गेहूं', 'गहू', 'Cereals', 'Medium (450-650 mm)', 'Rabi (Oct - March)', '18-22 Quintals / Acre', '["Alluvial", "Clay Loam"]', 'grain'),
('maize', 'Maize / Corn', 'मक्का', 'मका', 'Cereals', 'Medium (500-750 mm)', 'Kharif / Rabi', '25-30 Quintals / Acre', '["Loamy", "Deep Black"]', 'corn'),
('bajra', 'Pearl Millet (Bajra)', 'बाजरा', 'बाजरा', 'Cereals', 'Low (250-400 mm)', 'Kharif (July - Oct)', '10-14 Quintals / Acre', '["Sandy", "Light Soil"]', 'grain'),
('jowar', 'Sorghum (Jowar)', 'ज्वार', 'ज्वारी', 'Cereals', 'Low (300-500 mm)', 'Kharif / Rabi', '12-16 Quintals / Acre', '["Black Soil", "Clay Loam"]', 'grass'),

-- Pulses
('chickpea', 'Chickpea (Chana)', 'चना', 'हरभरा', 'Pulses', 'Low (250-350 mm)', 'Rabi (Oct - March)', '8-10 Quintals / Acre', '["Black Cotton", "Loam"]', 'spa'),
('tur', 'Pigeon Pea (Tur / Arhar)', 'अरहर / तुअर', 'तूर', 'Pulses', 'Medium (400-600 mm)', 'Kharif (June - Jan)', '7-9 Quintals / Acre', '["Well Drained Medium Black"]', 'eco'),
('moong', 'Green Gram (Moong)', 'मूंग', 'मूग', 'Pulses', 'Low (300-400 mm)', 'Kharif / Summer', '5-7 Quintals / Acre', '["Loamy", "Alluvial"]', 'eco'),
('urad', 'Black Gram (Urad)', 'उड़द', 'उडीद', 'Pulses', 'Low (300-400 mm)', 'Kharif (July - Oct)', '5-7 Quintals / Acre', '["Heavy Clay", "Loam"]', 'eco'),

-- Oilseeds
('soybean', 'Soybean', 'सोयाबीन', 'सोयाबीन', 'Oilseeds', 'Medium (450-700 mm)', 'Kharif (June - Oct)', '10-12 Quintals / Acre', '["Deep Black", "Loam"]', 'grain'),
('groundnut', 'Groundnut / Peanut', 'मूंफली', 'भुईमूग', 'Oilseeds', 'Medium (500-600 mm)', 'Kharif / Summer', '12-15 Quintals / Acre', '["Sandy Loam", "Red Soil"]', 'spa'),
('mustard', 'Mustard', 'सरसों', 'मोहरी', 'Oilseeds', 'Low (250-400 mm)', 'Rabi (Oct - Feb)', '7-9 Quintals / Acre', '["Loam", "Alluvial"]', 'eco'),
('sunflower', 'Sunflower', 'सूरजमुखी', 'सूर्यफूल', 'Oilseeds', 'Medium (500-650 mm)', 'Kharif / Rabi', '8-10 Quintals / Acre', '["Black Soil", "Red Soil"]', 'filter_vintage'),

-- Cash Crops
('cotton', 'Cotton', 'कपास', 'कापूस', 'Cash Crops', 'Medium (500-700 mm)', 'Kharif (May - Nov)', '12-15 Quintals / Acre', '["Deep Black Cotton Soil"]', 'dry_cleaning'),
('sugarcane', 'Sugarcane', 'गन्ना', 'ऊस', 'Cash Crops', 'High (1500-2500 mm)', 'Annual (12-14 Months)', '40-50 Tons / Acre', '["Heavy Clay", "Loam"]', 'grass'),

-- Vegetables
('tomato', 'Tomato', 'टमाटर', 'टोमॅटो', 'Vegetables', 'High (Drip 400-600 mm)', 'Round the Year', '25-30 Tons / Acre', '["Sandy Loam", "Red Soil"]', 'nutrition'),
('potato', 'Potato', 'आलू', 'बटाटा', 'Vegetables', 'Medium (400-500 mm)', 'Rabi (Oct - Feb)', '12-15 Tons / Acre', '["Loam", "Alluvial"]', 'spa'),
('onion', 'Onion', 'प्याज', 'कांदा', 'Vegetables', 'Medium (350-500 mm)', 'Kharif / Late Kharif / Rabi', '10-12 Tons / Acre', '["Deep Red Soil", "Sandy Loam"]', 'eco'),
('brinjal', 'Brinjal / Eggplant', 'बैंगन', 'वांगी', 'Vegetables', 'Medium (450-600 mm)', 'Round the Year', '15-18 Tons / Acre', '["Silt Loam", "Clay Loam"]', 'nutrition'),
('chilli', 'Chilli', 'मिर्च', 'मिरची', 'Vegetables', 'Medium (400-600 mm)', 'Kharif / Rabi', '6-8 Quintals (Dry) / Acre', '["Black Soil", "Red Loam"]', 'eco'),
('okra', 'Okra (Ladyfinger)', 'भिंडी', 'भेंडी', 'Vegetables', 'Medium (350-500 mm)', 'Kharif / Summer', '6-8 Tons / Acre', '["Loam", "Sandy Silt"]', 'eco'),

-- Fruits
('banana', 'Banana', 'केला', 'केळी', 'Fruits', 'High (1800-2000 mm)', 'Perennial (11-12 Months)', '30-35 Tons / Acre', '["Deep Rich Soil"]', 'eco'),
('mango', 'Mango', 'आम', 'आंबा', 'Fruits', 'Medium (750-1000 mm)', 'Perennial', '5-8 Tons / Acre', '["Deep Alluvial", "Red Loam"]', 'eco'),
('grapes', 'Grapes', 'अंगूर', 'द्राक्षे', 'Fruits', 'High (Drip 600-800 mm)', 'Perennial', '12-15 Tons / Acre', '["Well Drained Sandy Loam"]', 'wine_bar'),
('pomegranate', 'Pomegranate', 'अनार', 'डाळिंब', 'Fruits', 'Low-Medium (500-600 mm)', 'Perennial', '6-8 Tons / Acre', '["Medium Black", "Loam"]', 'eco')
ON CONFLICT (id) DO NOTHING;
