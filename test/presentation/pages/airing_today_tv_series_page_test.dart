import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/presentation/pages/airing_today_tv_series_page.dart';
import 'package:ditonton/presentation/provider/airing_today_tv_series_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';

import 'airing_today_tv_series_page_test.mocks.dart';

@GenerateMocks([AiringTodayTvSeriesNotifier])
void main() {
  late MockAiringTodayTvSeriesNotifier mockAiringTodayTvSeriesNotifier;

  setUp(() {
    mockAiringTodayTvSeriesNotifier = MockAiringTodayTvSeriesNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<AiringTodayTvSeriesNotifier>.value(
      value: mockAiringTodayTvSeriesNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('page should display center prgress bar when loading',
      (WidgetTester tester) async {
    when(mockAiringTodayTvSeriesNotifier.state)
        .thenReturn(RequestState.Loading);

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(AiringTodayTvSeriesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(mockAiringTodayTvSeriesNotifier.state).thenReturn(RequestState.Loaded);
    when(mockAiringTodayTvSeriesNotifier.tvSeries).thenReturn(<TvSeries>[]);

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(AiringTodayTvSeriesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('page should display text with message error',
      (WidgetTester tester) async {
    when(mockAiringTodayTvSeriesNotifier.state).thenReturn(RequestState.Error);
    when(mockAiringTodayTvSeriesNotifier.message).thenReturn('Error message');

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(AiringTodayTvSeriesPage()));

    expect(textFinder, findsOneWidget);
  });
}
