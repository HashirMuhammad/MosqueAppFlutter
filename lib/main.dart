// main.dart
import 'package:flutter/material.dart';
import 'package:mossq/AddDuaPage.dart';
import 'package:mossq/AddNikkahPage.dart';
import 'package:mossq/AddQuestionPage.dart';
import 'package:mossq/AdminPage.dart';
import 'package:mossq/AllQuestionsPage.dart';
import 'package:mossq/AllQuestionsadmin.dart';
import 'package:mossq/AnnouncementsPage.dart';
import 'package:mossq/AnnouncementsPageadmin.dart';
import 'package:mossq/NikkahBookingsPage.dart';
import 'package:mossq/PrayerTimesPage.dart';
import 'package:mossq/QiblaDirectionPage.dart';
import 'package:mossq/QuestionDetailsPage.dart';
import 'package:mossq/UpdateTimingPage.dart';
import 'package:mossq/UploadBookPage.dart';
import 'package:mossq/bookspage.dart';
import 'package:mossq/mosqueSelection.dart';
import 'package:mossq/signup.dart';
import 'package:mossq/userHome.dart';
import 'login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login Example',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/userHome': (context) => UserHomePage(),
        '/mosqueSelection': (context) => MosqueSelectionPage(),
        '/books': (context) => BooksPage(),
        '/Qibla': (context) => QiblaDirectionPage(),
        '/annoucements': (context) => AnnouncementsPage(),
        '/prayer_timing': (context) => PrayerTimesPage(),
        '/ask_imam': (context) => AddQuestionPage(),
        '/nikkah_booking': (context) => AddNikkahPage(),
        '/view_all_question': (context) => AllQuestionsPage (),



        '/adminHome': (context) => AdminPage(),
        '/Updateprayer_timing': (context) => UpdateTimingPage(),
        '/upload_book': (context) => UploadBookPage(),
        '/nikkah_booking_list': (context) => NikkahBookingsPage(),
        // '/answer_question': (context) => QandAPage (),
        '/add_dua': (context) => AddDuaPage(),
        '/admin_announcements': (context) => AnnouncementsPageadmin(),
        '/view_all_questionadmin': (context) => AllQuestionsAdminPage (),

      },
    );
  }
}

// ... rest of the code ...
