import 'dart:async';
import 'package:flutter/material.dart';
import 'package:genix_auctions/core/theme/app_pallete.dart';
import 'package:genix_auctions/core/widgets/gradient_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:genix_auctions/core/widgets/green_pill.dart';
import 'package:genix_auctions/core/widgets/red_gradient_button.dart';
import 'package:genix_auctions/model/auction_model.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuctionPanel extends StatefulWidget {
  final AuctionModel product;
  final isUpdate;
  final bool hasShadow;
  final String time;

  const AuctionPanel({
    super.key,
    this.hasShadow = true,
    required this.product,
    required this.time,
    this.isUpdate = false,
  });

  @override
  State<AuctionPanel> createState() => _AuctionPanelState();
}

class _AuctionPanelState extends State<AuctionPanel> {
  bool isHover = false;
  late Duration diffs;
  late Timer _timer;
  bool isFavorite = false;
  bool flag = true;

  @override
  void initState() {
    super.initState();
    diffs = DateTime.parse(widget.time).difference(DateTime.now());
    _startTimer();
    _checkIfFavorite();
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
        if (diffs.isNegative && flag) {
          flag = false;
          _handlewinner(context);
        }
      });
    });
  }

  Future<void> _checkIfFavorite() async {
    // Check if the product is already in user's favorites
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? favorites = prefs.getString('favorites');

    if (favorites != null && favorites.contains(widget.product.id)) {
      setState(() {
        isFavorite = true;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    final String? email = prefs.getString('user_id');

    if (token == null) {
      context.go('/login');
      return;
    }

    final response = await http.put(
      Uri.parse('http://localhost:5000/api/users/favorites'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'productId': widget.product.id, 'email': email}),
    );

    if (response.statusCode == 200) {
      setState(() {
        isFavorite = !isFavorite;
      });
    } else {
      // Handle error
      print('Failed to update favorites');
    }
  }

  Future<void> _handlewinner(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token')!;
    final String email = prefs.getString('user_id')!;
    final String username = prefs.getString('username')!;

    final response = await http.put(
        Uri.parse(
          'http://localhost:5000/api/products/winner',
        ),
        body: json.encode({
          'productId': widget.product.id,
          'email': email,
          "username": username
        }));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
    } else {
      throw Exception('Failed to load products');
    }
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 250,
        height: 400,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppPallete.white,
          border: isHover ? Border.all(color: Colors.transparent) : null,
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
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: Colors.white,
                    ),
                    onPressed: _toggleFavorite,
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
    );
  }
}
