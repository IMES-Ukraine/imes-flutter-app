import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imes/models/balance_card.dart';
import 'package:imes/resources/repository.dart';
import 'package:imes/resources/resources.dart';
import 'package:imes/widgets/base/raised_gradient_button.dart';
import 'package:imes/widgets/dialogs/dialogs.dart';
import 'package:octo_image/octo_image.dart';

class BalanceItem extends StatefulWidget {
  const BalanceItem({
    Key key,
    @required this.card,
  }) : super(key: key);

  final BalanceCard card;

  @override
  _BalanceItemState createState() => _BalanceItemState();
}

class _BalanceItemState extends State<BalanceItem> {
  BalanceCard _card;
  bool _isLoading = false;
  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await Repository().api.getBalanceCardById(_card.id);
      setState(() {
        _card = response.body.data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    _card = widget.card;
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe5e5e5),
      appBar: AppBar(
        elevation: 1,
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
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                _card.name.toUpperCase(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  height: 29 / 24,
                  color: const Color(0xff333333),
                ),
              ),
            ),
            const SizedBox(height: 10),
            if (_card.shortDescription?.isNotEmpty == true) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  _card.shortDescription,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    height: 22 / 16,
                    color: const Color(0xff606060),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
            if (_card?.cover?.isNotEmpty == true) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: AspectRatio(
                  aspectRatio: 17 / 10,
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      color: Color(0xFF00B7FF),
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
                        '''$BASE_URL${_card.cover}''',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(_card.description ?? ''),
            ),
            const SizedBox(height: 106),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        height: 106,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              const Color(0xfff2f2f2),
              Color.fromRGBO(242, 242, 242, 0),
            ],
            stops: [0.56, 1],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 74),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              RaisedGradientButton(
                onPressed: () async {
                  final result = await showWithdrawalDialog<bool>(
                      context, widget.card.cost);
                  if (result == true) {
                    final response =
                        await Repository().api.buyBalanceCard(_card.id);
                    Navigator.of(context).pop(result);
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'ОБМІНЯТИ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        height: 19 / 14,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Image.asset(
                      Images.token,
                      width: 16,
                      height: 16,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      _card.cost.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        height: 19 / 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
