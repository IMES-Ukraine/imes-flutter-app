import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:imes/blocs/user_notifier.dart';
import 'package:imes/hooks/observable.dart';
import 'package:imes/models/user_basic_info.dart';
import 'package:imes/models/user_financial_info.dart';
import 'package:imes/models/user_schedule.dart';
import 'package:imes/models/user_special_info.dart';
import 'package:imes/widgets/account/account_user_info.dart';
import 'package:imes/widgets/account/accout_widget_options_mixin.dart';
import 'package:imes/widgets/base/loading_lock.dart';
import 'package:imes/widgets/base/raised_gradient_button.dart';
import 'package:imes/widgets/dialogs.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:observable/observable.dart';

class AccountEditPage extends HookWidget with AccountWidgetOptions {
  static final days = ['ПН', 'ВТ', 'СР', 'ЧТ', 'ПТ', 'СБ', 'НД'];

  final workingDaysInitial = {0: [], 1: [], 2: []};

  @override
  Widget build(BuildContext context) {
    final userNotifier = useProvider(userNotifierProvider);
    final step = useState(
      userNotifier.user.specializedInformation == null
          ? 0
          : userNotifier.user.financialInformation == null
              ? 1
              : 2,
    );

    final workingDays = userNotifier.user?.specializedInformation?.schedule?.isNotEmpty ?? false
        ? userNotifier.user.specializedInformation.schedule
            .map((e) => useValueNotifier(ObservableList.from(e.days)))
            .toList()
        : workingDaysInitial.entries.map((e) => useValueNotifier(ObservableList.from(e.value))).toList();
    final workingDaysControllers = userNotifier.user?.specializedInformation?.schedule?.isNotEmpty ?? false
        ? userNotifier.user.specializedInformation.schedule.map((e) => useTextEditingController(text: e.time)).toList()
        : workingDaysInitial.entries.map((e) => useTextEditingController()).toList();

    final nameController = useTextEditingController(text: userNotifier.user?.basicInformation?.name);
    final phoneController = useTextEditingController(text: userNotifier.user?.basicInformation?.phone);
    final postController = useTextEditingController(text: userNotifier.user?.basicInformation?.email);

    final specificationController =
        useTextEditingController(text: userNotifier.user?.specializedInformation?.specification);
    final qualificationController =
        useTextEditingController(text: userNotifier.user?.specializedInformation?.qualification);
    final workPlaceController = useTextEditingController(text: userNotifier.user?.specializedInformation?.workplace);
    final positionController = useTextEditingController(text: userNotifier.user?.specializedInformation?.position);
    final licenseController = useTextEditingController(text: userNotifier.user?.specializedInformation?.licenseNumber);
    final studyPeriodController =
        useTextEditingController(text: userNotifier.user?.specializedInformation?.studyPeriod);
    final additionalQualificationController =
        useTextEditingController(text: userNotifier.user?.specializedInformation?.additionalQualification);

    final cardNumberController = useTextEditingController(text: userNotifier.user?.financialInformation?.card);
    final cardExpController = useTextEditingController(text: userNotifier.user?.financialInformation?.exp);
    final cardCCVController = useTextEditingController(text: userNotifier.user?.financialInformation?.ccv);

    final isLoading = useState<bool>(false);

    return Scaffold(
      appBar: AppBar(
        title: Text('АКАУНТ', style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 16.0),
                AccountUserInfo(
                  nameController: nameController,
                  phoneController: phoneController,
                  postController: positionController,
                  onAvatarTap: () async {
                    var path = await showChoosePictureDialog(context);
                    isLoading.value = true;
                    userNotifier.uploadProfilePicture(path).catchError((error) {}).whenComplete(() {
                      isLoading.value = false;
                    });
                  },
                ),
                if (step.value == 0)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: RaisedGradientButton(
                      child: Text('ДАЛІ', style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white)),
                      onPressed: () {
                        step.value = 1;
                      },
                    ),
                  ),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  clipBehavior: Clip.antiAlias,
                  child: IgnorePointer(
                    ignoring: step.value == 0,
                    child: Container(
                      foregroundDecoration:
                          step.value == 0 ? BoxDecoration(color: Theme.of(context).canvasColor.withOpacity(0.8)) : null,
                      child: ExpansionTile(
                        title: Text('Спеціалізована інформація'.toUpperCase(),
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        initiallyExpanded: true,
                        childrenPadding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
                        expandedCrossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                              controller: specificationController,
                              decoration: inputDecoration('Спеціалізація'),
                              style: textStyleBold),
                          const SizedBox(height: 8.0),
                          Divider(),
                          TextField(
                              controller: qualificationController,
                              decoration: inputDecoration('Рівень кваліфікації'),
                              style: textStyleBold),
                          const SizedBox(height: 8.0),
                          Divider(),
                          TextField(
                              controller: workPlaceController,
                              decoration: inputDecoration('Місце роботи'),
                              style: textStyleBold),
                          const SizedBox(height: 8.0),
                          Divider(),
                          Text('Графік роботи', style: TextStyle(fontSize: 12.0, color: Color(0xFFA1A1A1))),
                          const SizedBox(height: 8.0),
                          Column(
                            children: List.generate(3, (index) {
                              useObservable(workingDays[index]);
                              return Row(
                                children: [
                                  for (var i = 0; i < days.length; i++)
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            if (workingDays[index].value.contains(i)) {
                                              workingDays[index].value.removeWhere((element) => element == i);
                                            } else {
                                              workingDays[index].value.add(i);
                                            }
                                          },
                                          child: Text('${days[i]}${i != days.length - 1 ? ', ' : ':'}',
                                              style: TextStyle(
                                                  color: workingDays[index].value.contains(i)
                                                      ? Colors.black
                                                      : Color(0xFFBDBDBD))),
                                        ),
                                      ],
                                    ),
                                  Expanded(
                                    child: TextField(
                                        controller: workingDaysControllers[index],
                                        decoration: InputDecoration(isDense: true, contentPadding: EdgeInsets.zero),
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          MaskTextInputFormatter(mask: '##:## - ##:##', filter: {'#': RegExp(r'[0-9]')})
                                        ],
                                        style: textStyleBold),
                                  ),
                                ],
                              );
                            }),
                          ),
                          const SizedBox(height: 8.0),
                          Divider(),
                          TextField(
                              controller: positionController,
                              decoration: inputDecoration('Посада'),
                              style: textStyleBold),
                          const SizedBox(height: 8.0),
                          Divider(),
                          TextField(
                              controller: licenseController,
                              decoration: inputDecoration('Номер ліцензії лікаря'),
                              style: textStyleBold),
                          const SizedBox(height: 8.0),
                          Divider(),
                          Text('Документ про освіту', style: TextStyle(fontSize: 12.0, color: Color(0xFFA1A1A1))),
                          const SizedBox(height: 8.0),
                          InkWell(
                            onTap: () async {
                              final result = await FilePicker.platform.pickFiles();
                              if (result != null) {
                                isLoading.value = true;
                                userNotifier
                                    .uploadEducationDocument(result.files.single.path)
                                    .catchError((error) => showErrorDialog(context, error))
                                    .whenComplete(() {
                                  isLoading.value = false;
                                });
                              }
                            },
                            child: Row(
                              children: [
                                Icon(Icons.file_upload, color: Theme.of(context).primaryColor, size: 20.0),
                                const SizedBox(width: 8.0),
                                Text(
                                    userNotifier.user?.specializedInformation?.educationDocument?.fileName ??
                                        'Разместить',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 12.0)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Divider(),
                          TextField(
                            controller: studyPeriodController,
                            decoration: InputDecoration(
                              isDense: true,
                              labelText: 'Дата (період) навчання',
                              hintText: '__.__.____ - __.__.____',
                              labelStyle: TextStyle(fontSize: 12.0),
                              contentPadding: EdgeInsets.zero,
                              border: InputBorder.none,
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              MaskTextInputFormatter(mask: '##.##.#### - ##.##.####', filter: {'#': RegExp(r'[0-9]')})
                            ],
                            style: textStyleBold,
                          ),
                          const SizedBox(height: 8.0),
                          Divider(),
                          TextField(
                              controller: additionalQualificationController,
                              decoration: inputDecoration('Додаткова кваліфікація'),
                              style: textStyleBold),
                          const SizedBox(height: 16.0),
                        ],
                      ),
                    ),
                  ),
                ),
                if (step.value == 1)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: RaisedGradientButton(
                      child: Text('ДАЛІ', style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white)),
                      onPressed: () {
                        step.value = 2;
                      },
                    ),
                  ),
                Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                    clipBehavior: Clip.antiAlias,
                    child: IgnorePointer(
                      ignoring: step.value == 1,
                      child: Container(
                        foregroundDecoration: step.value == 1
                            ? BoxDecoration(color: Theme.of(context).canvasColor.withOpacity(0.8))
                            : null,
                        child: ExpansionTile(
                          title:
                              Text('Фінансова інформація'.toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold)),
                          initiallyExpanded: true,
                          childrenPadding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
                          expandedCrossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Divider(),
                            TextField(
                                controller: cardNumberController,
                                decoration: inputDecoration('Номер картки'),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  MaskTextInputFormatter(mask: '#### #### #### ####', filter: {'#': RegExp(r'[0-9]')})
                                ],
                                style: textStyleBold),
                            const SizedBox(height: 8.0),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                      controller: cardExpController,
                                      decoration: inputDecoration('Дата'),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        MaskTextInputFormatter(mask: '## / ##', filter: {'#': RegExp(r'[0-9]')})
                                      ],
                                      style: textStyleBold),
                                ),
                                const SizedBox(width: 200.0),
                                Expanded(
                                  child: TextField(
                                      controller: cardCCVController,
                                      decoration: inputDecoration('CVV'),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        MaskTextInputFormatter(mask: '###', filter: {'#': RegExp(r'[0-9]')})
                                      ],
                                      style: textStyleBold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16.0),
                          ],
                        ),
                      ),
                    )),
                if (step.value == 2)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: RaisedGradientButton(
                      child: Text('ЗАВЕРШИТИ', style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white)),
                      onPressed: () {
                        final userBasicInfo = UserBasicInfo(
                            name: nameController.text, email: postController.text, phone: phoneController.text);
                        final specializedInfo = UserSpecializedInfo(
                          specification: specificationController.text,
                          qualification: qualificationController.text,
                          workplace: workPlaceController.text,
                          position: positionController.text,
                          licenseNumber: licenseController.text,
                          studyPeriod: studyPeriodController.text,
                          additionalQualification: additionalQualificationController.text,
                          schedule: List.generate(
                            7,
                            (i) =>
                                UserSchedule(days: workingDays[i].value.toList(), time: workingDaysControllers[i].text),
                          ),
                        );
                        final financialInfo = UserFinancialInfo(
                            card: cardNumberController.text, exp: cardExpController.text, ccv: cardCCVController.text);

                        isLoading.value = true;
                        userNotifier
                            .submitProfile(userBasicInfo, specializedInfo, financialInfo)
                            .then((_) => Navigator.of(context).pop())
                            .catchError((error) => showErrorDialog(context, error))
                            .whenComplete(() {
                          isLoading.value = false;
                        });
                      },
                    ),
                  ),
              ],
            ),
          ),
          if (isLoading.value) LoadingLock(),
        ],
      ),
    );
  }
}
