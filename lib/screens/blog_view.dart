import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:imes/resources/repository.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';

import 'package:imes/blocs/blog_notifier.dart';
import 'package:imes/resources/resources.dart';

import 'package:imes/widgets/base/error_retry.dart';
import 'package:imes/widgets/base/raised_gradient_button.dart';

import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

class BlogViewPage extends HookWidget {
  BlogViewPage(this._id);

  final num _id;
  // final List<Blog> _recommended;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final _indicatorScrollController = useScrollController();
    final _indicatorState = useState(0);

    useEffect(() {
      final listener = () {
        _indicatorState.value =
            _indicatorScrollController.position.pixels ~/ (_indicatorScrollController.position.viewportDimension - 16);
      };
      _indicatorScrollController.addListener(listener);
      return () {
        _indicatorScrollController.removeListener(listener);
      };
    }, [_indicatorState]);

    return ChangeNotifierProvider(
      create: (_) => BlogNotifier()..load(_id),
      child: Consumer<BlogNotifier>(builder: (context, blogNotifier, _) {
        return Scaffold(
            appBar: AppBar(
                // actions: [
                //   IconButton(
                //     icon: Icon(Icons.favorite),
                //     onPressed: () {},
                //   )
                // ],
                ),
            body: LayoutBuilder(builder: (context, constraints) {
              if (blogNotifier.state == BlogState.ERROR) {
                return ErrorRetry(onTap: () {
                  blogNotifier.load(_id);
                });
              }

              if (blogNotifier.state == BlogState.LOADING) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return LayoutBuilder(
                builder: (context, viewportConstraints) {
                  return CustomScrollView(
                    slivers: [
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    blogNotifier.blog?.title ?? '',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22.0,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(''),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            blogNotifier.blog?.publishedAt != null
                                                ? DateFormat.yMMMMd('uk').format(blogNotifier.blog.publishedAt)
                                                : '',
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                              color: Color(0xFF828282), // TODO: extract colors to theme
                                              fontSize: 12.0,
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Card(
                              margin: const EdgeInsets.all(8.0),
                              clipBehavior: Clip.antiAlias,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (blogNotifier.blog?.featuredImages?.isNotEmpty ?? false)
                                    Container(
                                      height: 200,
                                      child: Stack(
                                        children: [
                                          PhotoViewGallery.builder(
                                            scrollPhysics: const BouncingScrollPhysics(),
                                            builder: (BuildContext context, int index) {
                                              return PhotoViewGalleryPageOptions.customChild(
                                                child: OctoImage.fromSet(
                                                  octoSet: OctoSet.blurHash(
                                                    'LKO2?V%2Tw=w]~RBVZRi};RPxuwH',
                                                  ),
                                                  image: CachedNetworkImageProvider(
                                                      blogNotifier.blog.featuredImages[index].path),
                                                  fit: BoxFit.fitWidth,
                                                ),
                                                initialScale: PhotoViewComputedScale.contained,
                                                minScale: PhotoViewComputedScale.contained,
                                                maxScale: PhotoViewComputedScale.covered * 2,
                                                heroAttributes: PhotoViewHeroAttributes(
                                                    tag:
                                                        'featured_image_${blogNotifier.blog.featuredImages[index].id}'),
                                              );
                                            },
                                            itemCount: blogNotifier.blog.featuredImages.length,
                                            backgroundDecoration: const BoxDecoration(color: Colors.white),
                                            pageController: _pageController,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ...blogNotifier.blog.content.map((e) {
                                    return HookBuilder(
                                      builder: (context) {
                                        final hasDoneRead = useState(false);
                                        if (e.type == 'text') {
                                          return VisibilityDetector(
                                            key: ValueKey<String>(e.title),
                                            onVisibilityChanged: (info) {
                                              if (info.size.height == info.visibleBounds.bottom && !hasDoneRead.value) {
                                                Repository()
                                                    .api
                                                    .readBlogBlock(
                                                      blogId: blogNotifier.blog.id,
                                                      blockIndex: blogNotifier.blog.content.indexOf(e),
                                                    )
                                                    .then((_) {
                                                  hasDoneRead.value = true;
                                                }).catchError((error) => print(error));
                                              }
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  if (e.title != null)
                                                    Text(
                                                      e.title,
                                                      style: TextStyle(fontWeight: FontWeight.bold),
                                                    ),
                                                  const SizedBox(height: 8.0),
                                                  Text(e.content),
                                                ],
                                              ),
                                            ),
                                          );
                                        } else {
                                          return const SizedBox();
                                        }
                                      },
                                    );
                                  }).toList(),
                                  // if ((blogNotifier.blog?.action?.isNotEmpty ?? false))
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 64.0),
                                      child: RaisedGradientButton(
                                        child: Text(
                                          'Читати ще'.toUpperCase(),
                                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                        ),
                                        // highlightedBorderColor: Theme.of(context).accentColor,
                                        // borderSide: BorderSide(color: Theme.of(context).accentColor),
                                        // textColor: Theme.of(context).accentColor,
                                        onPressed: () async {
                                          blogNotifier.read();
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Center(
                                child: FittedBox(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'ПОДЕЛИТЬСЯ',
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
                                      ),
                                      const SizedBox(width: 16.0),
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Image.asset(Images.facebook),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Image.asset(Images.telegram),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Image.asset(Images.whatsup),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Image.asset(Images.messenger),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Image.asset(Images.viber),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            if (blogNotifier.popular?.isNotEmpty ?? false)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Theme.of(context).primaryColor, width: 2.0),
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 16.0),
                                            child: Row(
                                              children: [
                                                Image.asset(Images.union),
                                                const SizedBox(width: 16.0),
                                                Text(
                                                  'ПОПУЛЯРНОЕ',
                                                  style: TextStyle(
                                                      color: Color(0xFF828282),
                                                      fontSize: 16.0), // TODO: extract colors to theme
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        ...blogNotifier.popular.map((e) {
                                          return InkWell(
                                            onTap: () {
                                              Navigator.of(context).pushNamed('/blogs/view', arguments: e.id);
                                            },
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Divider(indent: 32.0, endIndent: 32.0),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
                                                  child: Text(
                                                    e.title,
                                                    style: TextStyle(fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      ],
                                    )),
                              ),
                            const SizedBox(height: 32.0),
                            Column(children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                      icon: Icon(
                                        Icons.chevron_left,
                                        color: Theme.of(context).primaryColor,
                                        size: 24.0,
                                      ),
                                      onPressed: () {
                                        _indicatorScrollController.animateTo(
                                          _indicatorScrollController.offset -
                                              _indicatorScrollController.position.viewportDimension,
                                          duration: const Duration(milliseconds: 500),
                                          curve: Curves.easeInOut,
                                        );
                                      }),
                                  Text('Рекомендовано', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                                  IconButton(
                                      icon: Icon(
                                        Icons.chevron_right,
                                        color: Theme.of(context).primaryColor,
                                        size: 24.0,
                                      ),
                                      onPressed: () {
                                        _indicatorScrollController.animateTo(
                                          _indicatorScrollController.offset +
                                              _indicatorScrollController.position.viewportDimension,
                                          duration: const Duration(milliseconds: 500),
                                          curve: Curves.easeInOut,
                                        );
                                      }),
                                ],
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                controller: _indicatorScrollController,
                                physics: PageScrollPhysics(),
                                child: IntrinsicHeight(
                                  child: Row(
                                    children: blogNotifier.blog.recommended
                                        .where((o) => o.post != null)
                                        .map<Widget>(
                                          (item) => SizedBox(
                                            width: MediaQuery.of(context).size.width / 2.0,
                                            height: double.infinity,
                                            child: Card(
                                                margin: const EdgeInsets.all(8.0),
                                                child: InkWell(
                                                  onTap: () {
                                                    Navigator.of(context).pushNamed(
                                                      '/blogs/view',
                                                      arguments: item.recommendedId,
                                                    );
                                                  },
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      if (item.post.coverImage != null)
                                                        OctoImage.fromSet(
                                                          height: 100,
                                                          octoSet: OctoSet.blurHash(
                                                            'LKO2?V%2Tw=w]~RBVZRi};RPxuwH',
                                                          ),
                                                          image: CachedNetworkImageProvider(item.post.coverImage.path),
                                                        ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text(
                                                          item.post.title,
                                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  (blogNotifier.blog.recommended.length / 2.0).floor(),
                                  (index) => Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Container(
                                      width: 8.0,
                                      height: 8.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Theme.of(context).dividerColor),
                                        color: _indicatorState.value == index
                                            ? Color(0xFFA1A1A1) // TODO: extract colors to theme
                                            : Color(0xFFE0E0E0), // TODO: extract colors to theme
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                            const SizedBox(height: 32.0),
                          ],
                        ),
                      )
                    ],
                  );
                },
              );
            }));
      }),
    );
  }
}
