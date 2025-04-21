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

## Middleware Integration

This project uses middleware to integrate the database connection with Dart Frog's request handling flow:

1. `lib/middleware/db_middleware.dart` - Provides database access to route handlers
2. `routes/_middleware.dart` - Applies the database middleware to all routes

The middleware makes the database available through a convenient extension method on `RequestContext`:

```dart
// Inside any route handler:
final users = await context.db.execute((conn) async {
  final result = await conn.execute('SELECT * FROM users');
  return result.toList();
});
```

## Example Usage in Route Handlers

Here's how to use the database connection in your route handlers:

```dart
Future<Response> onRequest(RequestContext context) async {
  // Query the database
  final users = await context.db.execute((conn) async {
    final result = await conn.execute('SELECT id, name FROM users');
    return result.map((row) => {'id': row[0], 'name': row[1]}).toList();
  });

  // Return the result as JSON
  return Response.json(body: {'users': users});
}
```

## Application Shutdown

When shutting down the application, always call `closeDbConnections()` to properly close all database connections:

```dart
// In your application shutdown code:
await closeDbConnections();
```

## Database Schema Migrations

Before running the application, make sure to apply all database migrations:

```bash
# From the backend directory
dart run bin/migrate.dart
```

The migration scripts are located in the `backend/migrations/` directory.
