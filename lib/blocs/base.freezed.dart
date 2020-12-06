// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'base.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
class _$PageableDataTearOff {
  const _$PageableDataTearOff();

// ignore: unused_element
  _PageableData<T> call<T>({List<T> data, int total, int current}) {
    return _PageableData<T>(
      data: data,
      total: total,
      current: current,
    );
  }
}

/// @nodoc
// ignore: unused_element
const $PageableData = _$PageableDataTearOff();

/// @nodoc
mixin _$PageableData<T> {
  List<T> get data;
  int get total;
  int get current;

  $PageableDataCopyWith<T, PageableData<T>> get copyWith;
}

/// @nodoc
abstract class $PageableDataCopyWith<T, $Res> {
  factory $PageableDataCopyWith(
          PageableData<T> value, $Res Function(PageableData<T>) then) =
      _$PageableDataCopyWithImpl<T, $Res>;
  $Res call({List<T> data, int total, int current});
}

/// @nodoc
class _$PageableDataCopyWithImpl<T, $Res>
    implements $PageableDataCopyWith<T, $Res> {
  _$PageableDataCopyWithImpl(this._value, this._then);

  final PageableData<T> _value;
  // ignore: unused_field
  final $Res Function(PageableData<T>) _then;

  @override
  $Res call({
    Object data = freezed,
    Object total = freezed,
    Object current = freezed,
  }) {
    return _then(_value.copyWith(
      data: data == freezed ? _value.data : data as List<T>,
      total: total == freezed ? _value.total : total as int,
      current: current == freezed ? _value.current : current as int,
    ));
  }
}

/// @nodoc
abstract class _$PageableDataCopyWith<T, $Res>
    implements $PageableDataCopyWith<T, $Res> {
  factory _$PageableDataCopyWith(
          _PageableData<T> value, $Res Function(_PageableData<T>) then) =
      __$PageableDataCopyWithImpl<T, $Res>;
  @override
  $Res call({List<T> data, int total, int current});
}

/// @nodoc
class __$PageableDataCopyWithImpl<T, $Res>
    extends _$PageableDataCopyWithImpl<T, $Res>
    implements _$PageableDataCopyWith<T, $Res> {
  __$PageableDataCopyWithImpl(
      _PageableData<T> _value, $Res Function(_PageableData<T>) _then)
      : super(_value, (v) => _then(v as _PageableData<T>));

  @override
  _PageableData<T> get _value => super._value as _PageableData<T>;

  @override
  $Res call({
    Object data = freezed,
    Object total = freezed,
    Object current = freezed,
  }) {
    return _then(_PageableData<T>(
      data: data == freezed ? _value.data : data as List<T>,
      total: total == freezed ? _value.total : total as int,
      current: current == freezed ? _value.current : current as int,
    ));
  }
}

/// @nodoc
class _$_PageableData<T> implements _PageableData<T> {
  _$_PageableData({this.data, this.total, this.current});

  @override
  final List<T> data;
  @override
  final int total;
  @override
  final int current;

  @override
  String toString() {
    return 'PageableData<$T>(data: $data, total: $total, current: $current)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _PageableData<T> &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)) &&
            (identical(other.total, total) ||
                const DeepCollectionEquality().equals(other.total, total)) &&
            (identical(other.current, current) ||
                const DeepCollectionEquality().equals(other.current, current)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(data) ^
      const DeepCollectionEquality().hash(total) ^
      const DeepCollectionEquality().hash(current);

  @override
  _$PageableDataCopyWith<T, _PageableData<T>> get copyWith =>
      __$PageableDataCopyWithImpl<T, _PageableData<T>>(this, _$identity);
}

abstract class _PageableData<T> implements PageableData<T> {
  factory _PageableData({List<T> data, int total, int current}) =
      _$_PageableData<T>;

  @override
  List<T> get data;
  @override
  int get total;
  @override
  int get current;
  @override
  _$PageableDataCopyWith<T, _PageableData<T>> get copyWith;
}

/// @nodoc
class _$DataStateTearOff {
  const _$DataStateTearOff();

// ignore: unused_element
  Data<T> call<T>(T state) {
    return Data<T>(
      state,
    );
  }

// ignore: unused_element
  _Init<T> init<T>() {
    return _Init<T>();
  }

// ignore: unused_element
  _Loading<T> loading<T>() {
    return _Loading<T>();
  }

// ignore: unused_element
  ErrorDetails<T> error<T>([String message]) {
    return ErrorDetails<T>(
      message,
    );
  }
}

/// @nodoc
// ignore: unused_element
const $DataState = _$DataStateTearOff();

/// @nodoc
mixin _$DataState<T> {
  @optionalTypeArgs
  TResult when<TResult extends Object>(
    TResult $default(T state), {
    @required TResult init(),
    @required TResult loading(),
    @required TResult error(String message),
  });
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>(
    TResult $default(T state), {
    TResult init(),
    TResult loading(),
    TResult error(String message),
    @required TResult orElse(),
  });
  @optionalTypeArgs
  TResult map<TResult extends Object>(
    TResult $default(Data<T> value), {
    @required TResult init(_Init<T> value),
    @required TResult loading(_Loading<T> value),
    @required TResult error(ErrorDetails<T> value),
  });
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>(
    TResult $default(Data<T> value), {
    TResult init(_Init<T> value),
    TResult loading(_Loading<T> value),
    TResult error(ErrorDetails<T> value),
    @required TResult orElse(),
  });
}

/// @nodoc
abstract class $DataStateCopyWith<T, $Res> {
  factory $DataStateCopyWith(
          DataState<T> value, $Res Function(DataState<T>) then) =
      _$DataStateCopyWithImpl<T, $Res>;
}

/// @nodoc
class _$DataStateCopyWithImpl<T, $Res> implements $DataStateCopyWith<T, $Res> {
  _$DataStateCopyWithImpl(this._value, this._then);

  final DataState<T> _value;
  // ignore: unused_field
  final $Res Function(DataState<T>) _then;
}

/// @nodoc
abstract class $DataCopyWith<T, $Res> {
  factory $DataCopyWith(Data<T> value, $Res Function(Data<T>) then) =
      _$DataCopyWithImpl<T, $Res>;
  $Res call({T state});
}

/// @nodoc
class _$DataCopyWithImpl<T, $Res> extends _$DataStateCopyWithImpl<T, $Res>
    implements $DataCopyWith<T, $Res> {
  _$DataCopyWithImpl(Data<T> _value, $Res Function(Data<T>) _then)
      : super(_value, (v) => _then(v as Data<T>));

  @override
  Data<T> get _value => super._value as Data<T>;

  @override
  $Res call({
    Object state = freezed,
  }) {
    return _then(Data<T>(
      state == freezed ? _value.state : state as T,
    ));
  }
}

/// @nodoc
class _$Data<T> implements Data<T> {
  const _$Data(this.state) : assert(state != null);

  @override
  final T state;

  @override
  String toString() {
    return 'DataState<$T>(state: $state)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is Data<T> &&
            (identical(other.state, state) ||
                const DeepCollectionEquality().equals(other.state, state)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(state);

  @override
  $DataCopyWith<T, Data<T>> get copyWith =>
      _$DataCopyWithImpl<T, Data<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>(
    TResult $default(T state), {
    @required TResult init(),
    @required TResult loading(),
    @required TResult error(String message),
  }) {
    assert($default != null);
    assert(init != null);
    assert(loading != null);
    assert(error != null);
    return $default(state);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>(
    TResult $default(T state), {
    TResult init(),
    TResult loading(),
    TResult error(String message),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if ($default != null) {
      return $default(state);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>(
    TResult $default(Data<T> value), {
    @required TResult init(_Init<T> value),
    @required TResult loading(_Loading<T> value),
    @required TResult error(ErrorDetails<T> value),
  }) {
    assert($default != null);
    assert(init != null);
    assert(loading != null);
    assert(error != null);
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>(
    TResult $default(Data<T> value), {
    TResult init(_Init<T> value),
    TResult loading(_Loading<T> value),
    TResult error(ErrorDetails<T> value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }
}

abstract class Data<T> implements DataState<T> {
  const factory Data(T state) = _$Data<T>;

  T get state;
  $DataCopyWith<T, Data<T>> get copyWith;
}

/// @nodoc
abstract class _$InitCopyWith<T, $Res> {
  factory _$InitCopyWith(_Init<T> value, $Res Function(_Init<T>) then) =
      __$InitCopyWithImpl<T, $Res>;
}

/// @nodoc
class __$InitCopyWithImpl<T, $Res> extends _$DataStateCopyWithImpl<T, $Res>
    implements _$InitCopyWith<T, $Res> {
  __$InitCopyWithImpl(_Init<T> _value, $Res Function(_Init<T>) _then)
      : super(_value, (v) => _then(v as _Init<T>));

  @override
  _Init<T> get _value => super._value as _Init<T>;
}

/// @nodoc
class _$_Init<T> implements _Init<T> {
  const _$_Init();

  @override
  String toString() {
    return 'DataState<$T>.init()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is _Init<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>(
    TResult $default(T state), {
    @required TResult init(),
    @required TResult loading(),
    @required TResult error(String message),
  }) {
    assert($default != null);
    assert(init != null);
    assert(loading != null);
    assert(error != null);
    return init();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>(
    TResult $default(T state), {
    TResult init(),
    TResult loading(),
    TResult error(String message),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (init != null) {
      return init();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>(
    TResult $default(Data<T> value), {
    @required TResult init(_Init<T> value),
    @required TResult loading(_Loading<T> value),
    @required TResult error(ErrorDetails<T> value),
  }) {
    assert($default != null);
    assert(init != null);
    assert(loading != null);
    assert(error != null);
    return init(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>(
    TResult $default(Data<T> value), {
    TResult init(_Init<T> value),
    TResult loading(_Loading<T> value),
    TResult error(ErrorDetails<T> value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (init != null) {
      return init(this);
    }
    return orElse();
  }
}

abstract class _Init<T> implements DataState<T> {
  const factory _Init() = _$_Init<T>;
}

/// @nodoc
abstract class _$LoadingCopyWith<T, $Res> {
  factory _$LoadingCopyWith(
          _Loading<T> value, $Res Function(_Loading<T>) then) =
      __$LoadingCopyWithImpl<T, $Res>;
}

/// @nodoc
class __$LoadingCopyWithImpl<T, $Res> extends _$DataStateCopyWithImpl<T, $Res>
    implements _$LoadingCopyWith<T, $Res> {
  __$LoadingCopyWithImpl(_Loading<T> _value, $Res Function(_Loading<T>) _then)
      : super(_value, (v) => _then(v as _Loading<T>));

  @override
  _Loading<T> get _value => super._value as _Loading<T>;
}

/// @nodoc
class _$_Loading<T> implements _Loading<T> {
  const _$_Loading();

  @override
  String toString() {
    return 'DataState<$T>.loading()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is _Loading<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>(
    TResult $default(T state), {
    @required TResult init(),
    @required TResult loading(),
    @required TResult error(String message),
  }) {
    assert($default != null);
    assert(init != null);
    assert(loading != null);
    assert(error != null);
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>(
    TResult $default(T state), {
    TResult init(),
    TResult loading(),
    TResult error(String message),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>(
    TResult $default(Data<T> value), {
    @required TResult init(_Init<T> value),
    @required TResult loading(_Loading<T> value),
    @required TResult error(ErrorDetails<T> value),
  }) {
    assert($default != null);
    assert(init != null);
    assert(loading != null);
    assert(error != null);
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>(
    TResult $default(Data<T> value), {
    TResult init(_Init<T> value),
    TResult loading(_Loading<T> value),
    TResult error(ErrorDetails<T> value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _Loading<T> implements DataState<T> {
  const factory _Loading() = _$_Loading<T>;
}

/// @nodoc
abstract class $ErrorDetailsCopyWith<T, $Res> {
  factory $ErrorDetailsCopyWith(
          ErrorDetails<T> value, $Res Function(ErrorDetails<T>) then) =
      _$ErrorDetailsCopyWithImpl<T, $Res>;
  $Res call({String message});
}

/// @nodoc
class _$ErrorDetailsCopyWithImpl<T, $Res>
    extends _$DataStateCopyWithImpl<T, $Res>
    implements $ErrorDetailsCopyWith<T, $Res> {
  _$ErrorDetailsCopyWithImpl(
      ErrorDetails<T> _value, $Res Function(ErrorDetails<T>) _then)
      : super(_value, (v) => _then(v as ErrorDetails<T>));

  @override
  ErrorDetails<T> get _value => super._value as ErrorDetails<T>;

  @override
  $Res call({
    Object message = freezed,
  }) {
    return _then(ErrorDetails<T>(
      message == freezed ? _value.message : message as String,
    ));
  }
}

/// @nodoc
class _$ErrorDetails<T> implements ErrorDetails<T> {
  const _$ErrorDetails([this.message]);

  @override
  final String message;

  @override
  String toString() {
    return 'DataState<$T>.error(message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is ErrorDetails<T> &&
            (identical(other.message, message) ||
                const DeepCollectionEquality().equals(other.message, message)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(message);

  @override
  $ErrorDetailsCopyWith<T, ErrorDetails<T>> get copyWith =>
      _$ErrorDetailsCopyWithImpl<T, ErrorDetails<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>(
    TResult $default(T state), {
    @required TResult init(),
    @required TResult loading(),
    @required TResult error(String message),
  }) {
    assert($default != null);
    assert(init != null);
    assert(loading != null);
    assert(error != null);
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>(
    TResult $default(T state), {
    TResult init(),
    TResult loading(),
    TResult error(String message),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>(
    TResult $default(Data<T> value), {
    @required TResult init(_Init<T> value),
    @required TResult loading(_Loading<T> value),
    @required TResult error(ErrorDetails<T> value),
  }) {
    assert($default != null);
    assert(init != null);
    assert(loading != null);
    assert(error != null);
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>(
    TResult $default(Data<T> value), {
    TResult init(_Init<T> value),
    TResult loading(_Loading<T> value),
    TResult error(ErrorDetails<T> value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class ErrorDetails<T> implements DataState<T> {
  const factory ErrorDetails([String message]) = _$ErrorDetails<T>;

  String get message;
  $ErrorDetailsCopyWith<T, ErrorDetails<T>> get copyWith;
}
