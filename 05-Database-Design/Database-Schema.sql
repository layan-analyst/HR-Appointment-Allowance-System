PRAGMA foreign_keys = ON;

CREATE TABLE employees (
 employee_id INTEGER PRIMARY KEY,
 employee_reference TEXT NOT NULL UNIQUE,
 display_name TEXT NOT NULL
);
CREATE TABLE users (
 user_id INTEGER PRIMARY KEY,
 employee_id INTEGER REFERENCES employees(employee_id),
 role_name TEXT NOT NULL,
 is_active INTEGER NOT NULL DEFAULT 1 CHECK (is_active IN (0,1))
);
CREATE TABLE allowance_requests (
 request_id INTEGER PRIMARY KEY,
 request_reference TEXT NOT NULL UNIQUE,
 employee_id INTEGER NOT NULL REFERENCES employees(employee_id),
 request_details TEXT NOT NULL,
 supporting_information TEXT,
 status TEXT NOT NULL,
 submitted_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
 updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE request_reviews (
 review_id INTEGER PRIMARY KEY,
 request_id INTEGER NOT NULL REFERENCES allowance_requests(request_id),
 reviewer_user_id INTEGER NOT NULL REFERENCES users(user_id),
 eligibility_outcome TEXT,
 review_note TEXT,
 reviewed_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE request_decisions (
 decision_id INTEGER PRIMARY KEY,
 request_id INTEGER NOT NULL REFERENCES allowance_requests(request_id),
 approver_user_id INTEGER NOT NULL REFERENCES users(user_id),
 decision TEXT NOT NULL CHECK (decision IN ('Approved','Rejected')),
 reason TEXT,
 decided_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
 CHECK (decision <> 'Rejected' OR (reason IS NOT NULL AND LENGTH(TRIM(reason)) > 0))
);
CREATE TABLE request_history (
 history_id INTEGER PRIMARY KEY,
 request_id INTEGER NOT NULL REFERENCES allowance_requests(request_id),
 actor_user_id INTEGER NOT NULL REFERENCES users(user_id),
 previous_status TEXT,
 new_status TEXT NOT NULL,
 action_name TEXT NOT NULL,
 reason TEXT,
 occurred_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
 CHECK (action_name NOT IN ('Return for correction','Reject') OR
        (reason IS NOT NULL AND LENGTH(TRIM(reason)) > 0))
);
CREATE TABLE notifications (
 notification_id INTEGER PRIMARY KEY,
 request_id INTEGER NOT NULL REFERENCES allowance_requests(request_id),
 recipient_user_id INTEGER NOT NULL REFERENCES users(user_id),
 event_name TEXT NOT NULL,
 created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_requests_employee ON allowance_requests(employee_id);
CREATE INDEX idx_requests_status ON allowance_requests(status);
CREATE INDEX idx_history_request ON request_history(request_id, occurred_at);
CREATE INDEX idx_reviews_request ON request_reviews(request_id);
CREATE INDEX idx_decisions_request ON request_decisions(request_id);
CREATE INDEX idx_notifications_recipient ON notifications(recipient_user_id);
