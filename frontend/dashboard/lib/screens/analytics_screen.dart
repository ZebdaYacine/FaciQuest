import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/dashboard_provider.dart';
import '../models/analytics_model.dart';
import '../widgets/analytics_card.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

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
                        'Analytics Dashboard',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Overview of key metrics and performance indicators',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                  _buildTimePeriodSelector(context, provider),
                ],
              ),
              
              const SizedBox(height: 32),
              
              // Analytics Cards
              AnalyticsCardsGrid(
                cards: _buildAnalyticsCards(provider.analytics),
                isLoading: provider.isLoadingAnalytics,
              ),
              
              const SizedBox(height: 32),
              
              // Additional stats section
              if (provider.analytics != null) ...[
                Row(
                  children: [
                    Expanded(
                      child: _buildDetailCard(
                        context,
                        'Period Summary',
                        _buildPeriodSummary(context, provider.analytics!),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildDetailCard(
                        context,
                        'Quick Stats',
                        _buildQuickStats(context, provider.analytics!),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimePeriodSelector(BuildContext context, DashboardProvider provider) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: TimePeriod.values.map((period) {
          final isSelected = provider.selectedPeriod == period;
          return GestureDetector(
            onTap: () => provider.updateTimePeriod(period),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected 
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                period.displayName,
                style: TextStyle(
                  color: isSelected 
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 12,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  List<AnalyticsCard> _buildAnalyticsCards(AnalyticsModel? analytics) {
    if (analytics == null) {
      return [
        AnalyticsCard(title: 'Active Users', value: '--'),
        AnalyticsCard(title: 'Total Surveys', value: '--'),
        AnalyticsCard(title: 'Cashout Requests', value: '--'),
        AnalyticsCard(title: 'Total Amount', value: '--'),
      ];
    }

    return [
      AnalyticsCard(
        title: 'Active Users',
        value: '${analytics.activeUserPercentage.toStringAsFixed(1)}%',
        subtitle: '${analytics.activeUsers} of ${analytics.totalUsers} users',
        percentage: analytics.activeUserPercentage > 50 ? 5.2 : -2.1,
        isPositive: analytics.activeUserPercentage > 50,
      ),
      AnalyticsCard(
        title: 'Total Surveys',
        value: NumberFormat('#,###').format(analytics.totalSurveys),
        subtitle: 'Published surveys',
        percentage: 12.5,
        isPositive: true,
      ),
      AnalyticsCard(
        title: 'Cashout Requests',
        value: NumberFormat('#,###').format(analytics.totalCashoutRequests),
        subtitle: 'Pending & processed',
        percentage: 8.3,
        isPositive: true,
      ),
      AnalyticsCard(
        title: 'Total Amount',
        value: '\$${NumberFormat('#,###.00').format(analytics.totalCashoutAmount)}',
        subtitle: 'Cashout amount',
        percentage: 15.7,
        isPositive: true,
      ),
    ];
  }

  Widget _buildDetailCard(BuildContext context, String title, Widget content) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodSummary(BuildContext context, AnalyticsModel analytics) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSummaryRow(
          context,
          'Period',
          '${dateFormat.format(analytics.periodStart)} - ${dateFormat.format(analytics.periodEnd)}',
        ),
        const SizedBox(height: 8),
        _buildSummaryRow(
          context,
          'Total Users',
          NumberFormat('#,###').format(analytics.totalUsers),
        ),
        const SizedBox(height: 8),
        _buildSummaryRow(
          context,
          'Active Users',
          '${NumberFormat('#,###').format(analytics.activeUsers)} (${analytics.activeUserPercentage.toStringAsFixed(1)}%)',
        ),
        const SizedBox(height: 8),
        _buildSummaryRow(
          context,
          'Avg. per Day',
          NumberFormat('#,###').format(
            analytics.totalSurveys / analytics.periodEnd.difference(analytics.periodStart).inDays,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats(BuildContext context, AnalyticsModel analytics) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatItem(
          context,
          Icons.people,
          'User Engagement',
          '${analytics.activeUserPercentage.toStringAsFixed(1)}%',
          analytics.activeUserPercentage > 70 ? Colors.green : Colors.orange,
        ),
        const SizedBox(height: 12),
        _buildStatItem(
          context,
          Icons.quiz,
          'Survey Activity',
          NumberFormat('#,###').format(analytics.totalSurveys),
          Colors.blue,
        ),
        const SizedBox(height: 12),
        _buildStatItem(
          context,
          Icons.account_balance_wallet,
          'Avg. Cashout',
          '\$${(analytics.totalCashoutAmount / (analytics.totalCashoutRequests > 0 ? analytics.totalCashoutRequests : 1)).toStringAsFixed(2)}',
          Colors.purple,
        ),
      ],
    );
  }

  Widget _buildSummaryRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(BuildContext context, IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
