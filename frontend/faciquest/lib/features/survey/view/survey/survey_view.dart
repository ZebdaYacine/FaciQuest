import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/survey/survey.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SurveyView extends StatelessWidget {
  const SurveyView({
    super.key,
    required this.surveyId,
  });
  final String surveyId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SurveyCubit(
        surveyId: surveyId,
        repository: getIt<SurveyRepository>(),
      )..getSurvey(),
      child: const _SurveyContent(),
    );
  }
}

class _SurveyContent extends StatelessWidget {
  const _SurveyContent();

  @override
  Widget build(BuildContext context) {
    return BlocListener<SurveyCubit, SurveyState>(
      listenWhen: (previous, current) => previous.submissionStatus != current.submissionStatus,
      listener: (context, state) {
        if (state.submissionStatus.isSuccess) {
          _showSuccessDialog(context);
          Future.delayed(2.seconds, () {
            if (context.mounted) {
              context.pop();
              context.pop();
            }
          });
        }
      },
      child: BlocBuilder<SurveyCubit, SurveyState>(
        // buildWhen: (previous, current) => previous.survey != current.survey,
        builder: (context, state) {
          if (state.status.isLoading) return const _LoadingState();
          if (state.status.isFailure) return const _FailureState();
          if (state.survey.isEmpty) return const _EmptyState();

          return _SurveyQuestions(state: state);
        },
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    HapticFeedback.heavyImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              context.colorScheme.surface,
              context.colorScheme.primaryContainer.withOpacity(0.1),
            ],
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          boxShadow: [
            BoxShadow(
              color: context.colorScheme.shadow.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          child: Stack(
            children: [
              // Background pattern
              Positioned(
                top: -100,
                right: -100,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.colorScheme.primary.withOpacity(0.05),
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Handle bar
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: context.colorScheme.onSurfaceVariant.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      margin: const EdgeInsets.only(bottom: 32),
                    ),
                    // Success animation
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.green,
                            Colors.green.withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(60),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 60,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'survey.submit.success.title'.tr(),
                      style: context.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'survey.submit.success.message'.tr(),
                      style: context.textTheme.bodyLarge?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.green.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.celebration_rounded,
                            color: Colors.green,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Thank you for your participation!',
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SurveyQuestions extends StatefulWidget {
  const _SurveyQuestions({required this.state});

  final SurveyState state;

  @override
  State<_SurveyQuestions> createState() => _SurveyQuestionsState();
}

class _SurveyQuestionsState extends State<_SurveyQuestions> with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _progressAnimationController;
  late Animation<double> _progressAnimation;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _progressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressAnimationController,
      curve: Curves.easeInOut,
    ));
    _progressAnimationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _progressAnimationController.dispose();
    super.dispose();
  }

  void _nextQuestion() {
    if (_currentIndex < widget.state.survey.questions.length - 1) {
      final currentQuestion = widget.state.survey.questions[_currentIndex];
      final cubit = context.read<SurveyCubit>();
      final currentAnswer = cubit.state.answers[currentQuestion.id];

      // Check if current question is required and not answered
      if (currentQuestion.isRequired && !_isQuestionAnswered(currentQuestion, currentAnswer)) {
        _showAnswerRequiredMessage(context, currentQuestion);
        return;
      }

      HapticFeedback.lightImpact();
      _currentIndex++;
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _updateProgress();
    }
  }

  void _previousQuestion() {
    if (_currentIndex > 0) {
      HapticFeedback.lightImpact();
      _currentIndex--;
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _updateProgress();
    }
  }

  void _updateProgress() {
    _progressAnimationController.reset();
    _progressAnimationController.forward();
  }

  bool _isQuestionAnswered(QuestionEntity question, AnswerEntity? answer) {
    if (answer == null) return false;

    switch (question.type) {
      case QuestionType.shortAnswer:
        return answer is ShortAnswerAnswer && answer.value.trim().isNotEmpty;
      case QuestionType.commentBox:
        return answer is CommentBoxAnswer && answer.value.trim().isNotEmpty;
      case QuestionType.multipleChoice:
        return answer is MultipleChoiceAnswer && answer.selectedChoice.isNotEmpty;
      case QuestionType.checkboxes:
        return answer is CheckboxesAnswer && answer.selectedChoices.isNotEmpty;
      case QuestionType.dropdown:
        return answer is DropdownAnswer && (answer.selectedChoice?.isNotEmpty ?? false);
      case QuestionType.slider:
        return answer is SliderAnswer;
      case QuestionType.starRating:
        return answer is StarRatingAnswer && answer.rating > 0;
      case QuestionType.dateTime:
        return answer is DateTimeAnswer && answer.value.trim().isNotEmpty;
      case QuestionType.matrix:
        if (answer is MatrixAnswer) {
          // Check if at least one value is selected for each row
          return answer.values.isNotEmpty && answer.values.values.every((row) => row.values.any((value) => value));
        }
        return false;
      case QuestionType.imageChoice:
        return answer is ImageChoiceAnswer && answer.selectedChoices.isNotEmpty;
      case QuestionType.fileUpload:
        return answer is FileUploadAnswer; // File upload just needs to exist
      case QuestionType.audioRecord:
        return answer is AudioRecordAnswer; // Audio record just needs to exist
      case QuestionType.nameType:
        if (answer is NameAnswer) {
          return (answer.firstName?.trim().isNotEmpty ?? false) || (answer.lastName?.trim().isNotEmpty ?? false);
        }
        return false;
      case QuestionType.emailAddress:
        return answer is EmailAddressAnswer && answer.value.trim().isNotEmpty;
      case QuestionType.phoneNumber:
        return answer is PhoneAnswer && answer.value.trim().isNotEmpty;
      case QuestionType.address:
        if (answer is AddressAnswer) {
          return (answer.streetAddress1?.trim().isNotEmpty ?? false) ||
              (answer.city?.trim().isNotEmpty ?? false) ||
              (answer.postalCode?.trim().isNotEmpty ?? false);
        }
        return false;
      case QuestionType.text:
        return true; // Text questions don't require answers
      case QuestionType.image:
        return true; // Image questions don't require answers
    }
  }

  void _showAnswerRequiredMessage(BuildContext context, QuestionEntity question) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.warning_rounded,
              color: Colors.orange,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'survey.validation.required_question'.tr(),
                style: context.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: context.colorScheme.onSurface.withOpacity(0.9),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'survey.validation.understood'.tr(),
          textColor: context.colorScheme.primary,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SurveyCubit>();

    return Scaffold(
      backgroundColor: context.colorScheme.surfaceContainerLowest,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          _buildProgressSection(context),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
                _updateProgress();
              },
              itemCount: widget.state.survey.questions.length,
              itemBuilder: (context, index) {
                final question = widget.state.survey.questions[index];
                final answer = cubit.state.answers[question.id];

                return SlideInAnimation(
                  key: ValueKey(question.id),
                  direction: SlideDirection.bottom,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        _buildQuestionCard(context, question, answer, index, cubit),
                        const SizedBox(height: 32),
                        if (index == widget.state.survey.questions.length - 1) _SubmitSection(cubit: cubit),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          _buildNavigationBar(context),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: context.colorScheme.surface,
      elevation: 0,
      scrolledUnderElevation: 1,
      surfaceTintColor: context.colorScheme.surfaceTint,
      leading: BouncyButton(
        onTap: () {
          HapticFeedback.lightImpact();
          Navigator.of(context).pop();
        },
        child: Icon(
          Icons.arrow_back_rounded,
          color: context.colorScheme.onSurface,
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.state.survey.name,
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.colorScheme.onSurface,
            ),
          ),
        ],
      ),
      centerTitle: false,
    );
  }

  Widget _buildProgressSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: context.colorScheme.outline.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'survey.question.progress'
                    .tr(args: [(_currentIndex + 1).toString(), widget.state.survey.questions.length.toString()]),
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${((_currentIndex + 1) / widget.state.survey.questions.length * 100).round()}%',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return LinearProgressIndicator(
                value: (_currentIndex + _progressAnimation.value) / widget.state.survey.questions.length,
                backgroundColor: context.colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation(context.colorScheme.primary),
                borderRadius: BorderRadius.circular(8),
                minHeight: 8,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(
    BuildContext context,
    QuestionEntity question,
    AnswerEntity? answer,
    int index,
    SurveyCubit cubit,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.colorScheme.surface,
            context.colorScheme.surfaceContainerHighest.withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.shadow.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: context.colorScheme.primary.withOpacity(0.03),
            blurRadius: 40,
            offset: const Offset(0, 16),
          ),
        ],
        border: Border.all(
          color: context.colorScheme.outline.withOpacity(0.08),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Background pattern
            Positioned(
              top: -30,
              right: -30,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.colorScheme.primary.withOpacity(0.02),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(24),
              child: QuestionPreview(
                question: question,
                isPreview: false,
                index: index + 1,
                answer: answer,
                onAnswerChanged: cubit.onAnswerChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationBar(BuildContext context) {
    final isFirstQuestion = _currentIndex == 0;
    final isLastQuestion = _currentIndex == widget.state.survey.questions.length - 1;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: context.colorScheme.outline.withOpacity(0.1),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.shadow.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (!isFirstQuestion)
              Expanded(
                child: EnhancedButton(
                  onPressed: _previousQuestion,
                  variant: ButtonVariant.outline,
                  size: ButtonSize.large,
                  icon: const Icon(Icons.arrow_back_rounded),
                  child: Text('survey.button.previous'.tr()),
                ),
              ),
            if (!isFirstQuestion && !isLastQuestion) const SizedBox(width: 16),
            if (!isLastQuestion)
              Expanded(
                flex: isFirstQuestion ? 1 : 1,
                child: EnhancedButton(
                  onPressed: _nextQuestion,
                  variant: ButtonVariant.primary,
                  size: ButtonSize.large,
                  suffixIcon: const Icon(Icons.arrow_forward_rounded),
                  child: Text('survey.button.next'.tr()),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SubmitSection extends StatefulWidget {
  const _SubmitSection({required this.cubit});

  final SurveyCubit cubit;

  @override
  State<_SubmitSection> createState() => _SubmitSectionState();
}

class _SubmitSectionState extends State<_SubmitSection> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SurveyCubit, SurveyState>(
      buildWhen: (previous, current) => previous.submissionStatus != current.submissionStatus,
      builder: (context, state) {
        return AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: state.submissionStatus.isLoading ? 1.0 : _pulseAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      context.colorScheme.primaryContainer.withOpacity(0.8),
                      context.colorScheme.secondaryContainer.withOpacity(0.6),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: context.colorScheme.primary.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                    BoxShadow(
                      color: context.colorScheme.shadow.withOpacity(0.05),
                      blurRadius: 40,
                      offset: const Offset(0, 16),
                    ),
                  ],
                  border: Border.all(
                    color: context.colorScheme.primary.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Stack(
                    children: [
                      // Background pattern
                      Positioned(
                        top: -40,
                        right: -40,
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: context.colorScheme.primary.withOpacity(0.05),
                          ),
                        ),
                      ),
                      // Content
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            _buildHeader(context),
                            const SizedBox(height: 20),
                            _buildDescription(context),
                            const SizedBox(height: 32),
                            _buildSubmitButton(context, state),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                context.colorScheme.primary,
                context.colorScheme.primary.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: context.colorScheme.primary.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(
            Icons.rocket_launch_rounded,
            color: context.colorScheme.onPrimary,
            size: 32,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'survey.submit.ready.title'.tr(),
          style: context.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colorScheme.surface.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            'survey.submit.ready.message'.tr(),
            style: context.textTheme.bodyLarge?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.verified_rounded,
                color: context.colorScheme.primary,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'Your responses are secure',
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context, SurveyState state) {
    return BouncyButton(
      onTap: state.submissionStatus.isLoading
          ? null
          : () {
              HapticFeedback.mediumImpact();
              widget.cubit.submit();
            },
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          gradient: state.submissionStatus.isLoading
              ? null
              : LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    context.colorScheme.primary,
                    context.colorScheme.primary.withOpacity(0.8),
                  ],
                ),
          color: state.submissionStatus.isLoading ? context.colorScheme.onSurface.withOpacity(0.12) : null,
          borderRadius: BorderRadius.circular(16),
          boxShadow: state.submissionStatus.isLoading
              ? null
              : [
                  BoxShadow(
                    color: context.colorScheme.primary.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (state.submissionStatus.isLoading) ...[
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(
                    context.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ] else ...[
              Icon(
                Icons.send_rounded,
                color: context.colorScheme.onPrimary,
                size: 20,
              ),
              const SizedBox(width: 12),
            ],
            Text(
              state.submissionStatus.isLoading
                  ? 'survey.submit.button.loading'.tr()
                  : 'survey.submit.button.default'.tr(),
              style: context.textTheme.titleMedium?.copyWith(
                color: state.submissionStatus.isLoading
                    ? context.colorScheme.onSurface.withOpacity(0.6)
                    : context.colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingState extends StatefulWidget {
  const _LoadingState();

  @override
  State<_LoadingState> createState() => _LoadingStateState();
}

class _LoadingStateState extends State<_LoadingState> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.colorScheme.surface,
        leading: BouncyButton(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(
            Icons.arrow_back_rounded,
            color: context.colorScheme.onSurface,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            context.colorScheme.primaryContainer,
                            context.colorScheme.secondaryContainer,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(60),
                        boxShadow: [
                          BoxShadow(
                            color: context.colorScheme.primary.withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 80,
                            height: 80,
                            child: CircularProgressIndicator(
                              strokeWidth: 4,
                              color: context.colorScheme.primary,
                            ),
                          ),
                          Icon(
                            Icons.quiz_rounded,
                            color: context.colorScheme.primary,
                            size: 40,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
              Text(
                'survey.loading.title'.tr(),
                style: context.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'survey.loading.message'.tr(),
                style: context.textTheme.bodyLarge?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.colorScheme.surface,
        leading: BouncyButton(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(
            Icons.arrow_back_rounded,
            color: context.colorScheme.onSurface,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: context.colorScheme.surfaceContainerHighest.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(60),
                ),
                child: Icon(
                  Icons.quiz_outlined,
                  size: 64,
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'survey.empty'.tr(),
                style: context.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'survey.empty.message'.tr(),
                style: context.textTheme.bodyLarge?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              EnhancedButton(
                onPressed: () => Navigator.of(context).pop(),
                variant: ButtonVariant.outline,
                size: ButtonSize.large,
                icon: const Icon(Icons.arrow_back_rounded),
                child: Text('survey.empty.button.go_back'.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FailureState extends StatelessWidget {
  const _FailureState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.colorScheme.surface,
        leading: BouncyButton(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(
            Icons.arrow_back_rounded,
            color: context.colorScheme.onSurface,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: context.colorScheme.errorContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(60),
                ),
                child: Icon(
                  Icons.error_outline_rounded,
                  size: 64,
                  color: context.colorScheme.error,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'survey.error.title'.tr(),
                style: context.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'survey.error.message'.tr(),
                style: context.textTheme.bodyLarge?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: EnhancedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      variant: ButtonVariant.outline,
                      size: ButtonSize.large,
                      icon: const Icon(Icons.arrow_back_rounded),
                      child: Text('survey.error.button.go_back'.tr()),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: EnhancedButton(
                      onPressed: () {
                        // TODO: Implement retry functionality
                        Navigator.of(context).pop();
                      },
                      variant: ButtonVariant.primary,
                      size: ButtonSize.large,
                      icon: const Icon(Icons.refresh_rounded),
                      child: Text('survey.error.button.retry'.tr()),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
