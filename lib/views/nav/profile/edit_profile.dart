import 'package:agritechv2/styles/color_styles.dart';
import 'package:flutter/material.dart';

// class EditProfilePage extends StatefulWidget {
//   const EditProfilePage({super.key});

//   @override
//   State<EditProfilePage> createState() => _EditProfilePageState();
// }

// class _EditProfilePageState extends State<EditProfilePage> {
  
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: ColorStyle.brandRed,
//         title: const Text('Edit Profile'),
//       ),
//       body: Expanded(
//           child: Center(
//         child: Column(
//           children: [
//             TextFormField(
//               decoration: const InputDecoration(
//                 labelText: 'Fullname *',
//                 border: OutlineInputBorder(),
//               ),
//               onChanged: (value) {
//                 fullname = value;
//               },
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return "Fullname is required";
//                 }
//                 return null;
//               },
//             ),
//           ],
//         ),
//       )),
//     );
//   }
// }
