import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/alarm_provider.dart';
import '../../domain/entities/alarm.dart';
import '../../core/constants/colors.dart';

class AddAlarmScreen extends ConsumerStatefulWidget {
  const AddAlarmScreen({super.key});

  @override
  ConsumerState<AddAlarmScreen> createState() => _AddAlarmScreenState();
}

class _AddAlarmScreenState extends ConsumerState<AddAlarmScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isActive = true;
  final List<String> _selectedDays = [];
  String _selectedSound = 'Sonido predeterminado';
  double _vibrationIntensity = 0.5;

  final Map<String, String> _weekDays = {
    'LUN': 'Lunes',
    'MAR': 'Martes',
    'MIE': 'Miércoles',
    'JUE': 'Jueves',
    'VIE': 'Viernes',
    'SAB': 'Sábado',
    'DOM': 'Domingo',
  };

  final List<Map<String, dynamic>> _presetAlarms = [
    {
      'name': 'Despertar',
      'icon': Icons.wb_sunny_outlined,
      'time': TimeOfDay(hour: 7, minute: 0),
    },
    {
      'name': 'Ejercicio',
      'icon': Icons.fitness_center,
      'time': TimeOfDay(hour: 6, minute: 0),
    },
    {
      'name': 'Trabajo',
      'icon': Icons.work_outline,
      'time': TimeOfDay(hour: 8, minute: 0),
    },
    {
      'name': 'Estudios',
      'icon': Icons.school_outlined,
      'time': TimeOfDay(hour: 9, minute: 0),
    },
  ];

  final List<String> _availableSounds = [
    'Sonido predeterminado',
    'Campana',
    'Cascada',
    'Piano',
    'Guitarra',
    'Tambores',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: AppColors.surface,
              hourMinuteShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              dayPeriodShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              dayPeriodColor: AppColors.onBackground.withOpacity(0.1),
              dayPeriodTextColor: AppColors.onBackground,
              dayPeriodBorderSide: BorderSide(
                color: AppColors.onBackground.withOpacity(0.2),
              ),
              dialHandColor: AppColors.onBackground,
              dialBackgroundColor: AppColors.onBackground.withOpacity(0.1),
              dialTextColor: AppColors.onBackground,
              entryModeIconColor: AppColors.onBackground,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.onBackground,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _toggleDay(String day) {
    setState(() {
      if (_selectedDays.contains(day)) {
        _selectedDays.remove(day);
      } else {
        _selectedDays.add(day);
      }
    });
  }

  void _applyPreset(Map<String, dynamic> preset) {
    setState(() {
      _nameController.text = preset['name'];
      _selectedTime = preset['time'];
    });
  }

  void _saveAlarm() {
    if (_formKey.currentState!.validate()) {
      final now = DateTime.now();
      final alarmDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      final newAlarm = Alarm(
        id: DateTime.now().millisecondsSinceEpoch % 2147483647,
        name: _nameController.text,
        time: alarmDateTime,
        isActive: _isActive,
        days: _selectedDays,
      );

      ref.read(alarmsProvider.notifier).addAlarm(newAlarm);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Nueva Alarma',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 24,
            color: AppColors.onBackground,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.onBackground),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Presets de alarmas
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Presets',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.onBackground,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _presetAlarms.length,
                      itemBuilder: (context, index) {
                        final preset = _presetAlarms[index];
                        return GestureDetector(
                          onTap: () => _applyPreset(preset),
                          child: Container(
                            width: 80,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.onBackground.withOpacity(0.1),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  preset['icon'],
                                  color: AppColors.onBackground,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  preset['name'],
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: AppColors.onBackground,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.onBackground.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      style: const TextStyle(color: AppColors.onBackground),
                      decoration: InputDecoration(
                        labelText: 'Nombre de la alarma',
                        labelStyle: TextStyle(color: AppColors.onBackground.withOpacity(0.7)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.onBackground.withOpacity(0.2)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.onBackground.withOpacity(0.2)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.onBackground),
                        ),
                        prefixIcon: Icon(
                          Icons.label_outline_rounded,
                          color: AppColors.onBackground.withOpacity(0.7),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa un nombre';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.onBackground.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.access_time_rounded,
                          color: AppColors.onBackground.withOpacity(0.7),
                        ),
                      ),
                      title: Text(
                        'Hora',
                        style: TextStyle(
                          color: AppColors.onBackground,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          color: AppColors.onBackground.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.edit_rounded,
                          color: AppColors.onBackground.withOpacity(0.7),
                        ),
                        onPressed: _selectTime,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Días de la semana',
                          style: TextStyle(
                            color: AppColors.onBackground,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _weekDays.entries.map((entry) {
                            final isSelected = _selectedDays.contains(entry.key);
                            return FilterChip(
                              label: Text(
                                entry.value,
                                style: TextStyle(
                                  color: isSelected ? AppColors.background : AppColors.onBackground,
                                  fontSize: 14,
                                ),
                              ),
                              selected: isSelected,
                              onSelected: (selected) => _toggleDay(entry.key),
                              backgroundColor: AppColors.onBackground.withOpacity(0.1),
                              selectedColor: AppColors.onBackground,
                              checkmarkColor: AppColors.background,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                  color: isSelected ? AppColors.onBackground : AppColors.onBackground.withOpacity(0.2),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.onBackground.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.music_note_rounded,
                          color: AppColors.onBackground.withOpacity(0.7),
                        ),
                      ),
                      title: Text(
                        'Sonido',
                        style: TextStyle(
                          color: AppColors.onBackground,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        _selectedSound,
                        style: TextStyle(
                          color: AppColors.onBackground.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                      trailing: PopupMenuButton<String>(
                        icon: Icon(
                          Icons.arrow_drop_down_rounded,
                          color: AppColors.onBackground.withOpacity(0.7),
                        ),
                        itemBuilder: (context) => _availableSounds
                            .map(
                              (sound) => PopupMenuItem(
                                value: sound,
                                child: Text(sound),
                              ),
                            )
                            .toList(),
                        onSelected: (value) {
                          setState(() {
                            _selectedSound = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Intensidad de vibración',
                              style: TextStyle(
                                color: AppColors.onBackground,
                                fontSize: 16,
                              ),
                            ),
                            Icon(
                              _vibrationIntensity > 0.7
                                  ? Icons.vibration
                                  : _vibrationIntensity > 0.3
                                      ? Icons.vibration_outlined
                                      : Icons.notifications_off_outlined,
                              color: AppColors.onBackground.withOpacity(0.7),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Slider(
                          value: _vibrationIntensity,
                          onChanged: (value) {
                            setState(() {
                              _vibrationIntensity = value;
                            });
                          },
                          activeColor: AppColors.onBackground,
                          inactiveColor: AppColors.onBackground.withOpacity(0.2),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: Text(
                        'Activar alarma',
                        style: TextStyle(color: AppColors.onBackground),
                      ),
                      value: _isActive,
                      onChanged: (value) {
                        setState(() {
                          _isActive = value;
                        });
                      },
                      activeColor: AppColors.onBackground,
                      activeTrackColor: AppColors.onBackground.withOpacity(0.5),
                      inactiveThumbColor: AppColors.onBackground.withOpacity(0.7),
                      inactiveTrackColor: AppColors.onBackground.withOpacity(0.2),
                      thumbIcon: MaterialStateProperty.resolveWith<Icon?>((Set<MaterialState> states) {
                        if (states.contains(MaterialState.selected)) {
                          return Icon(
                            Icons.check,
                            color: AppColors.background,
                          );
                        }
                        return Icon(
                          Icons.close,
                          color: AppColors.onBackground.withOpacity(0.7),
                        );
                      }),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveAlarm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.surface,
                  foregroundColor: AppColors.onBackground,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: AppColors.onBackground.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                ),
                child: const Text(
                  'Guardar Alarma',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
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