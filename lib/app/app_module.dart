import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pollo2025/app/providers/app_user_provider.dart';
import 'package:pollo2025/app/providers/e_c_student_provider.dart';
import 'package:pollo2025/app/providers/itinerary_provider.dart';
import 'package:pollo2025/app/providers/school_provider.dart';
import 'package:pollo2025/app/providers/student_provider.dart';

import 'app_widget.dart';
import 'providers/app_auth_provider.dart';
import 'providers/e_c_activity_provider.dart';
import 'providers/for_payment_provider.dart';

class AppModule extends StatelessWidget {
  const AppModule({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => FirebaseAuth.instance),
        Provider(create: (_) => FirebaseFirestore.instance),
        ChangeNotifierProvider(
          create: (context) => AppAuthProvider(
            firebaseAuth: context.read(),
            firebaseFirestore: context.read(),
          ),
        ),
        ChangeNotifierProvider(
            create: (context) =>
                AppUserProvider(firebaseFirestore: context.read())),
        ChangeNotifierProvider(
            create: (context) =>
                ItineraryProvider(firebaseFirestore: context.read())),
        ChangeNotifierProvider(
            create: (context) =>
                SchoolProvider(firebaseFirestore: context.read())),
        ChangeNotifierProvider(
            create: (context) =>
                StudentProvider(firebaseFirestore: context.read())),
        ChangeNotifierProvider(
            create: (context) =>
                ECActivityProvider(firebaseFirestore: context.read())),
        ChangeNotifierProvider(
            create: (context) =>
                ECStudentProvider(firebaseFirestore: context.read())),
        ChangeNotifierProvider(
            create: (context) =>
                ForPaymentProvider(firebaseFirestore: context.read())),
      ],
      child: const AppWidget(),
    );
  }
}
