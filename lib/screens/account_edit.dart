import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imes/blocs/user_notifier.dart';
import 'package:imes/resources/local_data.dart';
import 'package:imes/utils/file_utils.dart';
import 'package:imes/widgets/account/documents_container.dart';
import 'package:imes/widgets/account/text_field.dart';
import 'package:imes/widgets/base/loading_lock.dart';
import 'package:imes/widgets/base/octo_circle_avatar.dart';
import 'package:imes/widgets/base/raised_gradient_button.dart';
import 'package:imes/widgets/dialogs/dialogs.dart';
import 'package:provider/provider.dart' show Consumer;
import 'package:hooks_riverpod/hooks_riverpod.dart' hide Consumer;

import 'package:sizer/sizer.dart';
import 'package:validators/sanitizers.dart';
import 'package:validators/validators.dart';

final citiesProvider = FutureProvider<List<String>>((ref) async {
  final cities = await ref.watch(citiesAndHospitalsProvider.future);
  return cities.map((c) => c.name).toList();
});

final hospitalsProvider = FutureProvider<List<String>>((ref) async {
  final hospitals = await ref.watch(citiesAndHospitalsProvider.future);
  final selectedCity = ref.watch(cityProvider).state;
  if (selectedCity != null && selectedCity.isNotEmpty) {
    return hospitals.firstWhere((c) => c.name == selectedCity).items.map((c) => c.name).toList();
  } else {
    final allHospitals = <String>[];
    hospitals.forEach((e) => allHospitals.addAll(e.items.map((e) => e.name)));
    return allHospitals;
  }
});

final cityProvider = StateProvider<String>((ref) => null);
final hospitalProvider = StateProvider<String>((ref) => null);
final doctorProvider = StateProvider<String>((ref) => null);

class AccountEditPage extends HookWidget {
  final workingDaysInitial = {0: [], 1: [], 2: []};

  final _basicInfoFormKey = GlobalKey<FormState>();
  final _specialInfoFormKey = GlobalKey<FormState>();

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
                                isLoading.value = true;
                                userNotifier.uploadProfilePicture(path).then((_) {
                                  print(userNotifier.user.basicInformation);
                                  isLoading.value = false;
                                }).catchError((error) {
                                  isLoading.value = false;
                                  showErrorDialog(context, error);
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.all(2.0.h),
                                child: OctoCircleAvatar(
                                  url: userNotifier.user?.basicInformation?.avatar?.path ?? '',
                                ),
                              ),
                            ),
                            Form(
                              key: _basicInfoFormKey,
                              child: Expanded(
                                  child: Padding(
                                padding: EdgeInsets.only(right: 4.0.w),
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  TextFormField(
                                    controller: nameController,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      hintText: 'Ім\’я Прізвище',
                                      hintStyle: TextStyle(fontSize: 10.0.sp),
                                      errorStyle: TextStyle(height: 0),
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    style: TextStyle(fontSize: 10.0.sp),
                                    validator: (v) => isNull(trim(v)) ? '' : null,
                                  ),
                                  SizedBox(height: 1.0.h),
                                  Row(
                                    children: [
                                      Icon(Icons.phone, color: Theme.of(context).primaryColor, size: 2.0.h),
                                      SizedBox(width: 1.0.w),
                                      Expanded(
                                        child: TextFormField(
                                          controller: phoneController,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            hintText: 'Телефон',
                                            hintStyle: TextStyle(fontSize: 10.0.sp),
                                            errorStyle: TextStyle(height: 0),
                                            contentPadding: EdgeInsets.zero,
                                          ),
                                          keyboardType: TextInputType.phone,
                                          style: TextStyle(fontSize: 10.0.sp, fontWeight: FontWeight.w600),
                                          validator: (v) => isNumeric(trim(v)) ? null : '',
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
                                        child: TextFormField(
                                          controller: postController,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            hintText: 'Пошта',
                                            hintStyle: TextStyle(fontSize: 10.0.sp),
                                            errorStyle: TextStyle(height: 0),
                                            contentPadding: EdgeInsets.zero,
                                          ),
                                          style: TextStyle(fontSize: 10.0.sp, fontWeight: FontWeight.w600),
                                          validator: (v) => isEmail(trim(v)) ? null : '',
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
                              )),
                            ),
                          ])),
                      if (step.value == 0)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 1.0.h),
                          child: RaisedGradientButton(
                            child: Text('ДАЛІ', style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white)),
                            onPressed: () {
                              if (_basicInfoFormKey.currentState.validate()) {
                                step.value = 1;
                              }
                            },
                          ),
                        ),
                      Form(
                        key: _specialInfoFormKey,
                        child: Card(
                          margin: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 1.0.h),
                          clipBehavior: Clip.antiAlias,
                          child: IgnorePointer(
                            ignoring: step.value == 0,
                            child: Container(
                              foregroundDecoration: step.value == 0
                                  ? BoxDecoration(color: Theme.of(context).canvasColor.withOpacity(0.8))
                                  : null,
                              child: ExpansionTile(
                                title: Text(
                                  'Спеціалізована інформація'.toUpperCase(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                initiallyExpanded: true,
                                childrenPadding: EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 1.0.h),
                                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TypeAheadFormField(
                                    validator: (v) => isNull(trim(v)) ? '' : null,
                                    textFieldConfiguration: TextFieldConfiguration(
                                      controller: cityController,
                                      onTap: () {
                                        city.state = '';
                                        cityController.text = '';
                                      },
                                      style: TextStyle(fontSize: 10.0.sp, fontWeight: FontWeight.w600),
                                      decoration: InputDecoration(
                                        isDense: true,
                                        border: UnderlineInputBorder(),
                                        contentPadding: EdgeInsets.zero,
                                        labelText: 'Місто',
                                        labelStyle: TextStyle(fontSize: 10.0.sp),
                                        errorStyle: TextStyle(height: 0, color: Colors.red),
                                      ),
                                    ),
                                    suggestionsCallback: (pattern) async {
                                      final items = await cityItems;
                                      return items
                                          .where((c) => c.toLowerCase().contains(pattern.toLowerCase()))
                                          .toList();
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
                                  TypeAheadFormField(
                                    validator: (v) => isNull(trim(v)) ? '' : null,
                                    textFieldConfiguration: TextFieldConfiguration(
                                      controller: hospitalController,
                                      onTap: () {
                                        hospital.state = '';
                                        hospitalController.text = '';
                                      },
                                      style: TextStyle(fontSize: 10.0.sp, fontWeight: FontWeight.w600),
                                      decoration: InputDecoration(
                                        isDense: true,
                                        border: UnderlineInputBorder(),
                                        contentPadding: EdgeInsets.zero,
                                        labelText: 'Місце роботи',
                                        labelStyle: TextStyle(fontSize: 10.0.sp),
                                        errorStyle: TextStyle(height: 0),
                                      ),
                                    ),
                                    suggestionsCallback: (pattern) async {
                                      final items = await hospitalItems;
                                      return items
                                          .where((c) => c.toLowerCase().contains(pattern.toLowerCase()))
                                          .toList();
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
                                  TypeAheadFormField(
                                    validator: (v) => isNull(trim(v)) ? '' : null,
                                    textFieldConfiguration: TextFieldConfiguration(
                                      controller: specificationController,
                                      onTap: () {
                                        doctor.state = '';
                                        specificationController.text = '';
                                      },
                                      style: TextStyle(fontSize: 10.0.sp, fontWeight: FontWeight.w600),
                                      decoration: InputDecoration(
                                        isDense: true,
                                        border: UnderlineInputBorder(),
                                        contentPadding: EdgeInsets.zero,
                                        labelText: 'Спеціалізація',
                                        labelStyle: TextStyle(fontSize: 10.0.sp),
                                        errorStyle: TextStyle(height: 0),
                                      ),
                                    ),
                                    suggestionsCallback: (pattern) async {
                                      final items = await doctorItems;
                                      return items
                                          .where((c) => c.toLowerCase().contains(pattern.toLowerCase()))
                                          .toList();
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
                                  AccountTextField(
                                    controller: qualificationController,
                                    labelText: 'Рівень кваліфікації',
                                  ),
                                  SizedBox(height: 1.0.h),
                                  Divider(),
                                  AccountTextField(
                                    controller: positionController,
                                    labelText: 'Посада',
                                    validator: (v) => isNull(trim(v)) ? '' : null,
                                  ),
                                  SizedBox(height: 1.0.h),
                                  Divider(),
                                  AccountTextField(
                                    controller: licenseController,
                                    labelText: 'Номер ліцензії лікаря',
                                  ),
                                  SizedBox(height: 1.0.h),
                                  Divider(),
                                  Text('Документ про освіту',
                                      style: TextStyle(fontSize: 10.0.sp, color: Color(0xFFA1A1A1))),
                                  DocumentsContainer(
                                    doc: userNotifier.user?.specializedInformation?.educationDocument,
                                    onDeleteTap: () {
                                      userNotifier.clearEducationDocument();
                                    },
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
                                          showErrorDialog(context, error);
                                        });
                                      }
                                    },
                                  ),
                                  Divider(),
                                  Text('Паспорт громадянини України',
                                      style: TextStyle(fontSize: 10.0.sp, color: Color(0xFFA1A1A1))),
                                  DocumentsContainer(
                                    doc: userNotifier.user?.specializedInformation?.passport,
                                    onDeleteTap: () {
                                      userNotifier.clearPassport();
                                    },
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
                                          showErrorDialog(context, error);
                                        });
                                      }
                                    },
                                  ),
                                  Divider(),
                                  Text('ІПН', style: TextStyle(fontSize: 10.0.sp, color: Color(0xFFA1A1A1))),
                                  DocumentsContainer(
                                    doc: userNotifier.user?.specializedInformation?.micId,
                                    onDeleteTap: () {
                                      userNotifier.clearMicId();
                                    },
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
                                          showErrorDialog(context, error);
                                        });
                                      }
                                    },
                                  ),
                                  SizedBox(height: 1.0.h),
                                ],
                              ),
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
                              if (_specialInfoFormKey.currentState.validate()) {
                                step.value = 2;
                              }
                            },
                          ),
                        ),
                      Card(
                          margin: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 1.0.h),
                          clipBehavior: Clip.antiAlias,
                          child: IgnorePointer(
                            ignoring: step.value < 2,
                            child: Container(
                              foregroundDecoration: step.value < 2
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
                                  AccountTextField(
                                    controller: cardNumberController,
                                    labelText: 'Номер картки',
                                    validator: (v) => isCreditCard(trim(v)) ? null : '',
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
                              if (_basicInfoFormKey.currentState.validate() &&
                                  _specialInfoFormKey.currentState.validate()) {
                                final result = <String, dynamic>{};
                                result['basic_information'] = {
                                  'name': nameController.text,
                                  'email': postController.text,
                                  'phone': phoneController.text,
                                };

                                result['specialized_information'] = {
                                  'city': cityController.text,
                                  'specification': specificationController.text,
                                  'qualification': qualificationController.text,
                                  'workplace': hospitalController.text,
                                  'position': positionController.text,
                                  'license_number': licenseController.text,
                                  'additional_qualification': additionalQualificationController.text,
                                };

                                result['financial_information'] = {'card': cardNumberController.text};

                                isLoading.value = true;
                                userNotifier.submitProfile(result).then((value) {
                                  isLoading.value = false;
                                  Navigator.of(context).pop();
                                }).catchError((error) {
                                  isLoading.value = false;
                                  showErrorDialog(context, error);
                                });
                              }
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
