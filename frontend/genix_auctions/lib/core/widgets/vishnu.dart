import 'package:flutter/material.dart';

class AuctionDropdownButton extends StatefulWidget {
  @override
  _AuctionDropdownButtonState createState() => _AuctionDropdownButtonState();
}

class _AuctionDropdownButtonState extends State<AuctionDropdownButton> {
  bool _isHovering = false;
  bool _isDropdownVisible = false;

  void _toggleDropdown() {
    setState(() {
      _isDropdownVisible = !_isDropdownVisible;
    });
  }

  void _showDropdown() {
    setState(() {
      _isDropdownVisible = true;
    });
  }

  void _hideDropdown() {
    setState(() {
      _isDropdownVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        _showDropdown();
      },
      onExit: (_) {
        _hideDropdown();
      },
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Auction',
              style: TextStyle(
                color: _isHovering ? Colors.blue : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (_isDropdownVisible)
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text('Option 1'),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text('Option 2'),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text('Option 3'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
