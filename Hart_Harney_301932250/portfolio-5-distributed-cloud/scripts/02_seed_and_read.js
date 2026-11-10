// Primary write + secondary read demonstration
const status = rs.status();
print('Replica set: ' + status.set);
print('Members:');
status.members.forEach((m) => print(`  ${m.name} state=${m.stateStr}`));

db = db.getSiblingDB('lagos_community_bank');

db.transfer_events.drop();
db.createCollection('transfer_events');

db.transfer_events.insertMany([
  {
    event_id: 'EVT-RS-1',
    transfer_ref: 'TRF-RS-001',
    from_account: '1002003002',
    to_account: '1002003040',
    amount: 1500,
    currency: 'NGN',
    status: 'posted',
    channel: 'api',
    occurred_at: new Date()
  },
  {
    event_id: 'EVT-RS-2',
    transfer_ref: 'TRF-RS-002',
    from_account: '1002003010',
    to_account: '1002003001',
    amount: 2200,
    currency: 'NGN',
    status: 'initiated',
    channel: 'mobile',
    occurred_at: new Date()
  }
]);

print('Primary write count: ' + db.transfer_events.countDocuments());
printjson(db.transfer_events.find({}, { _id: 0, event_id: 1, transfer_ref: 1, status: 1, amount: 1 }).toArray());
