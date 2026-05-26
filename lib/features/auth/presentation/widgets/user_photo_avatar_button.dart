import 'package:read_radius/features/auth/domain/auth_session_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserPhotoAvatarButton extends StatelessWidget {
  const UserPhotoAvatarButton({
    required this.authState,
    required this.photoUrl,
    required this.onGuestTap,
    required this.onAuthenticatedTap,
    super.key,
  });

  final AuthSessionState authState;
  final AsyncValue<String?> photoUrl;
  final VoidCallback onGuestTap;
  final VoidCallback onAuthenticatedTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: GestureDetector(
          onTap: () {
            if (authState == AuthSessionState.guest) {
              onGuestTap();
              return;
            }

            onAuthenticatedTap();
          },
          child: photoUrl.when(
            data: (String? value) {
              final String? trimmed = value?.trim();
              if (trimmed == null || trimmed.isEmpty) {
                return const CircleAvatar(
                  radius: 16,
                  child: Icon(Icons.person, size: 18),
                );
              }

              return CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(trimmed),
              );
            },
            loading: () => const CircleAvatar(
              radius: 16,
              child: SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            error: (_, _) => const CircleAvatar(
              radius: 16,
              child: Icon(Icons.person, size: 18),
            ),
          ),
        ),
      ),
    );
  }
}
