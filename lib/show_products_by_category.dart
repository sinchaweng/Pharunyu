import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ShowProductsByCategory extends StatefulWidget {
  final String category;

  ShowProductsByCategory({required this.category});

  @override
  _ShowProductsByCategoryState createState() => _ShowProductsByCategoryState();
}

class _ShowProductsByCategoryState extends State<ShowProductsByCategory> {
  DatabaseReference dbRef = FirebaseDatabase.instance.ref('products');
  List<Map<String, dynamic>> products = [];

  // ดึงข้อมูลสินค้าตามหมวดหมู่
  Future<void> fetchProductsByCategory() async {
    try {
      final snapshot = await dbRef.get();
      if (snapshot.exists) {
        List<Map<String, dynamic>> filteredProducts = [];
        snapshot.children.forEach((child) {
          Map<String, dynamic> product = Map<String, dynamic>.from(child.value as Map);
          if (product['category'] == widget.category) {
            product['key'] = child.key; // เก็บ key สำหรับอ้างอิง
            product['quantity'] = product['quantity'] ?? '0'; // ตรวจสอบว่ามีข้อมูล quantity หรือไม่
            filteredProducts.add(product);
          }
        });

        setState(() {
          products = filteredProducts;
        });
      } else {
        print("ไม่พบข้อมูลสินค้าในหมวดหมู่นี้");
      }
    } catch (e) {
      print("Error loading products: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาดในการโหลดข้อมูล: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProductsByCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('สินค้าในหมวดหมู่: ${widget.category}'),
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
        child: products.isEmpty
            ? Center(
                child: CircularProgressIndicator(color: Color(0xFF00BFA5)), // สีไอคอนโหลด
              )
            : ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0), // ขอบโค้งมน
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8.0,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                      title: Text(
                        product['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF00695C),
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ราคา: ${product['price']} บาท',
                            style: TextStyle(fontSize: 14, color: Colors.black54),
                          ),
                          Text(
                            'จำนวนคงเหลือ: ${product['quantity']} ชิ้น',
                            style: TextStyle(fontSize: 14, color: Colors.black54),
                          ),
                        ],
                      ),
                      trailing: Icon(Icons.arrow_forward, color: Color(0xFF00BFA5)), // สีไอคอนลูกศร
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailPage(product: product),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class ProductDetailPage extends StatelessWidget {
  final Map<String, dynamic> product;

  ProductDetailPage({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product['name']),
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
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8, // กำหนดให้กล่องมีความกว้าง 80% ของหน้าจอ
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0), // ขอบโค้งมน
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8.0,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // ปรับขนาดตามเนื้อหา
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'รายละเอียดสินค้า:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00695C),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  product['description'] ?? 'ไม่มีรายละเอียด',
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                SizedBox(height: 16),
                Text(
                  'ราคา: ${product['price']} บาท',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                SizedBox(height: 16),
                Text(
                  'จำนวนคงเหลือ: ${product['quantity']} ชิ้น',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                SizedBox(height: 16),
                Text(
                  'วันที่ผลิต: ${product['productionDate'] ?? 'ไม่ระบุ'}',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
