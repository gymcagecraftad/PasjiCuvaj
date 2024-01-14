// create_guardian_event.dart

import 'package:flutter/material.dart';
import 'package:pasji_cuvaj/providers/guardian_event_provider.dart';
import 'package:pasji_cuvaj/models/guardian_event.dart';
import 'package:intl/intl.dart'; // 


class CreateGuardianEventScreen extends StatefulWidget {
  @override
  _CreateGuardianEventScreenState createState() =>
      _CreateGuardianEventScreenState();
}

class _CreateGuardianEventScreenState extends State<CreateGuardianEventScreen> {
  DateTime? _selectedFromDate;
  DateTime? _selectedToDate;
  String? _selectedDwellingType;
  String? _selectedHasYard;
  String? _selectedDogSize;
  String? _selectedRegion;
  int? _maxDogs;
  double? _pricePerDay;

  final TextEditingController _locationController = TextEditingController();

  final GuardianEventProvider guardianEventProvider = GuardianEventProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a Dog Guardian Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'From',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () => _selectDate(context, true),
                child: Text(
                  _selectedFromDate == null
                      ? 'Select From Date'
                      : 'From: ${DateFormat('yyyy-MM-dd').format(_selectedFromDate!)}',
                ),
              ),
              SizedBox(height: 10),
              Text(
                'To',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () => _selectDate(context, false),
                child: Text(
                  _selectedToDate == null
                      ? 'Select To Date'
                      : 'To: ${DateFormat('yyyy-MM-dd').format(_selectedToDate!)}',
                ),
              ),
              SizedBox(height: 10),
              Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      'Dwelling Type:',
      style: TextStyle(
        color: Colors.black, // Set text color to black
        fontSize: 18.0, // Set text font size
        fontWeight: FontWeight.bold, // Set text font weight
      ),
    ),
    SizedBox(height: 8.0),
    Row(
      children: [
        Radio<String>(
          value: 'Apartment',
          groupValue: _selectedDwellingType,
          onChanged: (value) =>
              setState(() => _selectedDwellingType = value),
        ),
        Text(
          'Apartment',
          style: TextStyle(
            fontSize: 16.0,
             // Set text font size for the radio button label
          ),
        ),
        Radio<String>(
          value: 'House',
          groupValue: _selectedDwellingType,
          onChanged: (value) =>
              setState(() => _selectedDwellingType = value),
        ),
        Text(
          'House',
          style: TextStyle(
            fontSize: 16.0,
             // Set text font size for the radio button label
          ),
        ),
      ],
    ),
  ],
),

              SizedBox(height: 10),
              Text(
                'Has Yard:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              DropdownButton<String>(
                hint: Text('Select Has Yard'),
                value: _selectedHasYard,
                items: ['No', 'Yes'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) =>
                    setState(() => _selectedHasYard = value),
              ),
              SizedBox(height: 10),
              Text(
                'Select Dog Size:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              DropdownButton<String>(
                hint: Text('Select Dog Size'),
                value: _selectedDogSize,
                items: ['Small', 'Medium', 'Big'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) =>
                    setState(() => _selectedDogSize = value),
              ),
              SizedBox(height: 10),
              Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      'Maximum number of dogs:',
      style: TextStyle(
        color: Colors.black, // Set text color to black
        fontSize: 18.0, // Set text font size
        fontWeight: FontWeight.bold, // Set text font weight
      ),
    ),
    SizedBox(height: 8.0),
    TextFormField(
      keyboardType: TextInputType.number,
      onChanged: (value) {
        setState(() {
          _maxDogs = int.tryParse(value);
        });
      },
      style: TextStyle(
        fontSize: 16.0, // Set text font size for the input
      ),
      decoration: InputDecoration(
        hintText: 'Enter maximum number of dogs',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        filled: true,
        fillColor: Colors.grey[200], // Set background color
      ),
    ),
  ],
),

              SizedBox(height: 10),
              Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      'Location:',
      style: TextStyle(
        color: Colors.black, // Set text color to black
        fontSize: 18.0, // Set text font size
        fontWeight: FontWeight.bold, // Set text font weight
      ),
    ),
    SizedBox(height: 8.0),
    TextFormField(
      controller: _locationController,
      style: TextStyle(
        fontSize: 16.0, // Set text font size for the input
      ),
      decoration: InputDecoration(
        hintText: 'Enter location',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        filled: true,
        fillColor: Colors.grey[200], // Set background color
      ),
    ),
  ],
),

              SizedBox(height: 10),
              Text(
                'Select Region:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              DropdownButton<String>(
                hint: Text('Select Region'),
                value: _selectedRegion,
                items: [
                  'Pomurska regija',
                  'Podravska regija',
                  'Koroška regija',
                  'Savinjska regija',
                  'Zasavska regija',
                  'Posavska regija',
                  'Jugovzhodna Slovenija',
                  'Osrednjeslovenska regija',
                  'Gorenjska regija',
                  'Primorsko-notranjska regija',
                  'Goriška regija',
                  'Obalno-kraška regija',
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) =>
                    setState(() => _selectedRegion = value),
              ),
              SizedBox(height: 10),
              Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      'Price per day:',
      style: TextStyle(
        color: Colors.black, // Set text color to black
        fontSize: 18.0, // Set text font size
        fontWeight: FontWeight.bold, // Set text font weight
      ),
    ),
    SizedBox(height: 8.0),
    TextFormField(
      keyboardType: TextInputType.number,
      onChanged: (value) {
        setState(() {
          _pricePerDay = double.tryParse(value);
        });
      },
      style: TextStyle(
        fontSize: 16.0, // Set text font size for the input
      ),
      decoration: InputDecoration(
        hintText: 'Enter price per day',
        prefixText: '\$', // Add a currency symbol as a prefix
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        filled: true,
        fillColor: Colors.grey[200], // Set background color
      ),
    ),
  ],
),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Validate and save the form
                  if (_validateAndSaveForm()) {
                    // Create a GuardianEvent object
                    GuardianEvent event = GuardianEvent(
                      id: '', // Generate a unique ID, or use Firestore auto-ID
                      guardianId: '', // Get the currently logged-in user ID
                      fromDate: _selectedFromDate?.toLocal().toString() ?? '',
                      toDate: _selectedToDate?.toLocal().toString() ?? '',
                      location: _locationController.text,
                      housingType: _selectedDwellingType ?? '',
                      hasYard: _selectedHasYard == 'Yes', // Adjust based on your logic
                      dogSize: _selectedDogSize ?? '',
                      maxDogs: _maxDogs ?? 0,
                      pricePerDay: _pricePerDay ?? 0.0,
                      region: _selectedRegion ?? '',  
                    );

                    // Save the event to Firebase using the guardianEventProvider
                    await guardianEventProvider.createGuardianEvent(event);

                    // Navigate back to the HomeScreen
                    Navigator.pushNamedAndRemoveUntil(context, '/my_guardian_events_screen',(route) => false,);
                  }
                },
                style: ElevatedButton.styleFrom(
    primary: Colors.green, // Set the background color to green
                ),
                child: Text(
    'Create Event',
    style: TextStyle(
      color: Colors.black, // Set text color to black
      fontSize: 16.0, // Set text font size
      fontWeight: FontWeight.bold, // Set text font weight
    ),
  ),
),
              
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != DateTime.now()) {
      setState(() {
        if (isFromDate) {
          _selectedFromDate = pickedDate;
        } else {
          _selectedToDate = pickedDate;
        }
      });
    }
  }

  bool _validateAndSaveForm() {
    if (_selectedFromDate == null ||
        _selectedToDate == null ||
        _selectedDwellingType == null ||
        _selectedHasYard == null ||
        _selectedDogSize == null ||
        _maxDogs == null ||
        _pricePerDay == null ||
        _locationController.text.isEmpty) {
      // If any field is missing, show an alert
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Missing Information'),
            content: Text('Please fill in all the fields.'),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return false;
    } else if (_selectedFromDate!.isAfter(_selectedToDate!)) {
      // If From date is after To date, show an alert
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Invalid Date Range'),
            content: Text('From date cannot be after To date.'),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return false;
    } else if (_maxDogs! <= 0) {
      // If Max Dogs is less than or equal to 0, show an alert
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Invalid Maximum Number of Dogs'),
            content: Text('Maximum number of dogs must be greater than 0.'),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return false;
    }
    return true;
  }
}
