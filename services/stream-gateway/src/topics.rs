pub enum EventType {
    STREAM_CREATED,
    STREAM_ACTIVE,
    STREAM_ENDED,
    STREAM_ERROR,
}

pub struct LifecycleDetails {
    error_code: String,
    error_message: String,
}

pub struct StreamLifecycle {
    schema_version: u8,
    event_type: EventType,
    stream_id: String,
    mode: String,
    source_id: String,
    produced_at: i64,
    event_ts: i64,
    details: LifecycleDetails
}

impl StreamLifecycle {}