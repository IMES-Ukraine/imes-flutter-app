import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:imes/blocs/blogs_notifier.dart';
import 'package:imes/models/blog.dart';
import 'package:imes/utils/constants.dart';
import 'package:imes/widgets/base/error_retry.dart';
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
                    child: blogsNotifier.page == BlogPage.FAVORITES
                        ? ValueListenableBuilder(
                            valueListenable:
                                Hive.box(Constants.FAVORITES_BOX).listenable(),
                            builder: (context, box, widget) {
                              return PagedListView<int, Blog>(
                                pagingController:
                                    blogsNotifier.pagingController,
                                builderDelegate:
                                    PagedChildBuilderDelegate<Blog>(
                                  itemBuilder: (context, item, index) =>
                                      BlogListTile(
                                    isOpened: !(item.isOpened?.isEmpty ?? true),
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
                                      if (item.isOpened?.isEmpty ?? true) {
                                        open =
                                            await showBlogInfoDialog(context);
                                      }
                                      if (open) {
                                        Navigator.of(context).pushNamed(
                                            '/blogs/view',
                                            arguments: item.id);
                                      }
                                    },
                                  ),
                                ),
                              );
                              return ListView(
                                children: box.values
                                    .map<Widget>(
                                      (v) => BlogListTile(
                                        isOpened:
                                            !(v.isOpened?.isEmpty ?? true),
                                        date: v.publishedAt,
                                        title: v?.title ?? '',
                                        points: v?.learningBonus ?? 0,
                                        image: v?.coverImage?.path ?? '',
                                        isFavourite: box.containsKey(v.id),
                                        onFavoriteChanged: (value) async {
                                          if (value) {
                                            box.put(v.id, v);
                                          } else {
                                            box.delete(v.id);
                                          }
                                        },
                                        onTap: () async {
                                          var open = true;
                                          if (v.isOpened?.isEmpty ?? true) {
                                            open = await showBlogInfoDialog(
                                                context);
                                          }
                                          if (open) {
                                            Navigator.of(context).pushNamed(
                                                '/blogs/view',
                                                arguments: v.id);
                                          }
                                        },
                                      ),
                                    )
                                    .toList(),
                              );
                            },
                          )
                        : ValueListenableBuilder(
                            valueListenable:
                                Hive.box(Constants.FAVORITES_BOX).listenable(),
                            builder: (context, box, widget) {
                              return PagedListView<int, Blog>(
                                pagingController:
                                    blogsNotifier.pagingController,
                                builderDelegate:
                                    PagedChildBuilderDelegate<Blog>(
                                  itemBuilder: (context, item, index) =>
                                      BlogListTile(
                                    isOpened: !(item.isOpened?.isEmpty ?? true),
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
                                      if (item.isOpened?.isEmpty ?? true) {
                                        open =
                                            await showBlogInfoDialog(context);
                                      }
                                      if (open) {
                                        Navigator.of(context).pushNamed(
                                            '/blogs/view',
                                            arguments: item.id);
                                      }
                                    },
                                  ),
                                ),
                              );
                            })
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
