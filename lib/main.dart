import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GestureExample(),
    );
  }
}

class GestureExample extends StatefulWidget {
  @override
  _GestureExampleState createState() => _GestureExampleState();
}

class _GestureExampleState extends State<GestureExample> {
  List<int> doubleTapNumbers = [3, 23, 55, 76, 2, 41, 33, 82, 11, 6];
  List<int> singleTapNumbers = List.generate(100, (index) => index + 1)
    ..remove(67);
  int? displayedNumber; // Ko'rsatilgan raqam
  List<int> selectedNumbers = []; // Tanlangan raqamlar
  bool isLongPressUsed = false; // onLongPress faqat bir marta ishlaydi

  void handleLongPress() {
    if (!isLongPressUsed) {
      setState(() {
        displayedNumber = 67;
        selectedNumbers.add(67);
        isLongPressUsed = true; // Keyingi bosishda ishlamaydi
      });
    }
  }

  void handleDoubleTap() {
    if (doubleTapNumbers.isNotEmpty) {
      final random = Random();
      final index = random.nextInt(doubleTapNumbers.length); // Tasodifiy indeks
      setState(() {
        displayedNumber = doubleTapNumbers[index];
        selectedNumbers.add(doubleTapNumbers[index]);
        doubleTapNumbers.removeAt(index); // Tanlangan raqamni olib tashlash
      });
    }
  }

  void handleSingleTap() {
    if (singleTapNumbers.isNotEmpty) {
      final random = Random();
      final index = random.nextInt(singleTapNumbers.length); // Tasodifiy indeks
      setState(() {
        displayedNumber = singleTapNumbers[index];
        selectedNumbers.add(singleTapNumbers[index]);
        singleTapNumbers.removeAt(index); // Tanlangan raqamni olib tashlash
      });
    }
  }

  void resetAll() {
    setState(() {
      doubleTapNumbers = [3, 23, 55, 76, 2, 41, 33, 82, 11, 6];
      singleTapNumbers = List.generate(100, (index) => index + 1)..remove(67);
      displayedNumber = null;
      selectedNumbers.clear();
      isLongPressUsed = false;
    });
  }

  void showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              textInfo,
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.justify,
            ),
          ),
        );
      },
    );
  }

  void showPinBottomSheet(BuildContext context) {
    final TextEditingController pinController = TextEditingController();
    final String correctPin = "1234";

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            bool pinCorrect = false;

            return Container(
              padding: const EdgeInsets.all(16.0),
              height: 500,
              child: pinCorrect
                  ? Center(
                      child: TextField(
                        controller: pinController,
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter PIN',
                        ),
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Enter 4-digit PIN',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 16),
                        TextField(
                          controller: pinController,
                          keyboardType: TextInputType.number,
                          maxLength: 4,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter PIN',
                          ),
                        ),
                        SizedBox(height: 16),
                        GestureDetector(
                          onTap: () {
                            if (pinController.text == correctPin) {
                              setState(() {
                                pinCorrect = true;
                              });

                              // Show success dialog when the correct PIN is entered
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Success'),
                                    content: Text('The PIN is correct!'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('OK'),
                                        onPressed: () {
                                          Navigator.pop(
                                              context); // Close the dialog
                                          Navigator.pop(
                                              context); // Close the bottom sheet
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              // Show error dialog when the PIN is incorrect
                            }
                          },
                          child: Text('Submit'),
                        ),
                      ],
                    ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: 100,
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: resetAll,
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: const Text(
                    ('Reset'),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: GestureDetector(
                onLongPress: handleLongPress,
                onDoubleTap: handleDoubleTap,
                onTap: handleSingleTap,
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: const Text(
                    'Random',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Random Generator'),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () => showBottomSheet(context),
            onDoubleTap: () => showPinBottomSheet(context),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Icon(
                Icons.info_outline,
                size: 25,
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: const Color.fromARGB(255, 32, 101, 35), width: 3),
                  borderRadius: BorderRadius.circular(150),
                ),
                width: 250,
                height: 250,
                child: Text(
                  displayedNumber != null ? '$displayedNumber' : '0',
                  style: TextStyle(
                      fontSize: 100,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 32, 101, 35)),
                ),
              ),
            ),
          ),
          displayedNumber != null
              ? Container(
                  height: 250,
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    reverse: true,
                    child: Wrap(
                      textDirection: TextDirection.ltr,
                      runAlignment: WrapAlignment.start,
                      spacing: 10,
                      runSpacing: 10,
                      children: selectedNumbers.map((number) {
                        return Card(
                          color: Colors.green[300],
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '$number',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                )
              : SizedBox()
        ],
      ),
    );
  }

  String textInfo = """
A random number generator (RNG) is a system or algorithm designed to generate numbers in a way that is unpredictable or 'random.' In most cases, RNGs are used in applications where fairness and unpredictability are required, such as in gaming, cryptography, and statistical simulations.

A random number generator can produce numbers within a specified range, such as from 1 to 100. It works by using either a true random process (which is based on physical phenomena like atmospheric noise or radioactive decay) or a pseudo-random process (which relies on algorithms that produce number sequences that only appear random).

In programming, RNGs are commonly implemented using functions that generate numbers based on a seed value. A seed is a starting point in the algorithm, and the sequence of generated numbers is determined by this value. In many cases, if you use the same seed, you'll get the same sequence of numbers, which is why it's called "pseudo-random."

Key Uses of Random Number Generators:
- Gaming: Ensuring that game outcomes (like dice rolls or card shuffling) are random.
- Cryptography: Generating secure encryption keys and random passwords.
- Simulations: Performing statistical simulations that rely on random events.
- Testing: Generating random test data for software development.

In most programming languages, RNG functions are built into the standard libraries, making it easy to use random numbers in your applications.
""";
}





/// ----Bluetooth orqali ulash




// import 'package:flutter/material.dart';
// import 'package:flutter_blue/flutter_blue.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: BluetoothApp(),
//     );
//   }
// }

// class BluetoothApp extends StatefulWidget {
//   @override
//   _BluetoothAppState createState() => _BluetoothAppState();
// }

// class _BluetoothAppState extends State<BluetoothApp> {
//   FlutterBlue flutterBlue = FlutterBlue.instance;
//   BluetoothDevice? connectedDevice;
//   String receivedNumber = '';

//   // Bluetoothni skanerlash
//   void scanForDevices() {
//     flutterBlue.startScan(timeout: Duration(seconds: 5));
//     flutterBlue.scanResults.listen((results) {
//       for (ScanResult result in results) {
//         print('Device found: ${result.device.name}');
//         if (result.device.name == "YOUR_DEVICE_NAME") {
//           flutterBlue.stopScan();
//           connectToDevice(result.device);
//           break;
//         }
//       }
//     });
//   }

//   // Qurilmaga ulanish
//   void connectToDevice(BluetoothDevice device) async {
//     await device.connect();
//     setState(() {
//       connectedDevice = device;
//     });
//     discoverServices(device);
//   }

//   // Xizmatlarni aniqlash
//   void discoverServices(BluetoothDevice device) async {
//     List<BluetoothService> services = await device.discoverServices();
//     services.forEach((service) {
//       service.characteristics.forEach((characteristic) {
//         if (characteristic.properties.write) {
//           // Bu joyga yozuv xususiyatini ulash
//         }
//         if (characteristic.properties.notify) {
//           characteristic.setNotifyValue(true);
//           characteristic.value.listen((value) {
//             setState(() {
//               receivedNumber = String.fromCharCodes(value);
//             });
//           });
//         }
//       });
//     });
//   }

//   // Ma'lumot yozish
//   void writeNumber(String number) async {
//     if (connectedDevice != null) {
//       List<BluetoothService> services =
//           await connectedDevice!.discoverServices();
//       for (BluetoothService service in services) {
//         for (BluetoothCharacteristic characteristic
//             in service.characteristics) {
//           if (characteristic.properties.write) {
//             await characteristic.write(number.codeUnits);
//           }
//         }
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Bluetooth App'),
//       ),
//       body: connectedDevice == null
//           ? Center(
//               child: ElevatedButton(
//                 onPressed: scanForDevices,
//                 child: Text('Scan for devices'),
//               ),
//             )
//           : Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   'Connected to: ${connectedDevice!.name}',
//                   style: TextStyle(fontSize: 18),
//                 ),
//                 SizedBox(height: 20),
//                 Text(
//                   'Received Number: $receivedNumber',
//                   style: TextStyle(fontSize: 18),
//                 ),
//                 SizedBox(height: 20),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: TextField(
//                     decoration: InputDecoration(labelText: 'Enter a number'),
//                     keyboardType: TextInputType.number,
//                     onSubmitted: (value) {
//                       writeNumber(value);
//                     },
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }
// }
