import 'package:flutter/material.dart';

// ============================================================================
// DATA MODEL: UserRegistrationProfile
// ============================================================================
class UserRegistrationProfile {
  final String fullName;
  final String email;
  final String phone;
  final String role;
  final String password;
  final bool termsAccepted;
  final DateTime registeredAt;

  UserRegistrationProfile({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    required this.password,
    required this.termsAccepted,
    DateTime? registeredAt,
  }) : registeredAt = registeredAt ?? DateTime.now();

  String get maskedPassword => '•' * (password.length > 12 ? 12 : password.length);

  String get formattedRegistrationDate {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final month = months[registeredAt.month - 1];
    final day = registeredAt.day.toString().padLeft(2, '0');
    final hour = registeredAt.hour.toString().padLeft(2, '0');
    final minute = registeredAt.minute.toString().padLeft(2, '0');
    return '$month $day, ${registeredAt.year} at $hour:$minute';
  }

  String get initials {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return 'U';
    if (parts.length == 1) return parts[0].substring(0, 1).toUpperCase();
    return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
  }
}

// Session store to remember the last registered user across navigation
class SessionStore {
  static UserRegistrationProfile? lastRegisteredUser;
}

// ============================================================================
// MAIN APPLICATION & NAMED ROUTING CONFIGURATION
// ============================================================================
void main() {
  runApp(const ThreeScreenApp());
}

class ThreeScreenApp extends StatelessWidget {
  const ThreeScreenApp({super.key});

  // Named Route Constants
  static const String routeHome = '/';
  static const String routeForm = '/form';
  static const String routeDetail = '/detail';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Modular 3-Screen App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4F46E5), // Indigo 600
          primary: const Color(0xFF4F46E5),
          secondary: const Color(0xFF06B6D4), // Cyan 500
          surface: const Color(0xFFF8FAFC),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF1F5F9), // Slate 100
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Color(0xFF4F46E5),
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 0.3,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 2,
            backgroundColor: const Color(0xFF4F46E5),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      // Declarative Named Routes Table
      initialRoute: routeHome,
      routes: {
        routeHome: (context) => const HomeScreen(),
        routeForm: (context) => const RegistrationFormScreen(),
        routeDetail: (context) => const DetailScreen(),
      },
    );
  }
}

// ============================================================================
// SCREEN 1: HOME SCREEN
// ============================================================================
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final hasActiveUser = SessionStore.lastRegisteredUser != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Portal Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'App Info',
            onPressed: () => _showAppInfoDialog(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero Welcome Banner
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4F46E5).withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.alt_route_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '3-Screen Workflow',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Named Routes & Validation',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFFE0E7FF),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Experience structured multi-screen navigation using declarative named routes, argument serialization, and rigorous form validation.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Active Session Card (if user already registered)
            if (hasActiveUser) ...[
              Card(
                color: const Color(0xFFEEF2FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: Color(0xFFC7D2FE), width: 1.5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: const Color(0xFF4F46E5),
                            radius: 22,
                            child: Text(
                              SessionStore.lastRegisteredUser!.initials,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Current Registered Session',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF4F46E5),
                                  ),
                                ),
                                Text(
                                  SessionStore.lastRegisteredUser!.fullName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E293B),
                                  ),
                                ),
                                Text(
                                  SessionStore.lastRegisteredUser!.email,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              ThreeScreenApp.routeDetail,
                              arguments: SessionStore.lastRegisteredUser,
                            );
                          },
                          icon: const Icon(Icons.badge_outlined, size: 18),
                          label: const Text('View Active Profile Details'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF4F46E5),
                            side: const BorderSide(color: Color(0xFF4F46E5)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Navigation Map Card
            const Text(
              'APPLICATION FLOW',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 12),
            _buildRouteStepTile(
              stepNumber: '1',
              title: 'Home Screen',
              routePath: ThreeScreenApp.routeHome,
              description: 'Central hub and entry route into the application.',
              icon: Icons.home_rounded,
              isCurrent: true,
            ),
            _buildRouteStepTile(
              stepNumber: '2',
              title: 'Registration Form',
              routePath: ThreeScreenApp.routeForm,
              description: 'Multi-field input with email regex and password rules.',
              icon: Icons.assignment_turned_in_rounded,
              isCurrent: false,
            ),
            _buildRouteStepTile(
              stepNumber: '3',
              title: 'Detail Screen',
              routePath: ThreeScreenApp.routeDetail,
              description: 'Extracts route arguments to display registration profile.',
              icon: Icons.person_pin_rounded,
              isCurrent: false,
            ),
            const SizedBox(height: 24),

            // Primary Call to Action
            ElevatedButton.icon(
              onPressed: () async {
                // Navigate to Form via Named Route
                await Navigator.pushNamed(context, ThreeScreenApp.routeForm);
                // Refresh home in case a profile was registered
                setState(() {});
              },
              icon: const Icon(Icons.arrow_forward_rounded),
              label: const Text('Go to Registration Form'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Secondary Action: Demo Quick View
            OutlinedButton.icon(
              onPressed: () {
                final demoUser = UserRegistrationProfile(
                  fullName: 'Siddhant Jadhav',
                  email: 'siddhant@example.com',
                  phone: '9876543210',
                  role: 'Mobile Developer',
                  password: 'Password@2026',
                  termsAccepted: true,
                );
                Navigator.pushNamed(
                  context,
                  ThreeScreenApp.routeDetail,
                  arguments: demoUser,
                );
              },
              icon: const Icon(Icons.remove_red_eye_outlined),
              label: const Text('Explore Detail View (Sample Data)'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF4F46E5),
                side: const BorderSide(color: Color(0xFFCBD5E1), width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRouteStepTile({
    required String stepNumber,
    required String title,
    required String routePath,
    required String description,
    required IconData icon,
    required bool isCurrent,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: isCurrent ? const Color(0xFF4F46E5) : const Color(0xFFEEF2FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: isCurrent ? Colors.white : const Color(0xFF4F46E5),
                  size: 22,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFFCBD5E1)),
                        ),
                        child: Text(
                          routePath,
                          style: const TextStyle(
                            fontSize: 11,
                            fontFamily: 'Courier',
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF475569),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAppInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.layers_rounded, color: Color(0xFF4F46E5)),
            SizedBox(width: 10),
            Text('Routing Architecture'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This application demonstrates the following Flutter concepts:',
              style: TextStyle(fontSize: 14, color: Color(0xFF334155)),
            ),
            SizedBox(height: 12),
            Text('• Named Routes via MaterialApp.routes dictionary'),
            Text('• Navigation with Navigator.pushNamed() and arguments'),
            Text('• ModalRoute.of(context) parameter extraction'),
            Text('• Complete Form validation with GlobalKey<FormState>'),
            Text('• Email regex & password complexity checks'),
            Text('• Stack unwinding using Navigator.popUntil()'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// SCREEN 2: REGISTRATION FORM SCREEN (WITH VALIDATION)
// ============================================================================
class RegistrationFormScreen extends StatefulWidget {
  const RegistrationFormScreen({super.key});

  @override
  State<RegistrationFormScreen> createState() => _RegistrationFormScreenState();
}

class _RegistrationFormScreenState extends State<RegistrationFormScreen> {
  // GlobalKey used to uniquely identify and validate the Form
  final _formKey = GlobalKey<FormState>();

  // Text Editing Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // State flags & dropdown selection
  String _selectedRole = 'Mobile Developer';
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _termsAccepted = false;
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  final List<String> _roleOptions = [
    'Mobile Developer',
    'Frontend Engineer',
    'Backend Engineer',
    'UI/UX Designer',
    'Product Manager',
    'Student / Learner',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // --- Validation Logic ---

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  String? _validateFullName(String? value) {
    final requiredCheck = _validateRequired(value, 'Full name');
    if (requiredCheck != null) return requiredCheck;

    if (value!.trim().length < 3) {
      return 'Name must be at least 3 characters long';
    }
    final nameRegex = RegExp(r"^[a-zA-Z\s.'-]+$");
    if (!nameRegex.hasMatch(value.trim())) {
      return 'Please enter a valid alphabetic name';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    final requiredCheck = _validateRequired(value, 'Email address');
    if (requiredCheck != null) return requiredCheck;

    // RFC compliant regex pattern
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    );
    if (!emailRegex.hasMatch(value!.trim())) {
      return 'Enter a valid email address (e.g. name@domain.com)';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    final requiredCheck = _validateRequired(value, 'Phone number');
    if (requiredCheck != null) return requiredCheck;

    final digitsOnly = value!.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length != 10) {
      return 'Enter a valid 10-digit phone number';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final requiredCheck = _validateRequired(value, 'Password');
    if (requiredCheck != null) return requiredCheck;

    if (value!.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!value.contains(RegExp(r'[A-Za-z]'))) {
      return 'Password must contain at least one letter';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    final requiredCheck = _validateRequired(value, 'Confirm password');
    if (requiredCheck != null) return requiredCheck;

    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _handleSubmit() {
    // Trigger validation across all FormFields
    if (_formKey.currentState!.validate()) {
      // Create user profile model
      final profile = UserRegistrationProfile(
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim().toLowerCase(),
        phone: _phoneController.text.trim(),
        role: _selectedRole,
        password: _passwordController.text,
        termsAccepted: _termsAccepted,
      );

      // Save to session store for cross-screen persistence
      SessionStore.lastRegisteredUser = profile;

      // Transient confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_outline, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text('Welcome, ${profile.fullName}! Navigating to details...'),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF10B981), // Emerald 500
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );

      // Push to DetailScreen via Named Route and pass UserRegistrationProfile as arguments
      Navigator.pushNamed(
        context,
        ThreeScreenApp.routeDetail,
        arguments: profile,
      );
    } else {
      // Enable live autovalidation once user attempted an invalid submission
      setState(() {
        _autovalidateMode = AutovalidateMode.onUserInteraction;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 10),
              Text('Please resolve validation errors before submitting'),
            ],
          ),
          backgroundColor: Color(0xFFEF4444), // Red 500
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _handleReset() {
    _formKey.currentState?.reset();
    _nameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    setState(() {
      _selectedRole = 'Mobile Developer';
      _termsAccepted = false;
      _autovalidateMode = AutovalidateMode.disabled;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Form cleared successfully'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Registration'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back to Home',
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          autovalidateMode: _autovalidateMode,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Form Title Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEF2FF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.how_to_reg_rounded,
                          color: Color(0xFF4F46E5),
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Account Setup',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Complete all required fields below',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 1. Full Name Field
              TextFormField(
                controller: _nameController,
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Full Name *',
                  hintText: 'e.g. Siddhant Jadhav',
                  prefixIcon: Icon(Icons.person_outline, color: Color(0xFF4F46E5)),
                ),
                validator: _validateFullName,
              ),
              const SizedBox(height: 16),

              // 2. Email Field
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email Address *',
                  hintText: 'e.g. user@domain.com',
                  prefixIcon: Icon(Icons.email_outlined, color: Color(0xFF4F46E5)),
                ),
                validator: _validateEmail,
              ),
              const SizedBox(height: 16),

              // 3. Phone Number Field
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number (10 digits) *',
                  hintText: 'e.g. 9876543210',
                  prefixIcon: Icon(Icons.phone_outlined, color: Color(0xFF4F46E5)),
                ),
                validator: _validatePhone,
              ),
              const SizedBox(height: 16),

              // 4. Role Dropdown
              DropdownButtonFormField<String>(
                initialValue: _selectedRole,
                decoration: const InputDecoration(
                  labelText: 'Primary Specialization *',
                  prefixIcon: Icon(Icons.work_outline, color: Color(0xFF4F46E5)),
                ),
                items: _roleOptions.map((role) {
                  return DropdownMenuItem(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedRole = value);
                  }
                },
              ),
              const SizedBox(height: 16),

              // 5. Password Field
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password (min 8 chars, letter & number) *',
                  hintText: '••••••••',
                  prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF4F46E5)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: const Color(0xFF64748B),
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                ),
                validator: _validatePassword,
              ),
              const SizedBox(height: 16),

              // 6. Confirm Password Field
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  labelText: 'Confirm Password *',
                  hintText: '••••••••',
                  prefixIcon: const Icon(Icons.lock_reset_outlined, color: Color(0xFF4F46E5)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                      color: const Color(0xFF64748B),
                    ),
                    onPressed: () {
                      setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                    },
                  ),
                ),
                validator: _validateConfirmPassword,
              ),
              const SizedBox(height: 18),

              // 7. Terms & Conditions Checkbox (FormField wrapper for validation)
              FormField<bool>(
                initialValue: _termsAccepted,
                validator: (val) {
                  if (!_termsAccepted) {
                    return 'You must accept the terms & conditions to proceed';
                  }
                  return null;
                },
                builder: (formFieldState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: _termsAccepted,
                            activeColor: const Color(0xFF4F46E5),
                            onChanged: (val) {
                              setState(() {
                                _termsAccepted = val ?? false;
                                formFieldState.didChange(_termsAccepted);
                              });
                            },
                          ),
                          const Expanded(
                            child: Text(
                              'I agree to the Terms of Service and Privacy Policy *',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF334155),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (formFieldState.hasError)
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0, top: 4.0),
                          child: Text(
                            formFieldState.errorText!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFFEF4444),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),

              // Submit Button
              ElevatedButton.icon(
                onPressed: _handleSubmit,
                icon: const Icon(Icons.send_rounded),
                label: const Text('Complete Registration'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Secondary Actions Row
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _handleReset,
                      icon: const Icon(Icons.restart_alt_rounded, size: 18),
                      label: const Text('Reset'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF64748B),
                        side: const BorderSide(color: Color(0xFFCBD5E1)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.cancel_outlined, size: 18),
                      label: const Text('Cancel'),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF64748B),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// SCREEN 3: DETAIL SCREEN (RECEIVES ROUTE ARGUMENTS)
// ============================================================================
class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Extract argument passed via Navigator.pushNamed(context, route, arguments: ...)
    final arguments = ModalRoute.of(context)?.settings.arguments;
    final UserRegistrationProfile user = (arguments is UserRegistrationProfile)
        ? arguments
        : (SessionStore.lastRegisteredUser ??
            UserRegistrationProfile(
              fullName: 'Alex Morgan (Fallback Profile)',
              email: 'alex.morgan@demo.io',
              phone: '9876543210',
              role: 'Product Lead',
              password: 'SecretPassword123',
              termsAccepted: true,
            ));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back to Form',
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home_outlined),
            tooltip: 'Return to Home',
            onPressed: () {
              // Unwind navigation stack completely back to Home route ('/')
              Navigator.popUntil(
                context,
                ModalRoute.withName(ThreeScreenApp.routeHome),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // User Header Hero Card
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 42,
                      backgroundColor: const Color(0xFF4F46E5),
                      child: Text(
                        user.initials,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user.fullName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF2FF),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFC7D2FE)),
                      ),
                      child: Text(
                        user.role,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4F46E5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.access_time, size: 14, color: Color(0xFF64748B)),
                        const SizedBox(width: 4),
                        Text(
                          'Registered: ${user.formattedRegistrationDate}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Section: Contact & Identity Info
            const Text(
              'CONTACT & IDENTITY',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: Column(
                children: [
                  _buildDetailRow(
                    icon: Icons.email_outlined,
                    label: 'Email Address',
                    value: user.email,
                    trailing: const Chip(
                      label: Text('Verified', style: TextStyle(fontSize: 10, color: Colors.white)),
                      backgroundColor: Color(0xFF10B981),
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                  const Divider(height: 1, indent: 60),
                  _buildDetailRow(
                    icon: Icons.phone_outlined,
                    label: 'Phone Number',
                    value: user.phone,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Section: Security & Credentials
            const Text(
              'SECURITY & COMPLIANCE',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: Column(
                children: [
                  _buildDetailRow(
                    icon: Icons.lock_outline,
                    label: 'Password Status',
                    value: '${user.maskedPassword} (Encrypted)',
                    trailing: const Icon(
                      Icons.shield_outlined,
                      color: Color(0xFF10B981),
                      size: 20,
                    ),
                  ),
                  const Divider(height: 1, indent: 60),
                  _buildDetailRow(
                    icon: Icons.gavel_outlined,
                    label: 'Terms of Service',
                    value: user.termsAccepted ? 'Accepted & Signed' : 'Pending',
                    trailing: Icon(
                      user.termsAccepted ? Icons.check_circle : Icons.warning_amber_rounded,
                      color: user.termsAccepted ? const Color(0xFF10B981) : Colors.orange,
                      size: 20,
                    ),
                  ),
                  const Divider(height: 1, indent: 60),
                  _buildDetailRow(
                    icon: Icons.route_outlined,
                    label: 'Route Origin',
                    value: 'Passed via RouteSettings.arguments',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            ElevatedButton.icon(
              onPressed: () {
                // Return to home screen and clear entire route stack
                Navigator.popUntil(
                  context,
                  ModalRoute.withName(ThreeScreenApp.routeHome),
                );
              },
              icon: const Icon(Icons.home_rounded),
              label: const Text('Return to Home Dashboard'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 12),

            OutlinedButton.icon(
              onPressed: () {
                // Navigate back to form to edit details
                Navigator.pop(context);
              },
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Modify Registration (Back to Form)'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF4F46E5),
                side: const BorderSide(color: Color(0xFF4F46E5)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    Widget? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF4F46E5), size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
