import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_fly/Student_details_view_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';


class TextFieldPage extends StatefulWidget {
  @override
  _TextFieldPageState createState() => _TextFieldPageState();
}

class _TextFieldPageState extends State<TextFieldPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController DateController = TextEditingController();

  List<String> images = ["assets/images/default_car.png"];

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        images.add(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('Add Your Detials'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'name'),
            ),
            TextFormField(
              controller: ageController,
              decoration: InputDecoration(labelText: 'age'),
            ),
            TextFormField(
              controller: mobileController,
              decoration: InputDecoration(labelText: 'Mobile number'),
            ),
            TextFormField(
              controller: DateController,
              decoration: InputDecoration(labelText: 'Date of birth'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              onPressed: () {
                pickImage(); // Call this method to pick an image
              },
              child: Text('Pick Image'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              onPressed: () {
                saveCarData();
              },
              child: Text('Save Detials'),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CarListScree1()),
                );
              },
              icon: Icon(Icons.verified),
              label: Text("View your details"),
            ),
          ],
        ),
      ),
    );
  }

  void saveCarData() async {
    String name = nameController.text;
    String age = ageController.text;
    double price = double.tryParse(mobileController.text) ?? 0.0;
    String date = DateController.text;

    String imageUrl = await uploadImage(images.last);

    // Save the data to Firestore
    FirebaseFirestore.instance.collection('products').add({
      'name': name,
      'age': age,
      'price': price,
      'date': date,
      'images': [imageUrl],
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Details successfully!'),
      ));
      Navigator.pop(context);
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to Details.'),
      ));
    });
  }

  Future<String> uploadImage(String imagePath) async {
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('car_images/${DateTime.now()}.png');

    UploadTask uploadTask = storageReference.putFile(File(imagePath));

    TaskSnapshot taskSnapshot = await uploadTask;

    String imageUrl = await taskSnapshot.ref.getDownloadURL();

    return imageUrl;
  }
}
