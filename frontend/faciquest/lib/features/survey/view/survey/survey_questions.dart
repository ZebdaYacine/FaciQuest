part of 'survey_view.dart';

class _SurveyQuestions extends StatefulWidget {
  const _SurveyQuestions({required this.state});

  final SurveyState state;

  @override
  State<_SurveyQuestions> createState() => _SurveyQuestionsState();
}

class _SurveyQuestionsState extends State<_SurveyQuestions>
    with TickerProviderStateMixin {
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
      if (currentQuestion.isRequired &&
          !_isQuestionAnswered(currentQuestion, currentAnswer)) {
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
        return answer is MultipleChoiceAnswer &&
            answer.selectedChoice.isNotEmpty;
      case QuestionType.checkboxes:
        return answer is CheckboxesAnswer && answer.selectedChoices.isNotEmpty;
      case QuestionType.dropdown:
        return answer is DropdownAnswer &&
            (answer.selectedChoice?.isNotEmpty ?? false);
      case QuestionType.slider:
        return answer is SliderAnswer;
      case QuestionType.starRating:
        return answer is StarRatingAnswer && answer.rating > 0;
      case QuestionType.dateTime:
        return answer is DateTimeAnswer && answer.value.trim().isNotEmpty;
      case QuestionType.matrix:
        if (answer is MatrixAnswer) {
          // Check if at least one value is selected for each row
          return answer.values.isNotEmpty &&
              answer.values.values
                  .every((row) => row.values.any((value) => value));
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
          return (answer.firstName?.trim().isNotEmpty ?? false) ||
              (answer.lastName?.trim().isNotEmpty ?? false);
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

  void _showAnswerRequiredMessage(
      BuildContext context, QuestionEntity question) {
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
        backgroundColor: context.colorScheme.onSurface.withValues(alpha: 0.9),
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
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Column(
                      children: [
                        AdaptivePageBody(
                          maxWidth: 800,
                          child: Column(
                            children: [
                              SurveyQuestionRenderer(
                                question: question,
                                answer: answer,
                                index: index,
                                onAnswerChanged: cubit.onAnswerChanged,
                              ),
                              const SizedBox(height: 32),
                              if (index ==
                                  widget.state.survey.questions.length - 1)
                                _SubmitSection(cubit: cubit),
                            ],
                          ),
                        ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? context.colorScheme.surface.withValues(alpha: 0.8)
              : Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: context.colorScheme.shadow.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: context.colorScheme.outline.withValues(alpha: 0.1),
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'survey.question.progress'.tr(args: [
                    (_currentIndex + 1).toString(),
                    widget.state.survey.questions.length.toString()
                  ]),
                  style: context.textTheme.titleSmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: context.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${((_currentIndex + 1) / widget.state.survey.questions.length * 100).round()}%',
                    style: context.textTheme.labelMedium?.copyWith(
                      color: context.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AnimatedBuilder(
                animation: _progressAnimation,
                builder: (context, child) {
                  return LinearProgressIndicator(
                    value: (_currentIndex + _progressAnimation.value) /
                        widget.state.survey.questions.length,
                    backgroundColor:
                        context.colorScheme.surfaceContainerHighest,
                    valueColor:
                        AlwaysStoppedAnimation(context.colorScheme.primary),
                    minHeight: 8,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationBar(BuildContext context) {
    final isFirstQuestion = _currentIndex == 0;
    final isLastQuestion =
        _currentIndex == widget.state.survey.questions.length - 1;

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? context.colorScheme.surface.withValues(alpha: 0.7)
                : Colors.white.withValues(alpha: 0.7),
            border: Border(
              top: BorderSide(
                color: context.colorScheme.outline.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
          ),
          child: SafeArea(
            child: AdaptiveContentWidth(
              maxWidth: 800,
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
                  if (!isFirstQuestion && !isLastQuestion)
                    const SizedBox(width: 16),
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
          ),
        ),
      ),
    );
  }
}
