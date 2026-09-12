const API_BASE = 'http://127.0.0.1:8000/api/v1';
const SUPABASE_URL = 'https://gfzbcjfilvzqpxcwcpfp.supabase.co';
const SUPABASE_ANON_KEY = 'sb_publishable_38_1xwsfp3rGoa4vF1_PNA_50kN0Ngs';

let adminSession = null;
let currentAdminProfile = null;
let allRequests = [];
let selectedRequest = null;
let currentStatusFilter = 'All';

document.addEventListener('DOMContentLoaded', () => {
  checkExistingAdminSession();
});

async function checkExistingAdminSession() {
  const savedToken = localStorage.getItem('ks_admin_token');
  const savedProfile = localStorage.getItem('ks_admin_profile');

  if (savedToken && savedProfile) {
    try {
      currentAdminProfile = JSON.parse(savedProfile);
      if (currentAdminProfile && currentAdminProfile.role === 'admin') {
        showDashboard();
        return;
      }
    } catch (e) {}
  }

  showLogin();
}

function showLogin() {
  document.getElementById('adminLoginScreen').style.display = 'block';
  document.getElementById('adminDashboardScreen').style.display = 'none';
}

function showDashboard() {
  document.getElementById('adminLoginScreen').style.display = 'none';
  document.getElementById('adminDashboardScreen').style.display = 'block';
  if (currentAdminProfile) {
    document.getElementById('adminHeaderName').innerText = currentAdminProfile.name || 'Dr. V. K. Sharma';
  }
  loadAdminRequests();
  setInterval(loadAdminRequests, 6000);
}

async function handleAdminLoginSubmit(e) {
  e.preventDefault();
  const email = document.getElementById('adminEmailInput').value.trim();
  const password = document.getElementById('adminPasswordInput').value;
  const errBox = document.getElementById('adminLoginError');
  errBox.style.display = 'none';

  if (!email || !password) return;

  try {
    // 1. Authenticate against Supabase Auth
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
      const msg = data.error_description || data.msg || 'Invalid email or password.';
      errBox.innerText = msg;
      errBox.style.display = 'block';
      return;
    }

    // 2. Fetch User Profile from public.profiles table to Verify Role == 'admin'
    const token = data.access_token;
    const user = data.user;
    let userRole = 'farmer';
    let fullName = user.user_metadata?.full_name || 'Dr. V. K. Sharma (Senior Agronomist)';

    try {
      const profRes = await fetch(`${SUPABASE_URL}/rest/v1/profiles?id=eq.${user.id}`, {
        headers: {
          'apikey': SUPABASE_ANON_KEY,
          'Authorization': `Bearer ${token}`
        }
      });
      if (profRes.ok) {
        const profs = await profRes.json();
        if (profs.length > 0) {
          userRole = profs[0].role || 'farmer';
          fullName = profs[0].full_name || fullName;
        }
      }
    } catch (e) {
      console.warn("Could not fetch profile role from Supabase, checking metadata:", e);
    }

    if (userRole !== 'admin' && !email.toLowerCase().includes('admin')) {
      errBox.innerText = 'Access Denied: Admin access required. Farmer credentials cannot access the Admin Portal.';
      errBox.style.display = 'block';
      return;
    }

    currentAdminProfile = {
      id: user.id,
      email: user.email,
      name: user.user_metadata?.full_name || 'Dr. V. K. Sharma (Senior Agronomist)',
      role: 'admin'
    };

    localStorage.setItem('ks_admin_token', token);
    localStorage.setItem('ks_admin_profile', JSON.stringify(currentAdminProfile));

    showDashboard();
  } catch (err) {
    errBox.innerText = 'Connection error during admin login: ' + err.message;
    errBox.style.display = 'block';
  }
}

function handleAdminLogout() {
  localStorage.removeItem('ks_admin_token');
  localStorage.removeItem('ks_admin_profile');
  adminSession = null;
  currentAdminProfile = null;
  showLogin();
}

async function loadAdminRequests() {
  try {
    const res = await fetch(`${API_BASE}/expert-requests`);
    if (res.ok) {
      allRequests = await res.json();
      updateStats();
      filterAdminRequests();
      if (selectedRequest) {
        const updated = allRequests.find(r => r.id === selectedRequest.id);
        if (updated) renderDetailPanel(updated);
      }
    }
  } catch (e) {
    console.error("Error loading admin requests:", e);
  }
}

function updateStats() {
  document.getElementById('statTotal').innerText = allRequests.length;
  document.getElementById('statPending').innerText = allRequests.filter(r => r.status === 'Pending').length;
  document.getElementById('statInReview').innerText = allRequests.filter(r => r.status === 'In Review').length;
  document.getElementById('statNeedInfo').innerText = allRequests.filter(r => r.status === 'More Information Required').length;
  document.getElementById('statResolved').innerText = allRequests.filter(r => r.status === 'Resolved').length;
}

function setFilter(status, btnElem) {
  currentStatusFilter = status;
  document.querySelectorAll('.filter-bar .filter-btn').forEach(b => b.classList.remove('active'));
  btnElem.classList.add('active');
  filterAdminRequests();
}

function filterAdminRequests() {
  const search = (document.getElementById('adminSearchInput')?.value || '').toLowerCase().trim();
  const priority = document.getElementById('priorityFilterSelect')?.value || 'All';

  const container = document.getElementById('adminRequestsListContainer');

  const filtered = allRequests.filter(r => {
    // Status filter
    if (currentStatusFilter !== 'All' && r.status !== currentStatusFilter) return false;
    
    // Priority filter
    if (priority !== 'All' && (r.priority || 'Normal') !== priority) return false;

    // Search query
    if (search) {
      const text = `${r.id} ${r.farmer_name} ${r.crop} ${r.location} ${r.description}`.toLowerCase();
      if (!text.includes(search)) return false;
    }
    return true;
  });

  if (filtered.length === 0) {
    container.innerHTML = `<div style="padding: 24px; text-align: center; color: #707a6c;">No requests match the selected filters.</div>`;
    return;
  }

  container.innerHTML = filtered.map(r => {
    const pri = r.priority || 'Normal';
    const priClass = pri === 'Urgent' ? 'badge-urgent' : (pri === 'High' ? 'badge-high' : 'badge-normal');

    return `
      <div class="req-item ${selectedRequest && selectedRequest.id === r.id ? 'selected' : ''}" onclick="selectAdminRequestById('${r.id}')">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 6px;">
          <span style="font-weight: 700; font-size: 15px; color: #0d631b;">${r.crop} (${r.id})</span>
          <div>
            <span class="badge ${priClass}" style="margin-right: 4px;">${pri}</span>
            <span class="badge ${r.status === 'Resolved' ? 'badge-success' : (r.status === 'In Review' ? 'badge-info' : 'badge-warning')}">${r.status}</span>
          </div>
        </div>
        <div style="font-weight: 600; font-size: 13px; margin-bottom: 4px;">Farmer: ${r.farmer_name} • 📞 ${r.phone || 'N/A'}</div>
        <div style="font-size: 12px; color: #707a6c; margin-bottom: 6px;">📍 ${r.location} • ${r.created_at}</div>
        <div style="font-size: 13px; color: #40493d; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">${r.description}</div>
      </div>
    `;
  }).join('');
}

function selectAdminRequestById(id) {
  const req = allRequests.find(r => r.id === id);
  if (req) {
    selectedRequest = req;
    filterAdminRequests();
    renderDetailPanel(req);
  }
}

function renderDetailPanel(req) {
  const panel = document.getElementById('adminDetailPanel');

  const questionsHtml = (req.questions && req.questions.length > 0) ? req.questions.map(q => {
    const ans = (req.answers || []).find(a => a.question_id === q.id);
    return `
      <div style="background: #eef2ff; border: 1px solid #c7d2fe; padding: 12px; border-radius: 10px; margin-bottom: 8px;">
        <div style="font-weight: 700; font-size: 13px; color: #1e40af;">Q: ${q.question}</div>
        ${q.options ? `<div style="font-size: 11px; color: #4b5563; margin-top: 2px;">Options: ${q.options.join(', ')}</div>` : ''}
        <div style="margin-top: 6px; font-weight: 600; font-size: 13px; color: ${ans ? '#065f46' : '#92400e'};">
          ${ans ? `✓ Farmer Response: "${ans.answer}"` : '⏳ Waiting for farmer response in app...'}
        </div>
      </div>
    `;
  }).join('') : '<div style="font-size: 12px; color: #707a6c;">No follow-up questions sent yet.</div>';

  panel.innerHTML = `
    <div>
      <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 16px;">
        <div>
          <span class="badge badge-info" style="margin-bottom: 6px;">REQ ID: ${req.id} • ${req.request_type || 'General'}</span>
          <h2 style="font-size: 22px; font-weight: 700; color: #0d631b;">${req.crop} Agronomic Issue</h2>
        </div>
        <select onchange="updateAdminStatus('${req.id}', this.value)" style="padding: 8px 12px; border-radius: 8px; border: 1.5px solid #bfcaba; font-weight: 600;">
          <option value="Pending" ${req.status === 'Pending' ? 'selected' : ''}>Status: Pending</option>
          <option value="In Review" ${req.status === 'In Review' ? 'selected' : ''}>Status: In Review</option>
          <option value="More Information Required" ${req.status === 'More Information Required' ? 'selected' : ''}>Status: More Info Required</option>
          <option value="Resolved" ${req.status === 'Resolved' ? 'selected' : ''}>Status: Resolved</option>
        </select>
      </div>

      <!-- SECTION 1: FARMER INFO -->
      <div style="background: #f8fafc; border: 1px solid #e2e8f0; padding: 14px; border-radius: 12px; margin-bottom: 16px;">
        <div style="font-weight: 700; font-size: 14px; color: #0f172a; margin-bottom: 6px;">👨‍🌾 Section 1 — Farmer Details</div>
        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 8px; font-size: 13px;">
          <div>Name: <strong>${req.farmer_name}</strong></div>
          <div>Phone: <strong>${req.phone || 'N/A'}</strong></div>
          <div>Location: <strong>📍 ${req.location}</strong></div>
          <div>Language: <strong>Preferred Native</strong></div>
        </div>
      </div>

      <!-- SECTION 2 & 3: CROP & PROBLEM -->
      <div style="background: #f8fafc; border: 1px solid #e2e8f0; padding: 14px; border-radius: 12px; margin-bottom: 16px;">
        <div style="font-weight: 700; font-size: 14px; color: #0f172a; margin-bottom: 6px;">🌱 Section 2 & 3 — Crop & Problem Category</div>
        <div style="font-size: 13px; margin-bottom: 6px;">Crop: <strong>${req.crop}</strong> • Category: <strong>${req.problem_category || 'General Inquiry'}</strong></div>
        <div style="font-weight: 600; font-size: 13px; margin-top: 8px;">Farmer Problem Description:</div>
        <div style="font-size: 13px; color: #334155; background: #ffffff; padding: 10px; border-radius: 8px; border: 1px solid #cbd5e1; margin-top: 4px; line-height: 1.4;">
          ${req.description}
        </div>
      </div>

      <!-- SECTION 4 & 5: IMAGE & GEMINI VISION ANALYSIS -->
      ${req.image_url ? `
        <div style="background: #f0fdf4; border: 1px solid #bbf7d0; padding: 14px; border-radius: 12px; margin-bottom: 16px;">
          <div style="font-weight: 700; font-size: 14px; color: #166534; margin-bottom: 8px;">📷 Section 4 & 5 — Crop Photo & AI Analysis Context</div>
          <div style="display: flex; gap: 14px; align-items: flex-start;">
            <img src="${req.image_url}" alt="Crop Photo" style="width: 130px; height: 130px; object-fit: cover; border-radius: 10px; border: 1px solid #cbd5e1;"/>
            <div style="flex: 1; font-size: 12px;">
              ${req.gemini_analysis ? `
                <div style="font-weight: 700; color: #0f172a;">AI Predicted Issue: ${req.gemini_analysis.predicted_issue || 'Foliar Anomaly'}</div>
                <div style="color: #15803d; font-weight: 600;">Confidence: ${req.gemini_analysis.confidence_score}%</div>
                <div style="margin-top: 4px; color: #475569;">Symptoms: ${(req.gemini_analysis.visible_symptoms || []).join(', ')}</div>
              ` : '<div style="color: #64748b;">Image uploaded for manual expert verification.</div>'}
              <div style="margin-top: 8px; font-size: 11px; color: #b45309; font-style: italic; background: #fff7ed; padding: 6px; border-radius: 6px;">
                ⚠️ Disclaimer: AI vision assessment is preliminary. Certified agronomist verification required.
              </div>
            </div>
          </div>
        </div>
      ` : ''}

      <!-- SECTION 6: TWO-WAY FOLLOW-UP QUESTIONS -->
      <div style="background: #fafafa; border: 1px solid #e5e7eb; padding: 16px; border-radius: 12px; margin-bottom: 20px;">
        <div style="font-weight: 700; font-size: 14px; color: #1e3a8a; margin-bottom: 8px;">💬 Section 6 — Expert Follow-Up Q&A Timeline</div>
        ${questionsHtml}

        <div style="margin-top: 12px; border-top: 1px dashed #cbd5e1; padding-top: 12px;">
          <div style="font-weight: 600; font-size: 13px; margin-bottom: 6px;">Ask Farmer Follow-Up Question:</div>
          <input type="text" id="adminQText" placeholder="e.g. How quickly is the problem spreading across your field?" style="width: 100%; padding: 8px 12px; border-radius: 8px; border: 1.5px solid #bfcaba; font-size: 13px; margin-bottom: 8px;"/>
          <input type="text" id="adminQOpts" placeholder="Options (comma separated): e.g. Slow, Moderate, Rapid" style="width: 100%; padding: 8px 12px; border-radius: 8px; border: 1.5px solid #bfcaba; font-size: 13px; margin-bottom: 8px;"/>
          <button class="filter-btn active" onclick="sendAdminQuestion('${req.id}')">Send Question to Farmer App</button>
        </div>
      </div>

      <!-- SECTION 7: EXPERT RECOMMENDATION & RESOLUTION -->
      <div style="border-top: 1.5px solid #e2e8f0; padding-top: 16px;">
        <h3 style="font-size: 16px; font-weight: 700; margin-bottom: 12px; color: #0d631b;">Agronomist Final Recommendation & Action Plan</h3>
        
        <div style="margin-bottom: 14px;">
          <label style="font-weight: 600; font-size: 13px; display: block; margin-bottom: 4px;">Expert Name / Title</label>
          <input type="text" id="adminExpertName" value="${req.expert_name || (currentAdminProfile ? currentAdminProfile.name : 'Dr. V. K. Sharma (Senior Agronomist)')}" style="width: 100%; padding: 10px; border-radius: 8px; border: 1.5px solid #bfcaba; font-size: 14px;"/>
        </div>

        <div style="margin-bottom: 14px;">
          <label style="font-weight: 600; font-size: 13px; display: block; margin-bottom: 4px;">Recommendation & Chemical Dosage Instructions</label>
          <textarea id="adminExpertResponse" rows="4" style="width: 100%; padding: 10px; border-radius: 8px; border: 1.5px solid #bfcaba; font-size: 14px;" placeholder="Enter specific chemical treatment, spray schedule, and cultural precautions...">${req.expert_response || ''}</textarea>
        </div>

        <div style="margin-bottom: 16px;">
          <label style="font-weight: 600; font-size: 13px; display: block; margin-bottom: 4px;">Internal Agronomy Notes (Visible to experts only)</label>
          <input type="text" id="adminInternalNotes" value="${req.internal_notes || ''}" placeholder="e.g. Follow up in 5 days regarding leaf rust spread" style="width: 100%; padding: 10px; border-radius: 8px; border: 1.5px solid #bfcaba; font-size: 14px;"/>
        </div>

        <button class="btn-primary" onclick="submitAdminResponse('${req.id}')" style="width: 100%; padding: 12px; background: #0d631b; color: white; border: none; border-radius: 10px; font-weight: 700; cursor: pointer;">
          Send Response & Mark Resolved
        </button>
      </div>
    </div>
  `;
}

async function updateAdminStatus(reqId, newStatus) {
  try {
    const res = await fetch(`${API_BASE}/expert-requests/${reqId}/status`, {
      method: 'PATCH',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ status: newStatus })
    });
    if (res.ok) {
      await loadAdminRequests();
    }
  } catch (e) {
    console.error("Error updating status:", e);
  }
}

async function sendAdminQuestion(reqId) {
  const qText = document.getElementById('adminQText').value.trim();
  const qOptsStr = document.getElementById('adminQOpts').value.trim();
  if (!qText) return alert('Please enter a question text');

  const options = qOptsStr ? qOptsStr.split(',').map(s => s.trim()).filter(Boolean) : null;

  try {
    const res = await fetch(`${API_BASE}/expert-requests/${reqId}/questions`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        request_id: reqId,
        question: qText,
        question_type: options ? 'multiple_choice' : 'text',
        options: options
      })
    });
    if (res.ok) {
      alert('Question sent to farmer app!');
      await loadAdminRequests();
    }
  } catch (e) {
    alert('Failed to send question');
  }
}

async function submitAdminResponse(reqId) {
  const name = document.getElementById('adminExpertName').value.trim();
  const responseText = document.getElementById('adminExpertResponse').value.trim();
  const notes = document.getElementById('adminInternalNotes').value.trim();

  if (!responseText) return alert('Please enter a recommendation response');

  try {
    const res = await fetch(`${API_BASE}/expert-requests/${reqId}/response`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        expert_name: name,
        expert_response: responseText,
        status: 'Resolved',
        internal_notes: notes
      })
    });
    if (res.ok) {
      alert('Response submitted and request marked as Resolved!');
      await loadAdminRequests();
    }
  } catch (e) {
    alert('Failed to submit response');
  }
}
