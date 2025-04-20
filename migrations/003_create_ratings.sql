CREATE TABLE IF NOT EXISTS ratings (
  id SERIAL PRIMARY KEY,
  session_id INTEGER REFERENCES sessions(id),
  reviewer_id INTEGER REFERENCES users(id),
  reviewee_id INTEGER REFERENCES users(id),
  rating INTEGER CHECK (rating >= 1 AND rating <= 5),
  comment TEXT,
  UNIQUE (session_id, reviewer_id)
);
