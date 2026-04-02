CREATE TABLE IF NOT EXISTS segments (
    stream_id TEXT NOT NULL,
    track_type TEXT NOT NULL,
    segment_id TEXT NOT NULL,
    codec TEXT NOT NULL,
    seq_start BIGINT NOT NULL,
    seq_end BIGINT NOT NULL,
    start_ts TIMESTAMPTZ NOT NULL,
    end_ts TIMESTAMPTZ NOT NULL,
    duration_ms INT NOT NULL,
    keyframe_start BOOLEAN NOT NULL,
    object_provider TEXT NOT NULL,
    bucket TEXT NOT NULL,
    obj_key TEXT NOT NULL,
    byte_offset BIGINT,
    byte_length BIGINT,
    ingested_at TIMESTAMPTZ NOT NULL,
    PRIMARY KEY (stream_id, track_type, segment_id)
);

CREATE INDEX IDX_SEGMENTS_TIME ON segments(stream_id, track_type, start_ts);
CREATE INDEX IDX_SEGMENTS_SEQUENCE ON segments(stream_id, track_type, seq_start);
CREATE INDEX IDX_SEGMENTS_OBJECT ON segments(bucket, obj_key);