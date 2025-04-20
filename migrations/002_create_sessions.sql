CREATE TABLE IF NOT EXISTS sessions (
  id SERIAL PRIMARY KEY,
  requester_id INTEGER NOT NULL REFERENCES users(id),
  helper_id INTEGER NOT NULL REFERENCES users(id),
  timestamp TIMESTAMP DEFAULT NOW(),
  location TEXT,
  status TEXT CHECK (status IN ('pending', 'accepted', 'completed', 'cancelled'))
);
