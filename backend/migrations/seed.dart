// bin/seed.dart

import 'dart:io';
import 'package:dotenv/dotenv.dart';
import 'package:backend/db_connection.dart';
import 'package:postgres/postgres.dart';

Future<void> main() async {
  // 1) Load environment
  final env = DotEnv(includePlatformEnvironment: true)..load();
  final host = env['DB_HOST']!;
  final port = int.parse(env['DB_PORT']!);
  final db = env['DB_NAME']!;
  final user = env['DB_USER']!;
  stdout.writeln('Connecting to $host:$port/$db as $user');

  // 2) Perform all DB work inside withDb
  await withDb((conn) async {
    // 2.1 Truncate everything and reset serials
    await conn.execute('''
      TRUNCATE TABLE chats, ratings, sessions, user_settings, users
      RESTART IDENTITY CASCADE
    ''');

    // 2.2 Insert 5 users, collect IDs
    final userIds = <int>[];
    for (var i = 1; i <= 5; i++) {
      final result = await conn.execute(
        '''
        INSERT INTO users (name, email, phone, user_type)
        VALUES (@name, @email, @phone, @type)
        RETURNING id
        ''',
        parameters: {
          'name': 'User$i',
          'email': 'user$i@example.com',
          'phone': '555-000$i',
          'type': i.isEven ? 'helper' : 'requester',
        },
      );
      // Result is List<List<dynamic>>
      final newId = result.first[0] as int;
      userIds.add(newId);
    }

    // 2.3 Insert settings for each user
    for (final uid in userIds) {
      await conn.execute(
        '''
        INSERT INTO user_settings (user_id, prefs)
        VALUES (@uid, @prefs::json)
        ''',
        parameters: {
          'uid': uid,
          'prefs': {
            'theme': uid.isEven ? 'dark' : 'light',
            'alerts': uid.isOdd
          },
        },
      );
    }

    // 2.4 Insert 5 sessions (round-robin), collect session IDs
    final sessionIds = <int>[];
    for (var i = 0; i < userIds.length; i++) {
      final req = userIds[i];
      final help = userIds[(i + 1) % userIds.length];
      final result = await conn.execute(
        '''
        INSERT INTO sessions (requester_id, helper_id, location, status)
        VALUES (@req, @help, @loc, 'pending')
        RETURNING id
        ''',
        parameters: {
          'req': req,
          'help': help,
          'loc': 'Location #${i + 1}',
        },
      );
      sessionIds.add(result.first[0] as int);
    }

    // 2.5 Insert one rating per session
    for (var sid in sessionIds) {
      await conn.execute(
        '''
        INSERT INTO ratings (session_id, rater_id, score, comment)
        VALUES (@sid, @rater, @score, @comment)
        ''',
        parameters: {
          'sid': sid,
          'rater':
              userIds.firstWhere((u) => u != sid, orElse: () => userIds[0]),
          'score': (sid % 5) + 1,
          'comment': 'Rating for session $sid',
        },
      );
    }

    // 2.6 Insert one chat per session
    for (var sid in sessionIds) {
      await conn.execute(
        '''
        INSERT INTO chats (session_id, sender_id, message)
        VALUES (@sid, @sender, @msg)
        ''',
        parameters: {
          'sid': sid,
          'sender': userIds[0],
          'msg': 'Hello from session $sid',
        },
      );
    }
  });

  // 3) Close and exit
  await closeDbConnections();
  stdout.writeln('✅ Database seeded with sample data!');
  exit(0);
}
