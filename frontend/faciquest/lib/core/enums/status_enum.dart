/// most used Status
enum Status {
  ///
  initial,

  ///
  success,

  ///
  showLoading,

  ///
  hideLoading,

  ///
  info,

  ///
  failure;

  ///
  bool get isInitial => this == Status.initial;

  ///
  bool get isFailure => this == Status.failure;

  ///
  bool get isSuccess => this == Status.success;

  ///
  bool get isLoading => this == Status.showLoading;

  ///
  bool get isHideLoading => this == Status.hideLoading;

  ///
  bool get isInfo => this == Status.info;
}
