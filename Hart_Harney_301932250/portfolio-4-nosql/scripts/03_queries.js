// Meaningful queries over transfer_events
use('lagos_community_bank');

print('=== Q1: Full lifecycle for TRF-1001 ===');
printjson(db.transfer_events.find({ transfer_ref: 'TRF-1001' }).sort({ occurred_at: 1 }).toArray());

print('=== Q2: Failed events with reasons ===');
printjson(
  db.transfer_events
    .find({ status: 'failed' }, { transfer_ref: 1, amount: 1, failure_reason: 1, occurred_at: 1, _id: 0 })
    .toArray()
);

print('=== Q3: Posted volume by channel ===');
printjson(
  db.transfer_events
    .aggregate([
      { $match: { status: 'posted' } },
      {
        $group: {
          _id: '$channel',
          count: { $sum: 1 },
          total_amount: { $sum: '$amount' }
        }
      },
      { $sort: { total_amount: -1 } }
    ])
    .toArray()
);

print('=== Q4: Latest event per transfer_ref ===');
printjson(
  db.transfer_events
    .aggregate([
      { $sort: { transfer_ref: 1, occurred_at: -1 } },
      {
        $group: {
          _id: '$transfer_ref',
          latest_status: { $first: '$status' },
          amount: { $first: '$amount' },
          occurred_at: { $first: '$occurred_at' },
          channel: { $first: '$channel' }
        }
      },
      { $sort: { _id: 1 } }
    ])
    .toArray()
);
