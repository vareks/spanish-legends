require('dotenv').config();
const express = require('express');
const cors = require('cors');
const { query } = require('./db-postgres');

const app = express();
app.use(cors());
app.use(express.json());

app.get('/api/fighters', async (req, res) => {
  const r = await query('SELECT * FROM fighters ORDER BY created_at DESC');
  res.json(r.rows);
});

app.get('/api/events', async (req, res) => {
  const events = await query('SELECT * FROM events ORDER BY event_date DESC');
  const fights = await query('SELECT * FROM event_fights');

  const result = events.rows.map(ev => ({
    ...ev,
    fights: fights.rows.filter(f => f.event_id === ev.id)
  }));

  res.json(result);
});

app.get('/api/stats', async (req, res) => {
  const fighters = await query('SELECT COUNT(*) FROM fighters');
  const events = await query('SELECT COUNT(*) FROM events');
  const combats = await query('SELECT COUNT(*) FROM event_fights');

  res.json({
    fighters: parseInt(fighters.rows[0].count),
    events: parseInt(events.rows[0].count),
    combats: parseInt(combats.rows[0].count)
  });
});

app.get('/api/league/seasons', async (req, res) => {
  const r = await query('SELECT * FROM league_seasons ORDER BY year DESC');
  res.json(r.rows);
});

app.get('/api/league/bracket/:seasonId', async (req, res) => {
  const r = await query(`
    SELECT * FROM bracket_matches WHERE season_id=$1
    ORDER BY division, round_number, match_number
  `, [req.params.seasonId]);

  const grouped = {};
  r.rows.forEach(m => {
    if (!grouped[m.division]) grouped[m.division] = {};
    if (!grouped[m.division][m.round_name]) grouped[m.division][m.round_name] = [];
    grouped[m.division][m.round_name].push(m);
  });

  res.json(grouped);
});

const PORT = process.env.PORT || 3001;
app.listen(PORT, () => console.log('🚀 Backend Postgres en puerto', PORT));