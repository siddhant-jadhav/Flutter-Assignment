import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isFollowing = false;

  void toggleFollow() {
    setState(() {
      isFollowing = !isFollowing;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Center(
          // Outer Container: Main Profile Card
          child: Container(
            constraints: const BoxConstraints(maxWidth: 440),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ==========================================
                // 1. CIRCLE AVATAR & BADGE (Using CircleAvatar, Icon, Container)
                // ==========================================
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 54,
                      backgroundColor: colorScheme.primary.withOpacity(0.15),
                      child: CircleAvatar(
                        radius: 48,
                        backgroundColor: colorScheme.primary,
                        child: const Icon(
                          Icons.person,
                          size: 52,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: colorScheme.secondary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colorScheme.surface,
                          width: 2.5,
                        ),
                      ),
                      child: const Icon(
                        Icons.verified,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // ==========================================
                // 2. NAME & TITLE (Using Text)
                // ==========================================
                const Text(
                  'Siddhant Sharma',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'Flutter Developer & UI Enthusiast',
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 12),

                // ==========================================
                // 3. BIO (Using Text & Container)
                // ==========================================
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Text(
                    'Passionate about building responsive, beautiful cross-platform applications with Flutter and clean architecture.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ==========================================
                // 4. STATS SECTION (Using Row, Column, Container, Text)
                // ==========================================
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(
                        label: 'Projects',
                        value: '24',
                        color: colorScheme.primary,
                      ),
                      Container(
                        height: 30,
                        width: 1,
                        color: Colors.grey.shade300,
                      ),
                      _buildStatItem(
                        label: 'Followers',
                        value: '1.4k',
                        color: colorScheme.primary,
                      ),
                      Container(
                        height: 30,
                        width: 1,
                        color: Colors.grey.shade300,
                      ),
                      _buildStatItem(
                        label: 'Rating',
                        value: '4.9 ★',
                        color: colorScheme.tertiary,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ==========================================
                // 5. CONTACT & DETAILS (Using Row, Container, Icon, Text)
                // ==========================================
                _buildInfoRow(
                  icon: Icons.email_outlined,
                  text: 'siddhant@example.com',
                  colorScheme: colorScheme,
                ),
                const SizedBox(height: 10),
                _buildInfoRow(
                  icon: Icons.location_on_outlined,
                  text: 'San Francisco, CA',
                  colorScheme: colorScheme,
                ),
                const SizedBox(height: 10),
                _buildInfoRow(
                  icon: Icons.link_rounded,
                  text: 'github.com/siddhant',
                  colorScheme: colorScheme,
                ),

                const SizedBox(height: 24),

                // ==========================================
                // 6. ACTION BUTTONS (Using Row, Icon, Text)
                // ==========================================
                Row(
                  children: [
                    // Follow / Unfollow Button
                    Expanded(
                      flex: 3,
                      child: ElevatedButton.icon(
                        onPressed: toggleFollow,
                        icon: Icon(
                          isFollowing ? Icons.check : Icons.person_add,
                          size: 18,
                        ),
                        label: Text(
                          isFollowing ? 'Following' : 'Follow',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isFollowing
                              ? Colors.grey.shade800
                              : colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Message Button
                    Expanded(
                      flex: 3,
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: Icon(
                          Icons.chat_bubble_outline,
                          size: 18,
                          color: colorScheme.primary,
                        ),
                        label: Text(
                          'Message',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: colorScheme.primary,
                            width: 1.5,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Share IconButton
                    Container(
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.share_outlined,
                          color: colorScheme.primary,
                        ),
                        tooltip: 'Share Profile',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper Widget for Stats Item (Uses Column and Text)
  Widget _buildStatItem({
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // Helper Widget for Information Row (Uses Container, Row, Icon, Text)
  Widget _buildInfoRow({
    required IconData icon,
    required String text,
    required ColorScheme colorScheme,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade800,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
