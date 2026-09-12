import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/admin_provider.dart';
import '../../core/services/supabase_service.dart';

class AdminRequestDetailView extends StatefulWidget {
  final Map<String, dynamic>? request;

  const AdminRequestDetailView({super.key, this.request});

  @override
  State<AdminRequestDetailView> createState() => _AdminRequestDetailViewState();
}

class _AdminRequestDetailViewState extends State<AdminRequestDetailView> {
  final _questionController = TextEditingController();
  final _optionsController = TextEditingController();
  final _responseController = TextEditingController();
  final _expertNameController = TextEditingController();
  final _notesController = TextEditingController();

  List<Map<String, dynamic>> _questions = [];
  List<Map<String, dynamic>> _answers = [];
  Map<String, dynamic>? _diseaseScan;
  bool _isLoadingDetails = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDetailData();
    });
  }

  Future<void> _loadDetailData() async {
    final req = widget.request ?? context.read<AdminProvider>().selectedRequest;
    if (req == null) return;

    setState(() => _isLoadingDetails = true);
    _expertNameController.text = req['expert_name'] ?? 'Dr. V. K. Sharma (Senior Agronomist)';
    _responseController.text = req['expert_response'] ?? '';
    _notesController.text = req['internal_notes'] ?? '';

    final reqId = req['id'];
    final qList = await SupabaseService.fetchExpertQuestions(reqId);
    final qIds = qList.map((q) => q['id']).toList();
    final aList = await SupabaseService.fetchExpertAnswers(qIds);

    Map<String, dynamic>? scanData;
    if (req['disease_scan_id'] != null) {
      scanData = await SupabaseService.fetchDiseaseScan(req['disease_scan_id'].toString());
    }

    if (mounted) {
      setState(() {
        _questions = qList;
        _answers = aList;
        _diseaseScan = scanData;
        _isLoadingDetails = false;
      });
    }
  }

  @override
  void dispose() {
    _questionController.dispose();
    _optionsController.dispose();
    _responseController.dispose();
    _expertNameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _handleSendQuestion() async {
    final req = widget.request ?? context.read<AdminProvider>().selectedRequest;
    if (req == null) return;

    final qText = _questionController.text.trim();
    if (qText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a question.')));
      return;
    }

    final optsStr = _optionsController.text.trim();
    List<String>? options;
    if (optsStr.isNotEmpty) {
      options = optsStr.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
    }

    final adminProv = context.read<AdminProvider>();
    final success = await adminProv.sendFollowUpQuestion(req['id'], qText, options);

    if (mounted) {
      if (success) {
        _questionController.clear();
        _optionsController.clear();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Follow-up question sent to farmer app!')));
        _loadDetailData();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to send question.')));
      }
    }
  }

  Future<void> _handleSubmitResponse() async {
    final req = widget.request ?? context.read<AdminProvider>().selectedRequest;
    if (req == null) return;

    final respText = _responseController.text.trim();
    if (respText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please write a recommendation response.')));
      return;
    }

    final adminProv = context.read<AdminProvider>();
    final success = await adminProv.submitResponse(
      req['id'],
      _expertNameController.text.trim(),
      respText,
      _notesController.text.trim(),
    );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Response submitted & request marked Resolved!')));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to submit response.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final adminProv = context.watch<AdminProvider>();
    final req = widget.request ?? adminProv.selectedRequest;

    if (req == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Request Detail')),
        body: const Center(child: Text('No request selected.')),
      );
    }

    final status = req['status'] ?? 'Pending';

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text('Request #${req['id']} Details'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER CARD
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(color: AppColors.primaryContainer, borderRadius: BorderRadius.circular(8)),
                            child: Text('REQ ID: ${req['id']}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 12)),
                          ),
                          DropdownButton<String>(
                            value: ['Pending', 'In Review', 'More Information Required', 'Resolved'].contains(status) ? status : 'Pending',
                            items: const [
                              DropdownMenuItem(value: 'Pending', child: Text('Status: Pending')),
                              DropdownMenuItem(value: 'In Review', child: Text('Status: In Review')),
                              DropdownMenuItem(value: 'More Information Required', child: Text('Status: Need Info')),
                              DropdownMenuItem(value: 'Resolved', child: Text('Status: Resolved')),
                            ],
                            onChanged: (val) {
                              if (val != null) adminProv.updateRequestStatus(req['id'], val);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('${req['crop']} Agronomic Query', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),
              // SECTION 1: FARMER DETAILS
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('👨‍🌾 Section 1 — Farmer Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.primary)),
                      const Divider(height: 16),
                      Text('Farmer Name: ${req['farmer_name'] ?? 'Ramesh Patil'}', style: const TextStyle(fontSize: 14)),
                      const SizedBox(height: 4),
                      Text('Phone: 📞 ${req['phone'] ?? 'N/A'}', style: const TextStyle(fontSize: 14)),
                      const SizedBox(height: 4),
                      Text('Location: 📍 ${req['location'] ?? 'Nashik, Maharashtra'}', style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),
              // SECTION 2 & 3: CROP & PROBLEM
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('🌱 Section 2 & 3 — Crop & Problem Category', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.primary)),
                      const Divider(height: 16),
                      Text('Crop: ${req['crop']} • Category: ${req['problem_category'] ?? 'General'}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      const SizedBox(height: 8),
                      const Text('Farmer Description:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.all(12),
                        width: double.infinity,
                        decoration: BoxDecoration(color: AppColors.surfaceContainerLowest, borderRadius: BorderRadius.circular(8)),
                        child: Text(req['description'] ?? '', style: const TextStyle(fontSize: 13, height: 1.4)),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),
              // SECTION 4 & 5: PHOTO & AI VISION SCAN CONTEXT
              if (req['image_url'] != null || _diseaseScan != null) ...[
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('📷 Section 4 & 5 — Photo & AI Vision Context', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.green)),
                        const Divider(height: 16),
                        if (req['image_url'] != null) ...[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(req['image_url'], height: 160, width: double.infinity, fit: BoxFit.cover),
                          ),
                          const SizedBox(height: 12),
                        ],
                        Text(
                          'Possible issue detected: ${_diseaseScan?['predicted_issue'] ?? req['gemini_analysis']?['predicted_issue'] ?? 'Foliar anomaly requiring expert review'}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Confidence Score: ${_diseaseScan?['confidence_score'] ?? req['gemini_analysis']?['confidence_score'] ?? '85'}%',
                          style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.orange.shade200)),
                          child: const Text(
                            '⚠️ Disclaimer: AI diagnosis is preliminary. Certified agronomist verification required.',
                            style: TextStyle(fontSize: 11, color: Colors.orange, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // SECTION 6: TWO-WAY FOLLOW-UP QUESTIONS
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('💬 Section 6 — Expert Follow-Up Q&A Timeline', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.blue)),
                      const Divider(height: 16),
                      if (_isLoadingDetails)
                        const Center(child: CircularProgressIndicator())
                      else if (_questions.isEmpty)
                        const Text('No follow-up questions sent yet.', style: TextStyle(color: AppColors.outline, fontSize: 13))
                      else
                        ..._questions.map((q) {
                          final ans = _answers.firstWhere((a) => a['question_id'].toString() == q['id'].toString(), orElse: () => {});
                          final hasAns = ans.isNotEmpty;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.blue.shade200),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Q: ${q['question']}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 13)),
                                if (q['options'] != null)
                                  Text('Options: ${(q['options'] as List).join(', ')}', style: const TextStyle(fontSize: 11, color: AppColors.outline)),
                                const SizedBox(height: 6),
                                Text(
                                  hasAns ? '✓ Farmer Response: "${ans['answer']}"' : '⏳ Waiting for farmer response in app...',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: hasAns ? Colors.green.shade800 : Colors.amber.shade900),
                                ),
                              ],
                            ),
                          );
                        }),

                      const SizedBox(height: 12),
                      const Text('Ask Farmer Follow-Up Question:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _questionController,
                        decoration: const InputDecoration(hintText: 'e.g. Is the leaf yellowing on upper or lower leaves?', border: OutlineInputBorder()),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _optionsController,
                        decoration: const InputDecoration(hintText: 'Options (comma separated): e.g. Upper leaves, Lower leaves, All leaves', border: OutlineInputBorder()),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.send),
                        label: const Text('Send Question to Farmer App'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade700, foregroundColor: Colors.white),
                        onPressed: _handleSendQuestion,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),
              // SECTION 7: EXPERT RECOMMENDATION & RESOLUTION
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('🩺 Section 7 — Agronomist Recommendation & Action Plan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.primary)),
                      const Divider(height: 16),
                      TextField(
                        controller: _expertNameController,
                        decoration: const InputDecoration(labelText: 'Agronomist Name / Title', border: OutlineInputBorder()),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _responseController,
                        maxLines: 4,
                        decoration: const InputDecoration(labelText: 'Chemical Treatment & Dosage Instructions', border: OutlineInputBorder()),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _notesController,
                        decoration: const InputDecoration(labelText: 'Internal Agronomy Notes (Visible to experts only)', border: OutlineInputBorder()),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.check_circle),
                          label: const Text('Send Response & Mark Resolved', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
                          onPressed: _handleSubmitResponse,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
