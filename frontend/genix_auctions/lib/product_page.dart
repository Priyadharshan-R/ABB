import 'package:flutter/material.dart';
import 'package:genix_auctions/core/theme/app_pallete.dart';
import 'package:genix_auctions/core/widgets/auction_panel.dart';
import 'package:genix_auctions/core/widgets/nav_bar.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          NavBar(),
          Container(
            color: AppPallete.white,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 100.0,
                vertical: 25.0,
              ),
              child: Row(
                children: [
                  // back to catalog
                  Row(
                    children: [
                      Column(
                        children: [
                          // AuctionPanel(
                          //   title: 'title',
                          //   minimumBidPrice: 30,
                          //   currentBidPrice: 10,
                          //   id: 64165,
                          //   time: 615,
                          // )
                        ],
                      )
                    ],
                  ),
                  //product description
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 65,
                        child: Text(
                            overflow: TextOverflow.clip,
                            'asdffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffasgagaabsufbasbioabfubasfbuiosafiabsyfasofbyuasvuasvfasvyufvawuyfvyuavfuyavuyfvauvfyuasfubafbasfbasbfuasbfbasufbasufvuasvfuasvfusavfuysavfudasvfyuadvfuyvsauyfvasuyfvuyadfuyasfuasfyusafyisadyfvasuyfusafuasf'),
                      )
                    ],
                  ),
                  //history
                  Row(
                    children: [Text('history')],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
