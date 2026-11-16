export const DEFAULT_EVENT_TIMEZONE = process.env.EVENT_TIMEZONE || 'Asia/Kolkata';

const MONTH_INDEX_MAP = {
  jan: 1, january: 1,
  feb: 2, february: 2,
  mar: 3, march: 3,
  apr: 4, april: 4,
  may: 5,
  jun: 6, june: 6,
  jul: 7, july: 7,
  aug: 8, august: 8,
  sep: 9, sept: 9, september: 9,
  oct: 10, october: 10,
  nov: 11, november: 11,
  dec: 12, december: 12,
};

const EXCLUDED_STATUSES = new Set([
  'cancelled',
  'canceled',
  'deleted',
  'inactive',
  'past',
  'expired',
  'completed',
  'archived',
  'draft',
  'disabled',
  'hidden',
]);

const resolveTimeZone = (tz) => {
  if (typeof tz === 'string' && tz.trim()) {
    try {
      Intl.DateTimeFormat('en-CA', { timeZone: tz.trim() });
      return tz.trim();
    } catch (_) {
      // Fallback to default event timezone if custom timezone is invalid
    }
  }
  return DEFAULT_EVENT_TIMEZONE;
};

const isValidCalendarDay = (year, month, day) => {
  if (!Number.isInteger(year) || !Number.isInteger(month) || !Number.isInteger(day)) {
    return false;
  }
  if (year < 1900 || year > 2100 || month < 1 || month > 12 || day < 1 || day > 31) {
    return false;
  }
  const probe = new Date(Date.UTC(year, month - 1, day));
  return (
    probe.getUTCFullYear() === year &&
    probe.getUTCMonth() === month - 1 &&
    probe.getUTCDate() === day
  );
};

const makeCalendarDay = (year, month, day) =>
  isValidCalendarDay(year, month, day) ? { year, month, day } : null;

export const getZonedCalendarDate = (dateObj, timeZone = DEFAULT_EVENT_TIMEZONE) => {
  const safeTz = resolveTimeZone(timeZone);
  const parts = new Intl.DateTimeFormat('en-CA', {
    timeZone: safeTz,
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
  }).formatToParts(dateObj);

  const year = Number(parts.find((p) => p.type === 'year')?.value);
  const month = Number(parts.find((p) => p.type === 'month')?.value);
  const day = Number(parts.find((p) => p.type === 'day')?.value);
  return { year, month, day };
};

export const toDayUtcMs = (calendarDay) =>
  Date.UTC(calendarDay.year, calendarDay.month - 1, calendarDay.day);

/**
 * Parses a MongoDB Event date (ISO datetime, YYYY-MM-DD, DD/MM/YYYY, or natural text like "30 June 2026")
 * into a validated calendar date in the event's intended timezone without UTC midnight shift.
 */
export const parseEventCalendarDate = (rawValue, timeZone = DEFAULT_EVENT_TIMEZONE) => {
  if (!rawValue) return null;

  if (rawValue instanceof Date) {
    if (Number.isNaN(rawValue.getTime())) return null;
    return getZonedCalendarDate(rawValue, timeZone);
  }

  const cleaned = String(rawValue)
    .trim()
    .replace(/^(mon|tue|tues|wed|thu|thur|thurs|fri|sat|sun)[a-z]*,?\s+/i, '');

  if (!cleaned) return null;

  // 1. ISO timestamp with explicit time/timezone (e.g. "2026-11-12T18:30:00.000Z")
  if (/(T|\d{2}:\d{2})/.test(cleaned) && /(Z|[+-]\d{2}:?\d{2})$/i.test(cleaned)) {
    const parsed = new Date(cleaned);
    if (!Number.isNaN(parsed.getTime())) {
      return getZonedCalendarDate(parsed, timeZone);
    }
  }

  // 2. Date-only YYYY-MM-DD / YYYY/MM/DD / YYYY.MM.DD (or ISO without offset)
  const ymdMatch = cleaned.match(/^(\d{4})[-/.](\d{1,2})[-/.](\d{1,2})(?:[T\s].*)?$/);
  if (ymdMatch) {
    return makeCalendarDay(Number(ymdMatch[1]), Number(ymdMatch[2]), Number(ymdMatch[3]));
  }

  // 3. Numeric DD/MM/YYYY or DD-MM-YYYY or DD.MM.YYYY (Indian convention first, fallback MM/DD/YYYY)
  const dmyMatch = cleaned.match(/^(\d{1,2})[-/.](\d{1,2})[-/.](\d{4})$/);
  if (dmyMatch) {
    const first = Number(dmyMatch[1]);
    const second = Number(dmyMatch[2]);
    const year = Number(dmyMatch[3]);
    if (second > 12 && first <= 12) {
      return makeCalendarDay(year, first, second);
    }
    return makeCalendarDay(year, second, first);
  }

  // 4. Natural English: "30 June 2026", "30th June, 2026", "5-Nov-2026"
  const dMonYMatch = cleaned.match(
    /^(\d{1,2})(?:st|nd|rd|th)?[\s,-]+([a-zA-Z]+)[\s,.-]+(\d{4})$/
  );
  if (dMonYMatch) {
    const month = MONTH_INDEX_MAP[dMonYMatch[2].toLowerCase()];
    if (month) {
      return makeCalendarDay(Number(dMonYMatch[3]), month, Number(dMonYMatch[1]));
    }
  }

  // 5. Natural English: "June 30, 2026", "Nov 5 2026"
  const monDYMatch = cleaned.match(
    /^([a-zA-Z]+)[\s.-]+(\d{1,2})(?:st|nd|rd|th)?[\s,.-]+(\d{4})$/
  );
  if (monDYMatch) {
    const month = MONTH_INDEX_MAP[monDYMatch[1].toLowerCase()];
    if (month) {
      return makeCalendarDay(Number(monDYMatch[3]), month, Number(monDYMatch[2]));
    }
  }

  // 6. Fallback native Date parsing for other standard strings (e.g. RFC2822)
  const fallback = new Date(cleaned);
  if (!Number.isNaN(fallback.getTime())) {
    return getZonedCalendarDate(fallback, timeZone);
  }

  return null;
};

const getEventInfoObject = (event) => {
  if (Array.isArray(event?.eventInfo)) {
    return event.eventInfo.length > 0 && typeof event.eventInfo[0] === 'object'
      ? event.eventInfo[0]
      : null;
  }
  if (event?.eventInfo && typeof event.eventInfo === 'object') {
    return event.eventInfo;
  }
  return null;
};

export const getEventDateWindow = (event) => {
  const timeZone = resolveTimeZone(event?.timezone);
  const info = getEventInfoObject(event);
  const rawStart = event?.startDate ?? event?.start_date ?? event?.date ?? info?.Date ?? info?.date;
  const rawEnd = event?.endDate ?? event?.end_date ?? info?.EndDate ?? info?.endDate;

  let startDay = parseEventCalendarDate(rawStart, timeZone);
  let endDay = parseEventCalendarDate(rawEnd, timeZone);

  // Support date ranges written directly in `date` (e.g. "10 Nov 2026 - 15 Nov 2026" or "10-15 Nov 2026")
  if (!endDay && typeof rawStart === 'string') {
    const trimmed = rawStart.trim();
    const shortRangeMatch = trimmed.match(
      /^(\d{1,2}(?:st|nd|rd|th)?)\s*[-–—]\s*(\d{1,2}(?:st|nd|rd|th)?[\s,-]+[a-zA-Z]+[\s,.-]+\d{4})$/
    );
    if (shortRangeMatch) {
      const parsedEnd = parseEventCalendarDate(shortRangeMatch[2], timeZone);
      const tailMatch = shortRangeMatch[2].match(/^\d{1,2}(?:st|nd|rd|th)?([\s,-]+[a-zA-Z]+[\s,.-]+\d{4})$/);
      const parsedStart = tailMatch
        ? parseEventCalendarDate(`${shortRangeMatch[1]}${tailMatch[1]}`, timeZone)
        : parsedEnd;
      startDay = parsedStart || parsedEnd;
      endDay = parsedEnd;
    } else if (/\s+(?:to|-|–|—)\s+/i.test(trimmed)) {
      const parts = trimmed.split(/\s+(?:to|-|–|—)\s+/i);
      if (parts.length === 2) {
        const parsedStart = parseEventCalendarDate(parts[0], timeZone);
        const parsedEnd = parseEventCalendarDate(parts[1], timeZone);
        if (parsedStart || parsedEnd) {
          startDay = parsedStart || parsedEnd;
          endDay = parsedEnd || parsedStart;
        }
      }
    }
  }

  return { startDay, endDay, timeZone };
};

export const isExcludedEvent = (event) => {
  if (!event || typeof event !== 'object') return true;

  if (
    event.isCancelled === true ||
    event.isCanceled === true ||
    event.cancelled === true ||
    event.canceled === true ||
    event.isDeleted === true ||
    event.deleted === true ||
    event.isActive === false ||
    event.active === false ||
    Boolean(event.deletedAt)
  ) {
    return true;
  }

  if (typeof event.status === 'string') {
    const normalized = event.status.trim().toLowerCase();
    if (EXCLUDED_STATUSES.has(normalized)) {
      return true;
    }
  }

  return false;
};

export const isUpcomingEvent = (event, now = new Date()) => {
  if (isExcludedEvent(event)) return false;

  const { startDay, endDay, timeZone } = getEventDateWindow(event);
  const effectiveEndDay = endDay || startDay;
  if (!effectiveEndDay) return false;

  const today = getZonedCalendarDate(now, timeZone);
  return toDayUtcMs(effectiveEndDay) >= toDayUtcMs(today);
};

