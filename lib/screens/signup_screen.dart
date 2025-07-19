import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with TickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _emailHasError = false;
  bool _passwordHasError = false;
  bool _confirmPasswordHasError = false;
  String? _emailErrorText;
  String? _passwordErrorText;
  String? _confirmPasswordErrorText;
  
  late AnimationController _animationController;
  late AnimationController _particleController;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _particleRotation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _particleController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );
    
    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _particleRotation = Tween<double>(begin: 0.0, end: 2.0).animate(
      CurvedAnimation(parent: _particleController, curve: Curves.linear),
    );
    
    _animationController.forward();
    _particleController.repeat();

    // Add listeners for real-time validation
    emailController.addListener(_validateEmailRealTime);
    passwordController.addListener(_validatePasswordRealTime);
    confirmPasswordController.addListener(_validateConfirmPasswordRealTime);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _particleController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _validateEmailRealTime() {
    final email = emailController.text.trim();
    setState(() {
      if (email.isEmpty) {
        _emailHasError = false;
        _emailErrorText = null;
      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
        _emailHasError = true;
        _emailErrorText = 'Please enter a valid email address';
      } else {
        _emailHasError = false;
        _emailErrorText = null;
      }
    });
  }

  void _validatePasswordRealTime() {
    final password = passwordController.text;
    setState(() {
      if (password.isEmpty) {
        _passwordHasError = false;
        _passwordErrorText = null;
      } else if (password.length < 6) {
        _passwordHasError = true;
        _passwordErrorText = 'Password must be at least 6 characters';
      } else {
        _passwordHasError = false;
        _passwordErrorText = null;
      }
    });
    // Re-validate confirm password when password changes
    if (confirmPasswordController.text.isNotEmpty) {
      _validateConfirmPasswordRealTime();
    }
  }

  void _validateConfirmPasswordRealTime() {
    final confirmPassword = confirmPasswordController.text;
    final password = passwordController.text;
    setState(() {
      if (confirmPassword.isEmpty) {
        _confirmPasswordHasError = false;
        _confirmPasswordErrorText = null;
      } else if (confirmPassword != password) {
        _confirmPasswordHasError = true;
        _confirmPasswordErrorText = 'Passwords do not match';
      } else {
        _confirmPasswordHasError = false;
        _confirmPasswordErrorText = null;
      }
    });
  }

  void signUpUser() async {
    // Validate form
    if (emailController.text.trim().isEmpty) {
      setState(() {
        _emailHasError = true;
        _emailErrorText = 'Email is required';
      });
      return;
    }
    
    if (passwordController.text.isEmpty) {
      setState(() {
        _passwordHasError = true;
        _passwordErrorText = 'Password is required';
      });
      return;
    }

    if (confirmPasswordController.text.isEmpty) {
      setState(() {
        _confirmPasswordHasError = true;
        _confirmPasswordErrorText = 'Please confirm your password';
      });
      return;
    }

    if (_emailHasError || _passwordHasError || _confirmPasswordHasError) return;

    setState(() => _isLoading = true);

    try {
      var user = await _authService.signUp(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      
      if (user != null) {
        _showSuccessSnackBar("Account created successfully! Welcome to Learnify!");
        await Future.delayed(Duration(seconds: 1));
        Navigator.pop(context);
      }
    } catch (e) {
      String errorMessage = "Signup Failed. ";
      if (e.toString().contains('network-request-failed')) {
        errorMessage += "Please check your internet connection.";
      } else if (e.toString().contains('email-already-in-use')) {
        errorMessage += "Email already exists.";
      } else if (e.toString().contains('weak-password')) {
        errorMessage += "Password should be at least 6 characters.";
      } else if (e.toString().contains('invalid-email')) {
        errorMessage += "Please enter a valid email.";
      } else {
        errorMessage += "Please try again.";
      }
      
      _showErrorSnackBar(errorMessage);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.error_outline, color: Colors.white, size: 20),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Color(0xFFE53E3E),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.all(16),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.all(16),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1976D2),
              Color(0xFF1565C0),
              Color(0xFF0D47A1),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Animated background particles
            ...List.generate(8, (index) => _buildParticle(index)),
            
            // Main content
            SafeArea(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top -
                        MediaQuery.of(context).padding.bottom,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: FadeTransition(
                      opacity: _fadeInAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          children: [
                            // Back Button
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ),
                              ),
                            ),
                            
                            SizedBox(height: 20),
                            
                            // Logo Section
                            _buildLogoSection(),
                            
                            SizedBox(height: 32),
                            
                            // Sign Up Form Card
                            _buildSignUpForm(),
                            
                            SizedBox(height: 20),
                            
                            // Login Link
                            _buildLoginLink(),
                            
                            SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return Column(
      children: [
        // Modern logo container
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.25),
                Colors.white.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 5,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.person_add_rounded,
                size: 45,
                color: Colors.white,
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Color(0xFF03DAC6),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF03DAC6).withOpacity(0.4),
                        blurRadius: 6,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.auto_awesome,
                    size: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        SizedBox(height: 24),
        
        // Welcome text
        Text(
          "Join Learnify",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: -0.5,
            shadows: [
              Shadow(
                offset: Offset(0, 2),
                blurRadius: 4,
                color: Colors.black.withOpacity(0.2),
              ),
            ],
          ),
        ),
        
        SizedBox(height: 8),
        
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Text(
            "Start your learning journey today",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(0.9),
              letterSpacing: 0.3,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpForm() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 0,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Email field
              _buildModernTextField(
                controller: emailController,
                label: "Email Address",
                hint: "Enter your email",
                icon: Icons.email_outlined,
                hasError: _emailHasError,
                errorText: _emailErrorText,
                keyboardType: TextInputType.emailAddress,
              ),
              
              SizedBox(height: 20),
              
              // Password field
              _buildModernTextField(
                controller: passwordController,
                label: "Password",
                hint: "Create a strong password",
                icon: Icons.lock_outline,
                hasError: _passwordHasError,
                errorText: _passwordErrorText,
                isPassword: true,
                isPasswordVisible: _isPasswordVisible,
                onPasswordVisibilityToggle: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
              
              SizedBox(height: 20),
              
              // Confirm Password field
              _buildModernTextField(
                controller: confirmPasswordController,
                label: "Confirm Password",
                hint: "Re-enter your password",
                icon: Icons.lock_outline,
                hasError: _confirmPasswordHasError,
                errorText: _confirmPasswordErrorText,
                isPassword: true,
                isPasswordVisible: _isConfirmPasswordVisible,
                onPasswordVisibilityToggle: () {
                  setState(() {
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                  });
                },
              ),
              
              SizedBox(height: 24),
              
              // Sign Up button
              _buildSignUpButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool hasError = false,
    String? errorText,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onPasswordVisibilityToggle,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: hasError 
                  ? Color(0xFFE53E3E).withOpacity(0.5)
                  : Colors.transparent,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: hasError 
                    ? Color(0xFFE53E3E).withOpacity(0.1)
                    : Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            obscureText: isPassword && !isPasswordVisible,
            keyboardType: keyboardType,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1976D2),
            ),
            decoration: InputDecoration(
              labelText: label,
              hintText: hint,
              prefixIcon: Container(
                margin: EdgeInsets.all(12),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: hasError 
                      ? Color(0xFFE53E3E).withOpacity(0.1)
                      : Color(0xFF1976D2).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: hasError ? Color(0xFFE53E3E) : Color(0xFF1976D2),
                  size: 20,
                ),
              ),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                        color: Color(0xFF1976D2).withOpacity(0.7),
                      ),
                      onPressed: onPasswordVisibilityToggle,
                    )
                  : hasError 
                      ? Icon(Icons.error_outline, color: Color(0xFFE53E3E))
                      : controller.text.isNotEmpty && !hasError
                          ? Icon(Icons.check_circle, color: Color(0xFF4CAF50))
                          : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: hasError ? Color(0xFFE53E3E) : Color(0xFF1976D2),
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: Colors.white.withOpacity(0.9),
              labelStyle: TextStyle(
                color: hasError 
                    ? Color(0xFFE53E3E) 
                    : Color(0xFF1976D2).withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontWeight: FontWeight.w400,
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
          ),
        ),
        if (hasError && errorText != null)
          Padding(
            padding: EdgeInsets.only(left: 16, top: 8),
            child: Row(
              children: [
                Icon(
                  Icons.error_outline,
                  size: 16,
                  color: Color(0xFFE53E3E),
                ),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    errorText,
                    style: TextStyle(
                      color: Color(0xFFE53E3E),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildSignUpButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF1976D2).withOpacity(0.3),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : signUpUser,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: _isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_add_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                  SizedBox(width: 12),
                  Text(
                    "Create Account",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Already have an account? ",
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Color(0xFF03DAC6).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Color(0xFF03DAC6).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                "Sign In",
                style: TextStyle(
                  color: Color(0xFF03DAC6),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParticle(int index) {
    final positions = [
      Offset(0.1, 0.15),
      Offset(0.9, 0.1),
      Offset(0.8, 0.85),
      Offset(0.1, 0.9),
      Offset(0.3, 0.25),
      Offset(0.7, 0.7),
      Offset(0.2, 0.6),
      Offset(0.85, 0.4),
    ];
    
    final sizes = [6.0, 10.0, 4.0, 8.0, 3.0, 12.0, 5.0, 9.0];
    final colors = [
      Color(0xFF64B5F6).withOpacity(0.2),
      Color(0xFF42A5F5).withOpacity(0.15),
      Color(0xFF90CAF9).withOpacity(0.1),
      Color(0xFF2196F3).withOpacity(0.2),
      Color(0xFF1E88E5).withOpacity(0.12),
      Color(0xFF03DAC6).withOpacity(0.15),
      Color(0xFF1976D2).withOpacity(0.25),
      Color(0xFF0D47A1).withOpacity(0.18),
    ];

    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        return Positioned(
          left: MediaQuery.of(context).size.width * positions[index].dx,
          top: MediaQuery.of(context).size.height * positions[index].dy,
          child: Transform.rotate(
            angle: _particleRotation.value * 3.14159 * (index % 2 == 0 ? 1 : -1),
            child: Container(
              width: sizes[index],
              height: sizes[index],
              decoration: BoxDecoration(
                color: colors[index],
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: colors[index],
                    blurRadius: 3,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}