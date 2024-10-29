import 'package:flutter/material.dart';
import 'package:fruitables/app/data/core/app_export.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Header
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: ColorConstant.primaryPink
            ),
            accountName: Text(
              'Syed Ali Haider',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(
              '+923076497552',
              style: TextStyle(fontSize: 14),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: ColorConstant.yellow,
              child: Text(
                'S',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
          ),

          // Wallet and Loyalty Points Section
          ListTile(
            leading: Icon(Icons.account_balance_wallet),
            title: Row(
              children: [
                Text("My Wallet"),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: ColorConstant.yellow,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Rs. 0.00',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.loyalty),
            title: Row(
              children: [
                Text("Loyalty Points"),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: ColorConstant.yellow,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Rs. 0.00',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Menu Items
          ListTile(
            leading: Icon(Icons.location_on_outlined),
            title: Text('My Addresses'),
            trailing: Icon(Icons.chevron_right),
          ),
          ListTile(
            leading: Icon(Icons.receipt_long),
            title: Text('My Orders'),
            trailing: Icon(Icons.chevron_right),
          ),
          ListTile(
            leading: Icon(Icons.favorite_border),
            title: Text('My Favourites'),
            trailing: Icon(Icons.chevron_right),
          ),
          ListTile(
            leading: Icon(Icons.support_agent),
            title: Text('Support Center'),
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
          ),
          ListTile(
            leading: Icon(Icons.person_remove),
            title: Text('Req Account Deletion'),
          ),

        ],
      ),
    );
  }
}
