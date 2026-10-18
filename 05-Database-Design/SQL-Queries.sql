-- Read-only example queries for the proposed SQLite schema.
-- Replace :employee_id / :request_id / :recipient_user_id with parameters.
-- Authorization/ownership must be checked by the application.

-- Q1: Employee request tracking (BR-02).
SELECT request_reference, status, submitted_at, updated_at
FROM allowance_requests
WHERE employee_id = :employee_id
ORDER BY submitted_at DESC;

-- Q2: Request history (BR-05).
SELECT h.occurred_at, h.action_name, h.previous_status, h.new_status,
       h.actor_user_id, h.reason
FROM request_history AS h
WHERE h.request_id = :request_id
ORDER BY h.occurred_at, h.history_id;

-- Q3: HR review queue (BR-04); status values are provisional/TBD.
SELECT r.request_id, r.request_reference, r.employee_id, r.status, r.submitted_at
FROM allowance_requests AS r
WHERE r.status = 'Submitted'
ORDER BY r.submitted_at;

-- Q4: Manager summary by status (BR-06).
SELECT status, COUNT(*) AS request_count
FROM allowance_requests
GROUP BY status
ORDER BY request_count DESC;

-- Q5: Management turnaround indicator (BR-06).
-- SQLite julianday() returns elapsed calendar days, not approved SLA working days.
SELECT AVG(julianday(d.decided_at) - julianday(r.submitted_at))
       AS average_calendar_days_to_decision
FROM allowance_requests AS r
JOIN request_decisions AS d ON d.request_id = r.request_id;

-- Q6: Notifications to an authorized user (BR-07).
SELECT n.notification_id, r.request_reference, n.event_name, n.created_at
FROM notifications AS n
JOIN allowance_requests AS r ON r.request_id = n.request_id
WHERE n.recipient_user_id = :recipient_user_id
ORDER BY n.created_at DESC;
