import 'package:flutter/material.dart';
import 'package:imes/blocs/user_notifier.dart';
import 'package:imes/screens/account_edit.dart';
import 'package:imes/widgets/base/octo_circle_avatar.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:imes/extensions/color.dart';

import 'package:sizer/sizer.dart';

class AccountPage extends StatelessWidget {
  static final days = ['ПН', 'ВТ', 'СР', 'ЧТ', 'ПТ', 'СБ', 'НД'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('АКАУНТ', style: TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            color: Theme.of(context).primaryColor,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => AccountEditPage()));
            },
          ),
        ],
      ),
      body: Consumer<UserNotifier>(builder: (context, userNotifier, _) {
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
                        url: userNotifier.user?.basicInformation?.avatar?.path ?? '',
                      ),
                    ),
                    Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(
                        userNotifier.user?.basicInformation?.name ?? 'Ім\'я Прізвище',
                        style: TextStyle(
                          color: Theme.of(context).dividerColor.darken(20),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        children: [
                          Icon(Icons.phone, color: Theme.of(context).primaryColor, size: 16.0),
                          const SizedBox(width: 4.0),
                          Text(
                            userNotifier.user?.basicInformation?.phone ?? 'Телефон',
                            style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4.0),
                      Row(
                        children: [
                          Icon(Icons.mail_outline, color: Theme.of(context).primaryColor, size: 16.0),
                          const SizedBox(width: 4.0),
                          Text(
                            userNotifier.user?.basicInformation?.email ?? 'Пошта',
                            style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ])),
                  ])),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: ExpansionTile(
                  title: Text('Спеціалізована інформація'.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                  initiallyExpanded: true,
                  childrenPadding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(),
                    Text('Місто', style: TextStyle(fontSize: 12.0, color: Color(0xFFA1A1A1))),
                    const SizedBox(height: 8.0),
                    Text(userNotifier.user?.specializedInformation?.city ?? '',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Divider(),
                    Text('Місце роботи', style: TextStyle(fontSize: 12.0, color: Color(0xFFA1A1A1))),
                    const SizedBox(height: 8.0),
                    Text(userNotifier.user?.specializedInformation?.workplace ?? '',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Divider(),
                    Text('Спеціалізація', style: TextStyle(fontSize: 12.0, color: Color(0xFFA1A1A1))),
                    const SizedBox(height: 8.0),
                    Text(userNotifier.user?.specializedInformation?.specification ?? '',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Divider(),
                    Text('Рівень кваліфікації', style: TextStyle(fontSize: 12.0, color: Color(0xFFA1A1A1))),
                    const SizedBox(height: 8.0),
                    Text(userNotifier.user?.specializedInformation?.qualification ?? '',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Divider(),
                    Text('Посада', style: TextStyle(fontSize: 12.0, color: Color(0xFFA1A1A1))),
                    const SizedBox(height: 8.0),
                    Text(userNotifier.user?.specializedInformation?.position ?? '',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Divider(),
                    Text('Номер ліцензії лікаря', style: TextStyle(fontSize: 12.0, color: Color(0xFFA1A1A1))),
                    const SizedBox(height: 8.0),
                    Text(userNotifier.user?.specializedInformation?.licenseNumber ?? '',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Divider(),
                    Text('Документ про освіту', style: TextStyle(fontSize: 12.0, color: Color(0xFFA1A1A1))),
                    const SizedBox(height: 8.0),
                    InkWell(
                      onTap: () async {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 20.0.h),
                                child: PhotoView(
                                  backgroundDecoration: BoxDecoration(color: Colors.transparent),
                                  tightMode: true,
                                  imageProvider: NetworkImage(userNotifier.user.specializedInformation.educationDocument.path),
                                  loadingBuilder: (context, progress) => Center(
                                    child: Container(
                                      width: 5.0.h,
                                      height: 5.0.h,
                                      child: CircularProgressIndicator(
                                        value: progress == null
                                            ? null
                                            : progress.cumulativeBytesLoaded / progress.expectedTotalBytes,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(userNotifier.user?.specializedInformation?.educationDocument != null ? 'Показати' : '',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
                          SizedBox(width: 2.0.w),
                          Expanded(
                            child: Text(userNotifier.user?.specializedInformation?.educationDocument?.fileName ?? '',
                                style: TextStyle(color: Theme.of(context).primaryColor)),
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    Text('Паспорт громадянина України', style: TextStyle(fontSize: 12.0, color: Color(0xFFA1A1A1))),
                    const SizedBox(height: 8.0),
                    InkWell(
                      onTap: () async {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 20.0.h),
                                child: PhotoView(
                                  backgroundDecoration: BoxDecoration(color: Colors.transparent),
                                  tightMode: true,
                                  imageProvider: NetworkImage(userNotifier.user.specializedInformation.passport.path),
                                  loadingBuilder: (context, progress) => Center(
                                    child: Container(
                                      width: 5.0.h,
                                      height: 5.0.h,
                                      child: CircularProgressIndicator(
                                        value: progress == null
                                            ? null
                                            : progress.cumulativeBytesLoaded / progress.expectedTotalBytes,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(userNotifier.user?.specializedInformation?.passport != null ? 'Показати' : '',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
                          SizedBox(width: 2.0.w),
                          Expanded(
                            child: Text(userNotifier.user?.specializedInformation?.passport?.fileName ?? '',
                                style: TextStyle(color: Theme.of(context).primaryColor)),
                          ),
                        ],
                      ),
                    ),
                    // Divider(),
                    // Text('Графік роботи', style: TextStyle(fontSize: 12.0, color: Color(0xFFA1A1A1))),
                    // const SizedBox(height: 8.0),
                    // Column(
                    //   children: List.generate(3, (index) {
                    //         final s = userNotifier.user?.specializedInformation?.schedule?.elementAt(index);
                    //         return Row(
                    //           children: [
                    //             for (var i = 0; i < days.length; i++)
                    //               Row(
                    //                 children: [
                    //                   Text('${days[i]}${i != days.length - 1 ? ', ' : ':'}',
                    //                       style: TextStyle(
                    //                           color: s?.days?.contains(i) ?? false ? Colors.black : Color(0xFFBDBDBD))),
                    //                 ],
                    //               ),
                    //             Expanded(
                    //               child: Text(s?.time ?? '', style: TextStyle(fontWeight: FontWeight.bold)),
                    //             ),
                    //           ],
                    //         );
                    //       })?.toList() ??
                    //       [],
                    // ),
                    Divider(),
                    Text('ІПН', style: TextStyle(fontSize: 12.0, color: Color(0xFFA1A1A1))),
                    const SizedBox(height: 8.0),
                    InkWell(
                      onTap: () async {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 20.0.h),
                                child: PhotoView(
                                  backgroundDecoration: BoxDecoration(color: Colors.transparent),
                                  tightMode: true,
                                  imageProvider: NetworkImage(userNotifier.user.specializedInformation.micId.path),
                                  loadingBuilder: (context, progress) => Center(
                                    child: Container(
                                      width: 5.0.h,
                                      height: 5.0.h,
                                      child: CircularProgressIndicator(
                                        value: progress == null
                                            ? null
                                            : progress.cumulativeBytesLoaded / progress.expectedTotalBytes,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(userNotifier.user?.specializedInformation?.micId != null ? 'Показати' : '',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
                          SizedBox(width: 2.0.w),
                          Expanded(
                            child: Text(userNotifier.user?.specializedInformation?.micId?.fileName ?? '',
                                style: TextStyle(color: Theme.of(context).primaryColor)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16.0),
                  ],
                ),
              ),
              Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
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
                      Text('Номер картки', style: TextStyle(fontSize: 12.0, color: Color(0xFFA1A1A1))),
                      const SizedBox(height: 8.0),
                      Text(userNotifier.user?.financialInformation?.card ?? '',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16.0),
                    ],
                  )),
            ],
          ),
        );
      }),
    );
  }
}
