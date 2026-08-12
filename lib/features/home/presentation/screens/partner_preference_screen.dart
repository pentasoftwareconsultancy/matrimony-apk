import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/app_providers.dart';

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

  final List<String> _religions = ['Hindu', 'Christian', 'Muslim', 'Sikh', 'Jain', 'Buddhist', 'Any'];
  final List<String> _educations = ['B.Tech', 'Doctorate', 'M.B.A', 'Master\'s', 'Bachelor\'s', 'Any'];
  final List<String> _diets = ['Vegetarian', 'Non-Vegetarian', 'Eggetarian', 'Vegan', 'Any'];
  final List<String> _maritalStatuses = ['Single', 'Never Married', 'Divorced', 'Widowed', 'Awaiting Divorce', 'Any'];

  @override
  Widget build(BuildContext context) {
    final pref = ref.watch(partnerPreferenceProvider);

    if (!_initialized) {
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
      _initialized = true;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Partner Preference',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: false,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Set your partner requirements',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ),
            const SizedBox(height: 24),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  // Age Range
                  const Text('Age range', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          value: _ageMin,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          items: List.generate(24, (index) => index + 18)
                              .map((age) => DropdownMenuItem(value: age, child: Text('$age')))
                              .toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _ageMin = val);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          value: _ageMax,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          items: List.generate(24, (index) => index + 18)
                              .map((age) => DropdownMenuItem(value: age, child: Text('$age')))
                              .toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _ageMax = val);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Height Preference
                  const Text('Height expectation', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black)),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: _height,
                    decoration: InputDecoration(
                      hintText: 'Enter height expectation (e.g. 5\'2" - 6\'0")',
                      hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onChanged: (val) => _height = val.trim(),
                  ),
                  const SizedBox(height: 16),

                  // Religion
                  const Text('Religion', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _religions.contains(_religion) ? _religion : 'Hindu',
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    items: _religions
                        .map((rel) => DropdownMenuItem(value: rel, child: Text(rel)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _religion = val);
                    },
                  ),
                  const SizedBox(height: 16),

                  // Caste
                  const Text('Caste expectation', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black)),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: _caste,
                    decoration: InputDecoration(
                      hintText: 'Enter caste (or "Any")',
                      hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onChanged: (val) => _caste = val.trim(),
                  ),
                  const SizedBox(height: 16),

                  // City
                  const Text('City preference', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black)),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: _city,
                    decoration: InputDecoration(
                      hintText: 'Enter city preference',
                      hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onChanged: (val) => _city = val.trim(),
                  ),
                  const SizedBox(height: 16),

                  // Education
                  const Text('Education level', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _educations.contains(_education) ? _education : 'Bachelor\'s',
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    items: _educations
                        .map((edu) => DropdownMenuItem(value: edu, child: Text(edu)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _education = val);
                    },
                  ),
                  const SizedBox(height: 16),

                  // Occupation
                  const Text('Occupation preference', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black)),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: _occupation,
                    decoration: InputDecoration(
                      hintText: 'Enter preferred occupation',
                      hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onChanged: (val) => _occupation = val.trim(),
                  ),
                  const SizedBox(height: 16),

                  // Income
                  const Text('Annual Income expectation', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black)),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: _income,
                    decoration: InputDecoration(
                      hintText: 'Enter annual income range expectation',
                      hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onChanged: (val) => _income = val.trim(),
                  ),
                  const SizedBox(height: 16),

                  // Marital Status
                  const Text('Marital status requirement', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _maritalStatuses.contains(_maritalStatus) ? _maritalStatus : 'Never Married',
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    items: _maritalStatuses
                        .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _maritalStatus = val);
                    },
                  ),
                  const SizedBox(height: 16),

                  // Diet
                  const Text('Diet requirement', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _diets.contains(_diet) ? _diet : 'Vegetarian',
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    items: _diets
                        .map((diet) => DropdownMenuItem(value: diet, child: Text(diet)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _diet = val);
                    },
                  ),
                  const SizedBox(height: 16),

                  // Manglik
                  const Text('Manglik expectation', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black)),
                  const SizedBox(height: 8),
                  Row(
                    children: ['Yes', 'No', 'Any'].map((m) {
                      final isSel = _manglik == m;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _manglik = m),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSel ? AppColors.primary : Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: isSel ? AppColors.primary : Colors.grey.shade300),
                            ),
                            child: Text(
                              m,
                              style: TextStyle(
                                color: isSel ? Colors.white : Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),

            // Save changes button
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
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

                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Partner preference saved successfully.'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.pop(context);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: const Text('Save Changes', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
