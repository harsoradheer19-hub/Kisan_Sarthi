const API_BASE = 'http://127.0.0.1:8000/api/v1';

let allRequests = [];
let selectedRequest = null;
let currentFilter = 'All';

document.addEventListener('DOMContentLoaded', () => {
  loadExpertRequests();
  setInterval(loadExpertRequests, 8000);
});

async function loadExpertRequests() {
  try {
    const res = await fetch(`${API_BASE}/expert-requests`);
    if (res.ok) {
      allRequests = await res.json();
      updateStats();
      renderRequestsList();
      if (selectedRequest) {
        // Refresh selected detail
        const updated = allRequests.find(r => r.id === selectedRequest.id);
        if (updated) selectRequest(updated);
      }
    }
  } catch (e) {
    console.error("Error loading expert requests:", e);
  }
}

function updateStats() {
  document.getElementById('statTotal').innerText = allRequests.length;
  document.getElementById('statPending').innerText = allRequests.filter(r => r.status === 'Pending').length;
  document.getElementById('statInReview').innerText = allRequests.filter(r => r.status === 'In Review').length;
  document.getElementById('statResolved').innerText = allRequests.filter(r => r.status === 'Resolved').length;
}

function filterRequests(filter, btnElem) {
  currentFilter = filter;
  document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
  btnElem.classList.add('active');
  renderRequestsList();
}

function renderRequestsList() {
  const container = document.getElementById('requestsListContainer');
  const filtered = allRequests.filter(r => {
    if (currentFilter === 'All') return true;
    return r.status === currentFilter;
  });

  if (filtered.length === 0) {
    container.innerHTML = `<div style="padding: 20px; text-align: center; color: #707a6c;">No requests found.</div>`;
    return;
  }

  container.innerHTML = filtered.map(r => `
    <div class="req-item ${selectedRequest && selectedRequest.id === r.id ? 'selected' : ''}" onclick="selectRequestById('${r.id}')">
      <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 6px;">
        <span style="font-weight: 700; font-size: 15px; color: #0d631b;">${r.crop} (${r.id})</span>
        <span class="badge ${r.status === 'Resolved' ? 'badge-success' : (r.status === 'In Review' ? 'badge-info' : 'badge-warning')}">${r.status}</span>
      </div>
      <div style="font-weight: 600; font-size: 14px; margin-bottom: 4px;">Farmer: ${r.farmer_name}</div>
      <div style="font-size: 12px; color: #707a6c; margin-bottom: 6px;">📍 ${r.location} • ${r.created_at}</div>
      <div style="font-size: 13px; color: #40493d; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">${r.description}</div>
    </div>
  `).join('');
}

function selectRequestById(reqId) {
  const req = allRequests.find(r => r.id === reqId);
  if (req) selectRequest(req);
}

function selectRequest(req) {
  selectedRequest = req;
  renderRequestsList();
  renderDetailPanel(req);
}

function renderDetailPanel(req) {
  const panel = document.getElementById('detailPanel');

  const inputsHtml = req.collected_inputs ? Object.entries(req.collected_inputs).map(([k, v]) => `
    <div style="background: #f9f9f9; padding: 8px 12px; border-radius: 8px; font-size: 12px; margin-bottom: 4px;">
      <strong style="text-transform: uppercase;">${k}:</strong> ${v}
    </div>
  `).join('') : '<div style="font-size: 12px; color: #707a6c;">No guided Q&A history attached</div>';

  const questionsHtml = (req.questions && req.questions.length > 0) ? req.questions.map(q => {
    const ans = (req.answers || []).find(a => a.question_id === q.id);
    return `
      <div style="background: #eef2ff; border: 1px solid #c7d2fe; padding: 12px; border-radius: 10px; margin-bottom: 8px;">
        <div style="font-weight: 700; font-size: 13px; color: #1e40af;">Q: ${q.question}</div>
        ${q.options ? `<div style="font-size: 11px; color: #4b5563; margin-top: 2px;">Options: ${q.options.join(', ')}</div>` : ''}
        <div style="margin-top: 6px; font-weight: 600; font-size: 13px; color: ${ans ? '#065f46' : '#92400e'};">
          ${ans ? `✓ Farmer Answer: "${ans.answer}"` : '⏳ Waiting for farmer response...'}
        </div>
      </div>
    `;
  }).join('') : '<div style="font-size: 12px; color: #707a6c;">No follow-up questions sent yet.</div>';

  panel.innerHTML = `
    <div>
      <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 16px;">
        <div>
          <span class="badge badge-info" style="margin-bottom: 6px;">ID: ${req.id} • ${req.request_type || 'General'}</span>
          <h2 style="font-size: 22px; font-weight: 700; color: #0d631b;">${req.crop} Problem Inquiry</h2>
        </div>
        <select onchange="updateStatus('${req.id}', this.value)" style="padding: 8px 12px; border-radius: 8px; border: 1.5px solid #bfcaba; font-weight: 600;">
          <option value="Pending" ${req.status === 'Pending' ? 'selected' : ''}>Status: Pending</option>
          <option value="In Review" ${req.status === 'In Review' ? 'selected' : ''}>Status: In Review</option>
          <option value="More Information Required" ${req.status === 'More Information Required' ? 'selected' : ''}>Status: More Info Required</option>
          <option value="Resolved" ${req.status === 'Resolved' ? 'selected' : ''}>Status: Resolved</option>
        </select>
      </div>

      <!-- Image Preview & Gemini Analysis if available -->
      ${req.image_url ? `
        <div style="background: #ffffff; border: 1px solid #e8e8e8; border-radius: 12px; padding: 12px; margin-bottom: 16px;">
          <div style="font-weight: 700; font-size: 14px; margin-bottom: 8px; color: #0d631b;">📷 Uploaded Crop Image & Gemini Vision Context</div>
          <div style="display: flex; gap: 16px; align-items: flex-start;">
            <img src="${req.image_url}" alt="Crop Image" style="width: 140px; height: 140px; object-fit: cover; border-radius: 10px; border: 1px solid #ddd;"/>
            <div style="flex: 1; font-size: 13px;">
              ${req.gemini_analysis ? `
                <div style="font-weight: 700; color: #1e293b;">Possible Issue: ${req.gemini_analysis.predicted_issue || 'Foliar Anomaly'}</div>
                <div style="color: #059669; font-weight: 600; margin-top: 2px;">Confidence: ${req.gemini_analysis.confidence_score}%</div>
                <div style="margin-top: 4px; color: #475569;">Symptoms: ${(req.gemini_analysis.visible_symptoms || []).join(', ')}</div>
              ` : '<div style="color: #64748b;">Image attached for expert inspection.</div>'}
              ${req.weather_context ? `<div style="margin-top: 6px; font-size: 12px; color: #0284c7; background: #e0f2fe; padding: 6px 10px; border-radius: 6px;">🌦 Weather: ${req.weather_context}</div>` : ''}
            </div>
          </div>
        </div>
      ` : ''}

      <!-- Farmer Info Card -->
      <div style="background: #f3f3f3; padding: 16px; border-radius: 12px; margin-bottom: 16px;">
        <div style="font-weight: 700; font-size: 15px;">Farmer Details</div>
        <div style="font-size: 13px; margin-top: 4px;">Name: <strong>${req.farmer_name}</strong></div>
        <div style="font-size: 13px;">Phone: <strong>${req.phone || 'N/A'}</strong></div>
        <div style="font-size: 13px;">Location: <strong>📍 ${req.location}</strong></div>
      </div>

      <!-- Issue Description -->
      <div style="margin-bottom: 16px;">
        <div style="font-weight: 700; font-size: 14px; margin-bottom: 4px;">Farmer Problem Description:</div>
        <div style="font-size: 14px; color: #1a1c1c; line-height: 1.5; background: #ffffff; border: 1px solid #e8e8e8; padding: 12px; border-radius: 10px;">
          ${req.description}
        </div>
      </div>

      <!-- Two-Way Expert Follow-Up Q&A Section -->
      <div style="background: #fafafa; border: 1px solid #e5e7eb; padding: 16px; border-radius: 12px; margin-bottom: 20px;">
        <div style="font-weight: 700; font-size: 15px; color: #1e3a8a; margin-bottom: 8px;">💬 Follow-Up Questions Timeline</div>
        ${questionsHtml}

        <div style="margin-top: 12px; border-top: 1px dashed #cbd5e1; padding-top: 12px;">
          <div style="font-weight: 600; font-size: 13px; margin-bottom: 6px;">Ask Farmer Additional Question:</div>
          <input type="text" id="expertQText" placeholder="e.g. How quickly is the problem spreading across your field?" style="width: 100%; padding: 8px 12px; border-radius: 8px; border: 1.5px solid #bfcaba; font-size: 13px; margin-bottom: 8px;"/>
          <input type="text" id="expertQOpts" placeholder="Options (comma separated): e.g. Slow, Moderate, Rapid" style="width: 100%; padding: 8px 12px; border-radius: 8px; border: 1.5px solid #bfcaba; font-size: 13px; margin-bottom: 8px;"/>
          <button class="filter-btn active" onclick="sendExpertQuestion('${req.id}')">Send Question to Farmer</button>
        </div>
      </div>

      <!-- Expert Response Form -->
      <div style="border-top: 1px solid #e8e8e8; padding-top: 16px;">
        <h3 style="font-size: 16px; font-weight: 700; margin-bottom: 12px; color: #0d631b;">Agronomist Response & Action Plan</h3>
        
        <div class="form-group">
          <label>Expert Name / Title</label>
          <input type="text" id="expertNameInput" value="${req.expert_name || 'Dr. V. K. Sharma (Senior Agronomist)'}" style="width: 100%; padding: 10px; border-radius: 8px; border: 1.5px solid #bfcaba; font-size: 14px;"/>
        </div>

        <div class="form-group">
          <label>Recommendation & Dosage Instructions for Farmer</label>
          <textarea id="expertResponseInput" rows="4" placeholder="Enter specific chemical dosage, application method, and preventive steps...">${req.expert_response || ''}</textarea>
        </div>

        <div class="form-group">
          <label>Internal Agronomy Notes (Visible to experts only)</label>
          <input type="text" id="internalNotesInput" value="${req.internal_notes || ''}" placeholder="e.g. Follow up in 5 days regarding fungal spread" style="width: 100%; padding: 10px; border-radius: 8px; border: 1.5px solid #bfcaba; font-size: 14px;"/>
        </div>

        <button class="btn-primary" onclick="submitExpertResponse('${req.id}')" style="margin-top: 8px;">
          Submit Response & Mark Resolved
        </button>
      </div>
    </div>
  `;
}

async function sendExpertQuestion(reqId) {
  const qText = document.getElementById('expertQText').value;
  const qOptsStr = document.getElementById('expertQOpts').value;
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
      alert('Question sent to farmer successfully!');
      await loadExpertRequests();
    }
  } catch (e) {
    alert('Failed to send question');
  }
}


async function updateStatus(reqId, newStatus) {
  try {
    const res = await fetch(`${API_BASE}/expert-requests/${reqId}/status`, {
      method: 'PATCH',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ status: newStatus })
    });
    if (res.ok) {
      await loadExpertRequests();
    }
  } catch (e) {
    console.error("Error updating status:", e);
  }
}

async function submitExpertResponse(reqId) {
  const expertName = document.getElementById('expertNameInput').value;
  const expertResponse = document.getElementById('expertResponseInput').value;
  const internalNotes = document.getElementById('internalNotesInput').value;

  if (!expertResponse) {
    alert('Please enter a recommendation response');
    return;
  }

  try {
    const res = await fetch(`${API_BASE}/expert-requests/${reqId}/response`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        expert_name: expertName,
        expert_response: expertResponse,
        status: 'Resolved',
        internal_notes: internalNotes
      })
    });
    if (res.ok) {
      alert('Expert response submitted successfully!');
      await loadExpertRequests();
    }
  } catch (e) {
    alert('Failed to submit response');
  }
}
