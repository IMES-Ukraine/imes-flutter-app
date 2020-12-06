import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:imes/blocs/blogs_notifier.dart';
import 'package:imes/widgets/base/custom_alert_dialog.dart';
import 'package:imes/widgets/base/custom_flat_button.dart';

import 'package:imes/widgets/base/error_retry.dart';
import 'package:imes/widgets/blogs/blog_tile.dart';
import 'package:imes/widgets/blogs/blogs_app_bar.dart';

class BlogsPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final blogsNotifier = useProvider(blogsNotifierProvider);
    useEffect(() {
      blogsNotifier.load();
      return () {};
    }, const []);
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
                      showDialog(
                          context: context,
                          builder: (context) {
                            return CustomAlertDialog(
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Внимание!',
                                      style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Icon(Icons.warning, color: Theme.of(context).errorColor, size: 90.0),
                                  const SizedBox(height: 16.0),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Для получения баллов за изучение статьи, необходимо полностью её прочесть',
                                      style: TextStyle(fontSize: 12.0),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    child: CustomFlatButton(
                                        text: 'НАЧАТЬ',
                                        color: Theme.of(context).primaryColor,
                                        onPressed: () {
                                          Navigator.of(context).pop(true);
                                        }),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    child: CustomFlatButton(
                                        text: 'ВЕРНУТЬСЯ ПОЗДЖЕ',
                                        color: Theme.of(context).errorColor,
                                        onPressed: () {
                                          Navigator.of(context).pop(false);
                                        }),
                                  ),
                                ],
                              ),
                            );
                          }).then((value) {
                        if (value) {
                          Navigator.of(context).pushNamed('/blogs/view', arguments: blogsNotifier.blogs[index].id);
                        }
                      });
                    },
                  );
                },
              ),
            ),
    );
  }
}
