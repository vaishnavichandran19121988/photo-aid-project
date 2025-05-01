import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/providers.dart';


class TestPhotoAid extends StatelessWidget {
  const TestPhotoAid({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: ProfilePhotoAid());
  }
}

class ProfilePhotoAid extends ConsumerWidget {
  final String userId = 'user1';

  const ProfilePhotoAid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userFutureProvider(userId));
    return Scaffold(
      body: userAsync.when(
        data: (user) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Name: ${user.name}'),
            Text('Bio: ${user.bio}'),
            Text('Rating: ${user.rating}'),
            ElevatedButton(
              onPressed: () {
              
              },
              child: Text('Update User'),
            ),
          ],
        ),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}