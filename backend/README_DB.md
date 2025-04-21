# Database Connection Strategy

This project uses a flexible database connection approach that can switch between a singleton connection (for development) and a connection pool (for production).

## How It Works

The `db_connection.dart` file implements both connection strategies and automatically selects the appropriate one based on the `USE_CONNECTION_POOL` environment variable.

### Development Mode (Singleton)

In development mode, the application uses a single database connection that is reused across all requests. This approach:

- Is simpler to debug
- Consumes fewer resources
- Is suitable for development environments with low concurrent load

### Production Mode (Connection Pool)

In production mode, the application uses a connection pool that maintains multiple concurrent database connections. This approach:

- Handles high concurrency efficiently
- Provides better performance under load
- Automatically recovers from connection failures
- Is suitable for production environments

## Configuration

To configure the connection strategy, set the `USE_CONNECTION_POOL` environment variable in your `.env` file:

```
# Development mode (singleton connection)
USE_CONNECTION_POOL=false

# Production mode (connection pool)
USE_CONNECTION_POOL=true
```

## API Usage

Regardless of which connection strategy is used, your code always uses the `withDb()` function to execute database operations:

```dart
Future<List<User>> getAllUsers() async {
  return withDb((conn) async {
    final result = await conn.execute('SELECT * FROM users');
    return result.map((row) => User.fromRow(row)).toList();
  });
}
```

This ensures that you can easily switch between development and production modes without changing your application code.

## Closing Connections

When shutting down the application, always call `closeDbConnections()` to properly close all database connections:

```dart
await closeDbConnections();
```
