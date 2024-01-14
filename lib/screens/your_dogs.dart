import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pasji_cuvaj/models/dog.dart';
import 'package:pasji_cuvaj/screens/add_dog.dart';
import 'package:pasji_cuvaj/providers/auth_provider.dart';
import 'package:pasji_cuvaj/screens/edit_dog.dart';

class YourDogs extends StatefulWidget {
  @override
  _YourDogsState createState() => _YourDogsState();
}

class _YourDogsState extends State<YourDogs> {
  List<Dog> dogs = [];
  final AuthProvider authProvider = AuthProvider();

  @override
  void initState() {
    super.initState();
    fetchDogData();
  }

  Future<void> fetchDogData() async {
    String? currentUserId = authProvider.getCurrentUserUid();

    if (currentUserId != null) {
      List<Dog> fetchedDogs = await getUsersDogsFromFirestore(currentUserId);

      setState(() {
        dogs = fetchedDogs;
      });
    } else {
      // Handle the case where currentUserId is null
      print('Current user ID is null.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your registred dogs'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _navigateToAddDogScreen,
          ),
        ],
      ),
      body: dogs.isNotEmpty
          ? ListView.builder(
              itemCount: dogs.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () async {
                    await _navigateToEditDogScreen(dogs[index]);
                  },
                  onLongPress: () {
                    _showDeleteConfirmationDialog(dogs[index]);
                  },
                  child: Container(
                    margin: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ListTile(
                       leading: Icon(
      Icons.pets, // Add your desired icon here
      color: Colors.white,
      size: 36.0,
    ),
                      title: Text(
                        dogs[index].dogName,
                        style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 25.0),
                      ),  
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Age: ${dogs[index].dogAge.toString()}',
                            style: TextStyle(
                               fontSize: 20.0,
                               color: Colors.white),
                          ),
                          Text(
                            'Breed: ${dogs[index].dogBreed}',
                            style: TextStyle(color: Colors.white, fontSize: 20.0,),
                          ),
                          Text(
                            'Custom Requests: ${dogs[index].customRequests}',
                            style: TextStyle(color: Colors.white, fontSize: 16.0,),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          : Center(
              child: dogs.isEmpty
                  ? Text('No dogs to view.')
                  : CircularProgressIndicator(),
            ),
    );
  }

  Future<void> _navigateToAddDogScreen() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddDog(
          onDogAdded: refreshDogData,
        ),
      ),
    );
  }

  Future<void> _navigateToEditDogScreen(Dog selectedDog) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditDog(
          dog: selectedDog,
          onDogUpdated: refreshDogData,
        ),
      ),
    );
  }

  Future<void> refreshDogData() async {
    await fetchDogData();
    setState(() {});
  }

  Future<void> _showDeleteConfirmationDialog(Dog dog) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete'),
          content:
              Text('Are you sure you want to delete your dog ${dog.dogName}?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Call the function to delete the dog
                _deleteDogFromFirebase(dog);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteDogFromFirebase(Dog dog) async {
    try {
      // Access Firebase Firestore instance
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Delete the dog from the Firestore collection using the correct document ID
      await firestore
          .collection('users_dogs')
          .doc(dog.dogId) // Use the correct document ID
          .delete();

      // Refresh the dog data after deletion
      await fetchDogData();
      setState(() {});
    } catch (e) {
      // Handle errors, if any
      print('Error deleting dog from Firebase: $e');
    }
  }
}
