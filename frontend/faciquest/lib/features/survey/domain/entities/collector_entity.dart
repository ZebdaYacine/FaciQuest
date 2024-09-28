class CollectorEntity {
  final String id;
  final String name;
  final CollectorStatus status;
  final int responsesCount;
  final int viewsCount;
  final DateTime? createdDate;
  final String surveyId;
  final String? webUrl;
  // TODO add target audience
  CollectorEntity({
    required this.id,
    required this.surveyId,
    this.webUrl,
    required this.name,
    required this.status,
    required this.responsesCount,
    required this.viewsCount,
    this.createdDate,
  });
}

enum CollectorStatus { open, draft, deleted }
