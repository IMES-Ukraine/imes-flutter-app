import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imes/blocs/user_notifier.dart';
import 'package:imes/helpers/utils.dart';
import 'package:imes/hooks/observable.dart';
import 'package:imes/resources/resources.dart';
import 'package:imes/utils/file_utils.dart';
import 'package:imes/widgets/base/custom_alert_dialog.dart';
import 'package:imes/widgets/base/custom_dialog.dart';
import 'package:imes/widgets/base/loading_lock.dart';
import 'package:imes/widgets/base/octo_circle_avatar.dart';
import 'package:imes/widgets/base/raised_gradient_button.dart';
import 'package:imes/widgets/dialogs/dialogs.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:observable/observable.dart';
import 'package:provider/provider.dart' show Consumer;
import 'package:hooks_riverpod/hooks_riverpod.dart' hide Consumer;

import 'package:sizer/sizer.dart';

final citiesProvider = FutureProvider<List<String>>((ref) async {
  final cities = await ref.watch(citiesAndHospitalsProvider.future);
  return cities.map((c) => c.name).toList();
});

final hospitalsProvider = FutureProvider<List<String>>((ref) async {
  final hospitals = await ref.watch(citiesAndHospitalsProvider.future);
  return hospitals.firstWhere((c) => c.name == ref.watch(cityProvider).state).items.map((c) => c.name).toList();
});

final cityProvider = StateProvider<String>((ref) => null);
final hospitalProvider = StateProvider<String>((ref) => null);
final doctorProvider = StateProvider<String>((ref) => null);

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
                ? userNotifier.user.specializedInformation.schedule
                    .map((e) => useTextEditingController(text: e.time))
                    .toList()
                : workingDaysInitial.entries.map((e) => useTextEditingController()).toList();

            final nameController = useTextEditingController(text: userNotifier.user?.basicInformation?.name);
            final phoneController = useTextEditingController(text: userNotifier.user?.basicInformation?.phone);
            final postController = useTextEditingController(text: userNotifier.user?.basicInformation?.email);

            final specificationController =
                useTextEditingController(text: userNotifier.user?.specializedInformation?.specification);
            final qualificationController =
                useTextEditingController(text: userNotifier.user?.specializedInformation?.qualification);
            final licenseController =
                useTextEditingController(text: userNotifier.user?.specializedInformation?.licenseNumber);
            final additionalQualificationController =
                useTextEditingController(text: userNotifier.user?.specializedInformation?.additionalQualification);

            final cardNumberController = useTextEditingController(text: userNotifier.user?.financialInformation?.card);

            final city = useProvider(cityProvider);
            final hospital = useProvider(hospitalProvider);

            final cityItems = useProvider(citiesProvider.future);
            final hospitalItems = useProvider(hospitalsProvider.future);

            final cityController = useTextEditingController(text: userNotifier.user?.specializedInformation?.city);
            final hospitalController =
                useTextEditingController(text: userNotifier.user?.specializedInformation?.workplace);

            final doctor = useProvider(doctorProvider);
            final doctorItems = useProvider(doctorsProvider.future);
            final positionController =
                useTextEditingController(text: userNotifier.user?.specializedInformation?.position);

            final isLoading = useState<bool>(false);
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 2.0.h),
                      Card(
                          margin: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 1.0.h),
                          child: Row(children: [
                            InkResponse(
                              onTap: () async {
                                var path = await showCameraGalleryChooseDialog(context);
                                ;
                                isLoading.value = true;
                                userNotifier.uploadProfilePicture(path).then((_) {
                                  print(userNotifier.user.basicInformation);
                                  isLoading.value = false;
                                }).catchError((error) {
                                  isLoading.value = false;
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
                              child: Padding(
                                padding: EdgeInsets.all(2.0.h),
                                child: OctoCircleAvatar(
                                  url: userNotifier.user?.basicInformation?.avatar?.path ?? '',
                                ),
                              ),
                            ),
                            Expanded(
                                child: Padding(
                              padding: EdgeInsets.only(right: 4.0.w),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                TextField(
                                  controller: nameController,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    hintText: 'Ім\’я Прізвище',
                                    hintStyle: TextStyle(fontSize: 10.0.sp),
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  style: TextStyle(fontSize: 10.0.sp),
                                ),
                                SizedBox(height: 1.0.h),
                                Row(
                                  children: [
                                    Icon(Icons.phone, color: Theme.of(context).primaryColor, size: 2.0.h),
                                    SizedBox(width: 1.0.w),
                                    Expanded(
                                      child: TextField(
                                        controller: phoneController,
                                        decoration: InputDecoration(
                                          isDense: true,
                                          hintText: 'Телефон',
                                          hintStyle: TextStyle(fontSize: 10.0.sp),
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                        style: TextStyle(fontSize: 10.0.sp, fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4.0),
                                Row(
                                  children: [
                                    Icon(Icons.mail_outline, color: Theme.of(context).primaryColor, size: 2.0.h),
                                    SizedBox(width: 1.0.w),
                                    Expanded(
                                      child: TextField(
                                        controller: postController,
                                        decoration: InputDecoration(
                                          isDense: true,
                                          hintText: 'Пошта',
                                          hintStyle: TextStyle(fontSize: 10.0.sp),
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                        style: TextStyle(fontSize: 10.0.sp, fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ],
                                ),
                              ]),
                            )),
                          ])),
                      if (step.value == 0)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 1.0.h),
                          child: RaisedGradientButton(
                            child: Text('ДАЛІ', style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white)),
                            onPressed: () {
                              step.value = 1;
                            },
                          ),
                        ),
                      Card(
                        margin: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 1.0.h),
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
                              childrenPadding: EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 1.0.h),
                              expandedCrossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TypeAheadField(
                                  textFieldConfiguration: TextFieldConfiguration(
                                    autofocus: true,
                                    controller: cityController,
                                    style: TextStyle(fontSize: 10.0.sp, fontWeight: FontWeight.w600),
                                    decoration: InputDecoration(
                                        isDense: true,
                                        border: UnderlineInputBorder(),
                                        contentPadding: EdgeInsets.zero,
                                        labelText: 'Місто',
                                        labelStyle: TextStyle(fontSize: 10.0.sp)),
                                  ),
                                  suggestionsCallback: (pattern) async {
                                    final items = await cityItems;
                                    return items.where((c) => c.contains(pattern)).toList();
                                  },
                                  itemBuilder: (context, suggestion) {
                                    return Padding(
                                      padding: EdgeInsets.all(2.0.w),
                                      child: Text(suggestion, style: TextStyle(fontSize: 10.0.sp)),
                                    );
                                  },
                                  onSuggestionSelected: (suggestion) {
                                    city.state = suggestion;
                                    cityController.text = suggestion;
                                  },
                                ),
                                SizedBox(height: 1.0.h),
                                Divider(),
                                TypeAheadField(
                                  textFieldConfiguration: TextFieldConfiguration(
                                    autofocus: true,
                                    controller: hospitalController,
                                    style: TextStyle(fontSize: 10.0.sp, fontWeight: FontWeight.w600),
                                    decoration: InputDecoration(
                                        isDense: true,
                                        border: UnderlineInputBorder(),
                                        contentPadding: EdgeInsets.zero,
                                        labelText: 'Місце роботи',
                                        labelStyle: TextStyle(fontSize: 10.0.sp)),
                                  ),
                                  suggestionsCallback: (pattern) async {
                                    final items = await hospitalItems;
                                    return items.where((c) => c.contains(pattern)).toList();
                                  },
                                  itemBuilder: (context, suggestion) {
                                    return Padding(
                                      padding: EdgeInsets.all(2.0.w),
                                      child: Text(suggestion, style: TextStyle(fontSize: 10.0.sp)),
                                    );
                                  },
                                  onSuggestionSelected: (suggestion) {
                                    hospital.state = suggestion;
                                    hospitalController.text = suggestion;
                                  },
                                ),
                                SizedBox(height: 1.0.h),
                                Divider(),
                                TypeAheadField(
                                  textFieldConfiguration: TextFieldConfiguration(
                                    autofocus: true,
                                    controller: specificationController,
                                    style: TextStyle(fontSize: 10.0.sp, fontWeight: FontWeight.w600),
                                    decoration: InputDecoration(
                                        isDense: true,
                                        border: UnderlineInputBorder(),
                                        contentPadding: EdgeInsets.zero,
                                        labelText: 'Спеціалізація',
                                        labelStyle: TextStyle(fontSize: 10.0.sp)),
                                  ),
                                  suggestionsCallback: (pattern) async {
                                    final items = await doctorItems;
                                    return items.where((c) => c.contains(pattern)).toList();
                                  },
                                  itemBuilder: (context, suggestion) {
                                    return Padding(
                                      padding: EdgeInsets.all(2.0.w),
                                      child: Text(suggestion, style: TextStyle(fontSize: 10.0.sp)),
                                    );
                                  },
                                  onSuggestionSelected: (suggestion) {
                                    doctor.state = suggestion;
                                    specificationController.text = suggestion;
                                  },
                                ),
                                SizedBox(height: 1.0.h),
                                Divider(),
                                TextField(
                                  controller: qualificationController,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    labelText: 'Рівень кваліфікації',
                                    labelStyle: TextStyle(fontSize: 10.0.sp),
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  style: TextStyle(fontSize: 10.0.sp, fontWeight: FontWeight.w600),
                                ),
                                SizedBox(height: 1.0.h),
                                Divider(),
                                Text('Графік роботи', style: TextStyle(fontSize: 10.0.sp, color: Color(0xFFA1A1A1))),
                                SizedBox(height: 1.0.h),
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
                                                          fontSize: 10.0.sp,
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
                                                contentPadding: EdgeInsets.zero,
                                              ),
                                              keyboardType: TextInputType.number,
                                              inputFormatters: [
                                                MaskTextInputFormatter(
                                                    mask: '##:## - ##:##', filter: {'#': RegExp(r'[0-9]')})
                                              ],
                                              style: TextStyle(fontSize: 10.0.sp, fontWeight: FontWeight.w600),
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
                                    labelStyle: TextStyle(fontSize: 10.0.sp),
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  style: TextStyle(fontSize: 10.0.sp, fontWeight: FontWeight.w600),
                                ),
                                SizedBox(height: 1.0.h),
                                Divider(),
                                TextField(
                                  controller: licenseController,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    labelText: 'Номер ліцензії лікаря',
                                    labelStyle: TextStyle(fontSize: 10.0.sp),
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  style: TextStyle(fontSize: 10.0.sp, fontWeight: FontWeight.w600),
                                ),
                                SizedBox(height: 1.0.h),
                                Divider(),
                                Text('Документ про освіту',
                                    style: TextStyle(fontSize: 10.0.sp, color: Color(0xFFA1A1A1))),
                                SizedBox(height: 1.0.h),
                                InkWell(
                                  onTap: () async {
                                    final result = await ImagePicker()
                                        .getImage(source: ImageSource.gallery, maxWidth: 1080, maxHeight: 1920);
                                    if (result != null) {
                                      isLoading.value = true;
                                      final resultFile = await FileUtils.renameBaseFile(result.path, 'edu_doc');
                                      userNotifier.uploadEducationDocument(resultFile.path).then((_) {
                                        isLoading.value = false;
                                      }).catchError((error) {
                                        isLoading.value = false;
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
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      Icon(Icons.file_upload, color: Theme.of(context).primaryColor, size: 3.0.h),
                                      SizedBox(width: 1.0.h),
                                      Expanded(
                                        child: Text(
                                            userNotifier.user?.specializedInformation?.educationDocument?.fileName ??
                                                'Завантажити',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context).primaryColor,
                                                fontSize: 10.0.sp)),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 1.0.h),
                                Divider(),
                                Text('Паспорт громадянини України',
                                    style: TextStyle(fontSize: 10.0.sp, color: Color(0xFFA1A1A1))),
                                SizedBox(height: 1.0.h),
                                InkWell(
                                  onTap: () async {
                                    final result = await ImagePicker()
                                        .getImage(source: ImageSource.gallery, maxWidth: 1080, maxHeight: 1920);
                                    if (result != null) {
                                      isLoading.value = true;
                                      final resultFile = await FileUtils.renameBaseFile(result.path, 'passport');
                                      userNotifier.uploadPassport(resultFile.path).then((_) {
                                        isLoading.value = false;
                                      }).catchError((error) {
                                        isLoading.value = false;
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
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      Icon(Icons.file_upload, color: Theme.of(context).primaryColor, size: 3.0.h),
                                      SizedBox(width: 1.0.h),
                                      Expanded(
                                        child: Text(
                                            userNotifier.user?.specializedInformation?.passport?.fileName ??
                                                'Завантажити',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context).primaryColor,
                                                fontSize: 10.0.sp)),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 1.0.h),
                                Divider(),
                                Text('ІПН',
                                    style: TextStyle(fontSize: 10.0.sp, color: Color(0xFFA1A1A1))),
                                SizedBox(height: 1.0.h),
                                InkWell(
                                  onTap: () async {
                                    final result = await ImagePicker()
                                        .getImage(source: ImageSource.gallery, maxWidth: 1080, maxHeight: 1920);
                                    if (result != null) {
                                      isLoading.value = true;
                                      final resultFile = await FileUtils.renameBaseFile(result.path, 'mic');
                                      userNotifier.uploadMicId(resultFile.path).then((_) {
                                        isLoading.value = false;
                                      }).catchError((error) {
                                        isLoading.value = false;
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
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      Icon(Icons.file_upload, color: Theme.of(context).primaryColor, size: 3.0.h),
                                      SizedBox(width: 1.0.h),
                                      Expanded(
                                        child: Text(
                                            userNotifier.user?.specializedInformation?.micId?.fileName ??
                                                'Завантажити',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context).primaryColor,
                                                fontSize: 10.0.sp)),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 1.0.h),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (step.value == 1)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 1.0.h),
                          child: RaisedGradientButton(
                            child: Text('ДАЛІ', style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white)),
                            onPressed: () {
                              step.value = 2;
                            },
                          ),
                        ),
                      Card(
                          margin: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 1.0.h),
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
                                childrenPadding: EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 1.0.h),
                                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Divider(),
                                  TextField(
                                    controller: cardNumberController,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      labelText: 'Номер картки',
                                      labelStyle: TextStyle(fontSize: 10.0.sp),
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      MaskTextInputFormatter(
                                          mask: '#### #### #### ####', filter: {'#': RegExp(r'[0-9]')})
                                    ],
                                    style: TextStyle(fontSize: 10.0.sp, fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(height: 2.0.h),
                                ],
                              ),
                            ),
                          )),
                      if (step.value == 2)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 1.0.h),
                          child: RaisedGradientButton(
                            child:
                                Text('ЗАВЕРШИТИ', style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white)),
                            onPressed: () {
                              final result = <String, dynamic>{};
                              result['basic_information'] = {
                                'name': nameController.text,
                                'email': postController.text,
                                'phone': phoneController.text,
                              };

                              final resultSchedule = [];
                              for (var i = 0; i < workingDaysControllers.length; i++) {
                                resultSchedule
                                    .add({'days': workingDays[i].value, 'time': workingDaysControllers[i].text});
                              }

                              result['specialized_information'] = {
                                'city': cityController.text,
                                'specification': specificationController.text,
                                'qualification': qualificationController.text,
                                'workplace': hospitalController.text,
                                'position': positionController.text,
                                'license_number': licenseController.text,
                                'additional_qualification': additionalQualificationController.text,
                                'schedule': resultSchedule,
                              };

                              result['financial_information'] = {'card': cardNumberController.text};

                              isLoading.value = true;
                              userNotifier.submitProfile(result).then((value) {
                                isLoading.value = false;
                                Navigator.of(context).pop();
                              }).catchError((error) {
                                isLoading.value = false;
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
                ),
                if (isLoading.value) LoadingLock(),
              ],
            );
          });
        }));
  }
}
