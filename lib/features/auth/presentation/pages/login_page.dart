import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muvo/core/config/app_config.dart';
import 'package:muvo/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:muvo/features/movies/presentation/pages/movies_page.dart';
import 'package:muvo/core/widgets/error_display.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isRegister = false;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _toggleMode() {
    setState(() {
      isRegister = !isRegister;
    });
  }

  void _onEmailAuth(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      if (isRegister) {
        context.read<AuthBloc>().add(
              SignUpWithEmailRequested(
                email: _emailController.text.trim(),
                password: _passwordController.text.trim(),
              ),
            );
      } else {
        context.read<AuthBloc>().add(
              SignInWithEmailRequested(
                email: _emailController.text.trim(),
                password: _passwordController.text.trim(),
              ),
            );
      }
    }
  }

  dynamic _showResetPasswordDialog(BuildContext context) async {
    final emailController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Recuperar contraseña'),
        content: TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Correo electrónico',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              if (emailController.text.isNotEmpty) {
                context.read<AuthBloc>().add(
                  SendPasswordResetEmailRequested(email: emailController.text.trim()),
                );
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Se ha enviado un correo para restablecer tu contraseña.')),
                );
              }
            },
            child: const Text('Enviar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const MoviesPage()),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppConfig.backgroundColor,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título principal
                    Text(
                      isRegister ? 'Crear cuenta' : 'Iniciar sesión',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppConfig.textPrimaryColor,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isRegister
                          ? 'Únete a nuestra comunidad'
                          : 'Bienvenido de nuevo',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppConfig.textSecondaryColor,
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Formulario
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Correo electrónico',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppConfig.textSecondaryColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppConfig.textPrimaryColor,
                            ),
                            decoration: InputDecoration(
                              hintText: 'ejemplo@correo.com',
                              filled: true,
                              fillColor: AppConfig.surfaceColor,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Ingresa tu correo';
                              }
                              if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+').hasMatch(value)) {
                                return 'Correo no válido';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Contraseña',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppConfig.textSecondaryColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppConfig.textPrimaryColor,
                            ),
                            decoration: InputDecoration(
                              hintText: '••••••••',
                              filled: true,
                              fillColor: AppConfig.surfaceColor,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Ingresa tu contraseña';
                              }
                              if (value.length < 6) {
                                return 'Mínimo 6 caracteres';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () => _showResetPasswordDialog(context),
                              child: Text(
                                '¿Olvidaste tu contraseña?',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppConfig.accentColor,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () => _onEmailAuth(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppConfig.accentColor,
                                foregroundColor: AppConfig.backgroundColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                isRegister ? 'Crear cuenta' : 'Iniciar sesión',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppConfig.backgroundColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Separador
                    Row(
                      children: [
                        Expanded(child: Divider(color: AppConfig.textSecondaryColor.withOpacity(0.2))),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'O continúa con',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppConfig.textSecondaryColor,
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: AppConfig.textSecondaryColor.withOpacity(0.2))),
                      ],
                    ),
                    const SizedBox(height: 32),
                    // Botón de Google
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        final isLoading = state is AuthLoading;
                        return SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: isLoading
                              ? ElevatedButton(
                                  onPressed: null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black87,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                )
                              : OutlinedButton.icon(
                                  onPressed: () {
                                    context.read<AuthBloc>().add(SignInWithGoogleRequested());
                                  },
                                  icon: const Icon(Icons.g_mobiledata, size: 24),
                                  label: const Text('Google'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppConfig.textPrimaryColor,
                                    side: BorderSide(color: AppConfig.textSecondaryColor.withOpacity(0.2)),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    // Link para alternar entre login y registro
                    Center(
                      child: TextButton(
                        onPressed: _toggleMode,
                        child: Text(
                          isRegister
                              ? '¿Ya tienes cuenta? Inicia sesión'
                              : '¿No tienes cuenta? Regístrate',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppConfig.accentColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Mensaje de error
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        if (state is AuthAuthenticated && isRegister) {
                          if (!(state.user.emailVerified)) {
                            WidgetsBinding.instance.addPostFrameCallback((_) async {
                              await state.user.sendEmailVerification();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Te enviamos un correo para verificar tu cuenta.')),
                              );
                            });
                          }
                        }
                        if (state is AuthError) {
                          return ErrorDisplay(
                            message: state.exception.message,
                            suggestion: state.exception.suggestion,
                            onRetry: () {
                              if (isRegister) {
                                context.read<AuthBloc>().add(
                                  SignUpWithEmailRequested(
                                    email: _emailController.text.trim(),
                                    password: _passwordController.text,
                                  ),
                                );
                              } else {
                                context.read<AuthBloc>().add(
                                  SignInWithEmailRequested(
                                    email: _emailController.text.trim(),
                                    password: _passwordController.text,
                                  ),
                                );
                              }
                            },
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
} 