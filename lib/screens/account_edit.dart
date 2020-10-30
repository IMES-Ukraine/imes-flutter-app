import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:imes/blocs/user_notifier.dart';
import 'package:imes/helpers/utils.dart';
import 'package:imes/hooks/observable.dart';
import 'package:imes/widgets/base/custom_alert_dialog.dart';
import 'package:imes/widgets/base/custom_dialog.dart';
import 'package:imes/widgets/base/octo_circle_avatar.dart';
import 'package:imes/widgets/base/raised_gradient_button.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:observable/observable.dart';
import 'package:provider/provider.dart';

class AccountEditPage extends HookWidget {
  static final days = ['ПН', 'ВТ', 'СР', 'ЧТ', 'ПТ', 'СБ', 'НД'];
  final workingDaysInitial = {0: [], 1: [], 2: []};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('АКАУНТ', style: TextStyle(fontWeight: FontWeight.w800)),
        ),
        body: Consumer<UserNotifier>(builder: (context, userNotifier, _) {
          return HookBuilder(builder: (context) {
            final step = useState(
              userNotifier.user.specialInfo == null
                  ? 0
                  : userNotifier.user.financialInfo == null
                      ? 1
                      : 2,
            );

            final workingDays = userNotifier.user?.specialInfo?.schedule?.isNotEmpty ?? false
                ? userNotifier.user.specialInfo.schedule
                    .map((e) => useValueNotifier(ObservableList.from(e.days)))
                    .toList()
                : workingDaysInitial.entries.map((e) => useValueNotifier(ObservableList.from(e.value))).toList();
            final workingDaysControllers = userNotifier.user?.specialInfo?.schedule?.isNotEmpty ?? false
                ? userNotifier.user.specialInfo.schedule.map((e) => useTextEditingController(text: e.time)).toList()
                : workingDaysInitial.entries.map((e) => useTextEditingController()).toList();

            final nameController = useTextEditingController(text: userNotifier.user?.basicInfo?.name);
            final phoneController = useTextEditingController(text: userNotifier.user?.basicInfo?.phone);
            final postController = useTextEditingController(text: userNotifier.user?.basicInfo?.email);

            final specificationController =
                useTextEditingController(text: userNotifier.user?.specialInfo?.specification);
            final qualificationController =
                useTextEditingController(text: userNotifier.user?.specialInfo?.qualification);
            final workPlaceController = useTextEditingController(text: userNotifier.user?.specialInfo?.workplace);
            final positionController = useTextEditingController(text: userNotifier.user?.specialInfo?.position);
            final licenseController = useTextEditingController(text: userNotifier.user?.specialInfo?.licenseNumber);
            final studyPeriodController = useTextEditingController(text: userNotifier.user?.specialInfo?.studyPeriod);
            final additionalQualificationController =
                useTextEditingController(text: userNotifier.user?.specialInfo?.additionalQualification);

            final cardNumberController = useTextEditingController(text: userNotifier.user?.financialInfo?.card);
            final cardExpController = useTextEditingController(text: userNotifier.user?.financialInfo?.exp);
            final cardCCVController = useTextEditingController(text: userNotifier.user?.financialInfo?.ccv);
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16.0),
                  Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                      child: Row(children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: OctoCircleAvatar(
                            url: userNotifier.user?.basicInfo?.avatar?.path,
                          ),
                        ),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            TextField(
                              controller: nameController,
                              decoration: InputDecoration(
                                isDense: true,
                                hintText: 'Ім\’я Прізвище',
                                hintStyle: TextStyle(fontSize: 12.0),
                                contentPadding: EdgeInsets.zero,
                              ),
                              style: TextStyle(fontSize: 12.0),
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              children: [
                                Icon(Icons.phone, color: Theme.of(context).primaryColor, size: 16.0),
                                const SizedBox(width: 4.0),
                                Expanded(
                                  child: TextField(
                                    controller: phoneController,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      hintText: 'Телефон',
                                      hintStyle: TextStyle(fontSize: 12.0),
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4.0),
                            Row(
                              children: [
                                Icon(Icons.mail_outline, color: Theme.of(context).primaryColor, size: 16.0),
                                const SizedBox(width: 4.0),
                                Expanded(
                                  child: TextField(
                                    controller: postController,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      hintText: 'Пошта',
                                      hintStyle: TextStyle(fontSize: 12.0),
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          ]),
                        )),
                      ])),
                  if (step.value == 0)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: RaisedGradientButton(
                        child: Text(
                          'ДАЛІ',
                          style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white),
                        ),
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
                        foregroundDecoration: step.value == 0
                            ? BoxDecoration(color: Theme.of(context).canvasColor.withOpacity(0.8))
                            : null,
                        child: ExpansionTile(
                          title: Text('Спеціалізована інформація'.toUpperCase(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              )),
                          initiallyExpanded: true,
                          childrenPadding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
                          expandedCrossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: specificationController,
                              decoration: InputDecoration(
                                isDense: true,
                                labelText: 'Спеціалізація',
                                labelStyle: TextStyle(fontSize: 12.0),
                                contentPadding: EdgeInsets.zero,
                              ),
                              style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 8.0),
                            Divider(),
                            TextField(
                              controller: qualificationController,
                              decoration: InputDecoration(
                                isDense: true,
                                labelText: 'Рівень кваліфікації',
                                labelStyle: TextStyle(fontSize: 12.0),
                                contentPadding: EdgeInsets.zero,
                              ),
                              style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 8.0),
                            Divider(),
                            TextField(
                              controller: workPlaceController,
                              decoration: InputDecoration(
                                isDense: true,
                                labelText: 'Місце роботи',
                                labelStyle: TextStyle(fontSize: 12.0),
                                contentPadding: EdgeInsets.zero,
                              ),
                              style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 8.0),
                            Divider(),
                            Text('Графік роботи', style: TextStyle(fontSize: 12.0, color: Color(0xFFA1A1A1))),
                            const SizedBox(height: 8.0),
                            HookBuilder(builder: (context) {
                              return Column(
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
                                          decoration: InputDecoration(
                                            isDense: true,
                                            // labelText: 'Місце роботи',
                                            // labelStyle: TextStyle(fontSize: 12.0),
                                            contentPadding: EdgeInsets.zero,
                                          ),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            MaskTextInputFormatter(
                                                mask: '##:## - ##:##', filter: {'#': RegExp(r'[0-9]')})
                                          ],
                                          style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                              );
                            }),
                            const SizedBox(height: 8.0),
                            Divider(),
                            TextField(
                              controller: positionController,
                              decoration: InputDecoration(
                                isDense: true,
                                labelText: 'Посада',
                                labelStyle: TextStyle(fontSize: 12.0),
                                contentPadding: EdgeInsets.zero,
                              ),
                              style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 8.0),
                            Divider(),
                            TextField(
                              controller: licenseController,
                              decoration: InputDecoration(
                                isDense: true,
                                labelText: 'Номер ліцензії лікаря',
                                labelStyle: TextStyle(fontSize: 12.0),
                                contentPadding: EdgeInsets.zero,
                              ),
                              style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 8.0),
                            Divider(),
                            Text('Документ про освіту', style: TextStyle(fontSize: 12.0, color: Color(0xFFA1A1A1))),
                            const SizedBox(height: 8.0),
                            InkWell(
                              onTap: () {},
                              child: Row(
                                children: [
                                  Icon(Icons.file_upload, color: Theme.of(context).primaryColor, size: 20.0),
                                  const SizedBox(width: 8.0),
                                  Text(userNotifier.user?.specialInfo?.educationDocument?.fileName ?? 'Разместить',
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
                              style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 8.0),
                            Divider(),
                            TextField(
                              controller: additionalQualificationController,
                              decoration: InputDecoration(
                                isDense: true,
                                labelText: 'Додаткова кваліфікація',
                                labelStyle: TextStyle(fontSize: 12.0),
                                contentPadding: EdgeInsets.zero,
                              ),
                              style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600),
                            ),
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
                        child: Text(
                          'ДАЛІ',
                          style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white),
                        ),
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
                            title: Text('Фінансова інформація'.toUpperCase(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                            initiallyExpanded: true,
                            childrenPadding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
                            expandedCrossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Divider(),
                              TextField(
                                controller: cardNumberController,
                                decoration: InputDecoration(
                                  isDense: true,
                                  labelText: 'Номер картки',
                                  labelStyle: TextStyle(fontSize: 12.0),
                                  contentPadding: EdgeInsets.zero,
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  MaskTextInputFormatter(mask: '#### #### #### ####', filter: {'#': RegExp(r'[0-9]')})
                                ],
                                style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 8.0),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: cardExpController,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        labelText: 'Дата',
                                        labelStyle: TextStyle(fontSize: 12.0),
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        MaskTextInputFormatter(mask: '## / ##', filter: {'#': RegExp(r'[0-9]')})
                                      ],
                                      style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  const SizedBox(width: 200.0),
                                  Expanded(
                                    child: TextField(
                                      controller: cardCCVController,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        labelText: 'CVV',
                                        labelStyle: TextStyle(fontSize: 12.0),
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        MaskTextInputFormatter(mask: '###', filter: {'#': RegExp(r'[0-9]')})
                                      ],
                                      style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600),
                                    ),
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
                        child: Text(
                          'ЗАВЕРШИТИ',
                          style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white),
                        ),
                        onPressed: () {
                          final result = Map<String, dynamic>();
                          result['basic_information'] = {
                            'name': nameController.text,
                            'email': postController.text,
                            'phone': phoneController.text,
                          };

                          final resultSchedule = [];
                          for (var i = 0; i < workingDaysControllers.length; i++) {
                            resultSchedule.add({'days': workingDays[i].value, 'time': workingDaysControllers[i].text});
                          }

                          result['specialized_information'] = {
                            'specification': specificationController.text,
                            'qualification': qualificationController.text,
                            'workplace': workPlaceController.text,
                            'position': positionController.text,
                            'licenseNumber': licenseController.text,
                            'studyPeriod': studyPeriodController.text,
                            'additionalQualification': additionalQualificationController.text,
                            'schedule': resultSchedule,
                          };

                          result['financial_information'] = {
                            'card': cardNumberController.text,
                            'exp': cardExpController.text,
                            'ccv': cardCCVController.text,
                          };

                          userNotifier
                              .submitProfile(result)
                              .then((value) => Navigator.of(context).pop())
                              .catchError((error) {
                            print(error);
                            showDialog(
                              context: context,
                              builder: (context) {
                                return CustomAlertDialog(
                                  content: CustomDialog(
                                    icon: Icons.close,
                                    color: Theme.of(context).errorColor,
                                    text: Utils.getErrorText(error?.body?.toString() ?? 'unkown_error'),
                                  ),
                                );
                              },
                            );
                          });
                        },
                      ),
                    ),
                ],
              ),
            );
          });
        }));
  }
}
