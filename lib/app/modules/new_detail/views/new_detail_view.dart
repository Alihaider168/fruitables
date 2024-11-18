import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/new_detail_controller.dart';

class NewDetailView extends GetView<NewDetailController> {
  const NewDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Order Details",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Image
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage('assets/order_image.jpg'), // Replace with your image
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 16),

            // Order Information
            Text(
              "Order #e12y-2446-e4av",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 4),
            Text(
              "Delivered on 12 Nov 22:57",
              style: TextStyle(color: Colors.grey),
            ),
            Divider(thickness: 1, height: 32),

            // Delivery Information
            Row(
              children: [
                Icon(Icons.store, color: Colors.grey),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Order from",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
                Text(
                  "One Mart",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.location_pin, color: Colors.grey),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Delivered to",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
                Text(
                  "Stahl Application Laboratory, Sialkot",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            Divider(thickness: 1, height: 32),

            // Item List
            Row(
              children: [
                Text(
                  "1x",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Local Chicken Eggs | 6 pieces",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Text(
                  "Rs. 199.00",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Pricing Details
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPriceRow("Subtotal", "Rs. 199.00"),
                _buildPriceRow("Difference to minimum", "Rs. 50.00"),
                _buildPriceRow("Platform Fee", "Rs. 9.99"),
                Divider(thickness: 1, height: 32),
                _buildPriceRow(
                  "Total (incl. GST)",
                  "Rs. 258.99",
                  isBold: true,
                ),
              ],
            ),

            SizedBox(height: 16),

            // Payment Method
            Text(
              "Paid with",
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.money, color: Colors.grey),
                SizedBox(width: 8),
                Text(
                  "cash on delivery",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Spacer(),
                Text(
                  "Rs. 258.99",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 16),
            Divider(thickness: 1, height: 32),

            // Download Invoice
            Row(
              children: [
                Icon(Icons.file_download, color: Colors.grey),
                SizedBox(width: 8),
                Text(
                  "Download invoice",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            SizedBox(height: 32),

            // Button
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                // primary: Colors.pink, // Adjust the color
                // shape: RoundedRectangleBorder(
                //   borderRadius: BorderRadius.circular(8),
                // ),
                padding: EdgeInsets.symmetric(vertical: 16),
                minimumSize: Size(double.infinity, 48),
              ),
              child: Text(
                "Select items to reorder",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String title, String amount, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}