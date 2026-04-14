CREATE TABLE IF NOT EXISTS fighters (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  nickname TEXT,
  division TEXT NOT NULL,
  flag TEXT,
  age INTEGER,
  city TEXT,
  gym TEXT,
  stance TEXT DEFAULT 'Ortodoxo',
  height TEXT,
  reach TEXT,
  wins INTEGER DEFAULT 0,
  losses INTEGER DEFAULT 0,
  draws INTEGER DEFAULT 0,
  kos INTEGER DEFAULT 0,
  status TEXT DEFAULT 'active',
  photo TEXT,
  bio TEXT,
  instagram TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS fights (
  id SERIAL PRIMARY KEY,
  fighter_id INTEGER NOT NULL REFERENCES fighters(id) ON DELETE CASCADE,
  fight_date TEXT,
  opponent TEXT NOT NULL,
  result TEXT NOT NULL,
  method TEXT,
  round TEXT,
  title_fight TEXT,
  event_name TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS events (
  id SERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  subtitle TEXT,
  event_date TEXT NOT NULL,
  venue TEXT,
  address TEXT,
  city TEXT,
  doors_time TEXT,
  start_time TEXT,
  price_general TEXT,
  price_vip TEXT,
  ticket_url TEXT,
  phase TEXT,
  status TEXT DEFAULT 'upcoming',
  poster_url TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS event_fights (
  id SERIAL PRIMARY KEY,
  event_id INTEGER NOT NULL REFERENCES events(id) ON DELETE CASCADE,
  fighter1_id INTEGER REFERENCES fighters(id) ON DELETE SET NULL,
  fighter2_id INTEGER REFERENCES fighters(id) ON DELETE SET NULL,
  fighter1_name TEXT,
  fighter2_name TEXT,
  category TEXT,
  weight_class TEXT,
  rounds INTEGER DEFAULT 4,
  is_main_event BOOLEAN DEFAULT FALSE,
  result TEXT,
  winner_id INTEGER REFERENCES fighters(id) ON DELETE SET NULL,
  method TEXT,
  round_ended TEXT,
  sort_order INTEGER DEFAULT 0
);

CREATE TABLE IF NOT EXISTS league_seasons (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  year INTEGER,
  status TEXT DEFAULT 'active',
  description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS league_participants (
  id SERIAL PRIMARY KEY,
  season_id INTEGER NOT NULL REFERENCES league_seasons(id) ON DELETE CASCADE,
  fighter_id INTEGER NOT NULL REFERENCES fighters(id) ON DELETE CASCADE,
  division TEXT NOT NULL,
  seed INTEGER,
  status TEXT DEFAULT 'active'
);

CREATE TABLE IF NOT EXISTS bracket_matches (
  id SERIAL PRIMARY KEY,
  season_id INTEGER NOT NULL REFERENCES league_seasons(id) ON DELETE CASCADE,
  division TEXT NOT NULL,
  round_name TEXT NOT NULL,
  round_number INTEGER NOT NULL,
  match_number INTEGER NOT NULL,
  fighter1_id INTEGER REFERENCES fighters(id) ON DELETE SET NULL,
  fighter2_id INTEGER REFERENCES fighters(id) ON DELETE SET NULL,
  winner_id INTEGER REFERENCES fighters(id) ON DELETE SET NULL,
  event_id INTEGER REFERENCES events(id) ON DELETE SET NULL,
  scheduled_date TEXT,
  status TEXT DEFAULT 'pending'
);

CREATE INDEX IF NOT EXISTS idx_fighters_division ON fighters(division);
CREATE INDEX IF NOT EXISTS idx_events_status ON events(status);
CREATE INDEX IF NOT EXISTS idx_event_fights_event_id ON event_fights(event_id);
CREATE INDEX IF NOT EXISTS idx_bracket_matches_season_division ON bracket_matches(season_id, division, round_number, match_number);
