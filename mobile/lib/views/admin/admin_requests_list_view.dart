import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/admin_provider.dart';
import 'admin_request_detail_view.dart';

class AdminRequestsListView extends StatefulWidget {
  const AdminRequestsListView({super.key});

  @override
  State<AdminRequestsListView> createState() => _AdminRequestsListViewState();
}

class _AdminRequestsListViewState extends State<AdminRequestsListView> {
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

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('All Farmer Requests'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => adminProv.fetchAdminRequests(),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => adminProv.fetchAdminRequests(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  onChanged: (q) => adminProv.setSearchQuery(q),
                  decoration: InputDecoration(
                    hintText: 'Search Farmer, Crop, ID...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
              const SizedBox(height: 12),
              Expanded(
                child: adminProv.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : requests.isEmpty
                        ? const Center(child: Text('No requests match the selected filters.', style: TextStyle(color: AppColors.outline)))
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            itemCount: requests.length,
                            itemBuilder: (context, idx) {
                              final req = requests[idx];
                              final status = req['status'] ?? 'Pending';
                              return Card(
                                margin: const EdgeInsets.only(bottom: 10),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                child: ListTile(
                                  onTap: () {
                                    adminProv.selectRequest(req['id']);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => AdminRequestDetailView(request: req),
                                      ),
                                    );
                                  },
                                  title: Text('${req['crop']} (${req['id']})', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                                  subtitle: Text('Farmer: ${req['farmer_name']} • 📍 ${req['location']}'),
                                  trailing: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: status == 'Resolved' ? Colors.green.shade100 : (status == 'In Review' ? Colors.blue.shade100 : Colors.orange.shade100),
                                      borderRadius: BorderRadius.circular(8),
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
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
