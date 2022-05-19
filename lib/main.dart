import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:polyline_generator/result.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<FormState> validatorKey = GlobalKey();
  final TextEditingController originLatController = TextEditingController();
  final TextEditingController originLngController = TextEditingController();
  final TextEditingController destinationLatController =
      TextEditingController();
  final TextEditingController destinationLngController =
      TextEditingController();
  final TextEditingController waypointsController = TextEditingController();

  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 200.0),
          child: Form(
            key: validatorKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Origin *'),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: originLatController,
                            validator: latLngValidator,
                            decoration: const InputDecoration(
                              hintText: 'latitude',
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: originLngController,
                            validator: latLngValidator,
                            decoration: const InputDecoration(
                              hintText: 'longitude',
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Destination *'),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: destinationLatController,
                            validator: latLngValidator,
                            decoration: const InputDecoration(
                              hintText: 'latitude',
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: destinationLngController,
                            validator: latLngValidator,
                            decoration: const InputDecoration(
                              hintText: 'longitude',
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Waypoints *'),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: waypointsController,
                            validator: waypointsValidator,
                            decoration: const InputDecoration(
                              hintText:
                                  'Enter the intermediates here in the format of longitude,latitude;',
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: onGenerate,
                  child: ValueListenableBuilder(
                    valueListenable: isLoading,
                    builder: (context, _, __) {
                      return isLoading.value
                          ? const SizedBox(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                              ),
                            )
                          : const Text(
                              'GENERATE',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            );
                    },
                  ),
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(
                      const Size(double.maxFinite, 50),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? latLngValidator(String? input) {
    if (double.tryParse(input ?? '') == null) {
      return 'enter a valid input';
    } else {
      return null;
    }
  }

  String? waypointsValidator(String? input) {
    if (input?.isEmpty ?? true) {
      return 'enter a valid waypoint';
    } else {
      return null;
    }
  }

  void onGenerate() async {
    if (validatorKey.currentState?.validate() ?? false) {
      isLoading.value = true;
      final http.Response response = await http.get(
        Uri.parse('https://routing.openstreet'
            'map.de/routed-car/route/v1/driving/${originLngController.text.trim()},'
            '${originLatController.text.trim()};${waypointsController.text.trim()};'
            '${destinationLngController.text.trim()},${destinationLatController.text.trim()}'),
      );
      isLoading.value = false;
      try {
        final String encodedPolyline =
            jsonDecode(response.body)['routes'][0]['geometry'];
        print(jsonDecode(response.body));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ResultScreen(encodedPolyline: encodedPolyline),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No routes found for the given input.'),
          ),
        );
      }
    }
  }
}
