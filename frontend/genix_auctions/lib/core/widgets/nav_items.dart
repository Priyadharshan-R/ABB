import 'package:flutter/material.dart';

class NavItems extends StatefulWidget {
  final String text;
  final IconData icon;
  final IconData? leadingIcon;
  final List<String> options;

  const NavItems({
    Key? key,
    required this.text,
    required this.icon,
    this.leadingIcon,
    required this.options,
  }) : super(key: key);

  @override
  _NavItemState createState() => _NavItemState();
}

class _NavItemState extends State<NavItems> {
  bool _isHovered = false;
  bool _isClicked = false;

  void _showOptions() {
    setState(() {
      _isHovered = true;
    });
  }

  void _hideOptions() {
    setState(() {
      _isHovered = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _isClicked = !_isClicked),
      child: MouseRegion(
        onEnter: (_) => _showOptions(),
        onExit: (_) => _hideOptions(),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Row(
              children: [
                if (widget.leadingIcon != null) Icon(widget.leadingIcon),
                const SizedBox(width: 8),
                Text(widget.text),
                const SizedBox(width: 8),
                Icon(widget.icon),
              ],
            ),
            if (_isHovered || _isClicked)
              Positioned(
                top: 40,
                left: 0,
                child: Material(
                  elevation: 4.0,
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: widget.options
                          .map((option) => _buildOption(option))
                          .toList(),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(String option) {
    return GestureDetector(
      onTap: () {
        // Handle the click event here
        print('Clicked on $option');
        // Optionally, hide options after selection
        setState(() {
          _isClicked = false;
          _isHovered = false;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Text(option, style: TextStyle(color: Colors.grey[600])),
      ),
    );
  }
}
