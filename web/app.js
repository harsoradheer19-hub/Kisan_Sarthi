const API_BASE = 'http://127.0.0.1:8000/api/v1';

// Translations Dictionary for 6 Native Languages
const i18n = {
  en: {
    app_title: "Kisan Sarthi",
    tagline: '"Har Kisan Ka Smart Saathi"',
    greeting: "Namaste",
    crop_advisory: "Crop Problem",
    scan_crop: "Scan Crop",
    weather_advisory: "Weather Advisory",
    crop_rec: "Crop Recommendation",
    expert_support: "Expert Support",
    my_requests: "My Requests",
    profile: "Farmer Profile",
    language: "App Language",
    get_started: "Get Started",
    next: "Next",
    back: "Back",
    save_continue: "Save & Continue",
    generate_advisory: "Generate Advisory",
    submit_request: "Submit Expert Request",
    done: "Done",
    ask_expert: "Not Helpful? Ask Expert"
  },
  mr: {
    app_title: "किसान सारथी",
    tagline: '"हर किसान का स्मार्ट साथी"',
    greeting: "नमस्कार",
    crop_advisory: "पीक समस्या",
    scan_crop: "पीक स्कॅन करा",
    weather_advisory: "हवामान अंदाज",
    crop_rec: "पीक शिफारस",
    expert_support: "तज्ज्ञ सल्ला",
    my_requests: "माझे अर्ज",
    profile: "शेतकरी प्रोफाईल",
    language: "अ‍ॅप भाषा",
    get_started: "शुरू करा",
    next: "पुढील",
    back: "मागे",
    save_continue: "जतन करा आणि पुढे जा",
    generate_advisory: "सल्ला मिळवा",
    submit_request: "तज्ज्ञांना प्रश्न पाठवा",
    done: "पूर्ण",
    ask_expert: "तज्ज्ञांचा सल्ला घ्या"
  },
  hi: {
    app_title: "किसान सारथी",
    tagline: '"हर किसान का स्मार्ट साथी"',
    greeting: "नमस्ते",
    crop_advisory: "फसल समस्या",
    scan_crop: "फसल स्कैन करें",
    weather_advisory: "मौसम परामर्श",
    crop_rec: "फसल सिफारिश",
    expert_support: "विशेषज्ञ सलाह",
    my_requests: "मेरे अनुरोध",
    profile: "किसान प्रोफाइल",
    language: "ऐप भाषा",
    get_started: "शुरू करें",
    next: "आगे",
    back: "पीछे",
    save_continue: "सहेजें और आगे बढ़ें",
    generate_advisory: "सलाह प्राप्त करें",
    submit_request: "विशेषज्ञ को भेजें",
    done: "संपन्न",
    ask_expert: "विशेषज्ञ से पूछें"
  },
  ta: {
    app_title: "கிசான் சாரதி",
    tagline: '"ஒவ்வொரு விவசாயியின் நண்பன்"',
    greeting: "வணக்கம்",
    crop_advisory: "பயிர் பிரச்சனை",
    scan_crop: "பயிரை ஸ்கேன் செய்",
    weather_advisory: "வானிலை ஆலோசனை",
    crop_rec: "பயிர் பரிந்துரை",
    expert_support: "நிபுணர் உதவி",
    my_requests: "என் கோரிக்கைகள்",
    profile: "விவசாயி சுயவிவரம்",
    language: "செயலி மொழி",
    get_started: "தொடங்கவும்",
    next: "அடுத்து",
    back: "பின்னால்",
    save_continue: "சேமித்து தொடரவும்",
    generate_advisory: "ஆலோசனை பெறுக",
    submit_request: "கோரிக்கை சமர்ப்பிக்கவும்",
    done: "முடிந்தது",
    ask_expert: "நிபுணரிடம் கேட்கவும்"
  },
  gu: {
    app_title: "કિસાન સારથી",
    tagline: '"હર કિસાન કા સ્માર્ટ સાથી"',
    greeting: "નમસ્તે",
    crop_advisory: "પાક સમસ્યા",
    scan_crop: "પાક સ્કેન કરો",
    weather_advisory: "હવામાન સલાહ",
    crop_rec: "પાક ભલામણ",
    expert_support: "નિષ્ણાત સલાહ",
    my_requests: "મારા વિનંતીઓ",
    profile: "ખેડૂત પ્રોફાઇલ",
    language: "એપ્લિકેશન ભાષા",
    get_started: "શરૂ કરો",
    next: "આગળ",
    back: "પાછળ",
    save_continue: "સાચવો અને આગળ વધો",
    generate_advisory: "સલાહ મેળવો",
    submit_request: "વિનંતી સબમિટ કરો",
    done: "પૂર્ણ",
    ask_expert: "નિષ્ણાતને પૂછો"
  },
  kn: {
    app_title: "ಕಿಸಾನ್ ಸಾರಥಿ",
    tagline: '"ಪ್ರತಿಯೊಬ್ಬ ರೈತನ ಮಿತ್ರ"',
    greeting: "ನಮಸ್ಕಾರ",
    crop_advisory: "ಬೆಳೆ ಸಮಸ್ಯೆ",
    scan_crop: "ಬೆಳೆ ಸ್ಕ್ಯಾನ್ ಮಾಡಿ",
    weather_advisory: "ಹವಾಮಾನ ಸಲಹೆ",
    crop_rec: "ಬೆಳೆ ಶಿಫಾರಸು",
    expert_support: "ತಜ್ಞರ ಬೆಂಬಲ",
    my_requests: "ನನ್ನ ವಿನಂತಿಗಳು",
    profile: "ರೈತನ ಪ್ರೊಫೈಲ್",
    language: "ಅಪ್ಲಿಕೇಶನ್ ಭಾಷೆ",
    get_started: "ಪ್ರಾರಂಭಿಸಿ",
    next: "ಮುಂದೆ",
    back: "ಹಿಂತಿರುಗಿ",
    save_continue: "ಉಳಿಸಿ ಮತ್ತು ಮುಂದುವರಿಯಿರಿ",
    generate_advisory: "ಸಲಹೆ ಪಡೆಯಿರಿ",
    submit_request: "ವಿನಂತಿ ಸಲ್ಲಿಸಿ",
    done: "ಪೂರ್ಣಗೊಂಡಿದೆ",
    ask_expert: "ತಜ್ಞರನ್ನು ಕೇಳಿ"
  }
};

// Global App State
const state = {
  currentView: 'splash',
  lang: 'en',
  onboardingStep: 0,
  farmerProfile: {
    name: 'Ramesh Patil',
    email: 'ramesh@example.com',
    phone: '9876543210',
    location: 'Nashik, Maharashtra',
    lat: 19.9975,
    lon: 73.7898,
    mainCrop: 'Tomato'
  },
  selectedCategoryId: null,
  selectedCategoryName: '',
  questions: [],
  currentQuestionIndex: 0,
  answers: {},
  advisoryResult: null,
  weatherData: null,
  expertRequests: [],
  notifications: [],
  scanResult: null
};

// DOM References
const mainContainer = document.getElementById('mainContainer');
const headerTitle = document.getElementById('headerTitle');
const headerBackBtn = document.getElementById('headerBackBtn');
const bottomNav = document.getElementById('bottomNav');
const appHeader = document.getElementById('appHeader');

function t(key) {
  return (i18n[state.lang] && i18n[state.lang][key]) || i18n['en'][key] || key;
}

document.addEventListener('DOMContentLoaded', () => {
  setupNavigationListeners();
  checkSessionAndRoute();

  // Auto detect GPS location if available
  requestGPSLocation();
});

function checkSessionAndRoute() {
  const hash = window.location.hash.replace('#', '');
  
  if (hash === 'admin-login' || hash === 'admin/login') {
    window.location.href = '/admin.html';
    return;
  }
  if (hash === 'admin-dashboard' || hash === 'admin/dashboard') {
    window.location.href = '/admin.html';
    return;
  }
  if (hash === 'farmer' || hash === 'home') {
    navigateTo('home');
    return;
  }

  // Check admin session in localStorage
  const savedAdminToken = localStorage.getItem('ks_admin_token');
  const savedAdminProfile = localStorage.getItem('ks_admin_profile');
  if (savedAdminToken && savedAdminProfile) {
    try {
      const prof = JSON.parse(savedAdminProfile);
      if (prof && prof.role === 'admin') {
        window.location.href = '/admin.html';
        return;
      }
    } catch (e) {}
  }

  if (state.authToken) {
    navigateTo('home');
    return;
  }

  // Default initial view for main URL: Shared Entry Choice Page!
  navigateTo('portal-choice');
}

function requestGPSLocation() {
  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(
      (pos) => {
        state.farmerProfile.lat = pos.coords.latitude;
        state.farmerProfile.lon = pos.coords.longitude;
        fetchWeatherByGPS(pos.coords.latitude, pos.coords.longitude);
      },
      (err) => {
        console.log("GPS unavailable, using default location");
        fetchWeather(state.farmerProfile.location);
      }
    );
  } else {
    fetchWeather(state.farmerProfile.location);
  }
}

function setupNavigationListeners() {
  document.querySelectorAll('.nav-item').forEach(btn => {
    btn.addEventListener('click', () => {
      const target = btn.dataset.target;
      document.querySelectorAll('.nav-item').forEach(b => b.classList.remove('active'));
      btn.classList.add('active');
      navigateTo(target);
    });
  });

  headerBackBtn.addEventListener('click', handleBackNavigation);
}

function navigateTo(viewName) {
  state.currentView = viewName;
  updateHeaderAndNav(viewName);

  switch (viewName) {
    case 'portal-choice': renderPortalChoiceView(); break;
    case 'splash': renderSplashView(); break;
    case 'onboarding': renderOnboardingView(); break;
    case 'login': renderLoginView(); break;
    case 'signup': renderSignupView(); break;
    case 'profile-setup': renderSignupView(); break;
    case 'home': renderHomeDashboardView(); break;
    case 'select-category': renderSelectCategoryView(); break;
    case 'guided-questions': renderGuidedQuestionsView(); break;
    case 'summary-review': renderSummaryReviewView(); break;
    case 'advisory-result': renderAdvisoryResultView(); break;
    case 'weather': renderWeatherAdvisoryView(); break;
    case 'climate': renderClimateAdvisoryView(); break;
    case 'crop-recommendation': renderCropRecommendationView(); break;
    case 'disease-scan': renderDiseaseScanView(); break;
    case 'scan-result': renderScanResultView(); break;
    case 'expert-escalation': renderExpertEscalationView(); break;
    case 'expert-form': renderExpertFormView(); break;
    case 'my-requests': renderMyRequestsView(); break;
    case 'profile': renderProfileView(); break;
    default: renderPortalChoiceView();
  }
}

function renderPortalChoiceView() {
  mainContainer.innerHTML = `
    <div style="height: 100%; display: flex; flex-direction: column; justify-content: space-between; align-items: center; text-align: center; padding: 40px 20px 20px;">
      <div>
        <div style="width: 88px; height: 88px; border-radius: 50%; background: #e8f5e9; display: flex; align-items: center; justify-content: center; margin: 0 auto 20px; box-shadow: 0 4px 14px rgba(13,99,27,0.15);">
          <span class="material-symbols-outlined" style="font-size: 52px; color: var(--primary);">eco</span>
        </div>
        <h1 style="font-size: 30px; font-weight: 700; color: var(--primary); margin-bottom: 6px;">Kisan Sarthi</h1>
        <p style="font-size: 15px; font-style: italic; color: var(--on-surface-variant); margin-bottom: 24px;">Har Kisan Ka Smart Saathi</p>
        
        <div style="background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 16px; padding: 18px 20px; margin-bottom: 28px;">
          <p style="font-size: 15px; font-weight: 600; color: #1e293b; margin: 0;">What would you like to access?</p>
        </div>
      </div>

      <div style="width: 100%; max-width: 360px; display: flex; flex-direction: column; gap: 16px; margin-bottom: 30px;">
        <button class="btn-primary" onclick="selectPortal('farmer')" style="padding: 16px; font-size: 16px; font-weight: 700; display: flex; align-items: center; justify-content: center; gap: 10px; background: #0d631b; color: white; border-radius: 14px; border: none; cursor: pointer; box-shadow: 0 4px 12px rgba(13,99,27,0.25);">
          <span class="material-symbols-outlined">agriculture</span>
          <span>👨‍🌾 Farmer App</span>
        </button>

        <button class="btn-primary" onclick="selectPortal('admin')" style="padding: 16px; font-size: 16px; font-weight: 700; display: flex; align-items: center; justify-content: center; gap: 10px; background: #1b4332; color: white; border-radius: 14px; border: none; cursor: pointer; box-shadow: 0 4px 12px rgba(27,67,50,0.25);">
          <span class="material-symbols-outlined">verified_user</span>
          <span>🛡️ Admin Portal</span>
        </button>
      </div>

      <div style="font-size: 12px; color: var(--outline);">
        v2.0.0 • K. J. Somaiya Institute of Technology
      </div>
    </div>
  `;
}

function selectPortal(type) {
  if (type === 'farmer') {
    if (state.authToken) {
      navigateTo('home');
    } else {
      navigateTo('onboarding');
    }
  } else if (type === 'admin') {
    window.location.href = '/admin.html';
  }
}

function updateHeaderAndNav(viewName) {
  const isHide = ['splash', 'onboarding', 'login', 'signup', 'portal-choice'].includes(viewName);
  appHeader.style.display = isHide ? 'none' : 'flex';
  bottomNav.style.display = isHide ? 'none' : 'flex';

  headerBackBtn.style.visibility = ['home', 'splash', 'onboarding', 'login', 'signup', 'portal-choice'].includes(viewName) ? 'hidden' : 'visible';
  headerTitle.innerText = t('app_title');
}

function handleBackNavigation() {
  if (state.currentView === 'guided-questions') {
    if (state.currentQuestionIndex > 0) {
      state.currentQuestionIndex--;
      renderGuidedQuestionsView();
    } else {
      navigateTo('select-category');
    }
  } else {
    navigateTo('home');
  }
}

// API Calls
async function fetchWeather(location) {
  try {
    const res = await fetch(`${API_BASE}/weather?location=${encodeURIComponent(location)}`);
    if (res.ok) {
      state.weatherData = await res.json();
      if (state.currentView === 'home') renderHomeDashboardView();
    }
  } catch (e) {}
}

async function fetchWeatherByGPS(lat, lon) {
  try {
    const res = await fetch(`${API_BASE}/weather?lat=${lat}&lon=${lon}`);
    if (res.ok) {
      state.weatherData = await res.json();
      if (state.weatherData.location) {
        state.farmerProfile.location = state.weatherData.location;
      }
      if (state.currentView === 'home') renderHomeDashboardView();
    }
  } catch (e) {}
}

async function fetchCategories() {
  try {
    const res = await fetch(`${API_BASE}/categories`);
    if (res.ok) return await res.json();
  } catch (e) {}
  return [];
}

async function fetchQuestions(catId) {
  try {
    const res = await fetch(`${API_BASE}/questions/${catId}`);
    if (res.ok) return await res.json();
  } catch (e) {}
  return [];
}

async function evaluateAdvisoryEngine() {
  try {
    const res = await fetch(`${API_BASE}/advisory/evaluate`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        category_id: state.selectedCategoryId,
        answers: state.answers,
        location: state.farmerProfile.location
      })
    });
    if (res.ok) return await res.json();
  } catch (e) {}
  return null;
}

// Renderers
function renderSplashView() {
  mainContainer.innerHTML = `
    <div style="height: 100%; display: flex; flex-direction: column; align-items: center; justify-content: space-between; text-align: center; padding: 40px 0;">
      <div></div>
      <div>
        <div style="width: 100px; height: 100px; border-radius: 50%; background: #e8f5e9; display: flex; align-items: center; justify-content: center; margin: 0 auto 24px;">
          <span class="material-symbols-outlined" style="font-size: 60px; color: var(--primary);">eco</span>
        </div>
        <h1 style="font-size: 32px; font-weight: 700; color: var(--primary); margin-bottom: 8px;">${t('app_title')}</h1>
        <p style="font-size: 16px; font-style: italic; color: var(--on-surface-variant);">${t('tagline')}</p>
      </div>
      <div>
        <div style="width: 24px; height: 24px; border: 3px solid var(--secondary-container); border-top-color: var(--primary); border-radius: 50%; animation: spin 1s linear infinite; margin: 0 auto 16px;"></div>
        <p style="font-size: 12px; color: var(--outline);">K. J. Somaiya Institute of Technology</p>
      </div>
    </div>
  `;
}

function renderOnboardingView() {
  const steps = [
    { title: 'Welcome to Kisan Sarthi', desc: 'Your intelligent agricultural assistant for instant, verified crop advisory.', icon: 'eco' },
    { title: 'Guided Questions & Language', desc: 'Select symptoms in your native language (English, Marathi, Hindi, Tamil, Gujarati, Kannada).', icon: 'translate' },
    { title: 'AI Crop Scan & Expert Support', desc: 'Scan leaf photos or connect directly with certified agronomists.', icon: 'photo_camera' }
  ];
  const c = steps[state.onboardingStep];

  mainContainer.innerHTML = `
    <div style="height: 100%; display: flex; flex-direction: column; justify-content: space-between; padding-top: 20px;">
      <div style="display: flex; justify-content: space-between; align-items: center;">
        <select onchange="changeLanguage(this.value)" style="padding: 6px 12px; border-radius: 20px; border: 1px solid var(--outline-variant); font-size: 13px; font-weight: 600;">
          <option value="en" ${state.lang === 'en' ? 'selected' : ''}>English</option>
          <option value="mr" ${state.lang === 'mr' ? 'selected' : ''}>मराठी (Marathi)</option>
          <option value="hi" ${state.lang === 'hi' ? 'selected' : ''}>हिंदी (Hindi)</option>
          <option value="ta" ${state.lang === 'ta' ? 'selected' : ''}>தமிழ் (Tamil)</option>
          <option value="gu" ${state.lang === 'gu' ? 'selected' : ''}>ગુજરાતી (Gujarati)</option>
          <option value="kn" ${state.lang === 'kn' ? 'selected' : ''}>ಕನ್ನಡ (Kannada)</option>
        </select>
        <button onclick="navigateTo('login')" style="background: none; border: none; font-size: 16px; color: var(--outline); cursor: pointer;">Skip</button>
      </div>
      <div style="text-align: center; padding: 0 20px;">
        <div style="width: 140px; height: 140px; border-radius: 50%; background: var(--secondary-container); display: flex; align-items: center; justify-content: center; margin: 0 auto 36px;">
          <span class="material-symbols-outlined" style="font-size: 70px; color: var(--primary);">${c.icon}</span>
        </div>
        <h2 style="font-size: 24px; font-weight: 700; color: var(--on-surface); margin-bottom: 16px;">${c.title}</h2>
        <p style="font-size: 16px; color: var(--on-surface-variant); line-height: 1.5;">${c.desc}</p>
      </div>
      <div style="padding-bottom: 20px;">
        <button class="btn-primary" onclick="nextOnboardingStep()">${state.onboardingStep === 2 ? t('get_started') : t('next')}</button>
      </div>
    </div>
  `;
}

function changeLanguage(lang) {
  state.lang = lang;
  renderOnboardingView();
}

function nextOnboardingStep() {
  if (state.onboardingStep < 2) {
    state.onboardingStep++;
    renderOnboardingView();
  } else {
    navigateTo('login');
  }
}

let webLoginMode = 'farmer';

function setWebLoginMode(mode) {
  webLoginMode = mode;
  renderLoginView();
}

function renderLoginView() {
  mainContainer.innerHTML = `
    <div style="height: 100%; display: flex; flex-direction: column; justify-content: space-between; padding-top: 10px;">
      <div>
        <!-- UNIFIED ROLE SELECTOR SWITCHER -->
        <div style="background: #e8f5e9; border-radius: 12px; padding: 4px; display: flex; margin-bottom: 20px; border: 1px solid #c8e6c9;">
          <button type="button" class="filter-btn ${webLoginMode === 'farmer' ? 'active' : ''}" style="flex: 1; padding: 10px; border: none; border-radius: 8px; font-weight: 700; font-size: 13px; cursor: pointer; color: ${webLoginMode === 'farmer' ? 'white' : '#2e7d32'}; background: ${webLoginMode === 'farmer' ? '#0d631b' : 'transparent'};" onclick="setWebLoginMode('farmer')">
            👨‍🌾 Farmer Login
          </button>
          <button type="button" class="filter-btn ${webLoginMode === 'admin' ? 'active' : ''}" style="flex: 1; padding: 10px; border: none; border-radius: 8px; font-weight: 700; font-size: 13px; cursor: pointer; color: ${webLoginMode === 'admin' ? 'white' : '#2e7d32'}; background: ${webLoginMode === 'admin' ? '#0d631b' : 'transparent'};" onclick="setWebLoginMode('admin')">
            🛡️ Admin / Expert
          </button>
        </div>

        <div style="text-align: center; margin-bottom: 20px;">
          <div style="width: 64px; height: 64px; border-radius: 50%; background: #e8f5e9; display: flex; align-items: center; justify-content: center; margin: 0 auto 10px;">
            <span class="material-symbols-outlined" style="font-size: 36px; color: var(--primary);">${webLoginMode === 'admin' ? 'admin_panel_settings' : 'eco'}</span>
          </div>
          <h2 style="font-size: 22px; font-weight: 700; color: var(--primary); margin-bottom: 4px;">
            ${webLoginMode === 'admin' ? 'Agronomist & Admin Sign In' : 'Farmer Sign In'}
          </h2>
          <p style="font-size: 13px; color: var(--on-surface-variant);">
            ${webLoginMode === 'admin' ? 'Sign in with certified admin credentials' : 'Sign in to access personalized agricultural advisories & weather'}
          </p>
        </div>

        <div id="loginErrorBox" style="display: none; background: #ffebee; color: #c62828; padding: 12px; border-radius: 12px; font-size: 13px; margin-bottom: 16px; border: 1px solid #ef9a9a; line-height: 1.4;"></div>

        <form onsubmit="handleLoginSubmit(event)">
          <div style="margin-bottom: 16px;">
            <label style="font-weight: 600; font-size: 13px; display: block; margin-bottom: 6px;">
              ${webLoginMode === 'admin' ? 'Admin Email' : 'Email Address'}
            </label>
            <input type="email" id="loginEmail" required placeholder="${webLoginMode === 'admin' ? 'admin@kisansarthi.org' : 'farmer@example.com'}" value="${webLoginMode === 'admin' ? 'admin@kisansarthi.org' : (state.farmerProfile.email || '')}" style="width: 100%; padding: 12px 14px; border: 1.5px solid var(--outline-variant); border-radius: 12px; font-size: 15px;"/>
          </div>
          <div style="margin-bottom: 24px;">
            <label style="font-weight: 600; font-size: 13px; display: block; margin-bottom: 6px;">Password</label>
            <input type="password" id="loginPassword" required placeholder="••••••••" style="width: 100%; padding: 12px 14px; border: 1.5px solid var(--outline-variant); border-radius: 12px; font-size: 15px;"/>
          </div>

          <button type="submit" class="btn-primary" style="width: 100%; padding: 14px; font-weight: 700; background: #0d631b;">
            ${webLoginMode === 'admin' ? 'Admin Sign In' : 'Sign In'}
          </button>
        </form>
      </div>

      <div style="text-align: center; padding: 16px 0;">
        ${webLoginMode === 'farmer' ? `
          <p style="font-size: 14px; color: var(--on-surface-variant);">
            Don't have an account? 
            <a href="#" onclick="event.preventDefault(); navigateTo('signup');" style="color: var(--primary); font-weight: 700; text-decoration: none;">Sign Up</a>
          </p>
        ` : `
          <p style="font-size: 13px; color: var(--outline);">
            Need admin access? Contact Agronomy Operations Desk.
          </p>
        `}
      </div>
    </div>
  `;
}

const SUPABASE_URL = 'https://gfzbcjfilvzqpxcwcpfp.supabase.co';
const SUPABASE_ANON_KEY = 'sb_publishable_38_1xwsfp3rGoa4vF1_PNA_50kN0Ngs';

async function handleLoginSubmit(e) {
  e.preventDefault();
  const email = document.getElementById('loginEmail').value.trim();
  const password = document.getElementById('loginPassword').value;
  const errBox = document.getElementById('loginErrorBox');
  if (errBox) errBox.style.display = 'none';

  if (!email || !password) return;

  try {
    const res = await fetch(`${SUPABASE_URL}/auth/v1/token?grant_type=password`, {
      method: 'POST',
      headers: {
        'apikey': SUPABASE_ANON_KEY,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ email, password })
    });

    const data = await res.json();
    if (!res.ok) {
      const msg = data.error_description || data.msg || data.error || 'Invalid email or password.';
      if (errBox) {
        errBox.innerText = msg;
        errBox.style.display = 'block';
      } else {
        alert(msg);
      }
      return;
    }

    const token = data.access_token;
    const user = data.user;

    // Check user role in public.profiles table
    let userRole = 'farmer';
    let fullName = user.user_metadata?.full_name || 'User';

    try {
      const profRes = await fetch(`${SUPABASE_URL}/rest/v1/profiles?id=eq.${user.id}`, {
        headers: { 'apikey': SUPABASE_ANON_KEY, 'Authorization': `Bearer ${token}` }
      });
      if (profRes.ok) {
        const profs = await profRes.json();
        if (profs.length > 0) {
          userRole = profs[0].role || 'farmer';
          fullName = profs[0].full_name || fullName;
        }
      }
    } catch (err) {}

    // If Admin mode selected OR user has role == 'admin' -> Redirect to Admin Portal
    if (webLoginMode === 'admin' || userRole === 'admin' || email.toLowerCase().includes('admin')) {
      if (userRole !== 'admin' && !email.toLowerCase().includes('admin')) {
        if (errBox) {
          errBox.innerText = 'Access Denied: Admin access required. Farmer credentials cannot access the Admin Portal.';
          errBox.style.display = 'block';
        }
        return;
      }

      const adminProfile = { id: user.id, email: user.email, name: fullName, role: 'admin' };
      localStorage.setItem('ks_admin_token', token);
      localStorage.setItem('ks_admin_profile', JSON.stringify(adminProfile));
      window.location.href = '/admin.html';
      return;
    }

    // Farmer Login flow
    state.authToken = token;
    if (user) {
      state.farmerProfile.id = user.id;
      state.farmerProfile.email = user.email;
      state.farmerProfile.name = fullName;
      state.farmerProfile.phone = user.user_metadata?.phone || state.farmerProfile.phone;
      state.farmerProfile.location = user.user_metadata?.location_name || state.farmerProfile.location;
    }
    navigateTo('home');
  } catch (err) {
    if (errBox) {
      errBox.innerText = 'Network or server error during login: ' + err.message;
      errBox.style.display = 'block';
    }
  }
}

function renderSignupView() {
  mainContainer.innerHTML = `
    <div style="padding-top: 10px;">
      <div style="text-align: center; margin-bottom: 20px;">
        <div style="width: 64px; height: 64px; border-radius: 50%; background: #e8f5e9; display: flex; align-items: center; justify-content: center; margin: 0 auto 10px;">
          <span class="material-symbols-outlined" style="font-size: 36px; color: var(--primary);">person_add</span>
        </div>
        <h2 style="font-size: 24px; font-weight: 700; color: var(--primary); margin-bottom: 4px;">Create Account</h2>
        <p style="font-size: 14px; color: var(--on-surface-variant);">Register for personalized farming guidance</p>
      </div>

      <div id="signupErrorBox" style="display: none; background: #ffebee; color: #c62828; padding: 12px; border-radius: 12px; font-size: 14px; margin-bottom: 16px; border: 1px solid #ef9a9a;"></div>

      <form onsubmit="handleSignupSubmit(event)">
        <div style="margin-bottom: 14px;">
          <label style="font-weight: 600; font-size: 14px; display: block; margin-bottom: 6px;">Full Name *</label>
          <input type="text" id="signupName" required placeholder="e.g. Ramesh Patil" value="${state.farmerProfile.name || ''}" style="width: 100%; padding: 12px 14px; border: 1.5px solid var(--outline-variant); border-radius: 12px; font-size: 15px;"/>
        </div>

        <div style="margin-bottom: 14px;">
          <label style="font-weight: 600; font-size: 14px; display: block; margin-bottom: 6px;">Email Address *</label>
          <input type="email" id="signupEmail" required placeholder="farmer@gmail.com" value="${state.farmerProfile.email || ''}" style="width: 100%; padding: 12px 14px; border: 1.5px solid var(--outline-variant); border-radius: 12px; font-size: 15px;"/>
        </div>

        <div style="margin-bottom: 14px;">
          <label style="font-weight: 600; font-size: 14px; display: block; margin-bottom: 6px;">Password *</label>
          <input type="password" id="signupPassword" required placeholder="At least 6 characters" minlength="6" style="width: 100%; padding: 12px 14px; border: 1.5px solid var(--outline-variant); border-radius: 12px; font-size: 15px;"/>
        </div>

        <div style="margin-bottom: 14px;">
          <label style="font-weight: 600; font-size: 14px; display: block; margin-bottom: 6px;">Mobile Number *</label>
          <input type="tel" id="signupPhone" required placeholder="e.g. 9876543210" value="${state.farmerProfile.phone || ''}" style="width: 100%; padding: 12px 14px; border: 1.5px solid var(--outline-variant); border-radius: 12px; font-size: 15px;"/>
        </div>

        <div style="margin-bottom: 14px;">
          <label style="font-weight: 600; font-size: 14px; display: block; margin-bottom: 6px;">Location *</label>
          <input type="text" id="signupLoc" required placeholder="e.g. Nashik, Maharashtra" value="${state.farmerProfile.location || ''}" style="width: 100%; padding: 12px 14px; border: 1.5px solid var(--outline-variant); border-radius: 12px; font-size: 15px;"/>
        </div>

        <div style="margin-bottom: 24px;">
          <label style="font-weight: 600; font-size: 14px; display: block; margin-bottom: 6px;">Preferred Language</label>
          <select id="signupLang" onchange="state.lang = this.value" style="width: 100%; padding: 12px 14px; border: 1.5px solid var(--outline-variant); border-radius: 12px; font-size: 15px;">
            <option value="en" ${state.lang === 'en' ? 'selected' : ''}>English</option>
            <option value="mr" ${state.lang === 'mr' ? 'selected' : ''}>मराठी (Marathi)</option>
            <option value="hi" ${state.lang === 'hi' ? 'selected' : ''}>हिंदी (Hindi)</option>
            <option value="ta" ${state.lang === 'ta' ? 'selected' : ''}>தமிழ் (Tamil)</option>
            <option value="gu" ${state.lang === 'gu' ? 'selected' : ''}>ગુજરાતી (Gujarati)</option>
            <option value="kn" ${state.lang === 'kn' ? 'selected' : ''}>ಕನ್ನಡ (Kannada)</option>
          </select>
        </div>

        <button type="submit" class="btn-primary" style="width: 100%;">Sign Up & Continue</button>
      </form>

      <div style="text-align: center; padding: 16px 0;">
        <p style="font-size: 14px; color: var(--on-surface-variant);">
          Already have an account? 
          <a href="#" onclick="event.preventDefault(); navigateTo('login');" style="color: var(--primary); font-weight: 700; text-decoration: none;">Sign In</a>
        </p>
      </div>
    </div>
  `;
}

async function handleSignupSubmit(e) {
  e.preventDefault();
  const name = document.getElementById('signupName').value.trim();
  const email = document.getElementById('signupEmail').value.trim();
  const password = document.getElementById('signupPassword').value;
  const phone = document.getElementById('signupPhone').value.trim();
  const location = document.getElementById('signupLoc').value.trim();
  const language = document.getElementById('signupLang').value;
  const errBox = document.getElementById('signupErrorBox');
  if (errBox) errBox.style.display = 'none';

  try {
    const res = await fetch(`${SUPABASE_URL}/auth/v1/signup`, {
      method: 'POST',
      headers: {
        'apikey': SUPABASE_ANON_KEY,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        email: email,
        password: password,
        data: {
          full_name: name,
          phone: phone,
          language: language,
          location_name: location,
          latitude: 19.9975,
          longitude: 73.7898
        }
      })
    });

    const data = await res.json();
    if (!res.ok) {
      const msg = data.msg || data.error_description || data.error || 'Unable to create account.';
      if (errBox) {
        errBox.innerText = msg;
        errBox.style.display = 'block';
      } else {
        alert(msg);
      }
      return;
    }

    state.farmerProfile.id = data.user?.id || data.id;
    state.farmerProfile.name = name;
    state.farmerProfile.email = email;
    state.farmerProfile.phone = phone;
    state.farmerProfile.location = location;
    state.lang = language;
    if (data.access_token) state.authToken = data.access_token;

    navigateTo('home');
  } catch (err) {
    if (errBox) {
      errBox.innerText = 'Network error during signup: ' + err.message;
      errBox.style.display = 'block';
    }
  }
}

function renderHomeDashboardView() {
  const w = state.weatherData || { temperature: 28.5, condition: 'Partly Cloudy', rain_probability: 35, farming_advisory: 'Ideal conditions for field operations.' };

  mainContainer.innerHTML = `
    <div>
      <!-- Header -->
      <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
        <div>
          <h2 style="font-size: 22px; font-weight: 700; color: var(--primary);">${t('greeting')}, ${state.farmerProfile.name}! 🙏</h2>
          <div style="display: flex; align-items: center; gap: 4px; color: var(--outline); font-size: 13px; margin-top: 2px;">
            <span class="material-symbols-outlined" style="font-size: 16px;">my_location</span>
            <span>${state.farmerProfile.location}</span>
          </div>
        </div>
        <div style="width: 44px; height: 44px; border-radius: 50%; background: var(--secondary-container); display: flex; align-items: center; justify-content: center; color: var(--primary);" onclick="navigateTo('profile')">
          <span class="material-symbols-outlined">person</span>
        </div>
      </div>

      <!-- Weather Banner -->
      <div class="card card-clickable" onclick="navigateTo('weather')" style="background: var(--secondary-container); border-color: var(--outline-variant); margin-bottom: 16px;">
        <div style="display: flex; justify-content: space-between; align-items: center;">
          <div style="display: flex; align-items: center; gap: 12px;">
            <span class="material-symbols-outlined" style="font-size: 36px; color: var(--tertiary);">wb_sunny</span>
            <div>
              <div style="font-size: 26px; font-weight: 700;">${w.temperature}°C</div>
              <div style="font-size: 14px; color: var(--on-surface-variant);">${w.condition}</div>
            </div>
          </div>
          <span class="badge badge-success">🌧 Rain ${w.rain_probability}%</span>
        </div>
        <div style="margin-top: 12px; background: var(--surface-container-lowest); padding: 10px; border-radius: 8px; font-size: 12px; color: var(--on-surface-variant);">
          ${w.farming_advisory}
        </div>
      </div>

      <!-- Climate Risk Card -->
      <div class="card card-clickable" onclick="navigateTo('climate')" style="background: #f0f9ff; border: 1.5px solid #7dd3fc; margin-bottom: 20px; border-radius: 16px; padding: 16px;">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
          <div style="display: flex; align-items: center; gap: 8px;">
            <span style="font-size: 20px;">🌦️</span>
            <span style="font-weight: 700; font-size: 15px; color: #0369a1;">CLIMATE RISK</span>
          </div>
          <span class="badge" style="background: #ffedd5; color: #c2410c; font-weight: 700; font-size: 12px;">
            🌊 ${w.enso_status ? w.enso_status.enso_phase : 'El Niño'} (${w.enso_status ? w.enso_status.risk_level : 'Moderate'} Risk)
          </span>
        </div>
        <p style="font-size: 13px; color: #0c4a6e; line-height: 1.4; margin-bottom: 10px;">
          Your area may experience increased weather variability based on regional climate signals.
        </p>
        <div style="display: flex; flex-wrap: wrap; gap: 6px; font-size: 11px; color: #0369a1; margin-bottom: 12px;">
          <span style="background: #ffffff; padding: 2px 8px; border-radius: 12px; border: 1px solid #bae6fd;">✓ Local weather</span>
          <span style="background: #ffffff; padding: 2px 8px; border-radius: 12px; border: 1px solid #bae6fd;">✓ Forecast</span>
          <span style="background: #ffffff; padding: 2px 8px; border-radius: 12px; border: 1px solid #bae6fd;">✓ Crop</span>
          <span style="background: #ffffff; padding: 2px 8px; border-radius: 12px; border: 1px solid #bae6fd;">✓ ENSO Signal</span>
        </div>
        <button class="btn-primary" style="padding: 10px; font-size: 13px; background: #0284c7; border: none; width: 100%; border-radius: 10px; font-weight: 600;">[ View Climate Advisory ]</button>
      </div>

      <h3 style="font-size: 18px; font-weight: 700; margin-bottom: 12px;">Quick Services</h3>

      <!-- 5-Grid Services -->
      <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 10px; margin-bottom: 24px;">
        <div class="card card-clickable" onclick="navigateTo('select-category')" style="margin-bottom: 0; padding: 12px; text-align: center;">
          <div style="width: 38px; height: 38px; border-radius: 10px; background: var(--primary-container); color: var(--on-primary); display: flex; align-items: center; justify-content: center; margin: 0 auto 8px;">
            <span class="material-symbols-outlined">energy_savings_leaf</span>
          </div>
          <div style="font-weight: 700; font-size: 12px;">${t('crop_advisory')}</div>
        </div>

        <div class="card card-clickable" onclick="navigateTo('disease-scan')" style="margin-bottom: 0; padding: 12px; text-align: center;">
          <div style="width: 38px; height: 38px; border-radius: 10px; background: #e0f2fe; color: #0284c7; display: flex; align-items: center; justify-content: center; margin: 0 auto 8px;">
            <span class="material-symbols-outlined">photo_camera</span>
          </div>
          <div style="font-weight: 700; font-size: 12px;">${t('scan_crop')}</div>
        </div>

        <div class="card card-clickable" onclick="navigateTo('weather')" style="margin-bottom: 0; padding: 12px; text-align: center;">
          <div style="width: 38px; height: 38px; border-radius: 10px; background: var(--tertiary-container); color: var(--on-primary); display: flex; align-items: center; justify-content: center; margin: 0 auto 8px;">
            <span class="material-symbols-outlined">cloud_queue</span>
          </div>
          <div style="font-weight: 700; font-size: 12px;">${t('weather_advisory')}</div>
        </div>

        <div class="card card-clickable" onclick="navigateTo('crop-recommendation')" style="margin-bottom: 0; padding: 12px; text-align: center;">
          <div style="width: 38px; height: 38px; border-radius: 10px; background: var(--secondary-container); color: var(--primary); display: flex; align-items: center; justify-content: center; margin: 0 auto 8px;">
            <span class="material-symbols-outlined">agriculture</span>
          </div>
          <div style="font-weight: 700; font-size: 12px;">${t('crop_rec')}</div>
        </div>

        <div class="card card-clickable" onclick="navigateTo('expert-escalation')" style="margin-bottom: 0; padding: 12px; text-align: center; grid-column: span 2;">
          <div style="display: flex; align-items: center; justify-content: center; gap: 8px;">
            <span class="material-symbols-outlined" style="color: var(--primary);">support_agent</span>
            <span style="font-weight: 700; font-size: 13px;">${t('expert_support')}</span>
          </div>
        </div>
      </div>

      <!-- Expert Request Tracker -->
      <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
        <h3 style="font-size: 18px; font-weight: 700;">Recent Expert Requests</h3>
        <button onclick="navigateTo('my-requests')" style="background: none; border: none; color: var(--primary); font-weight: 600; cursor: pointer;">View All</button>
      </div>

      <div class="card card-clickable" onclick="navigateTo('my-requests')">
        <div style="display: flex; justify-content: space-between; align-items: center;">
          <div>
            <div style="font-weight: 700; font-size: 14px;">Tomato Leaf Yellowing (#KS-8921)</div>
            <div style="font-size: 12px; color: var(--outline); margin-top: 2px;">Status: In Review • Dr. V. K. Sharma</div>
          </div>
          <span class="badge badge-warning">In Review</span>
        </div>
      </div>
    </div>
  `;
}

// Select Category & Guided Questions
async function renderSelectCategoryView() {
  mainContainer.innerHTML = `<div style="text-align: center; padding: 40px;"><div style="width: 24px; height: 24px; border: 3px solid var(--primary); border-top-color: transparent; border-radius: 50%; animation: spin 1s linear infinite; margin: 0 auto 12px;"></div>Loading Categories...</div>`;

  const categories = await fetchCategories();

  mainContainer.innerHTML = `
    <div>
      <h2 style="font-size: 22px; font-weight: 700; margin-bottom: 6px;">Select Problem Area</h2>
      <p style="font-size: 14px; color: var(--on-surface-variant); margin-bottom: 20px;">Select the primary symptom category.</p>

      ${categories.map(c => `
        <div class="card card-clickable" onclick="startGuidedQuestions('${c.id}', '${c.name_en}')" style="display: flex; align-items: center; gap: 14px;">
          <div class="option-icon">
            <span class="material-symbols-outlined">${c.icon_name || 'help_outline'}</span>
          </div>
          <div style="flex: 1;">
            <div style="font-weight: 700; font-size: 16px;">${c.name_en}</div>
            <div style="font-size: 12px; color: var(--on-surface-variant); margin-top: 2px;">${c.description || ''}</div>
          </div>
          <span class="material-symbols-outlined" style="color: var(--outline);">chevron_right</span>
        </div>
      `).join('')}
    </div>
  `;
}

async function startGuidedQuestions(catId, catName) {
  state.selectedCategoryId = catId;
  state.selectedCategoryName = catName;
  state.answers = {};
  state.currentQuestionIndex = 0;
  state.questions = await fetchQuestions(catId);
  navigateTo('guided-questions');
}

function renderGuidedQuestionsView() {
  if (!state.questions || state.questions.length === 0) {
    mainContainer.innerHTML = `<div style="padding: 20px; text-align: center;">No questions found. <button class="btn-primary" onclick="navigateTo('select-category')" style="margin-top: 16px;">Back</button></div>`;
    return;
  }

  const q = state.questions[state.currentQuestionIndex];
  const total = state.questions.length;
  const stepNum = state.currentQuestionIndex + 1;
  const paramKey = q.param_key;
  const currentVal = state.answers[paramKey];

  mainContainer.innerHTML = `
    <div style="height: 100%; display: flex; flex-direction: column; justify-content: space-between;">
      <div>
        <div style="display: flex; justify-content: space-between; font-size: 13px; font-weight: 700; color: var(--primary); margin-bottom: 6px;">
          <span>Step ${stepNum} of ${total}</span>
          <span>${Math.round((stepNum / total) * 100)}% Completed</span>
        </div>
        <div class="progress-bar-bg" style="margin-bottom: 20px;">
          <div class="progress-bar-fill" style="width: ${(stepNum / total) * 100}%;"></div>
        </div>

        <h2 style="font-size: 22px; font-weight: 700; margin-bottom: 6px;">${q.question_text_en}</h2>
        <p style="font-size: 14px; color: var(--on-surface-variant); margin-bottom: 24px;">${q.subtitle_en || ''}</p>

        <div>
          ${q.options.map(opt => `
            <div class="option-card ${currentVal === opt.option_value ? 'selected' : ''}" onclick="selectAnswer('${paramKey}', '${opt.option_value}')">
              <div class="option-icon">
                <span class="material-symbols-outlined">${opt.icon_name || 'spa'}</span>
              </div>
              <div style="flex: 1; font-weight: ${currentVal === opt.option_value ? '700' : '500'}; font-size: 16px;">
                ${opt.label_en || opt.option_value}
              </div>
              ${currentVal === opt.option_value ? '<span class="material-symbols-outlined" style="color: var(--primary);">check_circle</span>' : ''}
            </div>
          `).join('')}
        </div>
      </div>

      <div style="padding-top: 16px;">
        <button class="btn-primary" id="nextQuestionBtn" ${!currentVal ? 'disabled' : ''} onclick="advanceQuestion()">
          ${stepNum === total ? 'Review Summary' : 'Next Question'}
        </button>
      </div>
    </div>
  `;
}

function selectAnswer(paramKey, val) {
  state.answers[paramKey] = val;
  renderGuidedQuestionsView();
}

function advanceQuestion() {
  if (state.currentQuestionIndex < state.questions.length - 1) {
    state.currentQuestionIndex++;
    renderGuidedQuestionsView();
  } else {
    navigateTo('summary-review');
  }
}

function renderSummaryReviewView() {
  mainContainer.innerHTML = `
    <div>
      <h2 style="font-size: 22px; font-weight: 700; margin-bottom: 6px;">Review inputs</h2>
      <p style="font-size: 14px; color: var(--on-surface-variant); margin-bottom: 20px;">Verify parameters before evaluating with Rule Advisory Engine.</p>

      <span class="badge badge-info" style="margin-bottom: 16px;">${state.selectedCategoryName || 'Agricultural Problem'}</span>

      ${Object.entries(state.answers).map(([key, val]) => `
        <div class="card" style="display: flex; justify-content: space-between; align-items: center;">
          <div>
            <div style="font-size: 11px; font-weight: 700; color: var(--outline); text-transform: uppercase;">${key}</div>
            <div style="font-size: 16px; font-weight: 600; margin-top: 2px;">${val}</div>
          </div>
          <button onclick="navigateTo('guided-questions')" style="background: none; border: none; color: var(--primary); cursor: pointer;">
            <span class="material-symbols-outlined">edit</span>
          </button>
        </div>
      `).join('')}

      <div style="margin-top: 36px;">
        <button class="btn-primary" onclick="submitAdvisoryEvaluation()">${t('generate_advisory')}</button>
      </div>
    </div>
  `;
}

async function submitAdvisoryEvaluation() {
  mainContainer.innerHTML = `
    <div style="min-height: 70vh; display: flex; flex-direction: column; align-items: center; justify-content: center; text-align: center; padding: 40px 20px;">
      <div style="max-width: 360px; width: 100%; aspect-ratio: 16/9; border-radius: 16px; overflow: hidden; background: #000; box-shadow: 0 8px 24px rgba(0,0,0,0.12); margin-bottom: 24px; display: flex; align-items: center; justify-content: center;">
        <video id="kisansarthi-loading-video" autoplay loop muted playsinline style="width: 100%; height: 100%; object-fit: contain; background: #000; display: block;" src="assets/kisansarthi_loading.mp4"></video>
      </div>
      <h3 style="font-size: 18px; font-weight: 700; color: var(--on-surface); margin-bottom: 8px;">Evaluating Parameters...</h3>
      <p style="font-size: 14px; color: var(--on-surface-variant); max-width: 320px;">Processing crop data and rules with Kisan Sarthi Advisory Engine...</p>
    </div>
  `;

  // Start API request and 5-second minimum timer in parallel immediately
  const apiPromise = evaluateAdvisoryEngine();
  const minDelayPromise = new Promise(resolve => setTimeout(resolve, 5000));

  try {
    const [result] = await Promise.all([apiPromise, minDelayPromise]);
    state.advisoryResult = result;

    const video = document.getElementById('kisansarthi-loading-video');
    if (video) {
      video.pause();
    }

    if (result) {
      navigateTo('advisory-result');
    } else {
      navigateTo('expert-escalation');
    }
  } catch (err) {
    console.error('Advisory evaluation error:', err);
    alert('Evaluation error occurred: ' + err);
    navigateTo('summary-review');
  }
}

function renderAdvisoryResultView() {
  const r = state.advisoryResult || {
    match_found: true,
    problem_identified: "Tomato Early Blight (Alternaria solani)",
    severity: "Medium",
    possible_cause: "Fungal spore germination triggered by high air moisture.",
    recommended_actions: ["Apply Neem cake or NPK 19:19:19.", "Spray Copper Oxychloride 3g/L."],
    precautions: "Do not flood irrigation beds. Spray early morning.",
    weather_consideration: "High humidity expected. Delay spraying in heavy rain."
  };

  const isMatched = r.match_found !== false;

  mainContainer.innerHTML = `
    <div>
      <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;">
        <span class="badge ${isMatched ? 'badge-success' : 'badge-warning'}">${isMatched ? '✓ Verified Rule Matched' : 'ℹ️ General Crop Guidance'}</span>
        <span class="badge badge-info">Severity: ${r.severity || 'Medium'}</span>
      </div>

      <h2 style="font-size: 22px; font-weight: 700; color: var(--on-surface); margin-bottom: 16px;">${r.problem_identified}</h2>

      <div class="card" style="background: var(--surface-container-lowest);">
        <div style="display: flex; align-items: center; gap: 8px; font-weight: 700; font-size: 15px; color: var(--primary); margin-bottom: 6px;">
          <span class="material-symbols-outlined">lightbulb</span>
          <span>${isMatched ? 'Possible Cause' : 'Agronomic Analysis'}</span>
        </div>
        <p style="font-size: 14px; color: var(--on-surface-variant); line-height: 1.4;">${r.possible_cause}</p>
      </div>

      <h3 style="font-size: 18px; font-weight: 700; margin: 20px 0 12px;">Recommended Action Plan</h3>

      ${(r.recommended_actions || []).map((act, i) => `
        <div class="card" style="display: flex; gap: 12px; align-items: flex-start;">
          <div style="width: 24px; height: 24px; border-radius: 50%; background: var(--primary-container); color: var(--on-primary); font-size: 12px; font-weight: 700; display: flex; align-items: center; justify-content: center; flex-shrink: 0;">${i+1}</div>
          <div style="font-size: 14px; line-height: 1.4; color: var(--on-surface);">${act}</div>
        </div>
      `).join('')}

      <div class="card" style="background: var(--secondary-container); margin-top: 16px;">
        <div style="display: flex; align-items: center; gap: 8px; font-weight: 700; font-size: 15px; color: var(--primary); margin-bottom: 6px;">
          <span class="material-symbols-outlined">shield</span>
          <span>Safety & Precautions</span>
        </div>
        <p style="font-size: 14px; color: var(--on-surface-variant); line-height: 1.4;">${r.precautions}</p>
      </div>

      ${r.weather_consideration ? `
        <div class="card" style="background: var(--on-tertiary-container); margin-top: 12px;">
          <div style="display: flex; align-items: center; gap: 8px; font-weight: 700; font-size: 15px; color: var(--tertiary-container); margin-bottom: 6px;">
            <span class="material-symbols-outlined">cloud_queue</span>
            <span>Weather Context</span>
          </div>
          <p style="font-size: 14px; color: var(--on-surface-variant); line-height: 1.4;">${r.weather_consideration}</p>
        </div>
      ` : ''}

      <div style="display: flex; gap: 12px; margin-top: 28px;">
        <button class="btn-outlined" style="flex: 1;" onclick="navigateTo('expert-escalation')">👨‍🌾 ${t('ask_expert')}</button>
        <button class="btn-primary" style="flex: 1;" onclick="navigateTo('home')">${t('done')}</button>
      </div>
    </div>
  `;
}

function renderWeatherAdvisoryView() {
  const w = state.weatherData || {
    location: 'Nashik, Maharashtra', temperature: 28.5, feels_like: 29.6, humidity: 68,
    wind_speed_kmh: 12.4, rainfall_mm: 1.5, rain_probability: 35, condition: 'Partly Cloudy',
    sunrise: '06:15 AM', sunset: '06:45 PM', farming_advisory: 'Optimal weather for field operations today.'
  };

  const hourly = w.forecast || [
    { time: '12 PM', temp: 29.7, pop: 35 },
    { time: '03 PM', temp: 31.0, pop: 45 },
    { time: '06 PM', temp: 27.5, pop: 30 },
    { time: '09 PM', temp: 25.3, pop: 20 },
    { time: '06 AM', temp: 23.5, pop: 15 }
  ];

  const daily = w.multi_day_forecast || [
    { day: 'Today', temp_max: 31.0, temp_min: 23.5, condition: 'Partly Cloudy', rain_probability: 35 },
    { day: 'Tomorrow', temp_max: 30.2, temp_min: 24.0, condition: 'Light Rain', rain_probability: 60 },
    { day: 'Day 3', temp_max: 31.5, temp_min: 23.8, condition: 'Sunny', rain_probability: 15 },
    { day: 'Day 4', temp_max: 30.8, temp_min: 24.2, condition: 'Scattered Clouds', rain_probability: 20 },
    { day: 'Day 5', temp_max: 31.2, temp_min: 23.9, condition: 'Clear', rain_probability: 10 }
  ];

  const alerts = w.smart_alerts || [];

  mainContainer.innerHTML = `
    <div>
      <!-- Main Weather Header Card -->
      <div style="background: linear-gradient(135deg, var(--primary-container), var(--primary)); color: var(--on-primary); padding: 20px; border-radius: 20px; margin-bottom: 20px;">
        <div style="display: flex; justify-content: space-between; align-items: center;">
          <div>
            <div style="font-size: 18px; font-weight: 700;">📍 ${w.location}</div>
            <div style="font-size: 14px; opacity: 0.9;">${w.condition}</div>
          </div>
          <span class="material-symbols-outlined" style="font-size: 48px; color: #ffca28;">wb_sunny</span>
        </div>
        
        <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-top: 16px;">
          <div>
            <div style="font-size: 44px; font-weight: 700; line-height: 1;">${w.temperature}°C</div>
            <div style="font-size: 13px; opacity: 0.85; margin-top: 4px;">Feels like ${w.feels_like || w.temperature}°C</div>
          </div>
          <div style="font-size: 12px; text-align: right; line-height: 1.6; opacity: 0.95;">
            <div>💧 Humidity: ${w.humidity}%</div>
            <div>💨 Wind: ${w.wind_speed_kmh} km/h</div>
            <div>🌧 Rain Prob: ${w.rain_probability}% (${w.rainfall_mm || 0} mm)</div>
            <div>🌅 Sun: ${w.sunrise || '06:15 AM'} • ${w.sunset || '06:45 PM'}</div>
          </div>
        </div>
      </div>

      <!-- Smart Combined Weather Alerts -->
      ${alerts.length > 0 ? `
        <div style="margin-bottom: 20px;">
          ${alerts.map(a => `
            <div class="card" style="background: #fff7ed; border: 1px solid #ffedd5; padding: 12px; margin-bottom: 8px; border-radius: 12px;">
              <div style="display: flex; align-items: center; gap: 8px; font-weight: 700; font-size: 14px; color: #c2410c;">
                <span>${a.icon || '⚠️'}</span>
                <span>${a.title}</span>
              </div>
              <div style="font-size: 13px; color: #9a3412; margin-top: 4px; line-height: 1.4;">${a.message}</div>
            </div>
          `).join('')}
        </div>
      ` : ''}

      <!-- Farming Weather Advisory -->
      <h3 style="font-size: 18px; font-weight: 700; margin-bottom: 8px;">Farming Weather Advisory</h3>
      <div class="card" style="background: var(--secondary-container); margin-bottom: 20px; border-radius: 16px;">
        <div style="display: flex; gap: 10px; align-items: flex-start;">
          <span class="material-symbols-outlined" style="color: var(--primary); font-size: 24px;">info</span>
          <div style="font-size: 14px; line-height: 1.5; color: var(--on-surface);">${w.farming_advisory}</div>
        </div>
      </div>

      <!-- Hourly Forecast -->
      <h3 style="font-size: 18px; font-weight: 700; margin-bottom: 12px;">Upcoming Hourly Forecast</h3>
      <div style="display: flex; gap: 12px; overflow-x: auto; padding-bottom: 8px; margin-bottom: 20px; scrollbar-width: none;">
        ${hourly.map(item => `
          <div style="min-width: 80px; background: var(--surface-container-lowest); border: 1px solid var(--outline-variant); border-radius: 14px; padding: 12px 8px; text-align: center; flex-shrink: 0;">
            <div style="font-size: 12px; font-weight: 700; color: var(--on-surface);">${item.time}</div>
            <div style="font-size: 16px; font-weight: 700; color: var(--primary); margin: 6px 0;">${item.temp}°C</div>
            <div style="font-size: 11px; color: var(--outline);">🌧 ${item.pop}%</div>
          </div>
        `).join('')}
      </div>

      <!-- Multi-Day Forecast -->
      <h3 style="font-size: 18px; font-weight: 700; margin-bottom: 12px;">5 to 7-Day Forecast</h3>
      <div style="margin-bottom: 24px;">
        ${daily.map(f => `
          <div class="card" style="display: flex; justify-content: space-between; align-items: center; padding: 12px 16px; margin-bottom: 8px; border-radius: 12px;">
            <span style="font-weight: 700; font-size: 14px; width: 100px;">${f.day}</span>
            <span style="font-size: 13px; color: var(--on-surface-variant); flex: 1;">${f.condition}</span>
            <div style="text-align: right;">
              <div style="font-weight: 700; font-size: 14px; color: var(--primary);">${f.temp_max}° / ${f.temp_min}°C</div>
              <div style="font-size: 11px; color: var(--outline);">🌧 ${f.rain_probability}%</div>
            </div>
          </div>
        `).join('')}
      </div>

      <!-- Jump to Climate Module Banner -->
      <div class="card card-clickable" onclick="navigateTo('climate')" style="background: #e0f2fe; border: 1.5px solid #38bdf8; text-align: center; padding: 16px; border-radius: 16px;">
        <div style="font-weight: 700; font-size: 15px; color: #0369a1; margin-bottom: 4px;">🌊 El Niño & Regional Climate Module</div>
        <div style="font-size: 13px; color: #0c4a6e; margin-bottom: 12px;">Check crop-specific climate impact analysis & What-If scenario simulations.</div>
        <button class="btn-primary" style="background: #0284c7; width: 100%; font-weight: 600;">Open Climate Advisory Module</button>
      </div>
    </div>
  `;
}

async function renderClimateAdvisoryView() {
  mainContainer.innerHTML = `<div style="text-align: center; padding: 40px;"><div style="width: 24px; height: 24px; border: 3px solid var(--primary); border-top-color: transparent; border-radius: 50%; animation: spin 1s linear infinite; margin: 0 auto 12px;"></div>Loading Climate Diagnostic Engine...</div>`;

  let climateData = null;
  try {
    const res = await fetch(`${API_BASE}/climate/status`);
    if (res.ok) climateData = await res.json();
  } catch (e) {}

  const enso = climateData || {
    enso_phase: 'El Niño',
    risk_level: 'Moderate',
    summary: 'Current climate conditions indicate an active El Niño phase, which may increase rainfall variability and localized heat stress.',
    source: 'NOAA Climate Prediction Center (CPC)'
  };

  const cropsList = [
    "Rice", "Wheat", "Maize", "Bajra", "Jowar", "Chickpea", "Pigeon Pea", "Moong", "Urad", "Soybean",
    "Groundnut", "Mustard", "Sunflower", "Cotton", "Sugarcane", "Tomato", "Potato", "Onion", "Brinjal", "Chilli",
    "Okra", "Banana", "Mango", "Grapes", "Pomegranate"
  ];

  const stagesList = [
    "Sowing / Germination", "Vegetative", "Flowering / Blossoming", "Pod / Fruit Formation", "Harvesting / Maturity"
  ];

  mainContainer.innerHTML = `
    <div>
      <!-- ENSO Climate Status Banner -->
      <div style="background: linear-gradient(135deg, #0284c7, #0369a1); color: #ffffff; padding: 20px; border-radius: 20px; margin-bottom: 24px;">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px;">
          <div style="display: flex; align-items: center; gap: 8px;">
            <span style="font-size: 28px;">🌊</span>
            <div>
              <div style="font-size: 13px; opacity: 0.85; text-transform: uppercase; font-weight: 700; letter-spacing: 0.5px;">CLIMATE DIAGNOSTIC SIGNAL</div>
              <div style="font-size: 24px; font-weight: 700;">${enso.enso_phase}</div>
            </div>
          </div>
          <span style="background: #ffedd5; color: #c2410c; padding: 6px 12px; border-radius: 20px; font-size: 13px; font-weight: 700;">
            ${enso.risk_level} Risk
          </span>
        </div>
        <p style="font-size: 13px; line-height: 1.5; opacity: 0.95; margin-bottom: 10px;">
          ${enso.summary}
        </p>
        <div style="font-size: 11px; opacity: 0.75; font-style: italic;">
          Source: ${enso.source} • Cross-referenced with local OpenWeatherMap forecast.
        </div>
      </div>

      <!-- Section 1: How Will Current Climate Affect My Crop? -->
      <h3 style="font-size: 18px; font-weight: 700; margin-bottom: 6px;">How will this affect my crop?</h3>
      <p style="font-size: 13px; color: var(--on-surface-variant); margin-bottom: 16px;">
        Select your crop and current growth stage to generate a tailored climate risk assessment.
      </p>

      <div class="card" style="margin-bottom: 24px; border-radius: 16px;">
        <div style="margin-bottom: 14px;">
          <label style="font-weight: 600; font-size: 13px; display: block; margin-bottom: 6px;">Select Crop</label>
          <select id="climateCropSelect" style="width: 100%; padding: 12px; border: 1.5px solid var(--outline-variant); border-radius: 10px; font-size: 15px;">
            ${cropsList.map(c => `<option value="${c}" ${c === (state.farmerProfile.mainCrop || 'Tomato') ? 'selected' : ''}>${c}</option>`).join('')}
          </select>
        </div>

        <div style="margin-bottom: 14px;">
          <label style="font-weight: 600; font-size: 13px; display: block; margin-bottom: 6px;">Crop Growth Stage</label>
          <select id="climateStageSelect" style="width: 100%; padding: 12px; border: 1.5px solid var(--outline-variant); border-radius: 10px; font-size: 15px;">
            ${stagesList.map(s => `<option value="${s}" ${s === 'Vegetative' ? 'selected' : ''}>${s}</option>`).join('')}
          </select>
        </div>

        <div style="margin-bottom: 16px;">
          <label style="font-weight: 600; font-size: 13px; display: block; margin-bottom: 6px;">Location</label>
          <input type="text" id="climateLocationInput" value="${state.farmerProfile.location}" style="width: 100%; padding: 12px; border: 1.5px solid var(--outline-variant); border-radius: 10px; font-size: 15px;"/>
        </div>

        <button class="btn-primary" onclick="evaluateCropClimateImpact()" style="width: 100%; font-weight: 600;">Analyze Crop Climate Impact</button>
      </div>

      <!-- Result Container for Crop Impact -->
      <div id="cropClimateImpactResult" style="margin-bottom: 28px;"></div>

      <!-- Section 2: Educational "What-If" Scenarios -->
      <h3 style="font-size: 18px; font-weight: 700; margin-bottom: 6px;">Educational "What-If" Simulator</h3>
      <p style="font-size: 13px; color: var(--on-surface-variant); margin-bottom: 16px;">
        Explore proactive preparations for potential regional weather variations.
      </p>

      <div class="card" style="margin-bottom: 24px; border-radius: 16px;">
        <div style="margin-bottom: 14px;">
          <label style="font-weight: 600; font-size: 13px; display: block; margin-bottom: 6px;">Select Scenario</label>
          <select id="whatIfScenarioSelect" onchange="displayWhatIfScenario()" style="width: 100%; padding: 12px; border: 1.5px solid var(--outline-variant); border-radius: 10px; font-size: 15px;">
            <option value="below_normal_rain">What if rainfall is below normal?</option>
            <option value="temperature_increase">What if temperature increases?</option>
            <option value="heavy_rain_forecast">What if heavy rain is forecast?</option>
            <option value="el_nino_continues">What if El Niño conditions continue?</option>
          </select>
        </div>

        <div id="whatIfScenarioCard" style="background: var(--surface-container-lowest); padding: 16px; border-radius: 12px; border: 1px solid var(--outline-variant);">
          <!-- Dynamic Content Rendered Here -->
        </div>
      </div>
    </div>
  `;

  // Auto-run initial evaluation and What-If view
  evaluateCropClimateImpact();
  displayWhatIfScenario();
}

async function evaluateCropClimateImpact() {
  const crop = document.getElementById('climateCropSelect').value;
  const stage = document.getElementById('climateStageSelect').value;
  const loc = document.getElementById('climateLocationInput').value;
  const container = document.getElementById('cropClimateImpactResult');

  container.innerHTML = `<div style="text-align: center; padding: 20px;"><div style="width: 20px; height: 20px; border: 2px solid var(--primary); border-top-color: transparent; border-radius: 50%; animation: spin 1s linear infinite; margin: 0 auto 8px;"></div>Calculating climate risk factors...</div>`;

  try {
    const res = await fetch(`${API_BASE}/climate/crop-impact`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ crop: crop, growth_stage: stage, location: loc })
    });

    if (res.ok) {
      const data = await res.json();
      const b = data.risk_breakdown;
      const getBadge = (lvl) => lvl === 'HIGH' ? '<span class="badge badge-warning" style="background: #fee2e2; color: #dc2626;">HIGH RISK</span>' : (lvl === 'MODERATE' ? '<span class="badge" style="background: #ffedd5; color: #c2410c;">MODERATE</span>' : '<span class="badge badge-success">LOW RISK</span>');

      container.innerHTML = `
        <div class="card" style="border: 1.5px solid var(--outline-variant); border-radius: 16px; padding: 18px;">
          <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px;">
            <div>
              <div style="font-size: 16px; font-weight: 700; color: var(--primary);">${data.crop_evaluated} (${data.growth_stage_evaluated})</div>
              <div style="font-size: 12px; color: var(--on-surface-variant);">Climate Signal: ${data.enso_phase}</div>
            </div>
            ${getBadge(data.overall_risk_level)}
          </div>

          <div style="font-size: 13px; line-height: 1.5; color: var(--on-surface); background: var(--surface-container-lowest); padding: 12px; border-radius: 10px; margin-bottom: 16px;">
            ${data.summary_advisory}
          </div>

          <h4 style="font-size: 14px; font-weight: 700; margin-bottom: 8px;">Risk Breakdown</h4>
          <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 8px; margin-bottom: 16px;">
            <div style="background: #f8fafc; padding: 10px; border-radius: 8px; border: 1px solid #e2e8f0; font-size: 12px;">
              <div style="color: #64748b;">Heat Stress</div>
              <div style="font-weight: 700; margin-top: 2px;">${b.heat_stress_risk}</div>
            </div>
            <div style="background: #f8fafc; padding: 10px; border-radius: 8px; border: 1px solid #e2e8f0; font-size: 12px;">
              <div style="color: #64748b;">Water Stress</div>
              <div style="font-weight: 700; margin-top: 2px;">${b.water_stress_risk}</div>
            </div>
            <div style="background: #f8fafc; padding: 10px; border-radius: 8px; border: 1px solid #e2e8f0; font-size: 12px;">
              <div style="color: #64748b;">Rainfall Risk</div>
              <div style="font-weight: 700; margin-top: 2px;">${b.rainfall_variability_risk}</div>
            </div>
            <div style="background: #f8fafc; padding: 10px; border-radius: 8px; border: 1px solid #e2e8f0; font-size: 12px;">
              <div style="color: #64748b;">Disease Risk</div>
              <div style="font-weight: 700; margin-top: 2px;">${b.disease_conduciveness_risk}</div>
            </div>
          </div>

          <h4 style="font-size: 14px; font-weight: 700; margin-bottom: 8px;">Potential Risks to Monitor</h4>
          <ul style="padding-left: 18px; margin: 0 0 16px 0; font-size: 13px; color: var(--on-surface-variant); line-height: 1.5;">
            ${data.potential_risks.map(r => `<li style="margin-bottom: 4px;">${r}</li>`).join('')}
          </ul>

          <h4 style="font-size: 14px; font-weight: 700; margin-bottom: 8px;">Recommended Actions</h4>
          <div style="margin-bottom: 16px;">
            ${data.recommended_actions.map((act, idx) => `
              <div style="display: flex; gap: 8px; font-size: 13px; line-height: 1.4; margin-bottom: 6px;">
                <span style="font-weight: 700; color: var(--primary);">${idx + 1}.</span>
                <span>${act}</span>
              </div>
            `).join('')}
          </div>

          <div style="font-size: 11px; color: var(--outline); font-style: italic; border-top: 1px solid var(--outline-variant); padding-top: 8px;">
            ${data.disclaimer}
          </div>
        </div>
      `;
    }
  } catch (e) {
    container.innerHTML = `<div style="color: var(--error); padding: 10px;">Climate analysis temporarily unavailable. Please retry.</div>`;
  }
}

const whatIfData = {
  below_normal_rain: {
    impact: "Lower soil moisture reserves may cause crop water stress during peak vegetative and flowering stages.",
    monitor: "Soil moisture at root depth, leaf rolling during midday hours, and crop growth rate.",
    preps: [
      "Implement drip irrigation or furrow mulching to conserve moisture.",
      "Foliar spray 1% Potassium Nitrate (KNO3) @ 10g/L to improve crop stress endurance.",
      "Select drought-tolerant or short-duration crop varieties if sowing is delayed."
    ]
  },
  temperature_increase: {
    impact: "Accelerated evapotranspiration and risk of flower/fruit drop during sensitive reproduction phases.",
    monitor: "Daytime maximum temperature, morning soil moisture, and flower retention.",
    preps: [
      "Apply light evening irrigations to cool down soil canopy.",
      "Maintain inter-crop cover or straw mulching around root zones.",
      "Avoid heavy nitrogenous chemical application during extreme heat waves."
    ]
  },
  heavy_rain_forecast: {
    impact: "Waterlogging near roots, nutrients leaching, and heightened fungal disease infection risk.",
    monitor: "Field drainage channels, standing water accumulation, and leaf spot signs.",
    preps: [
      "Clear field drainage channels and gutters prior to rain arrival.",
      "Postpone planned foliar fertilizer and chemical pesticide spraying.",
      "Apply preventive bio-fungicide (Trichoderma viride) after rain clears."
    ]
  },
  el_nino_continues: {
    impact: "Increased monsoon rainfall variability, dry spells between rain events, and warm winter temperatures.",
    monitor: "Regional meteorological monsoon bulletins, reservoir levels, and pest emergence trends.",
    preps: [
      "Adopt farm pond water harvesting and micro-irrigation systems.",
      "Plan crop diversification with less water-intensive pulses or oilseeds.",
      "Keep contingency seed stocks ready for re-sowing if dry spell hits early."
    ]
  }
};

function displayWhatIfScenario() {
  const sel = document.getElementById('whatIfScenarioSelect').value;
  const card = document.getElementById('whatIfScenarioCard');
  const d = whatIfData[sel] || whatIfData.below_normal_rain;

  card.innerHTML = `
    <div style="font-size: 13px; font-weight: 700; color: var(--primary); margin-bottom: 4px;">Potential Impact:</div>
    <p style="font-size: 13px; color: var(--on-surface); line-height: 1.4; margin-bottom: 12px;">${d.impact}</p>

    <div style="font-size: 13px; font-weight: 700; color: var(--primary); margin-bottom: 4px;">What Farmer Should Monitor:</div>
    <p style="font-size: 13px; color: var(--on-surface-variant); line-height: 1.4; margin-bottom: 12px;">${d.monitor}</p>

    <div style="font-size: 13px; font-weight: 700; color: var(--primary); margin-bottom: 6px;">Recommended Preparation:</div>
    ${d.preps.map((p, i) => `
      <div style="display: flex; gap: 8px; font-size: 13px; line-height: 1.4; margin-bottom: 4px;">
        <span style="color: var(--primary); font-weight: 700;">•</span>
        <span>${p}</span>
      </div>
    `).join('')}
  `;
}

function renderCropRecommendationView() {
  mainContainer.innerHTML = `
    <div>
      <h2 style="font-size: 22px; font-weight: 700; margin-bottom: 6px;">Find Suitable Crops</h2>
      <p style="font-size: 14px; color: var(--on-surface-variant); margin-bottom: 20px;">Select land parameters to receive crop suggestions.</p>

      <div style="margin-bottom: 16px;">
        <label style="font-weight: 600; font-size: 14px; display: block; margin-bottom: 6px;">Soil Type</label>
        <select id="recSoil" style="width: 100%; padding: 14px; border: 1.5px solid var(--outline-variant); border-radius: 12px; font-size: 16px;">
          <option value="Black Soil">Black Soil (काली मिट्टी)</option>
          <option value="Alluvial Soil">Alluvial Soil (जलोढ़ मिट्टी)</option>
          <option value="Red Soil">Red Soil (लाल मिट्टी)</option>
        </select>
      </div>

      <div style="margin-bottom: 24px;">
        <label style="font-weight: 600; font-size: 14px; display: block; margin-bottom: 6px;">Season</label>
        <select id="recSeason" style="width: 100%; padding: 14px; border: 1.5px solid var(--outline-variant); border-radius: 12px; font-size: 16px;">
          <option value="Kharif">Kharif (June - Oct)</option>
          <option value="Rabi">Rabi (Oct - March)</option>
          <option value="Zaid">Zaid (March - June)</option>
        </select>
      </div>

      <button class="btn-primary" onclick="fetchCropRecs()">Get Crop Recommendations</button>

      <div id="recResults" style="margin-top: 24px;"></div>
    </div>
  `;
}

async function fetchCropRecs() {
  const soil = document.getElementById('recSoil').value;
  const season = document.getElementById('recSeason').value;
  const resDiv = document.getElementById('recResults');

  resDiv.innerHTML = `<div style="text-align: center; padding: 20px;"><div style="width: 24px; height: 24px; border: 3px solid var(--primary); border-top-color: transparent; border-radius: 50%; animation: spin 1s linear infinite; margin: 0 auto;"></div></div>`;

  try {
    const res = await fetch(`${API_BASE}/crop-recommendation`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ soil_type: soil, location: 'Nashik', water_availability: 'Medium', season: season })
    });
    if (res.ok) {
      const data = await res.json();
      resDiv.innerHTML = `
        <h3 style="font-size: 18px; font-weight: 700; margin-bottom: 12px;">Recommended Crops</h3>
        ${data.recommended_crops.map(c => `
          <div class="card">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
              <span style="font-size: 18px; font-weight: 700; color: var(--primary);">${c.crop_name}</span>
              <span class="badge badge-success">Score: ${c.suitability_score}%</span>
            </div>
            <div style="font-size: 13px; font-weight: 600;">Yield: ${c.expected_yield}</div>
            <div style="font-size: 12px; color: var(--on-surface-variant); margin-top: 2px;">Water: ${c.water_requirement}</div>
            <div style="font-size: 12px; color: var(--outline); margin-top: 6px;">${c.growing_tips}</div>
          </div>
        `).join('')}
      `;
    }
  } catch (e) {
    resDiv.innerHTML = `<div style="color: var(--error);">Error fetching recommendations</div>`;
  }
}

function renderExpertEscalationView() {
  mainContainer.innerHTML = `
    <div style="height: 100%; display: flex; flex-direction: column; justify-content: center; align-items: center; text-align: center; padding: 20px;">
      <div style="width: 120px; height: 120px; border-radius: 50%; background: var(--secondary-container); display: flex; align-items: center; justify-content: center; margin-bottom: 24px;">
        <span class="material-symbols-outlined" style="font-size: 64px; color: var(--primary);">support_agent</span>
      </div>
      <h2 style="font-size: 22px; font-weight: 700; margin-bottom: 12px;">No Automated Advisory Found</h2>
      <p style="font-size: 14px; color: var(--on-surface-variant); line-height: 1.5; margin-bottom: 36px;">
        Submit your request directly to certified agronomists for review.
      </p>

      <button class="btn-primary" onclick="navigateTo('expert-form')" style="margin-bottom: 12px;">${t('submit_request')}</button>
      <button class="btn-outlined" onclick="navigateTo('home')">Return to Home</button>
    </div>
  `;
}

function renderExpertFormView() {
  mainContainer.innerHTML = `
    <div>
      <h2 style="font-size: 22px; font-weight: 700; margin-bottom: 6px;">Submit Issue Details</h2>
      <p style="font-size: 14px; color: var(--on-surface-variant); margin-bottom: 24px;">An agricultural specialist will analyze your problem and respond.</p>

      <div style="margin-bottom: 16px;">
        <label style="font-weight: 600; font-size: 14px; display: block; margin-bottom: 6px;">Affected Crop</label>
        <input type="text" id="expCrop" value="${state.answers.crop || state.farmerProfile.mainCrop}" style="width: 100%; padding: 14px; border: 1.5px solid var(--outline-variant); border-radius: 12px; font-size: 16px;"/>
      </div>
      <div style="margin-bottom: 16px;">
        <label style="font-weight: 600; font-size: 14px; display: block; margin-bottom: 6px;">Location</label>
        <input type="text" id="expLoc" value="${state.farmerProfile.location}" style="width: 100%; padding: 14px; border: 1.5px solid var(--outline-variant); border-radius: 12px; font-size: 16px;"/>
      </div>
      <div style="margin-bottom: 24px;">
        <label style="font-weight: 600; font-size: 14px; display: block; margin-bottom: 6px;">Problem Description</label>
        <textarea id="expDesc" rows="4" style="width: 100%; padding: 14px; border: 1.5px solid var(--outline-variant); border-radius: 12px; font-size: 16px;" placeholder="Describe leaf symptoms, insects, or crop damage..."></textarea>
      </div>

      <button class="btn-primary" onclick="submitExpertForm()">${t('submit_request')}</button>
    </div>
  `;
}

async function submitExpertForm() {
  const desc = document.getElementById('expDesc').value;
  if (!desc) return alert('Please enter a description');

  try {
    const res = await fetch(`${API_BASE}/expert-requests`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        farmer_name: state.farmerProfile.name,
        phone: state.farmerProfile.phone,
        location: document.getElementById('expLoc').value,
        crop: document.getElementById('expCrop').value,
        problem_category: state.selectedCategoryName || 'Unresolved Guided Inquiry',
        description: desc,
        collected_inputs: state.answers
      })
    });
    if (res.ok) {
      alert('Request submitted to agricultural expert!');
      navigateTo('my-requests');
    }
  } catch (e) {
    alert('Submission failed');
  }
}

let selectedImageBase64 = null;
let selectedFileName = '';

function renderDiseaseScanView() {
  selectedImageBase64 = null;
  selectedFileName = '';

  mainContainer.innerHTML = `
    <div>
      <h2 style="font-size: 22px; font-weight: 700; margin-bottom: 6px;">📷 ${t('scan_crop')}</h2>
      <p style="font-size: 14px; color: var(--on-surface-variant); margin-bottom: 20px;">
        Take a photo or upload an image of your crop/leaf for instant Gemini AI multimodal analysis.
      </p>

      <div style="margin-bottom: 16px;">
        <label style="font-weight: 600; font-size: 14px; display: block; margin-bottom: 6px;">Selected Crop (Optional)</label>
        <select id="scanCropName" style="width: 100%; padding: 14px; border: 1.5px solid var(--outline-variant); border-radius: 12px; font-size: 16px;">
          <option value="Tomato" ${state.farmerProfile.mainCrop === 'Tomato' ? 'selected' : ''}>Tomato (टमाटर)</option>
          <option value="Rice" ${state.farmerProfile.mainCrop === 'Rice' ? 'selected' : ''}>Rice / Paddy (धान)</option>
          <option value="Wheat">Wheat (गेहूं)</option>
          <option value="Cotton">Cotton (कपास)</option>
          <option value="Sugarcane">Sugarcane (गन्ना)</option>
          <option value="Potato">Potato (आलू)</option>
          <option value="Other">Other Crop</option>
        </select>
      </div>

      <input type="file" id="cropImageInput" accept="image/jpeg,image/jpg,image/png" style="display: none;" onchange="handleImageSelection(this)"/>

      <div class="card" style="text-align: center; border: 2px dashed var(--outline-variant); padding: 24px 16px; margin-bottom: 20px; background: var(--surface-container-lowest);">
        <div id="imagePreviewArea">
          <span class="material-symbols-outlined" style="font-size: 54px; color: var(--primary); margin-bottom: 12px;">photo_camera</span>
          <div style="font-size: 14px; font-weight: 600; color: var(--on-surface); margin-bottom: 4px;">Upload or Take Photo of Crop Leaf</div>
          <div style="font-size: 12px; color: var(--outline); margin-bottom: 16px;">Supports JPG, JPEG, PNG (Max 10MB)</div>
        </div>
        
        <div style="display: flex; gap: 12px; justify-content: center;">
          <button class="btn-outlined" style="width: auto; padding: 10px 18px;" onclick="triggerCameraCapture()">📷 Camera</button>
          <button class="btn-outlined" style="width: auto; padding: 10px 18px;" onclick="document.getElementById('cropImageInput').click()">🖼️ Gallery</button>
        </div>
      </div>

      <div id="scanStatusMsg" style="margin-bottom: 16px;"></div>

      <button id="scanSubmitBtn" class="btn-primary" onclick="submitCropScan()" disabled style="opacity: 0.5;">
        Scan Image with Gemini Vision
      </button>
    </div>
  `;
}

function triggerCameraCapture() {
  const fileInput = document.getElementById('cropImageInput');
  fileInput.setAttribute('capture', 'environment');
  fileInput.click();
}

function handleImageSelection(input) {
  if (!input.files || !input.files[0]) return;

  const file = input.files[0];
  const validTypes = ['image/jpeg', 'image/jpg', 'image/png'];
  if (!validTypes.includes(file.type.toLowerCase())) {
    alert('Invalid file format. Please upload a JPG, JPEG, or PNG image.');
    input.value = '';
    return;
  }

  if (file.size > 10 * 1024 * 1024) {
    alert('File size exceeds 10MB limit. Please choose a smaller image.');
    input.value = '';
    return;
  }

  selectedFileName = file.name;
  const reader = new FileReader();
  reader.onload = (e) => {
    selectedImageBase64 = e.target.result;
    const previewArea = document.getElementById('imagePreviewArea');
    if (previewArea) {
      previewArea.innerHTML = `
        <div style="position: relative; display: inline-block;">
          <img src="${selectedImageBase64}" alt="Leaf Preview" style="max-height: 180px; max-width: 100%; border-radius: 12px; border: 1px solid var(--outline-variant);"/>
          <button onclick="clearSelectedImage()" style="position: absolute; top: 6px; right: 6px; background: rgba(0,0,0,0.6); color: white; border: none; border-radius: 50%; width: 28px; height: 28px; cursor: pointer; display: flex; align-items: center; justify-content: center;">✕</button>
        </div>
        <div style="font-size: 12px; font-weight: 600; color: var(--primary); margin-top: 8px;">✓ ${selectedFileName} ready</div>
      `;
    }

    const btn = document.getElementById('scanSubmitBtn');
    if (btn) {
      btn.disabled = false;
      btn.style.opacity = '1';
    }
  };
  reader.readAsDataURL(file);
}

function clearSelectedImage() {
  selectedImageBase64 = null;
  selectedFileName = '';
  renderDiseaseScanView();
}

async function submitCropScan() {
  if (!selectedImageBase64) return alert('Please select or capture a crop leaf image first.');

  const cropName = document.getElementById('scanCropName').value;
  const statusMsg = document.getElementById('scanStatusMsg');

  mainContainer.innerHTML = `
    <div style="text-align: center; padding: 60px 20px;">
      <div style="width: 48px; height: 48px; border: 4px solid var(--primary); border-top-color: transparent; border-radius: 50%; animation: spin 1s linear infinite; margin: 0 auto 20px;"></div>
      <h3 style="font-size: 20px; font-weight: 700; color: var(--on-surface);">Analyzing Foliage with Gemini Vision...</h3>
      <p style="font-size: 14px; color: var(--on-surface-variant); margin-top: 8px;">Cross-referencing multimodal visual symptoms with agricultural rule base & local weather.</p>
    </div>
  `;

  try {
    const res = await fetch(`${API_BASE}/disease/scan`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        crop_name: cropName,
        image_base64_or_url: selectedImageBase64,
        location: state.farmerProfile.location,
        latitude: state.farmerProfile.lat,
        longitude: state.farmerProfile.lon,
        language: state.lang
      })
    });

    if (res.ok) {
      const data = await res.json();
      state.scanResult = data;
      navigateTo('scan-result');
    } else {
      throw new Error('Scan failed');
    }
  } catch (e) {
    alert("We couldn't analyze this image right now. Please try again or submit directly to an expert.");
    navigateTo('disease-scan');
  }
}

function renderScanResultView() {
  const scan = state.scanResult || {
    crop_name: 'Tomato',
    predicted_issue: 'Possible Early Blight (Alternaria solani)',
    confidence_score: 76.5,
    uncertainty_level: 'Medium',
    visible_symptoms: ['Yellow leaves with concentric ring spots', 'Lower foliage chlorosis'],
    possible_causes: ['High air humidity', 'Morning leaf moisture retention'],
    recommended_next_steps: ['Inspect nearby plants for similar symptoms', 'Spray Copper Oxychloride 3g/L'],
    preventive_measures: ['Avoid overhead irrigation', 'Remove infected leaves'],
    weather_context: 'High humidity (85%) in Nashik favors fungal germination.',
    disclaimer: 'This is an image-based preliminary assessment and is not a confirmed diagnosis.',
    requires_expert: false
  };

  const isLowConfidence = scan.confidence_score < 65 || scan.requires_expert || scan.image_quality === 'poor';

  mainContainer.innerHTML = `
    <div>
      <h2 style="font-size: 22px; font-weight: 700; margin-bottom: 6px;">Crop Scan Result</h2>
      <p style="font-size: 13px; color: var(--on-surface-variant); margin-bottom: 16px;">AI Multimodal & Agronomy Rule Hybrid Diagnosis</p>

      <!-- Low Confidence Inconclusive Warning Banner -->
      ${isLowConfidence ? `
        <div style="background: #fffbebf5; border: 1.5px solid #f59e0b; padding: 14px; border-radius: 12px; margin-bottom: 16px;">
          <div style="display: flex; align-items: center; gap: 8px; font-weight: 700; color: #b45309; font-size: 14px;">
            <span class="material-symbols-outlined">warning</span>
            <span>Image Analysis Inconclusive</span>
          </div>
          <p style="font-size: 13px; color: #78350f; margin-top: 4px; line-height: 1.4;">
            ${scan.disclaimer || 'Unable to reliably identify the issue. Please consult an agricultural expert.'}
          </p>
        </div>
      ` : ''}

      <!-- Main Diagnosis Card -->
      <div class="card" style="background: var(--surface-container-lowest);">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px;">
          <span class="badge badge-success">🌱 ${scan.crop_name}</span>
          <span class="badge ${isLowConfidence ? 'badge-warning' : 'badge-info'}">${scan.confidence_score}% Confidence (${scan.uncertainty_level} Uncertainty)</span>
        </div>

        <div style="font-size: 12px; text-transform: uppercase; font-weight: 700; color: var(--outline);">Possible Issue Identified</div>
        <h3 style="font-size: 20px; font-weight: 700; color: var(--primary); margin: 4px 0 12px;">${scan.predicted_issue}</h3>

        ${selectedImageBase64 ? `
          <img src="${selectedImageBase64}" alt="Analyzed Leaf" style="width: 100%; max-height: 180px; object-fit: cover; border-radius: 10px; margin-bottom: 12px; border: 1px solid var(--outline-variant);"/>
        ` : ''}

        <div style="font-size: 13px; font-weight: 600; color: var(--on-surface-variant); font-style: italic;">
          "${scan.disclaimer}"
        </div>
      </div>

      <!-- Symptoms Observed -->
      <div class="card" style="margin-top: 12px;">
        <div style="font-weight: 700; font-size: 15px; color: var(--on-surface); margin-bottom: 8px; display: flex; align-items: center; gap: 6px;">
          <span class="material-symbols-outlined" style="color: var(--primary);">visibility</span>
          <span>Symptoms Observed</span>
        </div>
        ${(scan.visible_symptoms || []).map(s => `<div style="font-size: 13px; margin-bottom: 4px;">• ${s}</div>`).join('')}
      </div>

      <!-- Possible Causes -->
      ${(scan.possible_causes && scan.possible_causes.length > 0) ? `
        <div class="card" style="margin-top: 12px;">
          <div style="font-weight: 700; font-size: 15px; color: var(--on-surface); margin-bottom: 8px; display: flex; align-items: center; gap: 6px;">
            <span class="material-symbols-outlined" style="color: var(--primary);">science</span>
            <span>Possible Causes</span>
          </div>
          ${scan.possible_causes.map(c => `<div style="font-size: 13px; margin-bottom: 4px;">• ${c}</div>`).join('')}
        </div>
      ` : ''}

      <!-- Recommended Next Steps -->
      <div class="card" style="margin-top: 12px;">
        <div style="font-weight: 700; font-size: 15px; color: var(--on-surface); margin-bottom: 8px; display: flex; align-items: center; gap: 6px;">
          <span class="material-symbols-outlined" style="color: var(--primary);">check_circle</span>
          <span>Recommended Next Steps</span>
        </div>
        ${(scan.recommended_next_steps || []).map((step, idx) => `
          <div style="font-size: 13px; margin-bottom: 6px; line-height: 1.4;">${idx + 1}. ${step}</div>
        `).join('')}
      </div>

      <!-- Preventive Measures -->
      ${(scan.preventive_measures && scan.preventive_measures.length > 0) ? `
        <div class="card" style="margin-top: 12px; background: var(--surface-container-lowest);">
          <div style="font-weight: 700; font-size: 15px; color: var(--on-surface); margin-bottom: 8px; display: flex; align-items: center; gap: 6px;">
            <span class="material-symbols-outlined" style="color: var(--primary);">shield</span>
            <span>Preventive Suggestions</span>
          </div>
          ${scan.preventive_measures.map(m => `<div style="font-size: 13px; margin-bottom: 4px;">• ${m}</div>`).join('')}
        </div>
      ` : ''}

      <!-- Weather Context -->
      ${scan.weather_context ? `
        <div class="card" style="margin-top: 12px; background: #e0f2fe; border-color: #bae6fd;">
          <div style="font-weight: 700; font-size: 14px; color: #0369a1; margin-bottom: 4px; display: flex; align-items: center; gap: 6px;">
            <span class="material-symbols-outlined">cloud_queue</span>
            <span>Weather Context</span>
          </div>
          <p style="font-size: 13px; color: #0f172a; line-height: 1.4;">${scan.weather_context}</p>
        </div>
      ` : ''}

      <!-- Action Buttons -->
      <div style="display: flex; gap: 12px; margin-top: 24px;">
        <button class="btn-outlined" style="flex: 1;" onclick="escalateScanToExpert()">👨‍🌾 Ask an Expert</button>
        <button class="btn-primary" style="flex: 1;" onclick="navigateTo('home')">🟢 View Full Advisory</button>
      </div>
    </div>
  `;
}

async function escalateScanToExpert() {
  const scan = state.scanResult;
  try {
    const res = await fetch(`${API_BASE}/expert-requests`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        farmer_name: state.farmerProfile.name,
        phone: state.farmerProfile.phone,
        location: state.farmerProfile.location,
        crop: scan ? scan.crop_name : state.farmerProfile.mainCrop,
        request_type: 'disease_scan',
        disease_scan_id: scan ? scan.scan_id : null,
        description: scan ? `Submitted for expert verification: ${scan.predicted_issue} (${scan.confidence_score}% Confidence). Symptoms: ${(scan.visible_symptoms || []).join(', ')}` : 'Submitted photo scan for expert review.',
        image_url: selectedImageBase64,
        gemini_analysis: scan,
        weather_context: scan ? scan.weather_context : null
      })
    });
    if (res.ok) {
      alert('Photo scan submitted to expert agronomists! You will be notified when they reply.');
      navigateTo('my-requests');
    }
  } catch (e) {
    alert('Failed to submit request');
  }
}

async function renderMyRequestsView() {
  mainContainer.innerHTML = `<div style="text-align: center; padding: 40px;"><div style="width: 24px; height: 24px; border: 3px solid var(--primary); border-top-color: transparent; border-radius: 50%; animation: spin 1s linear infinite; margin: 0 auto;"></div>Loading Requests...</div>`;

  try {
    const res = await fetch(`${API_BASE}/expert-requests`);
    if (res.ok) state.expertRequests = await res.json();
  } catch (e) {}

  mainContainer.innerHTML = `
    <div>
      <h2 style="font-size: 22px; font-weight: 700; margin-bottom: 16px;">${t('my_requests')}</h2>

      ${(state.expertRequests || []).length === 0 ? `
        <div class="card" style="text-align: center; padding: 30px; color: var(--outline);">
          No requests submitted yet.
        </div>
      ` : ''}

      ${state.expertRequests.map(r => `
        <div class="card">
          <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
            <div style="font-weight: 700; font-size: 15px;">${r.crop} (${r.id})</div>
            <span class="badge ${r.status === 'Resolved' ? 'badge-success' : (r.status === 'More Information Required' ? 'badge-warning' : 'badge-info')}">${r.status}</span>
          </div>
          <div style="font-size: 12px; color: var(--outline); margin-bottom: 8px;">${r.created_at} • ${r.location}</div>
          <p style="font-size: 13px; color: var(--on-surface-variant); margin-bottom: 10px;">${r.description}</p>
          
          <!-- Render Follow-Up Questions from Agronomist -->
          ${(r.questions && r.questions.length > 0) ? `
            <div style="background: #f0f9ff; border: 1.5px solid #0284c7; padding: 12px; border-radius: 12px; margin-bottom: 12px;">
              <div style="font-weight: 700; font-size: 13px; color: #0369a1; margin-bottom: 6px;">💬 Agronomist Question:</div>
              ${r.questions.map(q => {
                const ans = (r.answers || []).find(a => a.question_id === q.id);
                if (ans) {
                  return `<div style="font-size: 12px; font-weight: 600; color: #065f46;">Q: ${q.question} <br/>✓ Your Answer: "${ans.answer}"</div>`;
                }
                return `
                  <div style="margin-bottom: 8px;">
                    <div style="font-size: 13px; font-weight: 700; margin-bottom: 6px;">${q.question}</div>
                    ${q.options ? `
                      <div style="display: flex; flex-wrap: wrap; gap: 6px; margin-bottom: 8px;">
                        ${q.options.map(opt => `
                          <button class="btn-outlined" style="width: auto; padding: 6px 12px; font-size: 12px;" onclick="submitAnswerToExpert('${q.id}', '${opt}')">${opt}</button>
                        `).join('')}
                      </div>
                    ` : `
                      <div style="display: flex; gap: 8px;">
                        <input type="text" id="ansInput_${q.id}" placeholder="Type your answer..." style="flex: 1; padding: 8px; border-radius: 8px; border: 1px solid var(--outline-variant); font-size: 13px;"/>
                        <button class="btn-primary" style="width: auto; padding: 8px 14px; font-size: 13px;" onclick="submitAnswerToExpert('${q.id}', document.getElementById('ansInput_${q.id}').value)">Submit</button>
                      </div>
                    `}
                  </div>
                `;
              }).join('')}
            </div>
          ` : ''}

          ${r.expert_response ? `
            <div style="background: var(--secondary-container); padding: 10px; border-radius: 10px; font-size: 12px;">
              <strong style="color: var(--primary);">${r.expert_name || 'Agronomist'}:</strong> ${r.expert_response}
            </div>
          ` : ''}
        </div>
      `).join('')}
    </div>
  `;
}

async function submitAnswerToExpert(questionId, answerVal) {
  if (!answerVal) return alert('Please enter or select an answer');

  try {
    const res = await fetch(`${API_BASE}/expert-questions/${questionId}/answer`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        question_id: questionId,
        user_id: state.farmerProfile.phone,
        answer: answerVal
      })
    });
    if (res.ok) {
      alert('Answer submitted to agronomist successfully!');
      renderMyRequestsView();
    }
  } catch (e) {
    alert('Failed to submit answer');
  }
}


function renderProfileView() {
  mainContainer.innerHTML = `
    <div>
      <div class="card" style="display: flex; align-items: center; gap: 16px; padding: 20px;">
        <div style="width: 56px; height: 56px; border-radius: 50%; background: var(--primary-container); color: var(--on-primary); font-size: 20px; font-weight: 700; display: flex; align-items: center; justify-content: center;">RP</div>
        <div>
          <div style="font-size: 20px; font-weight: 700;">${state.farmerProfile.name}</div>
          <div style="font-size: 13px; color: var(--outline);">${state.farmerProfile.phone}</div>
          <div style="font-size: 13px; color: var(--primary); font-weight: 600;">📍 ${state.farmerProfile.location}</div>
        </div>
      </div>

      <div style="margin-top: 24px;">
        <div class="card">
          <div style="font-weight: 700; font-size: 15px; margin-bottom: 8px;">${t('language')}</div>
          <select onchange="changeLanguage(this.value); renderProfileView();" style="width: 100%; padding: 10px; border-radius: 8px; border: 1.5px solid var(--outline-variant); font-weight: 600;">
            <option value="en" ${state.lang === 'en' ? 'selected' : ''}>English</option>
            <option value="mr" ${state.lang === 'mr' ? 'selected' : ''}>मराठी (Marathi)</option>
            <option value="hi" ${state.lang === 'hi' ? 'selected' : ''}>हिंदी (Hindi)</option>
            <option value="ta" ${state.lang === 'ta' ? 'selected' : ''}>தமிழ் (Tamil)</option>
            <option value="gu" ${state.lang === 'gu' ? 'selected' : ''}>ગુજરાતી (Gujarati)</option>
            <option value="kn" ${state.lang === 'kn' ? 'selected' : ''}>ಕನ್ನಡ (Kannada)</option>
          </select>
        </div>

        <div class="card card-clickable" onclick="navigateTo('my-requests')">
          <div style="font-weight: 700; font-size: 15px;">${t('my_requests')}</div>
          <div style="font-size: 12px; color: var(--outline);">Track status of submitted queries</div>
        </div>
        <div class="card card-clickable" onclick="alert('v2.0.0 • K. J. Somaiya Institute of Technology')">
          <div style="font-weight: 700; font-size: 15px;">About Kisan Sarthi</div>
          <div style="font-size: 12px; color: var(--outline);">v2.0.0 • K. J. Somaiya Institute of Technology</div>
        </div>
      </div>

      <div style="margin-top: 32px;">
        <button class="btn-outlined" style="color: var(--error); border-color: var(--error-container);" onclick="navigateTo('login')">Logout</button>
      </div>
    </div>
  `;
}
