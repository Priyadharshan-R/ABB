import 'dart:async';
import 'package:flutter/material.dart';
import 'package:genix_auctions/core/theme/app_pallete.dart';
import 'package:genix_auctions/core/widgets/gradient_button.dart';
import 'package:genix_auctions/core/widgets/green_pill.dart';
import 'package:genix_auctions/core/widgets/red_gradient_button.dart';
import 'package:genix_auctions/model/auction_model.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyProductTile extends StatefulWidget {
  final AuctionModel product;
  final bool hasShadow = true;
  final String time;
  final void Function()? onTap;

  const MyProductTile({
    super.key,
    required this.product,
    required this.time,
    this.onTap,
  });

  @override
  State<MyProductTile> createState() => _MyProductTileState();
}

class _MyProductTileState extends State<MyProductTile> {
  bool isHover = false;
  late Duration diffs;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    diffs = DateTime.parse(widget.time).difference(DateTime.now());
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        diffs = DateTime.parse(widget.time).difference(DateTime.now());
      });
    });
  }

  Future<void> _handleBidNow(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token != null) {
      context.go('/product/${widget.product.id}');
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          isHover = true;
        });
      },
      onExit: (event) {
        setState(() {
          isHover = false;
        });
      },
      child: InkWell(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 250,
          height: 400,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppPallete.white,
            border: isHover ? Border.all(color: Colors.blue) : null,
            boxShadow: widget.hasShadow
                ? const [
                    BoxShadow(
                      color: AppPallete.borderColor,
                      blurRadius: 1,
                      spreadRadius: 0.3,
                      offset: Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.lightBlue,
                      ),
                      child: Image.network(
                        widget.product.imageUrl,
                        fit: BoxFit.fitWidth,
                      ),
                      height: 150,
                      width: double.infinity,
                    ),
                  ),
                  const Positioned(
                    top: 8,
                    right: 8,
                    child: Icon(
                      Icons.favorite_border,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              diffs.isNegative
                  ? const GreenPill(
                      text: 'Auction Ended',
                      red: true,
                    )
                  : const GreenPill(text: 'Live Auction'),
              const SizedBox(height: 8),
              Text(
                widget.product.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Minimum Bid',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    '\$ ${widget.product.minimumBidPrice}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Current Bid',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    '\$ ${widget.product.currentBidPrice}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                diffs.isNegative
                    ? 'Auction Ended'
                    : 'Ends in: ${diffs.inDays} days ${diffs.inHours % 24} hours ${diffs.inMinutes % 60} mins ${diffs.inSeconds % 60} secs',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 16),
              widget.hasShadow
                  ? Center(
                      child: RedGradientButton(
                        text: 'Bid Now',
                        ontap: () {
                          _handleBidNow(context);
                        },
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
