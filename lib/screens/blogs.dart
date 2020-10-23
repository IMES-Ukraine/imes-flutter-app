import 'package:flutter/material.dart';

import 'package:imes/blocs/blogs_notifier.dart';

import 'package:imes/widgets/base/error_retry.dart';
import 'package:imes/widgets/blogs/blog_tile.dart';
import 'package:imes/widgets/blogs/blogs_app_bar.dart';

import 'package:provider/provider.dart';

class BlogsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BlogsNotifier()..load(),
      child: Consumer<BlogsNotifier>(builder: (context, blogsNotifier, _) {
        return Scaffold(
          appBar: BlogsAppBar(),
          body: blogsNotifier.state == BlogsState.ERROR
              ? ErrorRetry(onTap: () {
                  blogsNotifier.load();
                })
              : RefreshIndicator(
                  onRefresh: () => blogsNotifier.load(),
                  child: ListView.builder(
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

                      return BlogListTile(
                        date: blogsNotifier.blogs[index].publishedAt,
                        title: blogsNotifier.blogs[index]?.title ?? '',
                        points: blogsNotifier.blogs[index]?.learningBonus ?? 0,
                        // text: blogsNotifier.blogs[index]?.content ?? '',
                        image: blogsNotifier.blogs[index]?.coverImage?.path ?? '',
                        // image: blogsNotifier.blogs[index]?.coverImages?.isNotEmpty ?? false
                        //     ? blogsNotifier.blogs[index].coverImages.first.path
                        //     : '',
                        onTap: () {
                          Navigator.of(context).pushNamed('/blogs/view', arguments: blogsNotifier.blogs[index].id);
                        },
                      );
                    },
                  ),
                ),
        );
      }),
    );
  }
}
