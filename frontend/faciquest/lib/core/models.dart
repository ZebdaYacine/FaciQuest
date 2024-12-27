enum Gender {
  male,
  female,
  both;

  String toMap() {
    switch (this) {
      case Gender.male:
        return 'Male';
      case Gender.female:
        return 'Female';
      case Gender.both:
        return 'Both';
    }
  }

  static Gender? fromMap(String? value) {
    switch (value) {
      case 'Male':
        return Gender.male;
      case 'Female':
        return Gender.female;
      case 'Both':
        return Gender.both;
      default:
        return Gender.both;
    }
  }
}
