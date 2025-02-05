import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    User? user = _authService.getCurrentUser();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2196F3),
              Color(0xFF1976D2),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 28,
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: user != null
                      ? Column(
                          children: [
                            SizedBox(height: 20),
                            // Profile Avatar
                            Container(
                              padding: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Color(0xFF1976D2),
                                  width: 2,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor:
                                    Color(0xFF1976D2).withOpacity(0.1),
                                child: Icon(
                                  Icons.person_outline,
                                  size: 50,
                                  color: Color(0xFF1976D2),
                                ),
                              ),
                            ),
                            SizedBox(height: 24),

                            // Profile Information Cards
                            Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Account Information',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1976D2),
                                      ),
                                    ),
                                    Divider(height: 24),
                                    ListTile(
                                      leading: Icon(
                                        Icons.email_outlined,
                                        color: Color(0xFF1976D2),
                                      ),
                                      title: Text(
                                        'Email',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      subtitle: Text(
                                        user.email ?? 'No email provided',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    ListTile(
                                      leading: Icon(
                                        Icons.calendar_today_outlined,
                                        color: Color(0xFF1976D2),
                                      ),
                                      title: Text(
                                        'Member Since',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      subtitle: Text(
                                        user.metadata.creationTime
                                                ?.toString()
                                                .split(' ')[0] ??
                                            'Unknown',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(height: 24),

                            // Settings Options
                            Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: Icon(
                                      Icons.settings_outlined,
                                      color: Color(0xFF1976D2),
                                    ),
                                    title: Text('Settings'),
                                    trailing: Icon(Icons.chevron_right),
                                  ),
                                  Divider(height: 1),
                                  ListTile(
                                    leading: Icon(
                                      Icons.help_outline,
                                      color: Color(0xFF1976D2),
                                    ),
                                    title: Text('Help & Support'),
                                    trailing: Icon(Icons.chevron_right),
                                  ),
                                  Divider(height: 1),
                                  ListTile(
                                    leading: Icon(
                                      Icons.logout,
                                      color: Colors.red,
                                    ),
                                    title: Text(
                                      'Logout',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Confirm Logout'),
                                            content: Text(
                                                'Are you sure you want to logout?'),
                                            actions: <Widget>[
                                              TextButton(
                                                child: Text('Cancel'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              TextButton(
                                                child: Text('Logout'),
                                                onPressed: () async {
                                                  await _authService.signOut();
                                                  Navigator.of(context)
                                                      .pushReplacementNamed(
                                                          '/login');
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 48,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No user is logged in',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
