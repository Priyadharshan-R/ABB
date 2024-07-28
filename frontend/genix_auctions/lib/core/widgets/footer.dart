import 'package:flutter/material.dart';
import 'package:genix_auctions/core/theme/app_pallete.dart';
import 'package:genix_auctions/core/widgets/logo.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: AppPallete.white),
      height: 270,
      child: Center(
        child: Container(
          height: 270,
          width: MediaQuery.of(context).size.width * 0.82,
          decoration: const BoxDecoration(
            color: AppPallete.footer,
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 75.0,
              vertical: 75.0,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Logo(
                      color: AppPallete.white,
                    ),
                    Column(
                      children: [
                        Text(
                          'Products',
                          style: TextStyle(
                            color: AppPallete.white,
                          ),
                        ),
                        Text(
                          'About us',
                          style: TextStyle(
                            color: AppPallete.white,
                          ),
                        ),
                        Text(
                          'Contact',
                          style: TextStyle(
                            color: AppPallete.white,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Auctions',
                      style: TextStyle(
                        color: AppPallete.white,
                      ),
                    ),
                    Text(
                      'Bidding',
                      style: TextStyle(
                        color: AppPallete.white,
                      ),
                    ),
                    Wrap(
                      children: [
                        Icon(
                          Icons.facebook,
                          color: AppPallete.white,
                        ),
                        Icon(
                          Icons.facebook,
                          color: AppPallete.white,
                        ),
                        Icon(
                          Icons.facebook,
                          color: AppPallete.white,
                        ),
                        Icon(
                          Icons.facebook,
                          color: AppPallete.white,
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(),
                Text(
                  '@ Copyright 2024, All Rights Reserved by Genix',
                  style: TextStyle(
                    color: AppPallete.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
