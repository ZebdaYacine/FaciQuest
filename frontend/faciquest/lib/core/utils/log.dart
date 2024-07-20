import 'dart:developer' as developer;

bool showTime = true;

String get printTime {
  final date = DateTime.now();
  return showTime ? ':${date.minute}:${date.second}:${date.millisecond}' : '';
}

/// blue text
void logInfo(dynamic msg) {
  developer.log(
    '\x1B[34m$msg\x1B[0m',
    name: 'YassirX$printTime',
  );
}

/// Green text
void logSuccess(dynamic msg) {
  developer.log(
    '\x1B[32m$msg\x1B[0m',
    name: 'YassirX$printTime',
  );
}

/// Yellow text
void logWarning(dynamic msg) {
  developer.log(
    '\x1B[33m$msg\x1B[0m',
    name: 'YassirX$printTime',
  );
}

/// Red text
void logError(dynamic msg) {
  developer.log(
    '\x1B[31m$msg\x1B[0m',
    name: 'YassirX$printTime',
  );
}
