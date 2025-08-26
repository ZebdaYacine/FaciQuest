import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:intl/intl.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/filter_widgets.dart';
import 'survey_preview_screen.dart';
import '../models/models.dart';

class SurveysScreen extends StatefulWidget {
  const SurveysScreen({super.key});

  @override
  State<SurveysScreen> createState() => _SurveysScreenState();
}

class _SurveysScreenState extends State<SurveysScreen> {
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
      context.read<DashboardProvider>().loadSurveys();
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
                        'Surveys Management',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Review and manage survey submissions',
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
                        onPressed: () => provider.loadSurveys(refresh: true),
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
                SurveyFiltersWidget(
                  filters: provider.surveyFilters,
                  onFiltersChanged: (filters) {
                    provider.updateSurveyFilters(filters);
                  },
                ),
                const SizedBox(height: 20),
              ],

              // Stats row
              Row(
                children: [
                  _buildStatCard(context, 'Total Surveys', provider.surveys.length.toString(), Icons.quiz, Colors.blue),
                  const SizedBox(width: 16),
                  _buildStatCard(
                    context,
                    'Published',
                    provider.surveys.where((s) => s.status == SurveyStatus.published).length.toString(),
                    Icons.publish,
                    Colors.green,
                  ),
                  const SizedBox(width: 16),
                  _buildStatCard(
                    context,
                    'Pending',
                    provider.surveys.where((s) => s.status == SurveyStatus.draft).length.toString(),
                    Icons.hourglass_empty,
                    Colors.orange,
                  ),
                  const SizedBox(width: 16),
                  _buildStatCard(
                    context,
                    'Rejected',
                    provider.surveys.where((s) => s.status == SurveyStatus.deleted).length.toString(),
                    Icons.block,
                    Colors.red,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Surveys table
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
                              'Surveys List',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            if (provider.isLoadingSurveys)
                              const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: DataTable2(
                            dataRowHeight: 60,
                            columnSpacing: 12,
                            horizontalMargin: 12,
                            minWidth: 900,
                            columns: const [
                              DataColumn2(label: Text('Title'), size: ColumnSize.L),
                              DataColumn2(label: Text('Created By'), size: ColumnSize.M),
                              DataColumn2(label: Text('Status'), size: ColumnSize.S),
                              DataColumn2(label: Text('Participants'), size: ColumnSize.S),
                              DataColumn2(label: Text('Questions'), size: ColumnSize.S),
                              DataColumn2(label: Text('Reward'), size: ColumnSize.S),
                              DataColumn2(label: Text('Created'), size: ColumnSize.M),
                              DataColumn2(label: Text('Actions'), size: ColumnSize.M),
                            ],
                            rows: provider.surveys.map((survey) => _buildSurveyRow(context, survey, provider)).toList(),
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

  DataRow _buildSurveyRow(BuildContext context, SurveyEntity survey, DashboardProvider provider) {
    return DataRow(
      cells: [
        DataCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                survey.name,
                style: const TextStyle(fontWeight: FontWeight.w500),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (survey.description != null)
                Text(
                  survey.description!,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
        DataCell(Text(survey.collectorId ?? '')),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(survey.status).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              survey.status.name,
              style: TextStyle(color: _getStatusColor(survey.status), fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Text(
              survey.responseCount.toString(),
              style: const TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: Colors.purple.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Text(
              survey.questions.length.toString(),
              style: const TextStyle(color: Colors.purple, fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        DataCell(
          Text('\$${survey.price?.toStringAsFixed(2) ?? '0.00'}', style: const TextStyle(fontWeight: FontWeight.w500)),
        ),
        DataCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(DateFormat('MMM dd, yyyy').format(survey.createdAt), style: Theme.of(context).textTheme.bodySmall),
              if (survey.updatedAt != null)
                Text(
                  'Published: ${DateFormat('MMM dd').format(survey.updatedAt!)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.green),
                ),
            ],
          ),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  _showSurveyDetails(context, survey);
                },
                icon: const Icon(Icons.visibility, size: 18),
                tooltip: 'View details',
              ),
              IconButton(
                onPressed: () {
                  _showSurveyPreview(context, survey);
                },
                icon: const Icon(Icons.preview, size: 18),
                tooltip: 'Preview survey',
              ),
              if (survey.status == SurveyStatus.draft) ...[
                IconButton(
                  onPressed: () {
                    _showStatusChangeDialog(context, survey, provider, SurveyStatus.published);
                  },
                  icon: const Icon(Icons.check, size: 18, color: Colors.green),
                  tooltip: 'Approve',
                ),
                IconButton(
                  onPressed: () {
                    _showStatusChangeDialog(context, survey, provider, SurveyStatus.deleted);
                  },
                  icon: const Icon(Icons.close, size: 18, color: Colors.red),
                  tooltip: 'Reject',
                ),
              ],
              PopupMenuButton<SurveyStatus>(
                icon: const Icon(Icons.more_vert, size: 18),
                onSelected: (status) {
                  _showStatusChangeDialog(context, survey, provider, status);
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: SurveyStatus.active,
                    child: Row(
                      children: [
                        Icon(Icons.publish, size: 16, color: Colors.green),
                        SizedBox(width: 8),
                        Text('Publish'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: SurveyStatus.draft,
                    child: Row(
                      children: [
                        Icon(Icons.hourglass_empty, size: 16, color: Colors.orange),
                        SizedBox(width: 8),
                        Text('Set Pending'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: SurveyStatus.deleted,
                    child: Row(
                      children: [
                        Icon(Icons.block, size: 16, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Reject'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(SurveyStatus status) {
    switch (status) {
      case SurveyStatus.published:
        return Colors.green;
      case SurveyStatus.draft:
        return Colors.orange;
      case SurveyStatus.deleted:
        return Colors.red;
      case SurveyStatus.draft:
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  void _showSurveyDetails(BuildContext context, SurveyEntity survey) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Survey Details: ${survey.name}'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Title', survey.name),
              _buildDetailRow('Description', survey.description ?? ''),
              _buildDetailRow('Created By', survey.collectorId ?? ''),
              _buildDetailRow('Status', survey.status.name),
              _buildDetailRow('Participants', survey.responseCount.toString()),
              _buildDetailRow('Questions', survey.questions.length.toString()),
              _buildDetailRow('Reward Amount', '\$${survey.price?.toStringAsFixed(2) ?? '0.00'}'),
              _buildDetailRow('Created', DateFormat('MMM dd, yyyy HH:mm').format(survey.createdAt)),
              if (survey.updatedAt != null)
                _buildDetailRow('Published', DateFormat('MMM dd, yyyy HH:mm').format(survey.updatedAt!)),
            ],
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close'))],
      ),
    );
  }

  void _showSurveyPreview(BuildContext context, SurveyEntity survey) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SurveyPreviewScreen(surveyId: survey.id)));
  }

  void _showStatusChangeDialog(
    BuildContext context,
    SurveyEntity survey,
    DashboardProvider provider,
    SurveyStatus newStatus,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Change Survey Status'),
        content: Text('Are you sure you want to change the status of "${survey.name}" to ${newStatus.name}?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              provider.updateSurveyStatus(survey.id, newStatus);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Survey status updated to ${newStatus.name}')));
            },
            child: const Text('Confirm'),
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
