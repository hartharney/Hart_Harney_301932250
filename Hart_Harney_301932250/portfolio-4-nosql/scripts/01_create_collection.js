// Lagos Community Bank — Portfolio 4 MongoDB transfer_events
// Hart_Harney_301932250
use('lagos_community_bank');

db.transfer_events.drop();

db.createCollection('transfer_events', {
  validator: {
    $jsonSchema: {
      bsonType: 'object',
      required: [
        'event_id',
        'transfer_ref',
        'from_account',
        'to_account',
        'amount',
        'currency',
        'status',
        'channel',
        'occurred_at'
      ],
      properties: {
        event_id: { bsonType: 'string' },
        transfer_ref: { bsonType: 'string' },
        from_account: { bsonType: 'string' },
        to_account: { bsonType: 'string' },
        amount: { bsonType: ['double', 'int', 'long', 'decimal'], minimum: 0.01 },
        currency: { enum: ['NGN'] },
        status: { enum: ['initiated', 'posted', 'failed', 'reversed'] },
        channel: { enum: ['branch', 'mobile', 'ussd', 'api'] },
        initiated_by: { bsonType: ['string', 'null'] },
        failure_reason: { bsonType: ['string', 'null'] },
        metadata: { bsonType: 'object' },
        occurred_at: { bsonType: 'date' }
      },
      additionalProperties: true
    }
  },
  validationLevel: 'strict',
  validationAction: 'error'
});

db.transfer_events.createIndex({ transfer_ref: 1, occurred_at: 1 });
db.transfer_events.createIndex({ status: 1, occurred_at: -1 });
db.transfer_events.createIndex({ from_account: 1, occurred_at: -1 });

print('Created transfer_events with JSON Schema validation and indexes');
