class DataState<T> {
  final T? data;

  final String? error;

  final bool isSuccess;

  DataState.success(this.data) : error = null, isSuccess = true;

  DataState.failure(this.error) : data = null, isSuccess = false;
}
