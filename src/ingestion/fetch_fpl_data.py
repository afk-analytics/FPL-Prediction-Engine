import os

import requests
from dotenv import load_dotenv
from sqlalchemy import create_engine, text

load_dotenv()

DATABASE_URL = os.getenv("DATABASE_URL")

engine = create_engine(DATABASE_URL)

# --------------------------------------------------
# Get FPL data
# --------------------------------------------------

url = "https://fantasy.premierleague.com/api/bootstrap-static/"

response = requests.get(url)
response.raise_for_status()

data = response.json()

teams = data["teams"]
players = data["elements"]

print(f"Found {len(teams)} teams")
print(f"Found {len(players)} players")


# --------------------------------------------------
# Load teams
# --------------------------------------------------

with engine.begin() as connection:

    for team in teams:

        connection.execute(
            text("""
                INSERT INTO teams (
                    team_id,
                    team_name,
                    short_name
                )
                VALUES (
                    :team_id,
                    :team_name,
                    :short_name
                )
                ON CONFLICT (team_id)
                DO UPDATE SET
                    team_name = EXCLUDED.team_name,
                    short_name = EXCLUDED.short_name;
            """),
            {
                "team_id": team["id"],
                "team_name": team["name"],
                "short_name": team["short_name"],
            },
        )

print("Teams successfully loaded")


# --------------------------------------------------
# Load players
# --------------------------------------------------

with engine.begin() as connection:

    for player in players:

        connection.execute(
            text("""
                INSERT INTO players (
                    player_id,
                    first_name,
                    second_name,
                    team_id,
                    position,
                    price
                )
                VALUES (
                    :player_id,
                    :first_name,
                    :second_name,
                    :team_id,
                    :position,
                    :price
                )
                ON CONFLICT (player_id)
                DO UPDATE SET
                    first_name = EXCLUDED.first_name,
                    second_name = EXCLUDED.second_name,
                    team_id = EXCLUDED.team_id,
                    position = EXCLUDED.position,
                    price = EXCLUDED.price;
            """),
            {
                "player_id": player["id"],
                "first_name": player["first_name"],
                "second_name": player["second_name"],
                "team_id": player["team"],
                "position": player["element_type"],
                "price": player["now_cost"] / 10,
            },
        )

print("Players successfully loaded")