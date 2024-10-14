enum Gender {
  male,
  female,
  both;

  String toMap() {
    switch (this) {
      case Gender.male:
        return 'male';
      case Gender.female:
        return 'female';
      case Gender.both:
        return 'both';
    }
  }

  static Gender? fromMap(String? value) {
    switch (value) {
      case 'male':
        return Gender.male;
      case 'female':
        return Gender.female;
      case 'both':
        return Gender.both;
      default:
        return Gender.both;
    }
  }
}
