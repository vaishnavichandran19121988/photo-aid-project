CREATE TABLE IF NOT EXISTS users (
  id SERIAL PRIMARY KEY,
  name TEXT,
  email TEXT UNIQUE NOT NULL,
  phone TEXT,
  user_type TEXT,
  profile_pic TEXT,
  last_known_location TEXT,
  password TEXT NOT NULL
);
