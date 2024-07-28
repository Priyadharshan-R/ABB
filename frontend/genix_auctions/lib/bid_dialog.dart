import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BidDialog extends StatefulWidget {
  final String productName;
  final double minimumBid;
  final double currentBid;
  final String endTime;
  final String productId;

  const BidDialog({
    super.key,
    required this.productName,
    required this.minimumBid,
    required this.currentBid,
    required this.endTime,
    required this.productId,
  });

  @override
  _BidDialogState createState() => _BidDialogState();
}

class _BidDialogState extends State<BidDialog> {
  final _straightBidController = TextEditingController();
  final _maxBidController = TextEditingController();

  @override
  void dispose() {
    _straightBidController.dispose();
    _maxBidController.dispose();
    super.dispose();
  }

  Future<void> _submitBid() async {
    final straightBid = int.parse(_straightBidController.text);
    final maxBid = int.parse(_maxBidController.text);

    final bidData = {
      'username': 'equinox',
      'price': straightBid,
      'maxBid': maxBid,
      'productId': widget.productId,
    };

    print(bidData);

    final response = await http.put(
      Uri.parse('http://localhost:5000/api/bids'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(bidData),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Handle successful bid submission
      Navigator.of(context).pop();
    } else {
      // Handle error
      print('Failed to submit bid: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Text('Submit Bid'),
          Spacer(),
          Text(widget.productName),
          Spacer(),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            _buildBidField('Straight bid', _straightBidController),
            SizedBox(height: 10),
            _buildBidField('Maximum bid', _maxBidController),
            SizedBox(height: 20),
            _buildBidInfo(),
          ],
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: _submitBid,
          child: Text('Submit'),
        ),
      ],
    );
  }

  Widget _buildBidField(String label, TextEditingController controller) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(labelText: label, prefixText: '\$'),
            keyboardType: TextInputType.number,
          ),
        ),
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: () {
            setState(() {
              double currentValue = double.parse(controller.text);
              controller.text = (currentValue - 1).toString();
            });
          },
        ),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            setState(() {
              double currentValue = double.parse(controller.text);
              controller.text = (currentValue + 1).toString();
            });
          },
        ),
      ],
    );
  }

  Widget _buildBidInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Minimum Bid: \$${widget.minimumBid.toStringAsFixed(2)}'),
        SizedBox(height: 5),
        Text('Current Bid: \$${widget.currentBid.toStringAsFixed(2)}'),
        SizedBox(height: 5),
        Text('Ends in: ${widget.endTime}'),
      ],
    );
  }
}
