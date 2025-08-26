import 'package:flutter/material.dart';
import '../models/models.dart';

class UserFiltersWidget extends StatefulWidget {
  final UserFilters filters;
  final Function(UserFilters) onFiltersChanged;

  const UserFiltersWidget({super.key, required this.filters, required this.onFiltersChanged});

  @override
  State<UserFiltersWidget> createState() => _UserFiltersWidgetState();
}

class _UserFiltersWidgetState extends State<UserFiltersWidget> {
  late UserFilters _filters;
  final _minSurveysController = TextEditingController();
  final _maxSurveysController = TextEditingController();
  final _minParticipationsController = TextEditingController();
  final _maxParticipationsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filters = widget.filters;
    _minSurveysController.text = _filters.minSurveys?.toString() ?? '';
    _maxSurveysController.text = _filters.maxSurveys?.toString() ?? '';
    _minParticipationsController.text = _filters.minParticipations?.toString() ?? '';
    _maxParticipationsController.text = _filters.maxParticipations?.toString() ?? '';
  }

  @override
  void dispose() {
    _minSurveysController.dispose();
    _maxSurveysController.dispose();
    _minParticipationsController.dispose();
    _maxParticipationsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Filters', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            Row(
              children: [
                // Active status filter
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Status',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<bool?>(
                        initialValue: _filters.isActive,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        items: const [
                          DropdownMenuItem(value: null, child: Text('All')),
                          DropdownMenuItem(value: true, child: Text('Active')),
                          DropdownMenuItem(value: false, child: Text('Inactive')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _filters = _filters.copyWith(isActive: value);
                          });
                          _applyFilters();
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                // Gender filter
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Gender',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<UserGender>(
                        initialValue: _filters.gender,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        items: UserGender.values.map((gender) {
                          return DropdownMenuItem(value: gender, child: Text(gender.displayName));
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _filters = _filters.copyWith(gender: value);
                            });
                            _applyFilters();
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                // Survey count range
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Surveys Range',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _minSurveysController,
                              decoration: const InputDecoration(
                                labelText: 'Min',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: _onSurveyRangeChanged,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _maxSurveysController,
                              decoration: const InputDecoration(
                                labelText: 'Max',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: _onSurveyRangeChanged,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                // Participation count range
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Participation Range',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _minParticipationsController,
                              decoration: const InputDecoration(
                                labelText: 'Min',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: _onParticipationRangeChanged,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _maxParticipationsController,
                              decoration: const InputDecoration(
                                labelText: 'Max',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: _onParticipationRangeChanged,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                // Clear filters button
                Column(
                  children: [
                    const SizedBox(height: 24),
                    ElevatedButton(onPressed: _clearFilters, child: const Text('Clear')),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onSurveyRangeChanged(String value) {
    final minSurveys = int.tryParse(_minSurveysController.text);
    final maxSurveys = int.tryParse(_maxSurveysController.text);

    setState(() {
      _filters = _filters.copyWith(minSurveys: minSurveys, maxSurveys: maxSurveys);
    });

    _applyFilters();
  }

  void _onParticipationRangeChanged(String value) {
    final minParticipations = int.tryParse(_minParticipationsController.text);
    final maxParticipations = int.tryParse(_maxParticipationsController.text);

    setState(() {
      _filters = _filters.copyWith(minParticipations: minParticipations, maxParticipations: maxParticipations);
    });

    _applyFilters();
  }

  void _applyFilters() {
    widget.onFiltersChanged(_filters);
  }

  void _clearFilters() {
    setState(() {
      _filters = UserFilters();
      _minSurveysController.clear();
      _maxSurveysController.clear();
      _minParticipationsController.clear();
      _maxParticipationsController.clear();
    });
    _applyFilters();
  }
}

class SurveyFiltersWidget extends StatefulWidget {
  final SurveyFilters filters;
  final Function(SurveyFilters) onFiltersChanged;

  const SurveyFiltersWidget({super.key, required this.filters, required this.onFiltersChanged});

  @override
  State<SurveyFiltersWidget> createState() => _SurveyFiltersWidgetState();
}

class _SurveyFiltersWidgetState extends State<SurveyFiltersWidget> {
  late SurveyFilters _filters;
  final _minRewardController = TextEditingController();
  final _maxRewardController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filters = widget.filters;
    _minRewardController.text = _filters.minReward?.toString() ?? '';
    _maxRewardController.text = _filters.maxReward?.toString() ?? '';
  }

  @override
  void dispose() {
    _minRewardController.dispose();
    _maxRewardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Filters', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            Row(
              children: [
                // Status filter
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Status',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<SurveyStatus>(
                        initialValue: _filters.status,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        items: SurveyStatus.values.map((status) {
                          return DropdownMenuItem(value: status, child: Text(status.name));
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _filters = _filters.copyWith(status: value);
                            });
                            _applyFilters();
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                // Reward range
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reward Range (\$)',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _minRewardController,
                              decoration: const InputDecoration(
                                labelText: 'Min',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: _onRewardRangeChanged,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _maxRewardController,
                              decoration: const InputDecoration(
                                labelText: 'Max',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: _onRewardRangeChanged,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                // Clear filters button
                Column(
                  children: [
                    const SizedBox(height: 24),
                    ElevatedButton(onPressed: _clearFilters, child: const Text('Clear')),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onRewardRangeChanged(String value) {
    final minReward = double.tryParse(_minRewardController.text);
    final maxReward = double.tryParse(_maxRewardController.text);

    setState(() {
      _filters = _filters.copyWith(minReward: minReward, maxReward: maxReward);
    });

    _applyFilters();
  }

  void _applyFilters() {
    widget.onFiltersChanged(_filters);
  }

  void _clearFilters() {
    setState(() {
      _filters = SurveyFilters();
      _minRewardController.clear();
      _maxRewardController.clear();
    });
    _applyFilters();
  }
}

class CashoutFiltersWidget extends StatefulWidget {
  final CashoutFilters filters;
  final Function(CashoutFilters) onFiltersChanged;

  const CashoutFiltersWidget({super.key, required this.filters, required this.onFiltersChanged});

  @override
  State<CashoutFiltersWidget> createState() => _CashoutFiltersWidgetState();
}

class _CashoutFiltersWidgetState extends State<CashoutFiltersWidget> {
  late CashoutFilters _filters;
  final _minAmountController = TextEditingController();
  final _maxAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filters = widget.filters;
    _minAmountController.text = _filters.minAmount?.toString() ?? '';
    _maxAmountController.text = _filters.maxAmount?.toString() ?? '';
  }

  @override
  void dispose() {
    _minAmountController.dispose();
    _maxAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Filters', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            Row(
              children: [
                // Status filter
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Status',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<CashoutStatus>(
                        initialValue: _filters.status,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        items: CashoutStatus.values.map((status) {
                          return DropdownMenuItem(value: status, child: Text(status.displayName));
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _filters = _filters.copyWith(status: value);
                            });
                            _applyFilters();
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                // Amount range
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Amount Range (\$)',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _minAmountController,
                              decoration: const InputDecoration(
                                labelText: 'Min',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: _onAmountRangeChanged,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _maxAmountController,
                              decoration: const InputDecoration(
                                labelText: 'Max',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: _onAmountRangeChanged,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                // Clear filters button
                Column(
                  children: [
                    const SizedBox(height: 24),
                    ElevatedButton(onPressed: _clearFilters, child: const Text('Clear')),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onAmountRangeChanged(String value) {
    final minAmount = double.tryParse(_minAmountController.text);
    final maxAmount = double.tryParse(_maxAmountController.text);

    setState(() {
      _filters = _filters.copyWith(minAmount: minAmount, maxAmount: maxAmount);
    });

    _applyFilters();
  }

  void _applyFilters() {
    widget.onFiltersChanged(_filters);
  }

  void _clearFilters() {
    setState(() {
      _filters = CashoutFilters();
      _minAmountController.clear();
      _maxAmountController.clear();
    });
    _applyFilters();
  }
}
