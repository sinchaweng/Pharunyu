import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'addproduct.dart';
import 'showproduct.dart';
import 'showcategories.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyA05LnnsrW7oexZlgnz2ZSGBQYATLrHSJQ",
        authDomain: "onlinefirebase-c6036.firebaseapp.com",
        databaseURL: "https://onlinefirebase-c6036-default-rtdb.firebaseio.com",
        projectId: "onlinefirebase-c6036",
        storageBucket: "onlinefirebase-c6036.firebasestorage.app",
        messagingSenderId: "525368077931",
        appId: "1:525368077931:web:bcbde22a6b816222118b2e",
        measurementId: "G-87QSR4TCMX",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF00BFA5), // สีฟ้าอมเขียวจากโลโก้
          primary: Color(0xFF00BFA5), // สีหลัก
          secondary: Color(0xFF80DEEA), // สีเสริมอ่อน
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white, // สีพื้นหลังขาวสะอาด
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF00BFA5), // สีฟ้าอมเขียว
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF00BFA5), // สีฟ้าอมเขียว
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        cardTheme: CardTheme(
          color: Colors.white,
          shadowColor: Colors.grey.shade200, // เพิ่มเงาสีอ่อน
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF00695C), // สีเข้มกว่าเล็กน้อยสำหรับข้อความ
          ),
          bodyMedium: TextStyle(
            fontSize: 16,
            color: Color(0xFF00695C),
          ),
        ),
      ),
      home: Main(),
    );
  }
}

class Main extends StatefulWidget {
  @override
  State<Main> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เมนูหลัก'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // เพิ่มโลโก้แอป
              Image.asset(
                'assets/logotookdee.jpg',
                height: 120, // ปรับขนาดโลโก้
              ),
              SizedBox(height: 20), // เพิ่มช่องว่างระหว่างโลโก้และข้อความ
              Text(
                'เลือกฟังก์ชันที่ต้องการ',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00695C),
                ),
              ),
              SizedBox(height: 40),
              _buildMenuCard(
                context: context,
                label: 'บันทึกสินค้า',
                icon: Icons.add_circle_outline,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddProduct()),
                  );
                },
              ),
              SizedBox(height: 20),
              _buildMenuCard(
                context: context,
                label: 'ประเภทสินค้า',
                icon: Icons.category,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ShowCategoriesPage()),
                  );
                },
              ),
              SizedBox(height: 20),
              _buildMenuCard(
                context: context,
                label: 'รายละเอียดสินค้า',
                icon: Icons.list_alt,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ShowProducts()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required BuildContext context,
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Card(
      elevation: 4, // เพิ่มเงาบางๆ ให้กรอบของ Card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white, // กำหนดสีพื้นหลังเป็นสีขาว
      child: ListTile(
        onTap: onPressed,
        leading: Icon(
          icon,
          size: 32,
          color: Color(0xFF00BFA5),
        ),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF00695C),
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Color(0xFF00BFA5),
        ),
      ),
    );
  }
}
