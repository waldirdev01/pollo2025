import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pollo2025/app/core/constants/constants.dart';
import 'package:pollo2025/app/core/ui/ap_ui_config.dart';
import 'package:pollo2025/app/database/debug_map.dart';
import 'package:pollo2025/app/modules/app_user/admin/data/data_company.dart';
import 'package:pollo2025/app/modules/app_user/admin/manager_user_type.dart';
import 'package:pollo2025/app/modules/app_user/monitor/monitor_for_ec_list.dart';
import 'package:pollo2025/app/modules/app_user/monitor/monitor_for_itinerary_list.dart';
import 'package:pollo2025/app/modules/app_user/school_member/school_member_home_page.dart';
import 'package:pollo2025/app/modules/auth/select_user_profile_page.dart';
import 'package:pollo2025/app/modules/extracurricular_activity/students_ec/e_c_student_create_form.dart';
import 'package:pollo2025/app/modules/home_page.dart';
import 'package:pollo2025/app/modules/itinerary/itineraries_list.dart';
import 'package:pollo2025/app/modules/itinerary/itinerary_edit_form.dart';
import 'package:pollo2025/app/modules/school/school_create_form.dart';
import 'package:pollo2025/app/modules/school/school_list.dart';

import 'modules/app_user/admin/data/data_home.dart';
import 'modules/app_user/admin/data/generate_for_payment.dart';
import 'modules/app_user/monitor/monitor_home_page.dart';
import 'modules/app_user/school_member/school_member_list.dart';
import 'modules/auth/login/login_page.dart';
import 'modules/auth/register/register_page.dart';
import 'modules/extracurricular_activity/activities/e_c_create_form.dart';
import 'modules/extracurricular_activity/activities/e_c_edit_form.dart';
import 'modules/extracurricular_activity/activities/e_c_list.dart';
import 'modules/extracurricular_activity/activities/extracurricular_activity_home.dart';
import 'modules/itinerary/itineraries_by_school_list.dart';
import 'modules/itinerary/itinerary_create_form.dart';
import 'modules/school/school_details_page.dart';
import 'modules/school/school_edit_form.dart';
import 'modules/splash/splash_page.dart';
import 'modules/student/student_by_name.dart';
import 'modules/student/student_create_form.dart';
import 'modules/student/student_edit_form.dart';
import 'modules/student/students_for_authorized.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Constants.kCOMPANYNAME,
      theme: AppUiConfig.themeCustom,
      locale: Locale('pt', 'BR'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'),
        Locale('en', 'US'),
      ],
      routes: {
        '/': (context) => const SplashPage(),
        Constants.kCOMPANYANALITICS: (context) => const DataCompany(),
        Constants.kDATAHOME: (context) => const DataHome(),
        Constants.kGENERATEDFORPAYMENT: (context) => const GenerateForPayment(),
        Constants.kHOMEROUTE: (context) => const HomePage(),
        Constants.kEXTRACURRICULARACTIVITYHOMEROUTE: (context) =>
            const ExtracurricularActivityHome(),
        Constants.kEXTRACURRICULARACTIVITYCREATEROUTE: (context) =>
            const ECCreateForm(),
        Constants.kEXTRACURRICULARACTIVITYLISTROUTE: (context) =>
            const ECList(),
        Constants.kEXTRACURRICULAREDITROUTE: (context) => const ECEditForm(),
        Constants.kECSTUDENTCREATEROUTE: (context) =>
            const ECStudentCreateForm(),
        Constants.kITINERARIESBYSCHOOLROUTE: (context) =>
            const ItinerariesBySchoolList(),
        Constants.kITINERARYCREATEROUTE: (context) =>
            const ItineraryCreateForm(),
        Constants.kITINERARYEDITROUTE: (context) => const ItineraryEditForm(),
        Constants.kITINERARYLISTROUTE: (context) => const ItinerariesList(),
        Constants.kSCHOOLCREATEROUTE: (context) => const SchoolCreateForm(),
        Constants.kSCHOOLDETAILSROUTE: (context) => const SchoolDetailsPage(),
        Constants.kSCHOOLEDITROUTE: (context) => const SchoolEditForm(),
        Constants.kSCHOOLLISTROUTE: (context) => const SchoolList(),
        Constants.kSCHOOLMEMBERHOMEPAGEROUTE: (context) =>
            const SchoolMemberHomePage(),
        Constants.kSCHOOLMEMBERSLISTROUTE: (context) =>
            const SchoolMemberList(),
        Constants.kSELECTUSERPROFILEROUTE: (context) =>
            const SelectUserProfilePage(),
        Constants.kSTUDENTBYNAMEROUTE: (context) => const StudentsByName(),
        Constants.kSTUDENTCREATEROUTE: (context) => const StudentCreateForm(),
        Constants.kSTUDENTEDITROUTE: (context) => const StudentEditForm(),
        Constants.kSTUDENTSFORAUTHORIZE: (context) =>
            const StudentsForAuthorize(),
        Constants.kUSERLOGINROUTE: (context) => const LoginPage(),
        Constants.kUSERMANAGEUSERTYPEROUTE: (context) =>
            const ManagerUsersType(),
        Constants.kUSERMONITORASFORECLISTROUTE: (context) =>
            const MonitorForECList(),
        Constants.kUSERMONITORASFORITINERARYLISTROUTE: (context) =>
            const MonitorForItineraryList(),
        Constants.kUSERMONITORHOMEPAGEROUTE: (context) =>
            const MonitorHomePage(),
        Constants.kUSERREGISTERROUTE: (context) => const RegisterPage(),
        Constants.kDEBUGPAGE: (context) => const DebugPage(),
      },
    );
  }
}
