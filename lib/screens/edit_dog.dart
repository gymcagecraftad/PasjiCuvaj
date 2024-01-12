import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pasji_cuvaj/models/dog.dart';

class EditDog extends StatefulWidget {
  final Dog dog; // Dog to be edited
  final Function()? onDogUpdated; // Callback function
  EditDog({required this.dog, this.onDogUpdated});

  @override
  _EditDogState createState() => _EditDogState();
}

class _EditDogState extends State<EditDog> {
  String? selectedBreed;
  String dogName = '';
  int? dogAge;
  String? customRequests = '';

  final List<String> breeds = [
    "Angleški buldog",
    "Angleški koker španjel",
    "Avstralski kelpie",
    "Avstralski ovčar",
    "Avstralski terier",
    "Basenji",
    "Baset",
    "Bavarski barvar",
    "Beagle",
    "Belgijeski ovčar",
    "Bernardinec",
    "Bernski planšar",
    "Bichon frisé",
    "Bolonjec",
    "Borderski ovčar",
    "Bostonski terier",
    "Bradati škotski ovčar",
    "Bulterier",
    "Cairnski terier",
    "Cane Corso",
    "Cavalier King Charles španjel",
    "Čivava",
    "Coton de Tulear",
    "Dalmatinec",
    "Doberman",
    "Elo",
    "Evrazijec",
    "Francoski buldog",
    "Havanski bišon",
    "Hrvaški ovčar",
    "Irski rdeči seter",
    "Jazbečar",
    "Kitajski goli pes",
    "Kratkodlaki škotski ovčar",
    "Kromforlander",
    "Labradorec",
    "Mali angleški hrt (Whippet)",
    "Mali in srednji nemški špic",
    "Mali italijanski hrt",
    "Mali pudelj",
    "Maltežan",
    "Miniaturni pinč",
    "Mops",
    "Nemška doga",
    "Nemški bokser",
    "Nemški kratkodlaki ptičar",
    "Nemški ovčar",
    "Nemški pinč",
    "Nemški volčji špic",
    "Pomeranec",
    "Pomsky",
    "Pritlikavi jazbečar",
    "Pritlikavi šnavcer",
    "Rotvajler",
    "Ruski hrt (Borzoj)",
    "Ruski mali terier",
    "Samojed",
    "Šarpej",
    "Sibirski husky",
    "Tibetanski terier",
    "Veliki angleški hrt",
    "Višavski terier",
    "Yorkshirski terier (Yorkie)",
    "Zlati prinašalec"
  ];

  bool completeData = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Initialize state based on the provided dog information
    dogName = widget.dog.dogName;
    dogAge = widget.dog.dogAge;
    selectedBreed = widget.dog.dogBreed;
    customRequests = widget.dog.customRequests;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Dog'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: dogName,
                decoration: InputDecoration(labelText: 'Dog name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a dog name';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    dogName = value;
                    checkDataCompletion();
                  });
                },
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Text('Age: '),
                  SizedBox(width: 8.0),
                  DropdownButton<int>(
                    value: dogAge,
                    onChanged: (value) {
                      setState(() {
                        dogAge = value!;
                        checkDataCompletion();
                      });
                    },
                    items: List.generate(30, (index) => index + 1)
                        .map((age) => DropdownMenuItem<int>(
                              value: age,
                              child: Text('$age'),
                            ))
                        .toList(),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Text('Dog breed: '),
                  DropdownButton<String>(
                    hint: Text('Select your dog breed'),
                    value: selectedBreed,
                    onChanged: (newValue) {
                      setState(() {
                        selectedBreed = newValue;
                        checkDataCompletion();
                      });
                    },
                    items: breeds.map((breed) {
                      return DropdownMenuItem<String>(
                        value: breed,
                        child: Text(breed),
                      );
                    }).toList(),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              TextFormField(
                initialValue: customRequests,
                decoration: InputDecoration(
                  labelText: 'Custom Requests',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    customRequests = value;
                  });
                },
                maxLines: 10,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                textAlignVertical: TextAlignVertical.top,
              ),
              SizedBox(height: 24.0),
              Container(
                width: double.infinity,
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() && completeData) {
                      updateDogInFirebase();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.yellow,
                    onPrimary: Colors.black,
                    side: BorderSide(color: Colors.black),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Update Dog'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void checkDataCompletion() {
    setState(() {
      completeData =
          dogName.isNotEmpty && dogAge != null && selectedBreed != null;
    });
  }

  Future<void> updateDogInFirebase() async {
    try {
      // Access Firebase Firestore instance
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Create a map containing the updated dog information
      Map<String, dynamic> updatedDogData = {
        'selectedBreed': selectedBreed,
        'dogName': dogName,
        'dogAge': dogAge,
        'customRequests': customRequests,
      };

      // Update the dog data in the Firestore collection using the correct document ID
      await firestore
          .collection('users_dogs')
          .doc(widget.dog.dogId) // Use the correct document ID
          .update(updatedDogData);

      // Call the onDogUpdated callback to trigger a refresh
      if (widget.onDogUpdated != null) {
        widget.onDogUpdated!();
      }

      // Navigate back to the previous screen
      Navigator.pop(context);
    } catch (e) {
      // Handle errors, if any
      print('Error updating dog in Firebase: $e');
    }
  }
}
