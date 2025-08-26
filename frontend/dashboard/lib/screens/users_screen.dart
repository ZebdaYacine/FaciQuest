import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:intl/intl.dart';
import '../providers/dashboard_provider.dart';
import '../models/user_model.dart';
import '../widgets/filter_widgets.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      // Load more users when reaching the bottom
      context.read<DashboardProvider>().loadUsers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Users Management',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Manage and monitor user accounts',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _showFilters = !_showFilters;
                          });
                        },
                        icon: Icon(_showFilters ? Icons.filter_list_off : Icons.filter_list),
                        tooltip: 'Toggle filters',
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: () => provider.loadUsers(refresh: true),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Refresh'),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Filters
              if (_showFilters) ...[
                UserFiltersWidget(
                  filters: provider.userFilters,
                  onFiltersChanged: (filters) {
                    provider.updateUserFilters(filters);
                  },
                ),
                const SizedBox(height: 20),
              ],

              // Stats row
              Row(
                children: [
                  _buildStatCard(context, 'Total Users', provider.users.length.toString(), Icons.people, Colors.blue),
                  const SizedBox(width: 16),
                  _buildStatCard(
                    context,
                    'Active Users',
                    provider.users.where((u) => u.isActive).length.toString(),
                    Icons.people_alt,
                    Colors.green,
                  ),
                  const SizedBox(width: 16),
                  _buildStatCard(
                    context,
                    'Inactive Users',
                    provider.users.where((u) => !u.isActive).length.toString(),
                    Icons.people_outline,
                    Colors.orange,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Users table
              Expanded(
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Users List',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            if (provider.isLoadingUsers)
                              const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: DataTable2(
                            dataRowHeight: 60,
                            columnSpacing: 12,
                            horizontalMargin: 12,
                            minWidth: 800,
                            columns: const [
                              DataColumn2(label: Text('Name'), size: ColumnSize.L),
                              DataColumn2(label: Text('Email'), size: ColumnSize.L),
                              DataColumn2(label: Text('Gender'), size: ColumnSize.S),
                              DataColumn2(label: Text('Status'), size: ColumnSize.S),
                              DataColumn2(label: Text('Surveys'), size: ColumnSize.S),
                              DataColumn2(label: Text('Participation'), size: ColumnSize.S),
                              DataColumn2(label: Text('Joined'), size: ColumnSize.M),
                              DataColumn2(label: Text('Actions'), size: ColumnSize.M),
                            ],
                            rows: provider.users.map((user) => _buildUserRow(context, user, provider)).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
                  ),
                  Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  DataRow _buildUserRow(BuildContext context, UserModel user, DashboardProvider provider) {
    return DataRow(
      cells: [
        DataCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(user.name, style: const TextStyle(fontWeight: FontWeight.w500)),
              if (user.lastLoginAt != null)
                Text(
                  'Last login: ${DateFormat('MMM dd').format(user.lastLoginAt!)}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                ),
            ],
          ),
        ),
        DataCell(Text(user.email)),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getGenderColor(user.gender).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              user.gender.toUpperCase(),
              style: TextStyle(color: _getGenderColor(user.gender), fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: user.isActive ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              user.isActive ? 'Active' : 'Inactive',
              style: TextStyle(
                color: user.isActive ? Colors.green : Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Text(
              user.surveyCount.toString(),
              style: const TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: Colors.purple.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Text(
              user.participationCount.toString(),
              style: const TextStyle(color: Colors.purple, fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        DataCell(Text(DateFormat('MMM dd, yyyy').format(user.createdAt), style: Theme.of(context).textTheme.bodySmall)),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  _showUserDetails(context, user);
                },
                icon: const Icon(Icons.visibility, size: 18),
                tooltip: 'View details',
              ),
              Switch(
                value: user.isActive,
                onChanged: (value) {
                  provider.updateUserStatus(user.id, value);
                },
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getGenderColor(String gender) {
    switch (gender.toLowerCase()) {
      case 'male':
        return Colors.blue;
      case 'female':
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }

  void _showUserDetails(BuildContext context, UserModel user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('User Details: ${user.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Email', user.email),
            _buildDetailRow('Gender', user.gender),
            _buildDetailRow('Status', user.isActive ? 'Active' : 'Inactive'),
            _buildDetailRow('Surveys Created', user.surveyCount.toString()),
            _buildDetailRow('Participations', user.participationCount.toString()),
            _buildDetailRow('Joined', DateFormat('MMM dd, yyyy').format(user.createdAt)),
            if (user.lastLoginAt != null)
              _buildDetailRow('Last Login', DateFormat('MMM dd, yyyy HH:mm').format(user.lastLoginAt!)),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close'))],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text('$label:', style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
