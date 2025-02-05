import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart'; // İzinler için ekledik unutma bunu
import 'community_news.dart';
import 'events_calendar.dart';
import 'advisors.dart';
import 'tournaments_results.dart';
import 'teams_players.dart';
import 'member_registration.dart';
import 'member_profiles.dart';
import 'feedback.dart';
import 'social_media.dart';
import 'tournament_registration.dart';
import 'current_economy.dart';
import 'live_market.dart';
import 'community_managers.dart';
import 'poll.dart';
import 'member_join.dart';
import 'sponsors_page.dart';
import 'sponsor_ads_page.dart';
import 'update_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase'i başlat
  await Firebase.initializeApp();

  // Firebase bildirimlerini dinlemeye başla
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Received message: ${message.notification?.title}');
    // Burada, mesaj geldiğinde yapacağınız işlemleri tanımlayabilirsiniz
  });

  // Bildirim iznini iste
  await _requestNotificationPermission();

  // Depolama iznini iste
  await _requestStoragePermission();

  // FCM Token al
  await _getFCMToken();

  // Durum çubuğunu gizle
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  runApp(const MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message: ${message.messageId}');
  // Arka planda gelen bildirimlere yapılacak işlemleri buraya ekleyebilirsiniz.
}

Future<void> _requestNotificationPermission() async {
  // Bildirim iznini kontrol et ve iste
  PermissionStatus status = await Permission.notification.request();

  if (status.isGranted) {
    print("Bildirim izni verildi!");
  } else if (status.isDenied) {
    print("Bildirim izni reddedildi.");
  } else if (status.isPermanentlyDenied) {
    print(
        "Bildirim izni kalıcı olarak reddedildi. Ayarlardan izin verebilirsiniz.");
    // Eğer izin kalıcı olarak reddedildiyse, kullanıcıyı ayarlara yönlendirebilirsiniz:
    openAppSettings();
  }
}

Future<void> _requestStoragePermission() async {
  // Depolama iznini kontrol et ve iste
  PermissionStatus status = await Permission.storage.request();

  if (status.isGranted) {
    print("Depolama izni verildi!");
  } else if (status.isDenied) {
    print("Depolama izni reddedildi.");
  } else if (status.isPermanentlyDenied) {
    print(
        "Depolama izni kalıcı olarak reddedildi. Ayarlardan izin verebilirsiniz.");
    // Eğer izin kalıcı olarak reddedildiyse, kullanıcıyı ayarlara yönlendirebilirsiniz:
    openAppSettings();
  }
}

Future<void> _getFCMToken() async {
  String? token = await FirebaseMessaging.instance.getToken();
  print("Firebase Token: $token"); // Token'ı konsola yazdır
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EKOS',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 40.0, bottom: 20.0),
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF7C4DFF), Color(0xFF18FFFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 6.0,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/kkulogo.png',
                        height: 60.0, // Yüksekliği artırdık
                      ),
                      const SizedBox(width: 8.0),
                      const Text(
                        'Kırıkkale Üniversitesi',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22.0, // Font boyutunu biraz büyüttük
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Image.asset(
                        'assets/images/ekoslogo.png',
                        height: 60.0, // Yüksekliği artırdık
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0), // Boşluk ekliyoruz
                  const Text(
                    'Ekonometri ve E-Spor Topluluğu',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17.0, // Font boyutunu büyüttük
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(16.0),
              crossAxisSpacing: 12.0, // Çapraz boşluk arttırıldı
              mainAxisSpacing: 12.0, // Ana boşluk arttırıldı
              children: <Widget>[
                _buildGridButton(
                  context,
                  'Topluluk Haberleri',
                  Icons.newspaper,
                  CommunityNewsPage(),
                ),
                _buildGridButton(
                  context,
                  'Etkinlik Takvimi',
                  Icons.calendar_today,
                  const EventsCalendarPage(),
                ),
                _buildGridButton(
                  context,
                  'Turnuvalar ve Sonuçlar',
                  Icons.sports_esports,
                  const TournamentsResultsPage(),
                ),
                _buildGridButton(
                  context,
                  'Takım ve Oyuncular',
                  Icons.group,
                  const TeamsPlayersPage(),
                ),
                _buildGridButton(
                  context,
                  'Üye Kayıt Formu',
                  Icons.app_registration,
                  const MemberRegistrationPage(),
                ),
                _buildGridButton(
                  context,
                  'Üye Profilleri',
                  Icons.person,
                  const MemberProfilesPage(),
                ),
                _buildGridButton(
                  context,
                  'Sosyal Medya',
                  Icons.share,
                  const SocialMediaPage(),
                ),
                _buildGridButton(
                  context,
                  'Turnuva Başvuru Kayıt',
                  Icons.assignment_turned_in,
                  const TournamentRegistrationPage(),
                ),
                _buildGridButton(
                  context,
                  'Danışmanlar',
                  Icons.people,
                  const AdvisorsPage(),
                ),
                _buildGridButton(
                  context,
                  'Geri Bildirim',
                  Icons.feedback,
                  FeedbackPage(),
                ),
                _buildGridButton(
                  context,
                  'Güncel Ekonomi',
                  Icons.bar_chart,
                  const CurrentEconomyPage(),
                ),
                _buildGridButton(
                  context,
                  'Canlı Piyasa',
                  Icons.show_chart,
                  LiveMarketPage(),
                ),
                _buildGridButton(
                  context,
                  'Topluluk Yöneticileri',
                  Icons.admin_panel_settings,
                  CommunityManagersPage(),
                ),
                _buildGridButton(
                  context,
                  'Anket Butonu', // Yeni buton eklendi
                  Icons.poll,
                  SurveyPage(),
                ),
                _buildGridButton(
                  context,
                  'Topluluğa Üye Olma',
                  Icons.group_add,
                  const MemberJoinPage(),
                ),
                _buildGridButton(
                  context,
                  'Sponsorlar',
                  Icons.business, // İş simgesi kullanıldı, değiştirebilirsin
                  SponsorsPage(), // Sayfa adı, kendi sayfanın ismine göre değiştir
                ),
                _buildGridButton(
                  context,
                  'Sponsor Reklamları', // Yeni buton ismi
                  Icons.business, // İş simgesi kullanıldı
                  const SponsorAdsPage(), // Yeni Sponsor Ads sayfasına yönlendirecek
                ),
                _buildGridButton(
                  context,
                  'Güncelleme', // Yeni buton ismi
                  Icons.update, // Güncelleme simgesi kullanıldı
                  UpdatePage(), // UpdatePage sayfasına yönlendirecek
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridButton(
      BuildContext context, String title, IconData icon, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF7C4DFF), Color(0xFF18FFFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.0), // Köşe yuvarlama artırıldı
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8.0, // Gölgeler arttırıldı
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 55.0, color: Colors.white), // İkon boyutu arttırıldı
            const SizedBox(height: 8.0),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18.0, // Font boyutu arttırıldı
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
