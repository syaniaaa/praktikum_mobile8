import 'package:flutter/material.dart';
import 'package:wisata_app/helper/session_manager.dart';
import 'package:wisata_app/models/tourism_place.dart';
import 'package:wisata_app/screens/detail_screen.dart';
import 'package:wisata_app/services/tourism_place_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

Future<void> checkLoginStatus(BuildContext context) async {
  await SessionManager().checkLoginStatus(context);
}

class _MainScreenState extends State<MainScreen> {
  late Future<List<TourismPlace>> _tourismPlaces;

  @override
  void initState() {
    super.initState();
    _tourismPlaces = TourismPlaceService.getTourismPlaces();
    checkLoginStatus(context);
  }

  Future<void> _refresh() async {
    setState(() {
      _tourismPlaces = TourismPlaceService.getTourismPlaces();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wisata Bandung'),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<TourismPlace>>(
          future: _tourismPlaces,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No data available'));
            } else {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final TourismPlace place = snapshot.data![index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(place: place),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 4.0,
                      margin: EdgeInsets.all(8.0),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(8.0),
                        leading: AspectRatio(
                          aspectRatio: 1,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              place.image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: Text(
                          place.name,
                          style: TextStyle(fontSize: 16.0),
                        ),
                        subtitle: Text(place.location),
                      ),
                    ),
                  );
                },
                itemCount: snapshot.data!.length,
              );
            }
          },
        ),
      ),
    );
  }
}
