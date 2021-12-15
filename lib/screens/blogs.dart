import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:imes/blocs/blogs_notifier.dart';
import 'package:imes/models/blog.dart';
import 'package:imes/resources/repository.dart';
import 'package:imes/utils/constants.dart';
import 'package:imes/widgets/base/custom_alert_dialog.dart';
import 'package:imes/widgets/base/custom_checkbox.dart';
import 'package:imes/widgets/base/error_retry.dart';
import 'package:imes/widgets/base/raised_gradient_button.dart';
import 'package:imes/widgets/blogs/blog_tile.dart';
import 'package:imes/widgets/blogs/blogs_app_bar.dart';
import 'package:imes/widgets/dialogs/dialogs.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class BlogsPage extends StatefulWidget {
  const BlogsPage({Key key}) : super(key: key);
  @override
  _BlogsPageState createState() => _BlogsPageState();
}

class _BlogsPageState extends State<BlogsPage> {
  final _notifier = BlogsNotifier();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _notifier..init(),
      child: Consumer<BlogsNotifier>(builder: (context, blogsNotifier, _) {
        return DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: BlogsAppBar(),
            body: blogsNotifier.state == BlogsState.ERROR
                ? ErrorRetry(onTap: () {
                    blogsNotifier.pagingController.refresh();
                  })
                : RefreshIndicator(
                    onRefresh: () async {
                      blogsNotifier.pagingController.refresh();
                      await Future.delayed(const Duration(seconds: 1));
                    },
                    child: _Page(
                      blogsNotifier: blogsNotifier,
                    ),
                    // : ListView.builder(
                    //     itemCount: blogsNotifier.state == BlogsState.LOADING
                    //         ? 1
                    //         : blogsNotifier.blogs.length + 1,
                    //     itemBuilder: (context, index) {
                    //       if (blogsNotifier.state == BlogsState.LOADING) {
                    //         return Center(
                    //           child: Padding(
                    //             padding: const EdgeInsets.all(8.0),
                    //             child: CircularProgressIndicator(),
                    //           ),
                    //         );
                    //       }
                    //
                    //       if (index == blogsNotifier.blogs.length) {
                    //         if (blogsNotifier.blogs.isEmpty) {
                    //           return Center(
                    //             child: Padding(
                    //               padding: const EdgeInsets.all(8.0),
                    //               child: Text('Новини відсутні.'),
                    //             ),
                    //           );
                    //         }
                    //
                    //         if (blogsNotifier.blogs.length ==
                    //             blogsNotifier.total) {
                    //           return null;
                    //         }
                    //
                    //         blogsNotifier.loadNext();
                    //         return Center(
                    //           child: Padding(
                    //             padding: const EdgeInsets.all(8.0),
                    //             child: CircularProgressIndicator(),
                    //           ),
                    //         );
                    //       }
                    //
                    //       return ValueListenableBuilder(
                    //           valueListenable:
                    //               Hive.box(Constants.FAVORITES_BOX)
                    //                   .listenable(),
                    //           builder: (context, box, widget) {
                    //             return BlogListTile(
                    //               date: blogsNotifier
                    //                   .blogs[index].publishedAt,
                    //               title:
                    //                   blogsNotifier.blogs[index]?.title ??
                    //                       '',
                    //               points: blogsNotifier
                    //                       .blogs[index]?.learningBonus ??
                    //                   0,
                    //               image: blogsNotifier
                    //                       .blogs[index]?.coverImage?.path ??
                    //                   '',
                    //               isFavourite: box.containsKey(
                    //                   blogsNotifier.blogs[index].id),
                    //               onFavoriteChanged: (value) async {
                    //                 if (value) {
                    //                   box.put(blogsNotifier.blogs[index].id,
                    //                       blogsNotifier.blogs[index]);
                    //                 } else {
                    //                   box.delete(
                    //                       blogsNotifier.blogs[index].id);
                    //                 }
                    //               },
                    //               onTap: () async {
                    //                 var open = true;
                    //                 if (blogsNotifier
                    //                         .blogs[index].learningBonus >
                    //                     0) {
                    //                   open =
                    //                       await showBlogInfoDialog(context);
                    //                 }
                    //                 if (open) {
                    //                   Navigator.of(context).pushNamed(
                    //                       '/blogs/view',
                    //                       arguments: blogsNotifier
                    //                           .blogs[index].id);
                    //                 }
                    //               },
                    //             );
                    //           });
                    //     },
                    //   ),
                  ),
          ),
        );
      }),
    );
  }
}

class _Page extends StatelessWidget {
  const _Page({
    Key key,
    @required this.blogsNotifier,
  }) : super(key: key);
  final BlogsNotifier blogsNotifier;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box(Constants.FAVORITES_BOX).listenable(),
      builder: (context, box, widget) {
        return PagedListView<int, Blog>(
          pagingController: blogsNotifier.pagingController,
          builderDelegate: PagedChildBuilderDelegate<Blog>(
            itemBuilder: (context, item, index) => _PageTile(
              item: item,
              box: box,
            ),
          ),
        );
      },
    );
  }
}

class _PageTile extends StatelessWidget {
  const _PageTile({
    Key key,
    @required this.item,
    @required this.box,
  }) : super(key: key);
  final Blog item;
  final Box box;
  @override
  Widget build(BuildContext context) {
    return BlogListTile(
      isOpened: item.isOpened,
      date: item.publishedAt,
      title: item?.title ?? '',
      points: item?.learningBonus ?? 0,
      image: item?.coverImage?.path ?? '',
      isFavourite: box.containsKey(item.id),
      onFavoriteChanged: (value) async {
        if (value) {
          box.put(item.id, item);
        } else {
          box.delete(item.id);
        }
      },
      onTap: () async {
        var open = true;
        if (item.isCommercial == true && item.learningBonus > 0) {
          open = await showBlogInfoDialog(context);
          if (item?.isAgreementAccepted == false) {
            final response =
                await Repository().api.getAgreement(item.researchId);
            showDialog(
                context: context,
                builder: (innerContext) {
                  return HookBuilder(builder: (ctx) {
                    final checkBoxState = useState(false);
                    return CustomAlertDialog(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Згода на участь в дослідженні',
                              style: TextStyle(
                                  fontSize: 17.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                          if (response?.body?.data?.agreement?.isNotEmpty ==
                              true) ...[
                            Container(
                              constraints: BoxConstraints(maxHeight: 250),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xFFA1A1A1)),
                                  borderRadius: BorderRadius.circular(5.0)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SingleChildScrollView(
                                    child: Text(response.body.data.agreement,
                                        style: TextStyle(fontSize: 12.0))),
                              ),
                            ),
                          ],
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: [
                                CustomCheckbox(
                                  value: checkBoxState.value,
                                  onTap: () => checkBoxState.value =
                                      !checkBoxState.value,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: RichText(
                                      text: TextSpan(
                                        text:
                                            'Я ознайомлений з Умовами данної згоди для участі в дослідженні',
                                        style: TextStyle(
                                            fontSize: 11.0,
                                            color: Color(
                                                0xFF828282)), // TODO: extract colors to theme
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: RaisedGradientButton(
                              onPressed: checkBoxState.value
                                  ? () async {
                                      await Repository()
                                          .api
                                          .postAgreement(item.researchId);
                                      Navigator.of(innerContext).pop();
                                      Navigator.of(context).pushNamed(
                                          '/blogs/view',
                                          arguments: item.id);
                                    }
                                  : null,
                              child: Text(
                                'РОЗПОЧАТИ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  });
                });
            return;
          } else {
            Navigator.of(context).pushNamed('/blogs/view', arguments: item.id);
            return;
          }
        }
        if (open) {
          Navigator.of(context).pushNamed('/blogs/view', arguments: item.id);
        }
      },
    );
  }
}
