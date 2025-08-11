import 'package:burger_app_full/Core/Utils/const.dart';
import 'package:burger_app_full/Core/models/user_profile_model.dart';
import 'package:burger_app_full/pages/Screen/edit_profile_screen.dart';
import 'package:burger_app_full/pages/Screen/favorites_screen.dart';
import 'package:burger_app_full/pages/Screen/order_history_screen.dart';
import 'package:burger_app_full/service/auth_service.dart';
import 'package:burger_app_full/service/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService authService = AuthService();
  final ProfileService profileService = ProfileService();
  UserProfileModel? userProfile;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    setState(() => isLoading = true);
    try {
      final profile = await profileService.getCurrentUserProfile();
      if (profile == null) {
        // Initialize profile for new users
        final newProfile = await profileService.initializeProfile();
        setState(() {
          userProfile = newProfile;
          isLoading = false;
        });
      } else {
        setState(() {
          userProfile = profile;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading profile: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey1,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Iconsax.edit, color: red),
            onPressed: () {
              // Navigate to edit profile
              _navigateToEditProfile();
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: red))
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildProfileHeader(),
                  SizedBox(height: 30),
                  _buildAccountSection(),
                  SizedBox(height: 20),
                  _buildOrderSection(),
                  SizedBox(height: 20),
                  _buildSettingsSection(),
                  SizedBox(height: 20),
                  _buildSupportSection(),
                  SizedBox(height: 30),
                  _buildLogoutButton(),
                  SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: _changeProfilePicture,
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: red.withOpacity(0.1),
                  backgroundImage: userProfile?.avatarUrl != null
                      ? NetworkImage(userProfile!.avatarUrl!)
                      : null,
                  child: userProfile?.avatarUrl == null
                      ? Text(
                          userProfile?.initials ?? '?',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: red,
                          ),
                        )
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: red,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Iconsax.camera,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Text(
            userProfile?.displayName ?? 'User',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 4),
          Text(
            userProfile?.email ?? '',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          if (userProfile?.phone != null) ...[
            SizedBox(height: 4),
            Text(
              userProfile!.phone!,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAccountSection() {
    return _buildSection(
      title: 'Account',
      children: [
        _buildMenuItem(
          icon: Iconsax.user,
          title: 'Edit Profile',
          subtitle: 'Update your personal information',
          onTap: _navigateToEditProfile,
        ),
        _buildMenuItem(
          icon: Iconsax.lock,
          title: 'Change Password',
          subtitle: 'Update your account password',
          onTap: () {
            // TODO: Implement change password
          },
        ),
        _buildMenuItem(
          icon: Iconsax.location,
          title: 'Addresses',
          subtitle: 'Manage delivery addresses',
          onTap: () {
            // TODO: Implement addresses
          },
        ),
      ],
    );
  }

  Widget _buildOrderSection() {
    return _buildSection(
      title: 'Orders & Preferences',
      children: [
        _buildMenuItem(
          icon: Iconsax.bag_2,
          title: 'Order History',
          subtitle: 'View your past orders',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderHistoryScreen(),
              ),
            );
          },
        ),
        _buildMenuItem(
          icon: Iconsax.heart,
          title: 'Favorites',
          subtitle: 'Your favorite items',
          onTap: _navigateToFavorites,
        ),
      ],
    );
  }

  Widget _buildSettingsSection() {
    return _buildSection(
      title: 'Settings',
      children: [
        _buildMenuItem(
          icon: Iconsax.notification,
          title: 'Notifications',
          subtitle: 'Manage notification preferences',
          onTap: () {
            // TODO: Implement notification settings
          },
          trailing: Switch(
            value: userProfile?.notificationsEnabled ?? true,
            activeColor: red,
            onChanged: _toggleNotifications,
          ),
        ),
        _buildMenuItem(
          icon: Iconsax.moon,
          title: 'Theme',
          subtitle: userProfile?.theme ?? 'System',
          onTap: _showThemeSelector,
        ),
        _buildMenuItem(
          icon: Iconsax.global,
          title: 'Language',
          subtitle: 'English',
          onTap: () {
            // TODO: Implement language selection
          },
        ),
      ],
    );
  }

  Widget _buildSupportSection() {
    return _buildSection(
      title: 'Support',
      children: [
        _buildMenuItem(
          icon: Iconsax.message_question,
          title: 'Help & FAQ',
          subtitle: 'Get help and find answers',
          onTap: () {
            // TODO: Navigate to help
          },
        ),
        _buildMenuItem(
          icon: Iconsax.call,
          title: 'Contact Us',
          subtitle: 'Reach out for support',
          onTap: () {
            // TODO: Implement contact us
          },
        ),
        _buildMenuItem(
          icon: Iconsax.document_text,
          title: 'Terms & Privacy',
          subtitle: 'Review our policies',
          onTap: () {
            // TODO: Navigate to terms
          },
        ),
      ],
    );
  }

  Widget _buildSection({required String title, required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: red, size: 20),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            trailing ??
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[400],
                  size: 16,
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () => _showLogoutDialog(),
        style: ElevatedButton.styleFrom(
          backgroundColor: red.withOpacity(0.1),
          foregroundColor: red,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.logout, size: 20),
            SizedBox(width: 8),
            Text(
              'Logout',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToEditProfile() async {
    if (userProfile == null) return;
    
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(userProfile: userProfile!),
      ),
    );
    
    // Refresh profile if changes were made
    if (result != null && result is UserProfileModel) {
      setState(() {
        userProfile = result;
      });
    }
  }

  void _navigateToFavorites() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FavoritesScreen(),
      ),
    );
  }

  void _changeProfilePicture() {
    // TODO: Implement image picker
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Change Profile Picture - Coming Soon!')),
    );
  }

  void _toggleNotifications(bool value) async {
    final success = await profileService.updateProfileField('notifications_enabled', value);
    if (success) {
      setState(() {
        userProfile = userProfile?.copyWith(notificationsEnabled: value);
      });
    }
  }

  void _showThemeSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Choose Theme',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            _buildThemeOption('Light', 'light'),
            _buildThemeOption('Dark', 'dark'),
            _buildThemeOption('System', 'system'),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(String title, String value) {
    final isSelected = userProfile?.theme == value;
    return ListTile(
      title: Text(title),
      trailing: isSelected ? Icon(Icons.check, color: red) : null,
      onTap: () async {
        Navigator.pop(context);
        final success = await profileService.updateProfileField('theme', value);
        if (success) {
          setState(() {
            userProfile = userProfile?.copyWith(theme: value);
          });
        }
      },
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              authService.Logout(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: red),
            child: Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
