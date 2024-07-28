import 'package:flutter/material.dart';
import 'package:genix_auctions/core/widgets/sub_nav.dart';

class NavigationButton extends StatefulWidget {
  final String text;
  final List<String> subItems;

  const NavigationButton(
      {required this.text, this.subItems = const [], Key? key})
      : super(key: key);

  @override
  _NavigationButtonState createState() => _NavigationButtonState();
}

class _NavigationButtonState extends State<NavigationButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: SizedBox(
        height: 150,
        child: Column(
          children: [
            InkWell(
              onTap: () {},
              child: SizedBox(
                width: 90,
                child: Row(
                  children: [
                    Text(
                      widget.text,
                      style:
                          const TextStyle(fontFamily: "Outfit", fontSize: 14),
                    ),
                    const Icon(Icons.keyboard_arrow_down_rounded)
                  ],
                ),
              ),
            ),
            if (_isHovered && widget.subItems.isNotEmpty)
              Container(
                color: Colors.white,
                child: Column(
                  children: widget.subItems
                      .map((subItem) => SubNavigationButton(
                            text: subItem,
                            onTap: () {
                              // Handle sub-item tap
                            },
                          ))
                      .toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
