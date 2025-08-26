import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:intl/intl.dart';
import '../providers/dashboard_provider.dart';
import '../models/cashout_model.dart';
import '../widgets/filter_widgets.dart';

class CashoutsScreen extends StatefulWidget {
  const CashoutsScreen({super.key});

  @override
  State<CashoutsScreen> createState() => _CashoutsScreenState();
}

class _CashoutsScreenState extends State<CashoutsScreen> {
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
      context.read<DashboardProvider>().loadCashouts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, child) {
        final totalAmount = provider.cashouts.fold<double>(0.0, (sum, cashout) => sum + cashout.amount);

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
                        'Cashout Requests',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Process and manage cashout requests',
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
                        onPressed: () => provider.loadCashouts(refresh: true),
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
                CashoutFiltersWidget(
                  filters: provider.cashoutFilters,
                  onFiltersChanged: (filters) {
                    provider.updateCashoutFilters(filters);
                  },
                ),
                const SizedBox(height: 20),
              ],

              // Stats row
              Row(
                children: [
                  _buildStatCard(
                    context,
                    'Total Requests',
                    provider.cashouts.length.toString(),
                    Icons.account_balance_wallet,
                    Colors.blue,
                  ),
                  const SizedBox(width: 16),
                  _buildStatCard(
                    context,
                    'Pending',
                    provider.cashouts.where((c) => c.status == CashoutStatus.pending).length.toString(),
                    Icons.hourglass_empty,
                    Colors.orange,
                  ),
                  const SizedBox(width: 16),
                  _buildStatCard(
                    context,
                    'Processed',
                    provider.cashouts.where((c) => c.status == CashoutStatus.processed).length.toString(),
                    Icons.check_circle,
                    Colors.green,
                  ),
                  const SizedBox(width: 16),
                  _buildStatCard(
                    context,
                    'Total Amount',
                    '\$${NumberFormat('#,###.00').format(totalAmount)}',
                    Icons.attach_money,
                    Colors.purple,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Cashouts table
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
                              'Cashout Requests List',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            if (provider.isLoadingCashouts)
                              const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: DataTable2(
                            dataRowHeight: 60,
                            columnSpacing: 12,
                            horizontalMargin: 12,
                            minWidth: 1000,
                            columns: const [
                              DataColumn2(label: Text('User'), size: ColumnSize.L),
                              DataColumn2(label: Text('Amount'), size: ColumnSize.S),
                              DataColumn2(label: Text('Payment Method'), size: ColumnSize.M),
                              DataColumn2(label: Text('Status'), size: ColumnSize.S),
                              DataColumn2(label: Text('Requested'), size: ColumnSize.M),
                              DataColumn2(label: Text('Processed'), size: ColumnSize.M),
                              DataColumn2(label: Text('Actions'), size: ColumnSize.M),
                            ],
                            rows: provider.cashouts
                                .map((cashout) => _buildCashoutRow(context, cashout, provider))
                                .toList(),
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
              Expanded(
                child: Column(
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  DataRow _buildCashoutRow(BuildContext context, CashoutRequestModel cashout, DashboardProvider provider) {
    return DataRow(
      cells: [
        DataCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(cashout.userName, style: const TextStyle(fontWeight: FontWeight.w500)),
              Text(
                cashout.userEmail,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
              ),
            ],
          ),
        ),
        DataCell(
          Text(
            '\$${cashout.amount.toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ),
        DataCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(cashout.paymentMethod, style: const TextStyle(fontWeight: FontWeight.w500)),
              if (cashout.paymentDetails != null)
                Text(
                  cashout.paymentDetails!,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(cashout.status).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              cashout.status.displayName,
              style: TextStyle(color: _getStatusColor(cashout.status), fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        DataCell(
          Text(
            DateFormat('MMM dd, yyyy\nHH:mm').format(cashout.requestedAt),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        DataCell(
          cashout.processedAt != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('MMM dd, yyyy').format(cashout.processedAt!),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (cashout.processedBy != null)
                      Text(
                        'By: ${cashout.processedBy!}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                  ],
                )
              : const Text('-'),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  _showCashoutDetails(context, cashout);
                },
                icon: const Icon(Icons.visibility, size: 18),
                tooltip: 'View details',
              ),
              if (cashout.status == CashoutStatus.pending) ...[
                IconButton(
                  onPressed: () {
                    _showStatusChangeDialog(context, cashout, provider, CashoutStatus.approved);
                  },
                  icon: const Icon(Icons.check, size: 18, color: Colors.green),
                  tooltip: 'Approve',
                ),
                IconButton(
                  onPressed: () {
                    _showRejectDialog(context, cashout, provider);
                  },
                  icon: const Icon(Icons.close, size: 18, color: Colors.red),
                  tooltip: 'Reject',
                ),
              ],
              if (cashout.status == CashoutStatus.approved) ...[
                IconButton(
                  onPressed: () {
                    _showStatusChangeDialog(context, cashout, provider, CashoutStatus.processed);
                  },
                  icon: const Icon(Icons.done_all, size: 18, color: Colors.blue),
                  tooltip: 'Mark as Processed',
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(CashoutStatus status) {
    switch (status) {
      case CashoutStatus.pending:
        return Colors.orange;
      case CashoutStatus.approved:
        return Colors.blue;
      case CashoutStatus.processed:
        return Colors.green;
      case CashoutStatus.rejected:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showCashoutDetails(BuildContext context, CashoutRequestModel cashout) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cashout Request Details'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('User Name', cashout.userName),
              _buildDetailRow('User Email', cashout.userEmail),
              _buildDetailRow('Amount', '\$${cashout.amount.toStringAsFixed(2)}'),
              _buildDetailRow('Payment Method', cashout.paymentMethod),
              if (cashout.paymentDetails != null) _buildDetailRow('Payment Details', cashout.paymentDetails!),
              _buildDetailRow('Status', cashout.status.displayName),
              _buildDetailRow('Requested At', DateFormat('MMM dd, yyyy HH:mm').format(cashout.requestedAt)),
              if (cashout.processedAt != null)
                _buildDetailRow('Processed At', DateFormat('MMM dd, yyyy HH:mm').format(cashout.processedAt!)),
              if (cashout.processedBy != null) _buildDetailRow('Processed By', cashout.processedBy!),
              if (cashout.rejectionReason != null) _buildDetailRow('Rejection Reason', cashout.rejectionReason!),
            ],
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close'))],
      ),
    );
  }

  void _showStatusChangeDialog(
    BuildContext context,
    CashoutRequestModel cashout,
    DashboardProvider provider,
    CashoutStatus newStatus,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Change Cashout Status'),
        content: Text(
          'Are you sure you want to change the status of this \$${cashout.amount.toStringAsFixed(2)} cashout request to ${newStatus.displayName}?',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              provider.updateCashoutStatus(cashout.id, newStatus);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Cashout status updated to ${newStatus.displayName}')));
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _showRejectDialog(BuildContext context, CashoutRequestModel cashout, DashboardProvider provider) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject Cashout Request'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Are you sure you want to reject this \$${cashout.amount.toStringAsFixed(2)} cashout request?'),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Rejection Reason',
                border: OutlineInputBorder(),
                hintText: 'Please provide a reason for rejection',
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (reasonController.text.isNotEmpty) {
                provider.updateCashoutStatus(
                  cashout.id,
                  CashoutStatus.rejected,
                  rejectionReason: reasonController.text,
                );
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cashout request rejected')));
              }
            },
            child: const Text('Reject'),
          ),
        ],
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
