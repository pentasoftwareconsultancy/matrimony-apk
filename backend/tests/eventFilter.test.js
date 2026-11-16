import test from 'node:test';
import assert from 'node:assert/strict';
import {
  isUpcomingEvent,
  parseEventCalendarDate,
  getEventDateWindow,
} from '../src/utils/eventDateFilter.js';

// Fixed reference instant: 2026-11-12T18:35:00.000Z
// In UTC this is Nov 12; in Asia/Kolkata (+05:30) this is 2026-11-13 00:05 IST!
const istNov13MidnightInstant = new Date('2026-11-12T18:35:00.000Z');
// 2026-11-12T10:00:00.000Z => 2026-11-12 15:30 IST
const istNov12AfternoonInstant = new Date('2026-11-12T10:00:00.000Z');

test('parses multiple date formats into calendar dates accurately', () => {
  assert.deepEqual(parseEventCalendarDate('2026-11-25'), { year: 2026, month: 11, day: 25 });
  assert.deepEqual(parseEventCalendarDate('25/11/2026'), { year: 2026, month: 11, day: 25 });
  assert.deepEqual(parseEventCalendarDate('30 June 2025'), { year: 2025, month: 6, day: 30 });
  assert.deepEqual(parseEventCalendarDate('November 12, 2026'), { year: 2026, month: 11, day: 12 });
  assert.equal(parseEventCalendarDate('31 Feb 2026'), null);
  assert.equal(parseEventCalendarDate(''), null);
});

test('includes future and today events while excluding past events', () => {
  assert.equal(
    isUpcomingEvent({ date: '2026-11-20' }, istNov12AfternoonInstant),
    true
  );
  assert.equal(
    isUpcomingEvent({ date: '12 November 2026' }, istNov12AfternoonInstant),
    true
  );
  assert.equal(
    isUpcomingEvent({ date: '11 November 2026' }, istNov12AfternoonInstant),
    false
  );
  assert.equal(
    isUpcomingEvent({ date: '30 June 2025' }, istNov12AfternoonInstant),
    false
  );
});

test('respects Asia/Kolkata timezone around UTC midnight rollover', () => {
  // At 2026-11-12T18:35:00Z it is already 2026-11-13 in Asia/Kolkata
  assert.equal(
    isUpcomingEvent({ date: '2026-11-12' }, istNov13MidnightInstant),
    false
  );
  assert.equal(
    isUpcomingEvent({ date: '2026-11-13' }, istNov13MidnightInstant),
    true
  );
});

test('preserves ongoing multi-day events via endDate or inline ranges', () => {
  assert.equal(
    isUpcomingEvent(
      { startDate: '2026-11-10', endDate: '2026-11-15', date: '2026-11-10' },
      istNov12AfternoonInstant
    ),
    true
  );
  assert.equal(
    isUpcomingEvent(
      { startDate: '2026-11-08', endDate: '2026-11-11', date: '2026-11-08' },
      istNov12AfternoonInstant
    ),
    false
  );
  const rangeWin = getEventDateWindow({ date: '10-15 Nov 2026' });
  assert.deepEqual(rangeWin.startDay, { year: 2026, month: 11, day: 10 });
  assert.deepEqual(rangeWin.endDay, { year: 2026, month: 11, day: 15 });
  assert.equal(isUpcomingEvent({ date: '10-15 Nov 2026' }, istNov12AfternoonInstant), true);
});

test('excludes cancelled, deleted, inactive, and invalid-date events even with future dates', () => {
  assert.equal(
    isUpcomingEvent({ date: '2027-01-15', status: 'cancelled' }, istNov12AfternoonInstant),
    false
  );
  assert.equal(
    isUpcomingEvent({ date: '2027-01-15', isCancelled: true }, istNov12AfternoonInstant),
    false
  );
  assert.equal(
    isUpcomingEvent({ date: '2027-01-15', isDeleted: true }, istNov12AfternoonInstant),
    false
  );
  assert.equal(
    isUpcomingEvent({ date: '2027-01-15', deletedAt: new Date() }, istNov12AfternoonInstant),
    false
  );
  assert.equal(
    isUpcomingEvent({ date: '2027-01-15', isActive: false }, istNov12AfternoonInstant),
    false
  );
  assert.equal(
    isUpcomingEvent({ date: 'TBD' }, istNov12AfternoonInstant),
    false
  );
});
