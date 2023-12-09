import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class CarListScree1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('Students Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {

              // Add your settings function here
              print('Settings button pressed');
            },
          ),
        ],
      ),
      body: CarList(),
    );
  }
}

class CarList extends StatefulWidget {
  @override
  _CarListState createState() => _CarListState();
}

class _CarListState extends State<CarList> {
  final CollectionReference carsCollection =
      FirebaseFirestore.instance.collection('students');
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: SizedBox(
            height: 50,
            width: 350,
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(29),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: carsCollection
                .where('model',
                    isGreaterThanOrEqualTo: searchController.text.toLowerCase())
                .where('model',
                    isLessThan: searchController.text.toLowerCase() +
                        'z') // Adjust as needed
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('No students available.'));
              }

              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var carData =
                      snapshot.data!.docs[index].data() as Map<String, dynamic>;
                  var carImages = carData['images'];
                  var carBrand = carData['name'];
                  var carModel = carData['age'];
                  var carCondition = carData['mobilenumber'];
                  var carPrice = carData['dateofbirth'];

                  return Card(
                    elevation: 8,
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(20),
                      leading: Image.network(
                          carImages != null && carImages.isNotEmpty
                              ? carImages[0]
                              : ''),
                      title: Text('$carBrand $carModel'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('age: $carCondition'),
                          Text('mobile number: $carPrice'),
                        ],
                      ),

                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
