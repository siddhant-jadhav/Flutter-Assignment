import 'package:flutter/material.dart';

// Main entry point to run the assignment
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Responsive Dashboard Assignment',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Sample data for categories (Horizontal ListView)
  final List<String> categories = [
    'Overview',
    'Analytics',
    'Reports',
    'Orders',
    'Customers',
    'Settings',
  ];

  int selectedCategoryIndex = 0;

  // Sample data for GridView cards
  final List<Map<String, dynamic>> statsData = [
    {
      'title': 'Total Sales',
      'value': '\$24,500',
      'icon': Icons.attach_money,
      'color': Colors.green,
    },
    {
      'title': 'New Users',
      'value': '1,250',
      'icon': Icons.people,
      'color': Colors.blue,
    },
    {
      'title': 'Pending Orders',
      'value': '48',
      'icon': Icons.shopping_bag,
      'color': Colors.orange,
    },
    {
      'title': 'Server Load',
      'value': '58%',
      'icon': Icons.storage,
      'color': Colors.purple,
    },
  ];

  // Sample data for Recent Activities (Vertical ListView)
  final List<Map<String, dynamic>> recentActivities = [
    {
      'title': 'John Doe placed an order',
      'time': '5 mins ago',
      'icon': Icons.shopping_cart,
      'color': Colors.blue,
    },
    {
      'title': 'New user registered: Sarah',
      'time': '15 mins ago',
      'icon': Icons.person_add,
      'color': Colors.green,
    },
    {
      'title': 'Payment failed for Order #1042',
      'time': '1 hour ago',
      'icon': Icons.error_outline,
      'color': Colors.red,
    },
    {
      'title': 'Database backup completed',
      'time': '3 hours ago',
      'icon': Icons.cloud_done,
      'color': Colors.teal,
    },
    {
      'title': 'Server restart scheduled',
      'time': '5 hours ago',
      'icon': Icons.schedule,
      'color': Colors.indigo,
    },
  ];

  @override
  Widget build(BuildContext context) {
    // -------------------------------------------------------------
    // 1. USING MEDIAQUERY TO MAKE THE DASHBOARD RESPONSIVE
    // -------------------------------------------------------------
    // Getting screen width and height using MediaQuery
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    Orientation orientation = MediaQuery.of(context).orientation;

    // Check if the screen is large (Tablet / Web / Desktop) or small (Mobile)
    bool isTabletOrDesktop = screenWidth > 600;

    // Adjust grid column count based on screen width
    int gridCrossAxisCount = isTabletOrDesktop ? 4 : 2;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------------------------------------------------------
            // 2. WELCOME BANNER USING EXPANDED & FLEXIBLE IN A ROW
            // ---------------------------------------------------------
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Row(
                children: [
                  // Using Expanded so welcome text takes most of the space
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Welcome back, Siddhant!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Screen Width: ${screenWidth.toStringAsFixed(1)} px | Orientation: ${orientation.name}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Using Flexible for the banner icon
                  Flexible(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.dashboard_customize,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ---------------------------------------------------------
            // 3. HORIZONTAL LISTVIEW FOR CATEGORIES / TABS
            // ---------------------------------------------------------
            const Text(
              'Quick Categories (Horizontal ListView)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // Using ListView with horizontal scroll direction
            SizedBox(
              height: 45,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  bool isSelected = selectedCategoryIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategoryIndex = index;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blueAccent : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? Colors.blueAccent : Colors.grey.shade300,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          categories[index],
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // ---------------------------------------------------------
            // 4. RESPONSIVE GRIDVIEW FOR STATS CARDS
            // ---------------------------------------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Overview Metrics (GridView)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Columns: $gridCrossAxisCount',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Using GridView.builder with dynamic crossAxisCount
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: statsData.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: gridCrossAxisCount,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                childAspectRatio: isTabletOrDesktop ? 1.5 : 1.3,
              ),
              itemBuilder: (context, index) {
                final item = statsData[index];
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item['title'],
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Icon(
                              item['icon'],
                              color: item['color'],
                              size: 24,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item['value'],
                          style: TextStyle(
                            fontSize: isTabletOrDesktop ? 22 : 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // ---------------------------------------------------------
            // 5. SPLIT SECTION USING EXPANDED & FLEXIBLE IN A ROW
            // ---------------------------------------------------------
            const Text(
              'Performance & Target (Flexible & Expanded)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // Row with Expanded and Flexible cards
            Row(
              children: [
                // Expanded card (takes 2 parts of available width)
                Expanded(
                  flex: 2,
                  child: Card(
                    color: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Monthly Target',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: 0.75,
                            backgroundColor: Colors.grey[200],
                            color: Colors.green,
                            minHeight: 8,
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            '75% Completed',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // Flexible card (takes 1 part of available width)
                Flexible(
                  flex: 1,
                  child: Card(
                    color: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Pending',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '25%',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange[800],
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'To reach goal',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ---------------------------------------------------------
            // 6. VERTICAL LISTVIEW FOR RECENT ACTIVITIES
            // ---------------------------------------------------------
            const Text(
              'Recent Activities (Vertical ListView)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // Using ListView with shrinkWrap to display items in a Card container
            Card(
              color: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: recentActivities.length,
                separatorBuilder: (context, index) => const Divider(
                  height: 1,
                  indent: 60,
                ),
                itemBuilder: (context, index) {
                  final activity = recentActivities[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: (activity['color'] as Color).withValues(alpha: 0.15),
                      child: Icon(
                        activity['icon'] as IconData,
                        color: activity['color'] as Color,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      activity['title'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      activity['time'],
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Colors.grey,
                    ),
                    onTap: () {
                      // Action when clicked
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Information footer showing screen height
            Center(
              child: Text(
                'Total Screen Height: ${screenHeight.toStringAsFixed(1)} px',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
