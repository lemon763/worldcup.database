
CREATE DATABASE worldcup

CREATE TABLE games (
    game_id integer NOT NULL identity(1,1),
    year integer NOT NULL,
    round character varying(40) NOT NULL,
    winner_id integer NOT NULL,
    opponent_id integer NOT NULL,
    winner_goals integer NOT NULL,
    opponent_goals integer NOT NULL
);

CREATE TABLE teams (
    team_id integer NOT NULL identity(1,1),
    name character varying(40) NOT NULL
);

ALTER TABLE teams
    ADD UNIQUE (name);

ALTER TABLE games
    ADD PRIMARY KEY (game_id);

ALTER TABLE teams
    ADD PRIMARY KEY (team_id);

ALTER TABLE games
    ADD FOREIGN KEY (opponent_id) 
	REFERENCES teams(team_id);

ALTER TABLE games
    ADD FOREIGN KEY (winner_id) 
	REFERENCES teams(team_id);
