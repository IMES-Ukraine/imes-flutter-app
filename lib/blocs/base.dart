import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:imes/models/analytics.dart';
import 'package:imes/models/test.dart';
import 'package:imes/resources/repository.dart';
import 'package:state_notifier/state_notifier.dart';

part 'base.freezed.dart';

@freezed
abstract class PageableData<T> with _$PageableData<T> {
  factory PageableData({List<T> data, int total, int current}) = _PageableData;
}

@freezed
abstract class DataState<T> with _$DataState<T> {
  const factory DataState(T state) = Data<T>;
  const factory DataState.init() = Init<T>;
  const factory DataState.loading() = Loading<T>;
  const factory DataState.error([String message]) = ErrorDetails<T>;
}

class TestsNotifier extends StateNotifier<DataState<PageableData<Test>>> with LocatorMixin {
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  TestsNotifier() : super(DataState.init());

  Future load() async {
    // state = DataState.loading();

    try {
      final response = await Repository().api.tests();
      // final response = await Repository().api.analytics(date: dateFormat.format(DateTime.now()));
      if (response.statusCode == 200) {
        final optionsPage = response.body.data;
        final current = PageableData<Test>(
          data: optionsPage?.data ?? [],
          total: optionsPage?.total ?? 0,
          current: optionsPage?.currentPage ?? 0,
        );

        state = DataState(current);
      }
    } catch (e) {
      state = DataState.error(e.toString());
      // rethrow;
    }
  }
}
