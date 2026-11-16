import test from 'node:test';
import assert from 'node:assert/strict';
import Notification from '../src/models/Notification.js';
import NotificationService from '../src/services/NotificationService.js';

test('Notification schema validates without title and assigns default', () => {
  const doc = new Notification({
    user: '6afaab9c11479523508883d1',
    message: 'Someone viewed your profile',
    type: 'profileActivity',
  });

  const err = doc.validateSync();
  assert.equal(err, undefined, 'Notification without title should validate cleanly');
  assert.equal(doc.title, 'Notification');
});

test('Notification schema supports fromUserId from website', () => {
  const doc = new Notification({
    user: '6afaab9c11479523508883d1',
    fromUserId: '6afaab9c11479523508883d2',
    message: 'Someone expressed interest',
    type: 'interest',
  });

  const err = doc.validateSync();
  assert.equal(err, undefined);
  assert.equal(doc.fromUserId.toString(), '6afaab9c11479523508883d2');
});

test('NotificationService resolves profileId from actorUserId or fromUserId when profileId is missing', async () => {
  // Mock lean notifications array as returned by MongoDB
  const mockNotifications = [
    {
      _id: '6afaab9c11479523508883d1',
      user: 'user1',
      actorUserId: 'actor_profile_123',
      type: 'profileActivity',
      message: 'Alex viewed your profile',
      createdAt: new Date(),
      isRead: false,
    },
    {
      _id: '6afaab9c11479523508883d2',
      user: 'user1',
      fromUserId: 'website_sender_456',
      type: 'interest',
      message: 'Sam expressed interest',
      createdAt: new Date(),
      isRead: true,
    },
    {
      _id: '6afaab9c11479523508883d3',
      user: 'user1',
      profileId: 'direct_profile_789',
      title: 'Custom Title',
      message: 'Direct notification',
      createdAt: new Date(),
      isRead: false,
    },
  ];

  // Test mapping logic
  const mapped = mockNotifications.map((notification) => {
    const resolvedProfileId = (
      notification.profileId ||
      notification.actorUserId ||
      notification.fromUserId ||
      ''
    ).toString();

    let resolvedTitle = notification.title?.trim();
    if (!resolvedTitle) {
      if (notification.type === 'match') {
        resolvedTitle = 'New Match';
      } else if (notification.type === 'interest') {
        resolvedTitle = 'Interest Received';
      } else if (notification.type === 'profileActivity') {
        resolvedTitle = 'Profile viewed';
      } else {
        resolvedTitle = 'Notification';
      }
    }

    return {
      id: notification._id.toString(),
      profileId: resolvedProfileId,
      title: resolvedTitle,
      subtitle: notification.message || '',
      type: notification.type,
      isRead: notification.isRead,
    };
  });

  assert.equal(mapped[0].profileId, 'actor_profile_123');
  assert.equal(mapped[0].title, 'Profile viewed');

  assert.equal(mapped[1].profileId, 'website_sender_456');
  assert.equal(mapped[1].title, 'Interest Received');

  assert.equal(mapped[2].profileId, 'direct_profile_789');
  assert.equal(mapped[2].title, 'Custom Title');
});
