import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/app_providers.dart';
import '../../../../core/utils/dropdown_localizer.dart';
import '../../../../l10n/app_localizations.dart';

class PartnerPreferenceScreen extends ConsumerStatefulWidget {
  const PartnerPreferenceScreen({super.key});

  @override
  ConsumerState<PartnerPreferenceScreen> createState() => _PartnerPreferenceScreenState();
}

class _PartnerPreferenceScreenState extends ConsumerState<PartnerPreferenceScreen> {
  final _formKey = GlobalKey<FormState>();

  late int _ageMin;
  late int _ageMax;
  late String _height;
  late String _religion;
  late String _caste;
  late String _city;
  late String _education;
  late String _occupation;
  late String _income;
  late String _maritalStatus;
  late String _diet;
  late String _manglik;
  bool _initialized = false;
  bool _isSaving = false;

  final List<String> _heights = [
    'Any',
    '4\'10" - 5\'2"',
    '5\'0" - 5\'6"',
    '5\'2" - 5\'8"',
    '5\'2" - 6\'0"',
    '5\'5" - 6\'0"',
    '5\'8" - 6\'2"',
    '6\'0" & Above',
  ];

  final List<String> _religions = [
    'Hindu',
    'Christian',
    'Muslim',
    'Sikh',
    'Jain',
    'Buddhist',
    'Any',
  ];

  final List<String> _castes = [
    'Any',
    'Kunbi',
    'Maratha',
    'Brahmin',
    'Nair',
    'Ezhava',
    'Lingayat',
    'Rajput',
    'Other',
  ];

  final List<String> _cities = [
    'Pune',
    'Mumbai',
    'Nagpur',
    'Nashik',
    'Amravati',
    'Akola',
    'Buldhana',
    'Washim',
    'Yavatmal',
    'Ahmedabad',
    'Hyderabad',
    'Bengaluru',
    'Delhi',
    'Any',
    'Other',
  ];

  final List<String> _educations = [
    'Bachelor\'s',
    'Master\'s',
    'B.Tech',
    'M.Tech',
    'M.B.A',
    'Doctorate',
    'Ph.D',
    'MBBS',
    'B.Com',
    'M.Com',
    'B.Sc',
    'Any',
    'Other',
  ];

  final List<String> _occupations = [
    'Software Engineer',
    'Chartered Accountant',
    'Doctor (MD/MBBS)',
    'Architect',
    'Bank Manager',
    'Civil Engineer',
    'Teacher/Professor',
    'Business Owner',
    'Government Officer',
    'Any',
    'Other',
  ];

  void _syncFromPref(PartnerPreference pref) {
    _ageMin = pref.ageMin;
    _ageMax = pref.ageMax;
    _height = pref.height;
    _religion = pref.religion;
    _caste = pref.caste;
    _city = pref.city;
    _education = pref.education;
    _occupation = pref.occupation;
    _income = pref.income;
    _maritalStatus = pref.maritalStatus;
    _diet = pref.diet;
    _manglik = pref.manglik;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _syncFromPref(ref.read(partnerPreferenceProvider));
      _initialized = true;
    }
  }

  List<String> _resolveOptions(List<String> baseOptions, String currentValue) {
    final result = List<String>.from(baseOptions);
    final trimmed = currentValue.trim();
    if (trimmed.isNotEmpty && !result.any((e) => e.toLowerCase() == trimmed.toLowerCase())) {
      result.insert(0, trimmed);
    }
    return result;
  }

  Future<void> _handleSave() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);
    try {
      final updatedPref = PartnerPreference(
        ageMin: _ageMin,
        ageMax: _ageMax,
        height: _height,
        religion: _religion,
        caste: _caste,
        city: _city,
        education: _education,
        occupation: _occupation,
        income: _income,
        maritalStatus: _maritalStatus,
        diet: _diet,
        manglik: _manglik,
      );

      await ref.read(partnerPreferenceProvider.notifier).save(updatedPref);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Partner preference saved successfully.'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save preferences: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen for provider updates to keep state synchronized
    ref.listen<PartnerPreference>(partnerPreferenceProvider, (previous, next) {
      if (!_isSaving) {
        setState(() {
          _syncFromPref(next);
        });
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFFFF1F4), // Soft pink screen background
      body: SafeArea(
        child: RefreshIndicator(
          color: const Color(0xFFC0003E),
          onRefresh: () async {
            try {
              await ref.read(partnerPreferenceProvider.notifier).refresh();
              final updated = ref.read(partnerPreferenceProvider);
              if (mounted) {
                setState(() {
                  _syncFromPref(updated);
                });
              }
            } catch (_) {}
          },
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Romantic Top Header with Couple & Floating Hearts
                  SizedBox(
                    height: 165,
                    child: Stack(
                      children: [
                        // Layered rolling soft pink landscape
                        Positioned.fill(
                          child: CustomPaint(
                            painter: _HeaderLandscapePainter(),
                          ),
                        ),

                        // Two overlapping outlined pink hearts in upper-right corner
                        Positioned(
                          top: 10,
                          right: 18,
                          child: CustomPaint(
                            size: const Size(60, 50),
                            painter: _OverlappingHeartsPainter(),
                          ),
                        ),

                        // Couple illustration seated together looking out
                        Positioned(
                          right: 48,
                          bottom: 0,
                          child: Image.asset(
                            'assets/images/couple1.png',
                            height: 108,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                const SizedBox.shrink(),
                          ),
                        ),

                        // Back arrow, Title, and Subtitle on the left
                        Positioned(
                          top: 10,
                          left: 16,
                          right: 150,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (Navigator.canPop(context)) {
                                    Navigator.pop(context);
                                  }
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4.0),
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: Color(0xFF1E1E1E),
                                    size: 24,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                AppLocalizations.of(context)?.partnerPreferences ?? 'Partner Preference',
                                style: const TextStyle(
                                  color: Color(0xFFC0003E),
                                  fontSize: 25,
                                  fontFamily: 'serif',
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                  height: 1.15,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                AppLocalizations.of(context)?.savePreferences ?? 'Set your partner requirements',
                                style: const TextStyle(
                                  color: Color(0xFF6B7280),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 2. Main Rounded White Form Card with 7 Preference Rows
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFFFFE0E8), width: 1.0),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFC0003E).withValues(alpha: 0.04),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Column(
                        children: [
                          // 1. Age Range Row
                          _buildAgeRangeRow(),
                          const Divider(color: Color(0xFFFFEEF3), height: 18, thickness: 1.0),

                          // 2. Height Expectation Row
                          _buildPreferenceRow(
                            icon: Icons.straighten_rounded,
                            label: 'Height expectation',
                            currentValue: _height,
                            options: _heights,
                            onChanged: (val) => setState(() => _height = val),
                          ),
                          const Divider(color: Color(0xFFFFEEF3), height: 18, thickness: 1.0),

                          // 3. Religion Row with Om Symbol
                          _buildPreferenceRow(
                            customIcon: const Text(
                              'ॐ',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFC0003E),
                                height: 1.0,
                              ),
                            ),
                            label: 'Religion',
                            currentValue: _religion,
                            options: _religions,
                            onChanged: (val) => setState(() => _religion = val),
                          ),
                          const Divider(color: Color(0xFFFFEEF3), height: 18, thickness: 1.0),

                          // 4. Caste Expectation Row
                          _buildPreferenceRow(
                            icon: Icons.groups_rounded,
                            label: 'Caste expectation',
                            currentValue: _caste,
                            options: _castes,
                            onChanged: (val) => setState(() => _caste = val),
                          ),
                          const Divider(color: Color(0xFFFFEEF3), height: 18, thickness: 1.0),

                          // 5. City Preference Row
                          _buildPreferenceRow(
                            icon: Icons.location_on_rounded,
                            label: 'City preference',
                            currentValue: _city,
                            options: _cities,
                            onChanged: (val) => setState(() => _city = val),
                          ),
                          const Divider(color: Color(0xFFFFEEF3), height: 18, thickness: 1.0),

                          // 6. Education Level Row
                          _buildPreferenceRow(
                            icon: Icons.school_rounded,
                            label: 'Education level',
                            currentValue: _education,
                            options: _educations,
                            onChanged: (val) => setState(() => _education = val),
                          ),
                          const Divider(color: Color(0xFFFFEEF3), height: 18, thickness: 1.0),

                          // 7. Occupation Preference Row
                          _buildPreferenceRow(
                            icon: Icons.work_rounded,
                            label: 'Occupation preference',
                            currentValue: _occupation,
                            options: _occupations,
                            onChanged: (val) => setState(() => _occupation = val),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 3. Large Rounded Save Changes Button
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 22, 16, 28),
                    child: SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : _handleSave,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFC0003E),
                          foregroundColor: Colors.white,
                          elevation: 1.5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        child: _isSaving
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Text(
                                AppLocalizations.of(context)?.savePreferences ?? 'Save Changes',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.3,
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
      ),
    );
  }

  // Row 1: Age range row with two side-by-side dropdowns separated by dash
  Widget _buildAgeRangeRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFFFE8EF),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.calendar_month_outlined,
              color: Color(0xFFC0003E),
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Age range',
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E1E1E),
              ),
            ),
          ),
          _buildAgeDropdown(
            value: _ageMin,
            items: List.generate(43, (i) => i + 18),
            onChanged: (val) {
              if (val != null) setState(() => _ageMin = val);
            },
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.0),
            child: Text(
              '–',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF9E9E9E),
              ),
            ),
          ),
          _buildAgeDropdown(
            value: _ageMax,
            items: List.generate(43, (i) => i + 18),
            onChanged: (val) {
              if (val != null) setState(() => _ageMax = val);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAgeDropdown({
    required int value,
    required List<int> items,
    required ValueChanged<int?> onChanged,
  }) {
    final resolvedItems = items.contains(value) ? items : [value, ...items];
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFFDDE6), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: value,
          isDense: true,
          icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF333333), size: 20),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(14),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E1E1E),
          ),
          items: resolvedItems.map((age) {
            return DropdownMenuItem<int>(
              value: age,
              child: Text(
                '$age',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E1E1E),
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  // Rows 2-7: Reusable row with icon, label, and right-aligned dropdown pill
  Widget _buildPreferenceRow({
    IconData? icon,
    Widget? customIcon,
    required String label,
    required String currentValue,
    required List<String> options,
    required ValueChanged<String> onChanged,
  }) {
    final resolvedOptions = _resolveOptions(options, currentValue);
    final selected = resolvedOptions.contains(currentValue)
        ? currentValue
        : (resolvedOptions.isNotEmpty ? resolvedOptions.first : '');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFFFE8EF),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: customIcon ??
                Icon(
                  icon,
                  color: const Color(0xFFC0003E),
                  size: 22,
                ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E1E1E),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            height: 38,
            constraints: const BoxConstraints(minWidth: 100, maxWidth: 180),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFFFDDE6), width: 1.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selected,
                isDense: true,
                isExpanded: false,
                icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF333333), size: 20),
                dropdownColor: Colors.white,
                borderRadius: BorderRadius.circular(14),
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E1E1E),
                ),
                items: resolvedOptions.map((opt) {
                  return DropdownMenuItem<String>(
                    value: opt,
                    child: Text(
                      DropdownLocalizer.getLabel(context, opt),
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1E1E1E),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    onChanged(val);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Two overlapping delicate outline pink hearts for top-right header
class _OverlappingHeartsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE8507D)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Main / Left larger heart
    final path1 = Path();
    final w1 = size.width * 0.68;
    final h1 = size.height * 0.78;
    final ox1 = size.width * 0.04;
    final oy1 = size.height * 0.04;

    path1.moveTo(ox1 + w1 * 0.5, oy1 + h1 * 0.3);
    path1.cubicTo(ox1 + w1 * 0.5, oy1 + h1 * 0.1, ox1 + w1 * 0.35, oy1, ox1 + w1 * 0.22, oy1);
    path1.cubicTo(ox1 + w1 * 0.05, oy1, ox1, oy1 + h1 * 0.2, ox1, oy1 + h1 * 0.35);
    path1.cubicTo(ox1, oy1 + h1 * 0.6, ox1 + w1 * 0.35, oy1 + h1 * 0.82, ox1 + w1 * 0.5, oy1 + h1);
    path1.cubicTo(ox1 + w1 * 0.65, oy1 + h1 * 0.82, ox1 + w1, oy1 + h1 * 0.6, ox1 + w1, oy1 + h1 * 0.35);
    path1.cubicTo(ox1 + w1, oy1 + h1 * 0.2, ox1 + w1 * 0.95, oy1, ox1 + w1 * 0.78, oy1);
    path1.cubicTo(ox1 + w1 * 0.65, oy1, ox1 + w1 * 0.5, oy1 + h1 * 0.1, ox1 + w1 * 0.5, oy1 + h1 * 0.3);
    canvas.drawPath(path1, paint);

    // Secondary / overlapping smaller heart on bottom-right
    final path2 = Path();
    final w2 = size.width * 0.46;
    final h2 = size.height * 0.52;
    final ox2 = size.width * 0.52;
    final oy2 = size.height * 0.45;

    path2.moveTo(ox2 + w2 * 0.5, oy2 + h2 * 0.3);
    path2.cubicTo(ox2 + w2 * 0.5, oy2 + h2 * 0.1, ox2 + w2 * 0.35, oy2, ox2 + w2 * 0.22, oy2);
    path2.cubicTo(ox2 + w2 * 0.05, oy2, ox2, oy2 + h2 * 0.2, ox2, oy2 + h2 * 0.35);
    path2.cubicTo(ox2, oy2 + h2 * 0.6, ox2 + w2 * 0.35, oy2 + h2 * 0.82, ox2 + w2 * 0.5, oy2 + h2);
    path2.cubicTo(ox2 + w2 * 0.65, oy2 + h2 * 0.82, ox2 + w2, oy2 + h2 * 0.6, ox2 + w2, oy2 + h2 * 0.35);
    path2.cubicTo(ox2 + w2, oy2 + h2 * 0.2, ox2 + w2 * 0.95, oy2, ox2 + w2 * 0.78, oy2);
    path2.cubicTo(ox2 + w2 * 0.65, oy2, ox2 + w2 * 0.5, oy2 + h2 * 0.1, ox2 + w2 * 0.5, oy2 + h2 * 0.3);
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Rolling pink hills landscape in the background of the header
class _HeaderLandscapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Distant soft hill
    final hillPaint1 = Paint()
      ..color = const Color(0xFFF7D5E0).withValues(alpha: 0.55)
      ..style = PaintingStyle.fill;
    final hill1 = Path();
    hill1.moveTo(0, size.height * 0.85);
    hill1.quadraticBezierTo(
      size.width * 0.4,
      size.height * 0.6,
      size.width * 0.8,
      size.height * 0.8,
    );
    hill1.quadraticBezierTo(
      size.width * 0.9,
      size.height * 0.85,
      size.width,
      size.height * 0.75,
    );
    hill1.lineTo(size.width, size.height);
    hill1.lineTo(0, size.height);
    hill1.close();
    canvas.drawPath(hill1, hillPaint1);

    // Closer hill
    final hillPaint2 = Paint()
      ..color = const Color(0xFFF4C4D4).withValues(alpha: 0.65)
      ..style = PaintingStyle.fill;
    final hill2 = Path();
    hill2.moveTo(0, size.height * 0.95);
    hill2.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.72,
      size.width,
      size.height * 0.88,
    );
    hill2.lineTo(size.width, size.height);
    hill2.lineTo(0, size.height);
    hill2.close();
    canvas.drawPath(hill2, hillPaint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
