--create table: teams
CREATE TABLE teams (
    team_id INTEGER PRIMARY KEY,
    team_name VARCHAR(100) NOT NULL,
    short_name VARCHAR(10) NOT NULL
);

--create table: players
CREATE TABLE players (
    player_id INTEGER PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    second_name VARCHAR(100) NOT NULL,
    team_id INTEGER NOT NULL,
    position INTEGER NOT NULL,
    price NUMERIC(6,2) NOT NULL,
    
    CONSTRAINT fk_players_team
        FOREIGN KEY (team_id)
        REFERENCES teams(team_id)
);

--create table: gameweeks
CREATE TABLE gameweeks (
    gameweek_id INTEGER PRIMARY KEY,
    name VARCHAR(20) NOT NULL,
    deadline TIMESTAMP,
    finished BOOLEAN NOT NULL DEFAULT FALSE
);

--create table: fixtures
CREATE TABLE fixtures (
    fixture_id INTEGER PRIMARY KEY,
    gameweek_id INTEGER NOT NULL,
    home_team_id INTEGER NOT NULL,
    away_team_id INTEGER NOT NULL,
    home_score INTEGER,
    away_score INTEGER,

    CONSTRAINT fk_fixtures_gameweek
        FOREIGN KEY (gameweek_id)
        REFERENCES gameweeks(gameweek_id),

    CONSTRAINT fk_fixtures_home_team
        FOREIGN KEY (home_team_id)
        REFERENCES teams(team_id),

    CONSTRAINT fk_fixtures_away_team
        FOREIGN KEY (away_team_id)
        REFERENCES teams(team_id)
);

--create table: player_gameweek_stats
CREATE TABLE player_gameweek_stats (
    player_id INTEGER NOT NULL,
    gameweek_id INTEGER NOT NULL,

    minutes INTEGER NOT NULL DEFAULT 0,
    goals INTEGER NOT NULL DEFAULT 0,
    assists INTEGER NOT NULL DEFAULT 0,
    clean_sheets INTEGER NOT NULL DEFAULT 0,
    goals_conceded INTEGER NOT NULL DEFAULT 0,

    xg NUMERIC(6,2),
    xa NUMERIC(6,2),

    bonus INTEGER NOT NULL DEFAULT 0,
    bps INTEGER NOT NULL DEFAULT 0,

    total_points INTEGER NOT NULL DEFAULT 0,

    PRIMARY KEY (player_id, gameweek_id),

    CONSTRAINT fk_stats_player
        FOREIGN KEY (player_id)
        REFERENCES players(player_id),

    CONSTRAINT fk_stats_gameweek
        FOREIGN KEY (gameweek_id)
        REFERENCES gameweeks(gameweek_id)
);