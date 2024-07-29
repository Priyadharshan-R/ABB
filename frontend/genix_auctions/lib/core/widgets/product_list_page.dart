import 'package:flutter/material.dart';
import 'package:genix_auctions/core/widgets/my_product_tile.dart';
import 'package:genix_auctions/model/auction_model.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ProductListPage extends StatefulWidget {
  final String ownerId;

  const ProductListPage({Key? key, required this.ownerId}) : super(key: key);

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  List<dynamic> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    final response = await http.get(
      Uri.parse('http://localhost:5000/api/products/u/${widget.ownerId}'),
    );

    if (response.statusCode == 200) {
      setState(() {
        _products = json.decode(response.body);
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('Failed to fetch products: ${response.body}');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToUpdateProductPage(String productId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateProductPage(
          ownerId: widget.ownerId,
          productId: productId,
        ),
      ),
    ).then((_) {
      // Refresh product list when returning from update page
      _fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Products')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Wrap(
                  spacing: 16.0,
                  runSpacing: 16.0,
                  children: _products.map((product) {
                    return MyProductTile(
                      product: AuctionModel.fromJson(product),
                      time: product['bidEndingTime'],
                      onTap: () => _navigateToUpdateProductPage(product['_id']),
                    );
                  }).toList(),
                ),
              ),
            ),
    );
  }
}

class UpdateProductPage extends StatefulWidget {
  final String ownerId;
  final String productId;

  const UpdateProductPage({
    Key? key,
    required this.ownerId,
    required this.productId,
  }) : super(key: key);

  @override
  _UpdateProductPageState createState() => _UpdateProductPageState();
}

class _UpdateProductPageState extends State<UpdateProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageController = TextEditingController();
  final _minBidPriceController = TextEditingController();
  final _currentBidPriceController = TextEditingController();
  final _bidEndingTimeController = TextEditingController();
  late String token;
  late String email;
  DateTime? _selectedDateTime;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProductData();
  }

  Future<void> _fetchProductData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final email = prefs.getString('user_id');

    final response = await http.get(
      Uri.parse('http://localhost:5000/api/products/${widget.productId}'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final product = json.decode(response.body);
      setState(() {
        _titleController.text = product['title'];
        _descriptionController.text = product['description'] ?? '';
        _imageController.text = product['imageUrl'];
        _minBidPriceController.text = product['minimumBidPrice'].toString();
        _currentBidPriceController.text = product['currentBidPrice'].toString();
        _selectedDateTime = DateTime.parse(product['bidEndingTime']);
        _bidEndingTimeController.text =
            DateFormat('yyyy-MM-dd - kk:mm').format(_selectedDateTime!);
        _isLoading = false;
      });
    } else {
      _showErrorDialog('Failed to fetch product data: ${response.body}');
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final product = {
        'owner': widget.ownerId,
        'title': _titleController.text,
        'description': _descriptionController.text,
        'imageUrl': _imageController.text,
        'minimumBidPrice': double.parse(_minBidPriceController.text),
        'currentBidPrice': double.parse(_currentBidPriceController.text),
        'bidEndingTime': _selectedDateTime?.toIso8601String(),
      };

      final response = await http.put(
        Uri.parse('http://localhost:5000/api/products/${widget.productId}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(product),
      );

      if (response.statusCode == 200) {
        Navigator.of(context).pop();
      } else {
        _showErrorDialog('Failed to update product: ${response.body}');
      }
    }
  }

  Future<void> _delete() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final email = prefs.getString('user_id');
    final prod = {'email': email};
    print(prod);
    final response = await http.delete(
        Uri.parse('http://localhost:5000/api/products/${widget.productId}'),
        headers: {
          'Authorization': 'Bearer $token',
          'email': '$email',
        },
        body: json.encode(prod));

    if (response.statusCode == 200) {
      Navigator.of(context).pop();
    } else {
      _showErrorDialog('Failed to delete product: ${response.body}');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (date != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime:
            TimeOfDay.fromDateTime(_selectedDateTime ?? DateTime.now()),
      );
      if (time != null) {
        setState(() {
          _selectedDateTime =
              DateTime(date.year, date.month, date.day, time.hour, time.minute);
          _bidEndingTimeController.text =
              DateFormat('yyyy-MM-dd - kk:mm').format(_selectedDateTime!);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update/ Delete Product'),
        backgroundColor: Colors.deepPurple[200],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: 'Title',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the title';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: _descriptionController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _imageController,
                        decoration: InputDecoration(
                          labelText: 'Image URL',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.grey[200],
                          suffixIcon: _imageController.text.isNotEmpty
                              ? SizedBox()
                              : null,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the image URL';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _minBidPriceController,
                        decoration: InputDecoration(
                          labelText: 'Minimum Bid Price',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the minimum bid price';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _currentBidPriceController,
                        decoration: InputDecoration(
                          labelText: 'Current Bid Price',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the current bid price';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _bidEndingTimeController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Bid Ending Time',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.grey[200],
                          suffixIcon: IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: () {
                              _selectDateTime(context);
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the bid ending time';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: _submit,
                            child: Text('Update'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 16),
                              textStyle: TextStyle(fontSize: 16),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: _delete,
                            child: Text('Delete'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 16),
                              textStyle: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
