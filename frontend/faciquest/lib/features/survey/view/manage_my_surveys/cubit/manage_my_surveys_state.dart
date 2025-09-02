part of 'manage_my_surveys_cubit.dart';

enum SortOption {
  name,
  dateCreated,
  dateUpdated,
  responseCount,
  status,
}

enum FilterOption {
  all,
  active,
  draft,
  closed,
}

extension SortOptionExtension on SortOption {
  String get name {
    switch (this) {
      case SortOption.name:
        return 'Name';
      case SortOption.dateCreated:
        return 'Date Created';
      case SortOption.dateUpdated:
        return 'Date Updated';
      case SortOption.responseCount:
        return 'Responses';
      case SortOption.status:
        return 'Status';
    }
  }

  IconData get icon {
    switch (this) {
      case SortOption.name:
        return Icons.sort_by_alpha_rounded;
      case SortOption.dateCreated:
      case SortOption.dateUpdated:
        return Icons.schedule_rounded;
      case SortOption.responseCount:
        return Icons.bar_chart_rounded;
      case SortOption.status:
        return Icons.label_rounded;
    }
  }
}

extension FilterOptionExtension on FilterOption {
  String get name {
    switch (this) {
      case FilterOption.all:
        return 'All Surveys';
      case FilterOption.active:
        return 'Active';
      case FilterOption.draft:
        return 'Draft';
      case FilterOption.closed:
        return 'Closed';
    }
  }

  IconData get icon {
    switch (this) {
      case FilterOption.all:
        return Icons.all_inclusive_rounded;
      case FilterOption.active:
        return Icons.play_arrow_rounded;
      case FilterOption.draft:
        return Icons.edit_rounded;
      case FilterOption.closed:
        return Icons.stop_rounded;
    }
  }
}

class ManageMySurveysState {
  List<SurveyEntity> get filteredSurveys {
    var result = surveys;

    // Apply filter
    if (selectedFilter != FilterOption.all) {
      result = result.where((survey) {
        switch (selectedFilter) {
          case FilterOption.active:
            return survey.status == SurveyStatus.active;
          case FilterOption.draft:
            return survey.status == SurveyStatus.draft;
          case FilterOption.closed:
            return survey.status == SurveyStatus.deleted;
          case FilterOption.all:
            return true;
        }
      }).toList();
    }

    // Apply search
    if (searchQuery != null && searchQuery!.isNotEmpty) {
      result = result.where((survey) {
        return survey.name.toLowerCase().contains(searchQuery!.toLowerCase()) ||
            survey.id.toLowerCase().contains(searchQuery!.toLowerCase());
      }).toList();
    }

    // Apply sort
    result.sort((a, b) {
      int comparison = 0;
      switch (sortOption) {
        case SortOption.name:
          comparison = a.name.compareTo(b.name);
          break;
        case SortOption.dateCreated:
          comparison = a.createdAt.compareTo(b.createdAt);
          break;
        case SortOption.dateUpdated:
          comparison = a.updatedAt?.compareTo(b.updatedAt ?? DateTime.now()) ?? 0;
          break;
        case SortOption.responseCount:
          comparison = a.responseCount.compareTo(b.responseCount);
          break;
        case SortOption.status:
          comparison = a.status.toString().compareTo(b.status.toString());
          break;
      }
      return isAscending ? comparison : -comparison;
    });

    return result;
  }

  final Status status;
  final String? msg;
  final List<SurveyEntity> surveys;
  final String? searchQuery;
  final SortOption sortOption;
  final bool isAscending;
  final FilterOption selectedFilter;

  ManageMySurveysState({
    this.status = Status.initial,
    this.msg,
    this.surveys = const [],
    this.searchQuery,
    this.sortOption = SortOption.dateUpdated,
    this.isAscending = false,
    this.selectedFilter = FilterOption.all,
  });

  ManageMySurveysState copyWith({
    Status? status,
    String? msg,
    List<SurveyEntity>? surveys,
    String? searchQuery,
    SortOption? sortOption,
    bool? isAscending,
    FilterOption? selectedFilter,
  }) {
    return ManageMySurveysState(
      status: status ?? this.status,
      msg: msg ?? this.msg,
      surveys: surveys ?? this.surveys,
      searchQuery: searchQuery ?? this.searchQuery,
      sortOption: sortOption ?? this.sortOption,
      isAscending: isAscending ?? this.isAscending,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }
}
