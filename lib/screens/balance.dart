import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:imes/blocs/history_notifier.dart';
import 'package:imes/blocs/user_notifier.dart';
import 'package:imes/models/balance_card.dart';
import 'package:imes/resources/repository.dart';
import 'package:imes/resources/resources.dart';
import 'package:imes/screens/balance_history.dart';
import 'package:imes/screens/balance_item.dart';
import 'package:imes/utils/constants.dart';
import 'package:imes/widgets/dialogs/dialogs.dart';
import 'package:octo_image/octo_image.dart';
import 'package:provider/provider.dart';

class BalancePage extends StatefulWidget {
  @override
  _BalancePageState createState() => _BalancePageState();
}

class _BalancePageState extends State<BalancePage> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userNotifier = Provider.of<UserNotifier>(context, listen: false);
      await userNotifier.updateProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dropdownBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: Constants.brandBlueColor,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(5),
      ),
      gapPadding: 0,
    );
    return ChangeNotifierProvider(
      create: (_) => HistoryNotifier()..load(),
      child: Consumer2<UserNotifier, HistoryNotifier>(
        builder: (context, userNotifier, historyNotifier, _) {
          return Scaffold(
            key: _drawerKey,
            appBar: AppBar(
              elevation: 1,
              leading: BackButton(),
              title: Text(
                'ОБМІН',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 17,
                  height: 23 / 17,
                  color: const Color(0xFF606060),
                ),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  icon:
                      SvgPicture.asset('assets/drawable/balance_settings.svg'),
                  onPressed: () => _drawerKey.currentState.openDrawer(),
                ),
                IconButton(
                  icon: SvgPicture.asset('assets/drawable/balance_history.svg'),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => BalanceHistoryPage(),
                    ),
                  ),
                ),
              ],
            ),
            body: Consumer2<UserNotifier, HistoryNotifier>(
                builder: (context, userNotifier, historyNotifier, _) {
              return SafeArea(
                child: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (notification) {
                    return true;
                  },
                  child: RefreshIndicator(
                    onRefresh: () async {
                      userNotifier.updateProfile();
                      historyNotifier.load();
                    },
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: <Widget>[
                          const SizedBox(height: 24),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              '${userNotifier.user.balance ?? 0}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 48.0,
                                fontWeight: FontWeight.w700,
                                height: 59 / 48,
                                color: Color(0xFF333333),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(Images.token),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                'IMIC',
                                style: TextStyle(
                                  color: Constants.brandBlueColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  height: 22 / 18,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 20),
                          if (historyNotifier.state == HistoryState.LOADED) ...[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: AspectRatio(
                                aspectRatio: 34 / 10,
                                child: Container(
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    color: Constants.brandBlueColor,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  child: OctoImage.fromSet(
                                    height: 100,
                                    octoSet: OctoSet.blurHash(
                                      'LKO2?V%2Tw=w]~RBVZRi};RPxuwH',
                                    ),
                                    image: CachedNetworkImageProvider(
                                      '''$BASE_URL${historyNotifier?.bannerCard?.image}''',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            if (historyNotifier.cardsItems.isEmpty == true) ...[
                              Text(
                                'Картки відсутні',
                                style: TextStyle(
                                  color: Color(0xffa1a1a1),
                                  fontSize: 24,
                                  height: 36 / 24,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ] else ...[
                              ListView.separated(
                                itemBuilder: (context, index) {
                                  return _ExchangeCard(
                                    index: index,
                                    card: historyNotifier.cardsItems[index],
                                    onBuy: () {
                                      historyNotifier.loadCards();
                                      userNotifier.updateProfile();
                                    },
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                  height: 10,
                                ),
                                itemCount: historyNotifier.state ==
                                        HistoryState.LOADING
                                    ? 1
                                    : historyNotifier.cardsItems.length,
                                shrinkWrap: true,
                                padding: EdgeInsets.only(
                                  left: 16,
                                  right: 16,
                                  bottom: 16,
                                ),
                                physics: const NeverScrollableScrollPhysics(),
                              ),
                            ]
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
            endDrawerEnableOpenDragGesture: false,
            onDrawerChanged: (isOpen) {},
            drawer: Drawer(
              elevation: 16,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.only(
                  left: 34,
                  right: 34,
                  bottom: 16,
                ),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 34),
                      // TODO CATEGORY
                      // Row(
                      //   children: [
                      //     SvgPicture.asset('assets/drawable/balance_category.svg'),
                      //     const SizedBox(width: 10),
                      //     Text(
                      //       'КАТЕГОРІЯ',
                      //       style: TextStyle(
                      //         fontSize: 12,
                      //         fontWeight: FontWeight.w800,
                      //         height: 16 / 12,
                      //         color: const Color(0xff606060),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // const SizedBox(height: 16),
                      // Divider(),
                      Row(
                        children: [
                          SvgPicture.asset(
                              'assets/drawable/balance_list_order.svg'),
                          const SizedBox(width: 10),
                          Text(
                            'СОРТУВАННЯ',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              height: 16 / 12,
                              color: const Color(0xff606060),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // TextButton(
                      //   onPressed: () {},
                      //   child: Text('за популярністю'),
                      // ),
                      ...HistorySorting.values
                          .map(
                            (e) => TextButton(
                              onPressed: () {
                                historyNotifier.changeSorting(e);
                              },
                              child: Text(
                                e.toLocalizedString,
                                style: TextStyle(
                                  fontSize: 12,
                                  height: 16 / 12,
                                  color: historyNotifier.sorting == e
                                      ? Constants.brandBlueColor
                                      : Color(0xff828282),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      OutlinedButton(
                        onPressed: () async {
                          historyNotifier.loadCards();
                          _drawerKey.currentState.openEndDrawer();
                        },
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                        ).copyWith(
                          side: MaterialStateProperty.resolveWith<BorderSide>(
                            (Set<MaterialState> states) {
                              return BorderSide(
                                color: Constants.brandBlueColor,
                              );
                            },
                          ),
                        ),
                        child: Text(
                          'ЗАСТОСУВАТИ',
                          style: TextStyle(
                            color: Constants.brandBlueColor,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Spacer(),
                      SvgPicture.asset(
                          'assets/drawable/balance_imes_drawer_logo.svg'),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ExchangeCard extends StatelessWidget {
  const _ExchangeCard({
    Key key,
    @required this.card,
    @required this.index,
    @required this.onBuy,
  }) : super(key: key);

  final BalanceCard card;
  final int index;
  final VoidCallback onBuy;

  List<Widget> _bluredBackground() {
    return [
      Positioned(
        top: -5,
        left: -5,
        right: -5,
        bottom: -5,
        child: FittedBox(
          fit: BoxFit.cover,
          child: SvgPicture.asset(
              'assets/drawable/balance_bg_${(index % 4).round()}.svg'),
        ),
      ),
      BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
        child: Text(' '),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.all(
        Radius.circular(5),
      ),
      clipBehavior: Clip.hardEdge,
      elevation: 1,
      child: InkWell(
        onTap: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => BalanceItem(
                card: card,
              ),
            ),
          ) as bool;
          if (result == true) {
            onBuy?.call();
          }
        },
        child: Container(
          constraints: BoxConstraints(
            minHeight: 95,
            minWidth: double.infinity,
          ),
          color: Colors.white,
          child: Stack(
            fit: StackFit.passthrough,
            children: [
              ..._bluredBackground(),
              Padding(
                padding: EdgeInsets.only(
                  top: 24,
                  left: 32,
                  right: 16,
                  bottom: 20,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          card.name?.toUpperCase() ?? 'Text'.toUpperCase(),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            height: 22 / 18,
                            color: const Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          card.shortDescription ?? 'Subtitle',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            height: 17 / 14,
                            color: const Color(0xFF979797),
                          ),
                        )
                      ],
                    ),
                    const Spacer(),
                    _AmountBox(
                      amount: card.cost,
                      id: card.id,
                      onBuy: () => onBuy?.call(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AmountBox extends StatelessWidget {
  const _AmountBox({
    Key key,
    @required this.amount,
    @required this.id,
    @required this.onBuy,
  }) : super(key: key);

  final int amount;
  final int id;
  final VoidCallback onBuy;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.all(
        Radius.circular(5),
      ),
      elevation: 1,
      child: InkWell(
        onTap: () async {
          final result = await showWithdrawalDialog<bool>(context, amount);
          if (result == true) {
            final response = await Repository().api.buyBalanceCard(id);
            onBuy?.call();
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 12,
          ),
          child: Row(
            children: [
              Image.asset(
                Images.token,
                width: 16,
                height: 16,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                amount.toString(),
                style: TextStyle(
                  color: Constants.brandBlueColor,
                  fontSize: 20,
                  height: 27 / 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
