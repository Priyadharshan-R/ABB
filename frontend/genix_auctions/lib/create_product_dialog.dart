import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateProductDialog extends StatefulWidget {
  final String ownerId;
  final Function(Map<String, dynamic>) onSave;

  const CreateProductDialog({
    Key? key,
    required this.ownerId,
    required this.onSave,
  }) : super(key: key);

  @override
  _CreateProductDialogState createState() => _CreateProductDialogState();
}

class _CreateProductDialogState extends State<CreateProductDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageController = TextEditingController();
  final _minBidPriceController = TextEditingController();
  final _bidEndingTimeController = TextEditingController();
  late String email;

  DateTime? _selectedDateTime;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _imageController.dispose();
    _minBidPriceController.dispose();
    _bidEndingTimeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final product = {
        'owner': widget.ownerId,
        'title': _titleController.text,
        'description': _descriptionController.text,
        'imageUrl': _imageController.text,
        'minimumBidPrice': double.parse(_minBidPriceController.text),
        'bidEndingTime': _selectedDateTime?.toIso8601String(),
        'id': email,
      };

      final response = await http.post(
        Uri.parse(
            'http://localhost:5000/api/products'), // Replace with your backend endpoint
        headers: {'Content-Type': 'application/json'},
        body: json.encode(product),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        widget.onSave(product);
        // Navigator.of(context).pop();
      } else {
        _showErrorDialog('Failed to create product: ${response.body}');
      }
    }
  }

  void getEmail() async {
    final a = await SharedPreferences.getInstance();
    setState(() {
      email = a.getString('user_id')!;
    });
  }

  @override
  void initState() {
    super.initState();
    getEmail();
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
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (date != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
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
    return AlertDialog(
      title: Text('Create New Product'),
      content: Container(
        height: 400,
        width: 600,
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
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _imageController,
                decoration: InputDecoration(
                  labelText: 'Image URL',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the image URL';
                  }
                  return null;
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
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
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
                controller: _bidEndingTimeController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Bid Ending Time',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
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
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: _submit,
          style: TextButton.styleFrom(
            backgroundColor: Colors.lightBlue,
            foregroundColor: Colors.black,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: Text('Save'),
        ),
      ],
    );
  }
}
