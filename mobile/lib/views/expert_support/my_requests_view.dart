import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/expert_provider.dart';

class MyRequestsView extends StatefulWidget {
  const MyRequestsView({super.key});

  @override
  State<MyRequestsView> createState() => _MyRequestsViewState();
}

class _MyRequestsViewState extends State<MyRequestsView> {
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExpertProvider>().fetchRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    final expertProv = context.watch<ExpertProvider>();
    final requests = expertProv.myRequests;

    final filtered = requests.where((r) {
      if (_selectedFilter == 'All') return true;
      return r['status'] == _selectedFilter;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('My Expert Requests'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Filter Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: ['All', 'Pending', 'In Review', 'Resolved'].map((filter) {
                  final isSelected = _selectedFilter == filter;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: ChoiceChip(
                        label: Center(child: Text(filter, style: const TextStyle(fontSize: 11))),
                        selected: isSelected,
                        selectedColor: AppColors.primaryContainer,
                        labelStyle: TextStyle(
                          color: isSelected ? AppColors.onPrimary : AppColors.onSurface,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        onSelected: (val) => setState(() => _selectedFilter = filter),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            Expanded(
              child: expertProv.isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                  : filtered.isEmpty
                      ? const Center(child: Text('No requests found under this status'))
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: filtered.length,
                          itemBuilder: (context, idx) {
                            final item = filtered[idx];
                            final status = item['status'];
                            final statusColor = _getStatusColor(status);

                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: ExpansionTile(
                                leading: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(color: statusColor.withOpacity(0.2), shape: BoxShape.circle),
                                  child: Icon(Icons.assignment, color: statusColor, size: 20),
                                ),
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${item['crop']} (${item['id']})',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: statusColor.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        status,
                                        style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 11),
                                      ),
                                    )
                                  ],
                                ),
                                subtitle: Text(
                                  '${item['created_at']} • ${item['location']}',
                                  style: const TextStyle(fontSize: 12, color: AppColors.outline),
                                ),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('Problem Description:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                        const SizedBox(height: 4),
                                        Text(item['description'], style: const TextStyle(fontSize: 13, color: AppColors.onSurfaceVariant)),
                                        const SizedBox(height: 12),
                                        if (item['expert_response'] != null) ...[
                                          Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: AppColors.secondaryContainer.withOpacity(0.5),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    const Icon(Icons.verified_user, color: AppColors.primary, size: 16),
                                                    const SizedBox(width: 6),
                                                    Text(item['expert_name'] ?? 'Agricultural Expert', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primary)),
                                                  ],
                                                ),
                                                const SizedBox(height: 6),
                                                Text(item['expert_response'], style: const TextStyle(fontSize: 13, height: 1.4)),
                                              ],
                                            ),
                                          )
                                        ] else ...[
                                          const Text(
                                            'Status: Specialist assigned. Detailed recommendation pending.',
                                            style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: AppColors.outline),
                                          )
                                        ]
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Resolved':
        return AppColors.primary;
      case 'In Review':
        return Colors.blue;
      default:
        return Colors.amber.shade800;
    }
  }
}
