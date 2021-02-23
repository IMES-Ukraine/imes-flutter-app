import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:imes/blocs/blogs_notifier.dart';
import 'package:imes/utils/constants.dart';

import 'package:imes/widgets/base/error_retry.dart';
import 'package:imes/widgets/blogs/blog_tile.dart';
import 'package:imes/widgets/blogs/blogs_app_bar.dart';
import 'package:imes/widgets/dialogs/dialogs.dart';

import 'package:provider/provider.dart';

class BlogsPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BlogsNotifier()..load(),
      child: Consumer<BlogsNotifier>(builder: (context, blogsNotifier, _) {
        return DefaultTabController(
          length: 3,
                  child: Scaffold(
            appBar: BlogsAppBar(),
            body: blogsNotifier.state == BlogsState.ERROR
                ? ErrorRetry(onTap: () {
                    blogsNotifier.load();
                  })
                : RefreshIndicator(
                    onRefresh: () => blogsNotifier.load(),
                    child: blogsNotifier.page == BlogPage.FAVORITES
                        ? ValueListenableBuilder(
                            valueListenable: Hive.box(Constants.FAVORITES_BOX).listenable(),
                            builder: (context, box, widget) {
                              return ListView(
                                children: box.values
                                    .map<Widget>((v) => 
                                          BlogListTile(
                                            isOpened: !(v.isOpened?.isEmpty ??  true),
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
                                                open = await showBlogInfoDialog(context);
                                              }
                                              if (open) {
                                                Navigator.of(context).pushNamed('/blogs/view', arguments: v.id);
                                              }
                                            },
                                          ),
                                        )
                                    .toList(),
                              );
                            },
                          )
                        : ListView.builder(
                            itemCount: blogsNotifier.state == BlogsState.LOADING ? 1 : blogsNotifier.blogs.length + 1,
                            itemBuilder: (context, index) {
                              if (blogsNotifier.state == BlogsState.LOADING) {
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              if (index == blogsNotifier.blogs.length) {
                                if (blogsNotifier.blogs.isEmpty) {
                                  return Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Новини відсутні.'),
                                    ),
                                  );
                                }

                                if (blogsNotifier.blogs.length == blogsNotifier.total) {
                                  return null;
                                }

                                blogsNotifier.loadNext();
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              return ValueListenableBuilder(
                                  valueListenable: Hive.box(Constants.FAVORITES_BOX).listenable(),
                                  builder: (context, box, widget) {
                                    return BlogListTile(
                                      date: blogsNotifier.blogs[index].publishedAt,
                                      title: blogsNotifier.blogs[index]?.title ?? '',
                                      points: blogsNotifier.blogs[index]?.learningBonus ?? 0,
                                      image: blogsNotifier.blogs[index]?.coverImage?.path ?? '',
                                      isFavourite: box.containsKey(blogsNotifier.blogs[index].id),
                                      onFavoriteChanged: (value) async {
                                        if (value) {
                                          box.put(blogsNotifier.blogs[index].id, blogsNotifier.blogs[index]);
                                        } else {
                                          box.delete(blogsNotifier.blogs[index].id);
                                        }
                                      },
                                      onTap: () async {
                                        var open = true;
                                        if (blogsNotifier.blogs[index].isOpened?.isEmpty ?? true) {
                                          open = await showBlogInfoDialog(context);
                                        }
                                        if (open) {
                                          Navigator.of(context)
                                              .pushNamed('/blogs/view', arguments: blogsNotifier.blogs[index].id);
                                        }
                                      },
                                    );
                                  });
                            },
                          ),
                  ),
          ),
        );
      }),
    );
  }
}
