import 'package:flutter/material.dart';
import 'package:genix_auctions/core/theme/app_pallete.dart';
import 'package:genix_auctions/core/widgets/gradient_button.dart';
import 'package:genix_auctions/core/widgets/green_pill.dart';
import 'package:genix_auctions/core/widgets/red_gradient_button.dart';
import 'package:genix_auctions/model/auction_model.dart';
import 'package:go_router/go_router.dart';

class AuctionPanel extends StatefulWidget {
  final AuctionModel product;
  final bool hasShadow;
  final time;

  const AuctionPanel({
    super.key,
    this.hasShadow = true,
    required this.product,
    required this.time,
  });

  @override
  State<AuctionPanel> createState() => _AuctionPanelState();
}

class _AuctionPanelState extends State<AuctionPanel> {
  bool isHover = false;

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
                      height: 150,
                      width: double.infinity,
                    )
                    // Image.network(
                    //   'https://via.placeholder.com/300',
                    //   height: 150,
                    //   width: double.infinity,
                    //   fit: BoxFit.cover,
                    // ),
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
            const GreenPill(text: 'Live Auction'),
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
              'Ends in: ${widget.time}',
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
                        context.go('/product/${widget.product.id}');
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
