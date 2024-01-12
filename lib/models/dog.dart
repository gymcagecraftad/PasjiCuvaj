// event.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Dog {
  String dogBreed;
  String? customRequests;
  int dogAge;
  String dogName;
  String dogId;

  Dog(
      {required this.dogBreed,
      this.customRequests,
      required this.dogAge,
      required this.dogName,
      required this.dogId});

  // Factory constructor to create an Event instance from Firestore data
  factory Dog.fromMap(Map<String, dynamic> data) {
    return Dog(
      dogBreed: data.containsKey('selectedBreed')
          ? data['selectedBreed'] as String
          : '',
      dogAge: data.containsKey('dogAge') ? data['dogAge'] as int : 0,
      dogName: data.containsKey('dogName') ? data['dogName'] as String : '',
      customRequests: data.containsKey('customRequests')
          ? data['customRequests'] as String
          : '',
      dogId: '',
    );
  }

  // Method to set the dogId based on the document ID
  void setDogId(String id) {
    dogId = id;
  }
}

Future<List<Dog>> getUsersDogsFromFirestore(String userId) async {
  try {
    // Access Firebase Firestore instance
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Retrieve the collection 'users_dogs' where userId matches
    QuerySnapshot querySnapshot = await firestore
        .collection('users_dogs')
        .where('userId', isEqualTo: userId)
        .get();

    // Iterate through the retrieved documents and map them to Dog objects
    List<Dog> dogs = querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      Dog dog = Dog.fromMap(data);
      dog.setDogId(doc.id); // Set the dogId based on the document ID
      return dog;
    }).toList();

    // Return the list of Dog objects
    return dogs;
  } catch (e) {
    // Handle errors, if any
    print('Error getting dogs from Firebase: $e');
    return []; // Return an empty list if there's an error
  }
}
