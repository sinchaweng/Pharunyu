import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'show_products_by_category.dart'; // หน้ารายการสินค้า

class ShowCategoriesPage extends StatefulWidget {
  @override
  _ShowCategoriesPageState createState() => _ShowCategoriesPageState();
}

class _ShowCategoriesPageState extends State<ShowCategoriesPage> {
  DatabaseReference dbRef = FirebaseDatabase.instance.ref('products');
  Set<String> categories = {};

  // ดึงข้อมูลประเภทสินค้า
  Future<void> fetchCategories() async {
    try {
      final snapshot = await dbRef.get();
      if (snapshot.exists) {
        Set<String> loadedCategories = {};
        snapshot.children.forEach((child) {
          Map<String, dynamic> product = Map<String, dynamic>.from(child.value as Map);
          final category = product['category'] ?? 'Uncategorized';
          loadedCategories.add(category);
        });

        setState(() {
          categories = loadedCategories;
        });
      } else {
        print("ไม่พบข้อมูลประเภทสินค้า");
      }
    } catch (e) {
      print("Error loading categories: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาดในการโหลดข้อมูล: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ประเภทสินค้า'),
        centerTitle: true,
        backgroundColor: Color(0xFF00695C), // สีเขียวเข้ม
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      body: Container(
        color: Color(0xFFE0F2F1), // สีพื้นหลังอ่อน
        child: categories.isEmpty
            ? Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF00BFA5), // สีไอคอนโหลด
                ),
              )
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 คอลัมน์
                  crossAxisSpacing: 16.0, // ระยะห่างระหว่างคอลัมน์
                  mainAxisSpacing: 16.0, // ระยะห่างระหว่างแถว
                  childAspectRatio: 1.0, // อัตราส่วนขนาดของแต่ละช่อง (สามารถปรับได้ตามต้องการ)
                ),
                padding: EdgeInsets.all(16.0),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories.elementAt(index);
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // กำหนดสีพื้นหลังเป็นสีขาว
                      borderRadius: BorderRadius.circular(16.0), // ขอบโค้งมน
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8.0,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: InkWell(
                      onTap: () {
                        // เมื่อกดที่หมวดหมู่สินค้า
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ShowProductsByCategory(category: category),
                          ),
                        );
                      },
                      child: Center(
                        child: Text(
                          category,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00695C), // สีเขียวเข้ม
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
