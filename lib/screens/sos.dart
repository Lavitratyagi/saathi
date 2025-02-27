import 'package:flutter/material.dart';

class SosScreen extends StatefulWidget {
  @override
  _SosScreenState createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _sosActivated = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.index = 1; // Default to EMERGENCY tab
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFEE3030),
        title: Text("Women Safety App"),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white,
          tabs: [
            Tab(text: "CHATS"),
            Tab(text: "EMERGENCY"),
            Tab(text: "HELPLINE"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildChatsTab(),
          _sosActivated ? buildActivatedEmergencyView() : buildEmergencyTab(),
          Center(child: Text("Helpline Page")),
        ],
      ),
    );
  }

  // ✅ DUMMY CHATS TAB
  Widget buildChatsTab() {
    final List<Map<String, String>> chats = [
      {"name": "Mom", "message": "How are you? Stay safe!"},
      {"name": "Dad", "message": "Call me when you’re free."},
    ];

    return ListView.builder(
      itemCount: chats.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Color(0xFFEE6262),
            child: Text(
              chats[index]['name']![0],
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          title: Text(
            chats[index]['name']!,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(chats[index]['message']!),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Opening chat with ${chats[index]['name']}')),
            );
          },
        );
      },
    );
  }

  Widget buildEmergencyTab() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Emergency help needed?",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            "JUST HOLD THE BUTTON TO ACTIVATE THE EMERGENCY SYSTEM",
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32),
          GestureDetector(
            onLongPress: () {
              setState(() => _sosActivated = true);
            },
            child: Center(
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [Color(0xFFE63A3A), Color(0xFF802020)],
                    center: Alignment.center,
                    radius: 0.85,
                  ),
                ),
                child: Icon(
                  Icons.wifi_tethering,
                  color: Colors.white,
                  size: 80,
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          Text(
            "Not sure what to do?",
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          SizedBox(
            height: 80,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                buildTileButton("Share your live location"),
                buildTileButton("Call emergency helpline number"),
                buildTileButton("I need a Doctor"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildActivatedEmergencyView() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "SOS Alert sent",
              style: TextStyle(
                fontSize: 28,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE63A3A), Color(0xFF802020)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 16),
                Icon(Icons.check_circle, size: 100, color: Colors.green),
                SizedBox(height: 16),
                Text(
                  "Help is on its way!",
                  style: TextStyle(fontSize: 24, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "Your live location has been shared to your friends, family, and everyone around you. Just hold on till someone reaches out for help.",
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 32),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "You are constantly being monitored....",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.fiber_manual_record,
                                color: Colors.red, size: 40),
                            Text(
                              "REC",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Your device will continue to record voice and click photos till you stop it manually!",
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFEE3030),
                          padding: EdgeInsets.symmetric(
                              horizontal: 32, vertical: 12),
                        ),
                        onPressed: () {
                          setState(() => _sosActivated = false);
                        },
                        child: Text(
                          "STOP, I’m Fine",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTileButton(String text) {
    return Container(
      width: 180,
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Color(0xFFF0D6D6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
