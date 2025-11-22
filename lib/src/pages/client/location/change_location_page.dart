import 'package:flutter/material.dart';

class ChangeLocationPage extends StatelessWidget {
  const ChangeLocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Widget')),
      body: const Center(child: Text('Hello, World!')),
    );
  }
}

// import 'package:flutter/material.dart';

// class ChangeLocationPage extends StatelessWidget {
//   const ChangeLocationPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       // top: false,
//       child: Container(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Center(
//               child: Container(
//                 width: 40,
//                 height: 5,
//                 margin: const EdgeInsets.only(bottom: 15),
//                 decoration: BoxDecoration(
//                   color: Colors.black26,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//             ),
//             const Text(
//               "Seleccionar ubicación",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20),

//             const Text("Aquí podrás agregar contenido, mapa, etc..."),

//             const SizedBox(height: 20),

//             ElevatedButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("Cerrar"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
