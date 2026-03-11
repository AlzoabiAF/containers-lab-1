CREATE TABLE
    IF NOT EXISTS users (
        id SERIAL PRIMARY KEY,
        name TEXT NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );

INSERT INTO
    users (name)
VALUES
    ('Docker Beginner'),
    ('Container Master'),
    ('DevOps Student') ON CONFLICT DO NOTHING;