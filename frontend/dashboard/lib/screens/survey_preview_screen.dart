import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/models.dart';

class SurveyPreviewScreen extends StatefulWidget {
  final String surveyId;

  const SurveyPreviewScreen({super.key, required this.surveyId});

  @override
  State<SurveyPreviewScreen> createState() => _SurveyPreviewScreenState();
}

class _SurveyPreviewScreenState extends State<SurveyPreviewScreen> {
  SurveyEntity? _survey;
  bool _isLoading = true;
  String? _error;
  String _selectedLanguage = 'en';

  @override
  void initState() {
    super.initState();
    _loadSurvey();
  }

  Future<void> _loadSurvey() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // For now, using dummy data until API is properly integrated
      final survey = await SurveyEntity.dummy();
      setState(() {
        _survey = survey;
        if (survey != null && survey.languages.isNotEmpty) {
          _selectedLanguage = survey.languages.first;
        }
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Survey Preview'),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        actions: [
          if (_survey != null)
            IconButton(
              onPressed: () {
                _showSurveyInfo(context);
              },
              icon: const Icon(Icons.info_outline),
              tooltip: 'Survey Information',
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [CircularProgressIndicator(), SizedBox(height: 16), Text('Loading survey...')],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 16),
            Text('Error loading survey', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              _error!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.error),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(onPressed: _loadSurvey, icon: const Icon(Icons.refresh), label: const Text('Retry')),
          ],
        ),
      );
    }

    if (_survey == null) {
      return const Center(child: Text('Survey not found'));
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildSurveyHeader(),
          _buildLanguageSelector(),
          _buildStatsSection(),
          _buildActionsSection(),
          _buildCollectorsSection(),
          _buildQuestionsSection(),
          _buildAnswersSection(),
        ],
      ),
    );
  }

  Widget _buildSurveyHeader() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _survey!.name,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _survey!.status.color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _survey!.status.color),
                ),
                child: Text(
                  _survey!.status.name.toUpperCase(),
                  style: TextStyle(color: _survey!.status.color, fontWeight: FontWeight.w600, fontSize: 12),
                ),
              ),
            ],
          ),
          if (_survey!.description != null && _survey!.description!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              _survey!.description!,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.8)),
            ),
          ],
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _buildInfoChip(icon: Icons.quiz, label: '${_survey!.questions.length} Questions', color: Colors.blue),
              _buildInfoChip(icon: Icons.people, label: '${_survey!.responseCount} Responses', color: Colors.green),
              _buildInfoChip(icon: Icons.visibility, label: '${_survey!.viewCount} Views', color: Colors.orange),
              if (_survey!.price != null)
                _buildInfoChip(
                  icon: Icons.monetization_on,
                  label: '\$${_survey!.price!.toStringAsFixed(2)} Reward',
                  color: Colors.amber,
                ),
              if (_survey!.likertScale != null)
                _buildInfoChip(icon: Icons.star_rate, label: _survey!.likertScale!.getValue(), color: Colors.purple),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.w500, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector() {
    if (_survey!.languages.length <= 1) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.language, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Text('Language:', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(width: 12),
          Expanded(
            child: Wrap(
              spacing: 8,
              children: _survey!.languages.map((language) {
                final isSelected = language == _selectedLanguage;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedLanguage = language;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      language.toUpperCase(),
                      style: TextStyle(
                        color: isSelected
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    final totalQuestions = _survey!.questions.length;
    final totalResponses = _survey!.responseCount;
    final totalViews = _survey!.viewCount;
    final completionRate = totalViews > 0 ? (totalResponses / totalViews * 100) : 0.0;

    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Survey Statistics',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildStatCard('Questions', totalQuestions.toString(), Icons.quiz, Colors.blue)),
              const SizedBox(width: 12),
              Expanded(child: _buildStatCard('Responses', totalResponses.toString(), Icons.people, Colors.green)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildStatCard('Views', totalViews.toString(), Icons.visibility, Colors.orange)),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Completion Rate',
                  '${completionRate.toStringAsFixed(1)}%',
                  Icons.trending_up,
                  Colors.purple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Actions', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildActionButton('Edit Survey', Icons.edit, Colors.blue, () => _handleAction(SurveyAction.edit)),
              _buildActionButton(
                'Analyze Data',
                Icons.analytics,
                Colors.green,
                () => _handleAction(SurveyAction.analyze),
              ),
              _buildActionButton(
                'Share Survey',
                Icons.share,
                Colors.orange,
                () => _handleAction(SurveyAction.collectResponses),
              ),
              _buildActionButton('Delete Survey', Icons.delete, Colors.red, () => _handleAction(SurveyAction.delete)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: color.withOpacity(0.3)),
        ),
      ),
    );
  }

  Widget _buildCollectorsSection() {
    if (_survey!.collectors.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Collectors', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ...List.generate(_survey!.collectors.length, (index) {
            final collector = _survey!.collectors[index];
            return _buildCollectorCard(collector);
          }),
        ],
      ),
    );
  }

  Widget _buildCollectorCard(CollectorEntity collector) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(collector.type.icon, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  collector.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getCollectorStatusColor(collector.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  collector.status.name.toUpperCase(),
                  style: TextStyle(
                    color: _getCollectorStatusColor(collector.status),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildInfoChip(icon: Icons.people, label: '${collector.responsesCount} Responses', color: Colors.green),
              const SizedBox(width: 12),
              _buildInfoChip(icon: Icons.visibility, label: '${collector.viewsCount} Views', color: Colors.blue),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionsSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Questions Preview',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (_survey!.questions.isEmpty)
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.quiz_outlined, size: 48, color: Theme.of(context).colorScheme.onSurfaceVariant),
                    const SizedBox(height: 12),
                    Text(
                      'No questions available',
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            )
          else
            ...List.generate(_survey!.questions.length, (index) {
              final question = _survey!.questions[index];
              return _buildQuestionCard(question, index + 1);
            }),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(QuestionEntity question, int questionNumber) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  questionNumber.toString(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            question.title,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getQuestionTypeColor(question.type).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(question.type.icon, size: 14, color: _getQuestionTypeColor(question.type)),
                              const SizedBox(width: 4),
                              Text(
                                question.type.name,
                                style: TextStyle(
                                  color: _getQuestionTypeColor(question.type),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (question.isRequired) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.star, size: 12, color: Theme.of(context).colorScheme.error),
                          const SizedBox(width: 4),
                          Text(
                            'Required',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          _buildQuestionPreview(question),
        ],
      ),
    );
  }

  Widget _buildQuestionPreview(QuestionEntity question) {
    switch (question.type) {
      case QuestionType.multipleChoice:
        if (question is MultipleChoiceQuestion) {
          return _buildMultipleChoicePreview(question);
        }
        break;
      case QuestionType.checkboxes:
        if (question is CheckboxesQuestion) {
          return _buildCheckboxesPreview(question);
        }
        break;
      case QuestionType.dropdown:
        if (question is DropdownQuestion) {
          return _buildDropdownPreview(question);
        }
        break;
      case QuestionType.starRating:
        if (question is StarRatingQuestion) {
          return _buildStarRatingPreview(question);
        }
        break;
      case QuestionType.slider:
        if (question is SliderQuestion) {
          return _buildSliderPreview(question);
        }
        break;
      case QuestionType.matrix:
        if (question is MatrixQuestion) {
          return _buildMatrixPreview(question);
        }
        break;
      case QuestionType.imageChoice:
        if (question is ImageChoiceQuestion) {
          return _buildImageChoicePreview(question);
        }
        break;
      default:
        return _buildDefaultPreview();
    }
    return _buildDefaultPreview();
  }

  Widget _buildMultipleChoicePreview(MultipleChoiceQuestion question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text('Options:', style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        ...question.choices.map((choice) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Theme.of(context).colorScheme.outline),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(choice, style: Theme.of(context).textTheme.bodyMedium)),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildCheckboxesPreview(CheckboxesQuestion question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text(
          'Options (Multiple selection):',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        ...question.choices.map((choice) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(color: Theme.of(context).colorScheme.outline),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(choice, style: Theme.of(context).textTheme.bodyMedium)),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildDropdownPreview(DropdownQuestion question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Select an option...',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              ),
              Icon(Icons.arrow_drop_down, color: Theme.of(context).colorScheme.onSurfaceVariant),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Available options: ${question.choices.join(', ')}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }

  Widget _buildStarRatingPreview(StarRatingQuestion question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Row(
          children: List.generate(question.maxRating, (index) {
            return Icon(Icons.star_outline, size: 24, color: Theme.of(context).colorScheme.primary);
          }),
        ),
        const SizedBox(height: 4),
        Text(
          'Rating scale: 1 to ${question.maxRating} stars',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }

  Widget _buildSliderPreview(SliderQuestion question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Row(
          children: [
            Text('${question.min}'),
            Expanded(
              child: Slider(
                value: (question.min + question.max) / 2,
                min: question.min.toDouble(),
                max: question.max.toDouble(),
                onChanged: null,
              ),
            ),
            Text('${question.max}'),
          ],
        ),
        Text(
          'Range: ${question.min} to ${question.max}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }

  Widget _buildMatrixPreview(MatrixQuestion question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text('Matrix Question', style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Text('Rows: ${question.rows.join(', ')}', style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 4),
        Text('Columns: ${question.cols.join(', ')}', style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 4),
        Text(
          'Type: ${question.useCheckbox ? 'Checkbox' : 'Radio button'}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }

  Widget _buildImageChoicePreview(ImageChoiceQuestion question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text('Image Options:', style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: question.choices.length,
            itemBuilder: (context, index) {
              final choice = question.choices[index];
              return Container(
                margin: const EdgeInsets.only(right: 12),
                width: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.3)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: choice.url != null
                      ? Image.network(
                          choice.url!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Theme.of(context).colorScheme.surfaceContainerHighest,
                              child: Icon(Icons.image, color: Theme.of(context).colorScheme.onSurfaceVariant),
                            );
                          },
                        )
                      : Container(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          child: Icon(Icons.image, color: Theme.of(context).colorScheme.onSurfaceVariant),
                        ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultPreview() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'Answer input field',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
    );
  }

  Widget _buildAnswersSection() {
    if (_survey!.submissions.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Recent Responses',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () {
                  // Navigate to full responses view
                },
                icon: const Icon(Icons.arrow_forward),
                label: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...List.generate(_survey!.submissions.length > 3 ? 3 : _survey!.submissions.length, (index) {
            final submission = _survey!.submissions[index];
            return _buildSubmissionCard(submission, index + 1);
          }),
        ],
      ),
    );
  }

  Widget _buildSubmissionCard(SubmissionEntity submission, int responseNumber) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Response #$responseNumber',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '${submission.answers.length} answers',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Collector ID: ${submission.collectorId}',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  Color _getQuestionTypeColor(QuestionType type) {
    switch (type) {
      case QuestionType.starRating:
        return Colors.amber;
      case QuestionType.multipleChoice:
        return Colors.blue;
      case QuestionType.checkboxes:
        return Colors.green;
      case QuestionType.dropdown:
        return Colors.orange;
      case QuestionType.fileUpload:
        return Colors.purple;
      case QuestionType.commentBox:
        return Colors.indigo;
      case QuestionType.slider:
        return Colors.teal;
      case QuestionType.dateTime:
        return Colors.brown;
      case QuestionType.audioRecord:
        return Colors.red;
      case QuestionType.shortAnswer:
        return Colors.cyan;
      case QuestionType.matrix:
        return Colors.pink;
      case QuestionType.imageChoice:
        return Colors.deepOrange;
      case QuestionType.nameType:
        return Colors.lightBlue;
      case QuestionType.emailAddress:
        return Colors.deepPurple;
      case QuestionType.phoneNumber:
        return Colors.lime;
      case QuestionType.address:
        return Colors.blueGrey;
      case QuestionType.text:
        return Colors.grey;
      case QuestionType.image:
        return Colors.lightGreen;
    }
  }

  Color _getCollectorStatusColor(CollectorStatus status) {
    switch (status) {
      case CollectorStatus.open:
        return Colors.green;
      case CollectorStatus.draft:
        return Colors.grey;
      case CollectorStatus.deleted:
        return Colors.red;
      case CollectorStatus.checkingPayment:
        return Colors.orange;
    }
  }

  void _handleAction(SurveyAction action) {
    switch (action) {
      case SurveyAction.edit:
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Edit survey functionality coming soon')));
        break;
      case SurveyAction.analyze:
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Analytics functionality coming soon')));
        break;
      case SurveyAction.collectResponses:
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Share survey functionality coming soon')));
        break;
      case SurveyAction.delete:
        _showDeleteConfirmation();
        break;
      default:
        break;
    }
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Survey'),
        content: const Text('Are you sure you want to delete this survey? This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Survey deleted successfully')));
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showSurveyInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Survey Information'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow('ID', _survey!.id),
              _buildInfoRow('Name', _survey!.name),
              if (_survey!.description != null) _buildInfoRow('Description', _survey!.description!),
              _buildInfoRow('Status', _survey!.status.name),
              _buildInfoRow('Created', DateFormat('MMM dd, yyyy HH:mm').format(_survey!.createdAt)),
              if (_survey!.updatedAt != null)
                _buildInfoRow('Updated', DateFormat('MMM dd, yyyy HH:mm').format(_survey!.updatedAt!)),
              _buildInfoRow('Languages', _survey!.languages.join(', ')),
              if (_survey!.topics.isNotEmpty) _buildInfoRow('Topics', _survey!.topics.join(', ')),
              _buildInfoRow('Questions', _survey!.questions.length.toString()),
              _buildInfoRow('Responses', _survey!.responseCount.toString()),
              _buildInfoRow('Views', _survey!.viewCount.toString()),
              if (_survey!.price != null) _buildInfoRow('Reward', '\$${_survey!.price!.toStringAsFixed(2)}'),
            ],
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close'))],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text('$label:', style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
