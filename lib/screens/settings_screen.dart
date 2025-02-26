import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final String initialName;
  final int initialDays;
  final bool initialNotifications;

  const SettingsScreen({
    super.key,
    required this.initialName,
    required this.initialDays,
    required this.initialNotifications,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final TextEditingController _nameController;  // Changed to late final
  int _daysUntilPayday = 0;
  bool _notificationsEnabled = true;
  bool _hasChanges = false;
  
  String _initialName = '';
  int _initialDays = 0;
  bool _initialNotifications = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _daysUntilPayday = widget.initialDays;
    _notificationsEnabled = widget.initialNotifications;
    
    _initialName = widget.initialName;
    _initialDays = widget.initialDays;
    _initialNotifications = widget.initialNotifications;
    
    _nameController.addListener(_checkChanges);
  }

  @override
  void dispose() {
    _nameController.removeListener(_checkChanges);
    _nameController.dispose();
    super.dispose();
  }

  void _checkChanges() {
    setState(() {
      _hasChanges = _nameController.text != _initialName ||
          _daysUntilPayday != _initialDays ||
          _notificationsEnabled != _initialNotifications;
    });
  }

  // Update the days setter
  void _updateDays(int newDays) {
    setState(() {
      _daysUntilPayday = newDays;
      _checkChanges();
    });
  }

  // Update the notifications setter
  void _updateNotifications(bool value) {
    setState(() {
      _notificationsEnabled = value;
      _checkChanges();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const Expanded(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.only(right: 48), // Compensate for back button width
                          child: Text(
                            'Configuración',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Expanded(
                  child: ListView(
                    children: [
                      _buildSettingSection(
                        title: 'Nombre de Usuario',
                        child: TextField(
                          controller: _nameController,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Ingresa tu nombre',
                            hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildSettingSection(
                        title: 'Días para la Quincena',
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    color: Colors.white.withOpacity(0.7),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Faltan $_daysUntilPayday días',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  _AnimatedCircleButton(
                                    icon: Icons.remove,
                                    color: const Color(0xFFE53935),
                                    onPressed: () {
                                      if (_daysUntilPayday > 0) {
                                        _updateDays(_daysUntilPayday - 1);
                                      }
                                    },
                                  ),
                                  const SizedBox(width: 12),
                                  _AnimatedCircleButton(
                                    icon: Icons.add,
                                    color: const Color(0xFF4CAF50),
                                    onPressed: () {
                                      if (_daysUntilPayday < 15) {
                                        _updateDays(_daysUntilPayday + 1);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildSettingSection(
                        title: 'Notificaciones',
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.notifications_outlined,
                                    color: Colors.white.withOpacity(0.7),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  const Text(
                                    'Habilitar Notificaciones',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              Switch.adaptive(
                                value: _notificationsEnabled,
                                onChanged: _updateNotifications,
                                activeColor: const Color(0xFF4CAF50),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: AnimatedOpacity(
                      opacity: _hasChanges ? 1.0 : 0.5,
                      duration: const Duration(milliseconds: 200),
                      child: ElevatedButton(
                        onPressed: _hasChanges
                            ? () {
                                Navigator.pop(context, {
                                  'name': _nameController.text,
                                  'days': _daysUntilPayday,
                                  'notifications': _notificationsEnabled,
                                });
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2979FF),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Guardar Cambios',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingSection({
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

// Add this new widget class at the bottom of the file
class _AnimatedCircleButton extends StatefulWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _AnimatedCircleButton({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  State<_AnimatedCircleButton> createState() => _AnimatedCircleButtonState();
}

class _AnimatedCircleButtonState extends State<_AnimatedCircleButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) {
          _controller.reverse();
          widget.onPressed();
        },
        onTapCancel: () => _controller.reverse(),
        borderRadius: BorderRadius.circular(20),
        splashColor: Colors.white24,
        highlightColor: Colors.white10,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: widget.color.withOpacity(0.9),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: widget.color.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Icon(
              widget.icon,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}