import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/admin_provider.dart';

class AdminDashboardView extends StatefulWidget {
  const AdminDashboardView({super.key});

  @override
  State<AdminDashboardView> createState() => _AdminDashboardViewState();
}

class _AdminDashboardViewState extends State<AdminDashboardView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminProvider>().fetchAdminRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    final adminProv = context.watch<AdminProvider>();
    final requests = adminProv.filteredRequests;
    final allReqs = adminProv.allRequests;

    final totalCount = allReqs.length;
    final pendingCount = allReqs.where((r) => r['status'] == 'Pending').length;
    final inReviewCount = allReqs.where((r) => r['status'] == 'In Review').length;
    final resolvedCount = allReqs.where((r) => r['status'] == 'Resolved').length;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Admin Portal — Requests Queue'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => adminProv.fetchAdminRequests(),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              adminProv.logout();
              Navigator.pushReplacementNamed(context, '/admin/login');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => adminProv.fetchAdminRequests(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // STATS GRID
                Row(
                  children: [
                    _statCard('Total', totalCount.toString(), AppColors.primary),
                    const SizedBox(width: 8),
                    _statCard('Pending', pendingCount.toString(), Colors.orange),
                    const SizedBox(width: 8),
                    _statCard('In Review', inReviewCount.toString(), Colors.blue),
                    const SizedBox(width: 8),
                    _statCard('Resolved', resolvedCount.toString(), Colors.green),
                  ],
                ),

                const SizedBox(height: 20),
                TextField(
                  onChanged: (q) => adminProv.setSearchQuery(q),
                  decoration: InputDecoration(
                    hintText: 'Search Farmer Name, Crop, Request ID...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),

                const SizedBox(height: 12),
                // FILTER TABS
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['All', 'Pending', 'In Review', 'More Information Required', 'Resolved'].map((st) {
                      final isSelected = adminProv.currentStatusFilter == st;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(st == 'More Information Required' ? 'Need Info' : st),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) adminProv.setFilterStatus(st);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 16),
                if (adminProv.isLoading)
                  const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()))
                else if (requests.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: Text('No requests match the selected filter.', style: TextStyle(color: AppColors.outline)),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: requests.length,
                    itemBuilder: (context, idx) {
                      final req = requests[idx];
                      return _buildRequestCard(context, req, adminProv);
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _statCard(String title, String count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.surfaceContainerHigh),
        ),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontSize: 10, color: AppColors.outline, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(count, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestCard(BuildContext context, Map<String, dynamic> req, AdminProvider adminProv) {
    final status = req['status'] ?? 'Pending';
    final pri = req['priority'] ?? 'Normal';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ExpansionTile(
        title: Text(
          '${req['crop']} (${req['id']})',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.primary),
        ),
        subtitle: Text(
          'Farmer: ${req['farmer_name']} • 📍 ${req['location']}',
          style: const TextStyle(fontSize: 12, color: AppColors.outline),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: status == 'Resolved' ? Colors.green.shade100 : (status == 'In Review' ? Colors.blue.shade100 : Colors.orange.shade100),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            status,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: status == 'Resolved' ? Colors.green.shade800 : (status == 'In Review' ? Colors.blue.shade800 : Colors.orange.shade800),
            ),
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Description:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 4),
                Text(req['description'] ?? '', style: const TextStyle(fontSize: 13, height: 1.3)),
                const SizedBox(height: 12),

                if (req['image_url'] != null) ...[
                  Image.network(
                    req['image_url'],
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 12),
                ],

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DropdownButton<String>(
                      value: status,
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
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                      onPressed: () => _showResponseDialog(context, req, adminProv),
                      child: const Text('Respond / Resolve'),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _showResponseDialog(BuildContext context, Map<String, dynamic> req, AdminProvider adminProv) {
    final respController = TextEditingController(text: req['expert_response'] ?? '');
    final nameController = TextEditingController(text: req['expert_name'] ?? 'Dr. V. K. Sharma (Senior Agronomist)');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Respond to Request #${req['id']}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Agronomist Name', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: respController,
                maxLines: 4,
                decoration: const InputDecoration(labelText: 'Recommendation & Dosage', border: OutlineInputBorder()),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (respController.text.isNotEmpty) {
                await adminProv.submitResponse(
                  req['id'],
                  nameController.text,
                  respController.text,
                  null,
                );
                if (context.mounted) Navigator.pop(context);
              }
            },
            child: const Text('Send & Resolve'),
          )
        ],
      ),
    );
  }
}
