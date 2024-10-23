abstract class ModelState<T extends Object> {
  final T? item;
  final String? message;

  const ModelState({this.item, this.message});

  static ModelState<T> idle<T extends Object>() => const IdleState();

  static ModelState<T> loading<T extends Object>() => LoadingState<T>();

  static ModelState<T> loaded<T extends Object>(T? item) =>
      LoadedState<T>(item);

  static ModelState<T> failed<T extends Object>(String? message) =>
      FailedState<T>(message);
}

class IdleState<T extends Object> extends ModelState<T> {
  const IdleState();
}

class LoadingState<T extends Object> extends ModelState<T> {
  LoadingState();
}

class LoadedState<T extends Object> extends ModelState<T> {
  LoadedState(T? item) : super(item: item);
}

class FailedState<T extends Object> extends ModelState<T> {
  FailedState(String? message) : super(message: message);
}
