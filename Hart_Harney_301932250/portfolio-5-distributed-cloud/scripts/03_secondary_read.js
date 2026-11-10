// Run against a secondary with readPreference
db.getMongo().setReadPref('secondary');
db = db.getSiblingDB('lagos_community_bank');
print('Hello from secondary readPreference');
print('isMaster: ');
printjson(db.hello());
print('transfer_events visible on secondary: ' + db.transfer_events.countDocuments());
printjson(db.transfer_events.find({}, { _id: 0, event_id: 1, transfer_ref: 1, status: 1 }).toArray());
