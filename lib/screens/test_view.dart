import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:imes/blocs/test_notifier.dart';
import 'package:imes/helpers/utils.dart';
import 'package:imes/hooks/test_timer_hook.dart';
import 'package:imes/widgets/custom_alert_dialog.dart';
import 'package:imes/widgets/custom_dialog.dart';
import 'package:imes/widgets/error_retry.dart';
import 'package:imes/widgets/raised_gradient_button.dart';
import 'package:imes/widgets/test_card.dart';
import 'package:imes/widgets/test_title.dart';
import 'package:provider/provider.dart';

class TestViewPage extends StatefulHookWidget {
  final num id;

  TestViewPage(this.id);

  @override
  _TestViewPageState createState() => _TestViewPageState();
}

class _TestViewPageState extends State<TestViewPage> {
  // BetterPlayerListVideoPlayerController videosController;
  @override
  void initState() {
    super.initState();
    // videosController = BetterPlayerListVideoPlayerController();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final controller = useTextEditingController();
    final durationTimer = useCountDownValueNotifier(context);
    // final durationTimer = ValueNotifier(const Duration(seconds: 5));

    return ChangeNotifierProvider(
      create: (_) => TestNotifier()
        ..load(widget.id).then(
          (duration) => durationTimer.value = Duration(seconds: duration),
        ),
      child: Scaffold(
        appBar: AppBar(),
        body: Consumer<TestNotifier>(builder: (context, testNotifier, _) {
          if (testNotifier.state == TestState.ERROR) {
            return ErrorRetry(onTap: () {
              testNotifier.load(widget.id);
            });
          }

          if (testNotifier.state == TestState.LOADING) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          switch (testNotifier.test.testType) {
            case 'complex':
              return SingleChildScrollView(
                  child: Column(
                children: [
                  TestTitle(title: 'Тест сложный', duration: durationTimer),
                  TestCard(test: testNotifier.test),
                  ...testNotifier.test.complex
                      .map(
                        (t) => Column(
                          children: [
                            Divider(indent: 8.0, endIndent: 8.0),
                            Text(t.question,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF00B7FF),
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                )),
                            if (t.hasVideo)
                              Card(
                                margin: const EdgeInsets.all(16.0),
                                clipBehavior: Clip.antiAlias,
                                child: AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: BetterPlayerListVideoPlayer(
                                    BetterPlayerDataSource(BetterPlayerDataSourceType.NETWORK, t.video.data),
                                    configuration: BetterPlayerConfiguration(
                                      autoPlay: false,
                                      aspectRatio: 16 / 9,
                                      fit: BoxFit.cover,
                                    ),
                                    playFraction: 0.8,
                                    // betterPlayerListVideoPlayerController: videosController,
                                  ),

                                  // BetterPlayer.network(
                                  //   t.video.data,
                                  //   betterPlayerConfiguration: BetterPlayerConfiguration(
                                  //     aspectRatio: 16 / 9,
                                  //   ),
                                  // ),
                                ),
                              ),
                          ],
                        ),
                      )
                      .toList(),
                ],
              ));
            case 'simple':
            default:
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TestTitle(title: 'Тест простой', duration: durationTimer),
                    TestCard(test: testNotifier.test),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text('ВОПРОС',
                          style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(testNotifier.test.question,
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Color(0xFFA1A1A1),
                          )),
                    ),
                    Divider(indent: 8.0, endIndent: 8.0),
                    if (testNotifier.test.answerType == 'variants')
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ОТВЕТ', style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 16.0),
                            ...testNotifier.test.variants.buttons
                                .map((v) => InkWell(
                                      onTap: () {
                                        testNotifier.select(v.variant);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(4.0),
                                                color: Colors.white,
                                                border: Border.all(
                                                  color: testNotifier.selectedVarint == v.variant
                                                      ? Colors.lightBlue
                                                      : Color(0xFFE0E0E0),
                                                )),
                                            child: Row(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: testNotifier.selectedVarint == v.variant
                                                        ? Colors.lightBlue
                                                        : Colors.white,
                                                    border: Border(
                                                      right: BorderSide(
                                                        width: 1.0,
                                                        style: BorderStyle.solid,
                                                        color: testNotifier.selectedVarint == v.variant
                                                            ? Colors.lightBlue
                                                            : Color(0xFFE0E0E0),
                                                      ),
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Text(
                                                      v.variant,
                                                      style: TextStyle(
                                                        color: testNotifier.selectedVarint == v.variant
                                                            ? Colors.white
                                                            : Color(0xFFE0E0E0),
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text(v.title),
                                                ),
                                              ],
                                            )),
                                      ),
                                    ))
                                .toList(),
                          ],
                        ),
                      )
                    else if (testNotifier.test.answerType == 'text')
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          controller: controller,
                          decoration: InputDecoration(border: OutlineInputBorder()),
                          minLines: 5,
                          maxLines: 5,
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 16.0),
                      child: RaisedGradientButton(
                          child: Text('ВІДПОВІДЬ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          onPressed: testNotifier.selectedVarint != null || controller.text.isNotEmpty
                              ? () {
                                  testNotifier
                                      .postAnswer(
                                    testNotifier.test.id,
                                    testNotifier.selectedVarint ?? controller.text,
                                    durationTimer.value,
                                  )
                                      .then((_) {
                                    Navigator.of(context).pop(testNotifier.test);
                                  }).catchError((error) {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return CustomAlertDialog(
                                          content: CustomDialog(
                                            icon: Icons.close,
                                            color: Color(0xFFFF5B5E),
                                            text: Utils.getErrorText(error?.body?.toString() ?? 'unkown_error'),
                                          ),
                                        );
                                      },
                                    );
                                  });
                                }
                              : null),
                    ),
                  ],
                ),
              );
          }
        }),
      ),
    );
  }
}
