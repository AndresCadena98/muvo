import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muvo/core/config/app_config.dart';
import 'package:muvo/core/l10n/app_localizations.dart';
import 'package:muvo/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Future<void> _showLogoutDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppConfig.darkCardColor,
          title: Text(
            l10n.logout,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppConfig.textPrimaryColor,
            ),
          ),
          content: Text(
            l10n.logoutConfirmation,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppConfig.textPrimaryColor,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                l10n.cancel,
                style: TextStyle(color: AppConfig.primaryColor),
              ),
            ),
            TextButton(
              onPressed: () {
                context.read<SettingsCubit>().signOut();
                Navigator.of(context).pop();
              },
              child: Text(
                l10n.signOut,
                style: TextStyle(color: AppConfig.primaryColor),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        if (state is SettingsLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final user = state is SettingsLoaded ? state.user : null;
        
        return BlocListener<SettingsCubit, SettingsState>(
          listener: (context, state) {
            if (state is SettingsError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${state.message}'),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state is SettingsUnauthenticated) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/login',
                (route) => false,
              );
            }
          },
          child: Scaffold(
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.settings,
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontSize: 28,
                                  color: AppConfig.textPrimaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                l10n.customizeExperience,
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: AppConfig.textSecondaryColor,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Lista de ajustes
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        if (user != null) ...[
                          _buildSection(l10n.account, [
                            _buildUserInfo(
                              email: user.email ?? 'No email',
                              displayName: user.displayName ?? 'Usuario',
                              photoURL: user.photoURL,
                              context: context,
                            ),
                          ], context),
                          const SizedBox(height: 32),
                        ],
                        _buildSection(l10n.settings, [
                          _buildSettingItem(
                            icon: Icons.language_rounded,
                            title: l10n.language,
                            subtitle: context.read<SettingsCubit>().getCurrentLanguage() == 'es' ? 'Español' : 'English',
                            onTap: () => _showLanguageDialog(context),
                            context: context,
                          ),
                          _buildSettingItem(
                            icon: Icons.notifications_rounded,
                            title: l10n.notifications,
                            subtitle: 'Activadas',
                            onTap: () {},
                            context: context,
                          ),
                        ], context),
                        const SizedBox(height: 32),
                        _buildSection(l10n.account, [
                          _buildSettingItem(
                            icon: Icons.logout_rounded,
                            title: l10n.logout,
                            subtitle: l10n.logoutMessage,
                            onTap: () => _showLogoutDialog(context),
                            context: context,
                          ),
                        ], context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildUserInfo({
    required String email,
    required String displayName,
    String? photoURL,
    required BuildContext context,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConfig.darkCardColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppConfig.primaryColor.withOpacity(0.1),
            backgroundImage: photoURL != null ? NetworkImage(photoURL) : null,
            child: photoURL == null
                ? Text(
                    displayName[0].toUpperCase(),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppConfig.primaryColor,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppConfig.darkTextSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppConfig.textPrimaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppConfig.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: AppConfig.primaryColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppConfig.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppConfig.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppConfig.textSecondaryColor,
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.language),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Español'),
              onTap: () {
                context.read<SettingsCubit>().setLanguage('es');
                Navigator.pop(context);
              },
              trailing: context.read<SettingsCubit>().getCurrentLanguage() == 'es'
                  ? const Icon(Icons.check, color: AppConfig.primaryColor)
                  : null,
            ),
            ListTile(
              title: const Text('English'),
              onTap: () {
                context.read<SettingsCubit>().setLanguage('en');
                Navigator.pop(context);
              },
              trailing: context.read<SettingsCubit>().getCurrentLanguage() == 'en'
                  ? const Icon(Icons.check, color: AppConfig.primaryColor)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
} 