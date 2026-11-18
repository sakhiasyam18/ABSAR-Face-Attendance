import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/api/api_client.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/luxury_card.dart';
import '../../../core/widgets/primary_button.dart';
import '../../auth/presentation/auth_state.dart';

class MahasiswaAccountScreen extends ConsumerWidget {
  const MahasiswaAccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    final name = user?.fullName.isNotEmpty == true ? user!.fullName : 'Santri';
    final nim = user?.identifier?.isNotEmpty == true ? user!.identifier! : '-';
    final email = user?.email.isNotEmpty == true ? user!.email : '-';
    final prodi = user?.programStudy?.isNotEmpty == true ? user!.programStudy! : "Lembaga / Ma'had Belum Diatur";

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(
        backgroundColor: AppColors.bgDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Informasi Akun',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            children: [
              // User header card
              LuxuryCard(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.cardSurface,
                        border: Border.all(color: AppColors.primary, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.25),
                            blurRadius: 18,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(Icons.person_rounded, size: 48, color: AppColors.primary),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      name,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'NIS $nim',
                      style: const TextStyle(
                        color: AppColors.primaryLight,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Detail fields card
              LuxuryCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Detail Informasi',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildFieldRow(label: 'Email', value: email, icon: Icons.email_outlined),
                    const Divider(color: AppColors.border, height: 24),
                    _buildFieldRow(label: 'NIS (Nomor Induk Santri)', value: nim, icon: Icons.badge_outlined),
                    const Divider(color: AppColors.border, height: 24),
                    _buildFieldRow(label: "Lembaga / Ma'had", value: prodi, icon: Icons.school_outlined),
                    const Divider(color: AppColors.border, height: 24),
                    _buildFieldRow(label: 'Status Akun', value: 'Active', isStatus: true),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Button to update face
              PrimaryButton(
                text: 'Perbarui / Update Wajah',
                icon: Icons.face_retouching_natural_rounded,
                onPressed: () async {
                  final sNim = user?.identifier?.toString().trim() ?? '';
                  if (sNim.isEmpty || sNim == '-') {
                    context.push('/register');
                    return;
                  }
                  try {
                    final dio = ref.read(apiClientProvider);
                    final res = await dio.get('/students/lookup', queryParameters: {'nim': sNim});
                    final studentId = res.data['id'] as int;
                    final studentName = (res.data['full_name'] ?? user?.fullName ?? 'Santri').toString();
                    final hasFaces = res.data['has_faces'] == true || res.data['has_faces'] == 1;

                    if (!context.mounted) return;
                    context.push(
                      '/register/capture',
                      extra: {
                        'student_id': studentId,
                        'student_name': studentName,
                        'nim': sNim,
                        'overwrite': hasFaces,
                      },
                    );
                  } catch (e) {
                    if (!context.mounted) return;
                    context.push('/register');
                  }
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldRow({
    required String label,
    required String value,
    IconData? icon,
    bool isStatus = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: isStatus ? AppColors.hadir : AppColors.textPrimary,
                fontSize: 14,
                fontWeight: isStatus ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ],
        ),
        if (isStatus)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.hadir.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.hadir.withValues(alpha: 0.4), width: 1),
            ),
            child: const Text(
              'Aktif',
              style: TextStyle(color: AppColors.hadir, fontSize: 11, fontWeight: FontWeight.w700),
            ),
          )
        else
          Icon(Icons.edit_outlined, size: 18, color: AppColors.textMuted.withValues(alpha: 0.6)),
      ],
    );
  }
}

