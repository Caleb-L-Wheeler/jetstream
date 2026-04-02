CREATE TABLE IF NOT EXISTS streams (
    stream_id TEXT PRIMARY KEY,
    node TEXT NOT NULL,
    source_id TEXT NOT NULL,
    created_at TIMESTAMPTZ,
    ended_at TIMESTAMPTZ,
    status TEXT NOT NULL,
    ERROR_CODE TEXT,
    ERROR_MSG TEXT
);

CREATE INDEX IDX_STREAM_SOURCE ON streams(source_id);
CREATE INDEX IDX_STREAM_STATUS ON streams(status);