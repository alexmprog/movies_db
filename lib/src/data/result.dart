class Result<T> {
  Result._();

  factory Result.success(T value) = SuccessResult<T>;

  factory Result.error(T error) = ErrorResult<T>;
}

class SuccessResult<T> extends Result<T> {
  SuccessResult(this.value) : super._();
  final T value;
}

class ErrorResult<T> extends Result<T> {
  ErrorResult(this.error) : super._();
  final T error;
}
