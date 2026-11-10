// Sample transfer lifecycle events aligned to Lagos Community Bank transfers
use('lagos_community_bank');

const docs = [
  {
    event_id: 'EVT-1001-INIT',
    transfer_ref: 'TRF-1001',
    from_account: '1002003010',
    to_account: '1002003001',
    amount: 25000,
    currency: 'NGN',
    status: 'initiated',
    channel: 'branch',
    initiated_by: 'STF-001',
    metadata: { branch: 'VI', customer_note: 'Rent support' },
    occurred_at: ISODate('2025-10-08T09:00:00+01:00')
  },
  {
    event_id: 'EVT-1001-POST',
    transfer_ref: 'TRF-1001',
    from_account: '1002003010',
    to_account: '1002003001',
    amount: 25000,
    currency: 'NGN',
    status: 'posted',
    channel: 'branch',
    initiated_by: 'STF-001',
    metadata: { ledger_refs: ['TRF-1001-DR', 'TRF-1001-CR'] },
    occurred_at: ISODate('2025-10-08T09:00:01+01:00')
  },
  {
    event_id: 'EVT-1002-INIT',
    transfer_ref: 'TRF-1002',
    from_account: '1002003030',
    to_account: '1002003020',
    amount: 12000,
    currency: 'NGN',
    status: 'initiated',
    channel: 'mobile',
    initiated_by: 'STF-005',
    metadata: { device: 'android' },
    occurred_at: ISODate('2025-10-09T10:15:00+01:00')
  },
  {
    event_id: 'EVT-1002-POST',
    transfer_ref: 'TRF-1002',
    from_account: '1002003030',
    to_account: '1002003020',
    amount: 12000,
    currency: 'NGN',
    status: 'posted',
    channel: 'mobile',
    initiated_by: 'STF-005',
    metadata: { ledger_refs: ['TRF-1002-DR', 'TRF-1002-CR'] },
    occurred_at: ISODate('2025-10-09T10:15:01+01:00')
  },
  {
    event_id: 'EVT-1003-INIT',
    transfer_ref: 'TRF-1003',
    from_account: '1002003070',
    to_account: '1002003060',
    amount: 8000,
    currency: 'NGN',
    status: 'initiated',
    channel: 'ussd',
    initiated_by: 'STF-002',
    metadata: {},
    occurred_at: ISODate('2025-10-10T08:40:00+01:00')
  },
  {
    event_id: 'EVT-1003-POST',
    transfer_ref: 'TRF-1003',
    from_account: '1002003070',
    to_account: '1002003060',
    amount: 8000,
    currency: 'NGN',
    status: 'posted',
    channel: 'ussd',
    initiated_by: 'STF-002',
    metadata: { ledger_refs: ['TRF-1003-DR', 'TRF-1003-CR'] },
    occurred_at: ISODate('2025-10-10T08:40:01+01:00')
  },
  {
    event_id: 'EVT-1004-INIT',
    transfer_ref: 'TRF-1004',
    from_account: '1002003001',
    to_account: '1002003040',
    amount: 5000,
    currency: 'NGN',
    status: 'initiated',
    channel: 'branch',
    initiated_by: 'STF-001',
    metadata: {},
    occurred_at: ISODate('2025-10-11T12:00:00+01:00')
  },
  {
    event_id: 'EVT-1004-FAIL',
    transfer_ref: 'TRF-1004',
    from_account: '1002003001',
    to_account: '1002003040',
    amount: 5000,
    currency: 'NGN',
    status: 'failed',
    channel: 'branch',
    initiated_by: 'STF-001',
    failure_reason: 'destination KYC review hold',
    metadata: { retryable: false },
    occurred_at: ISODate('2025-10-11T12:00:02+01:00')
  },
  {
    event_id: 'EVT-P3-OK-INIT',
    transfer_ref: 'TRF-P3-OK-01',
    from_account: '1002003002',
    to_account: '1002003040',
    amount: 7500,
    currency: 'NGN',
    status: 'initiated',
    channel: 'api',
    initiated_by: 'STF-001',
    metadata: { portfolio: 3 },
    occurred_at: ISODate('2025-11-10T11:00:00+00:00')
  },
  {
    event_id: 'EVT-P3-OK-POST',
    transfer_ref: 'TRF-P3-OK-01',
    from_account: '1002003002',
    to_account: '1002003040',
    amount: 7500,
    currency: 'NGN',
    status: 'posted',
    channel: 'api',
    initiated_by: 'STF-001',
    metadata: { portfolio: 3 },
    occurred_at: ISODate('2025-11-10T11:00:01+00:00')
  }
];

const result = db.transfer_events.insertMany(docs);
print(`Inserted ${Object.keys(result.insertedIds).length} transfer_events`);

print('=== Validation failure demo (amount 0) ===');
try {
  db.transfer_events.insertOne({
    event_id: 'EVT-BAD',
    transfer_ref: 'TRF-BAD',
    from_account: '1002003001',
    to_account: '1002003002',
    amount: 0,
    currency: 'NGN',
    status: 'initiated',
    channel: 'api',
    occurred_at: new Date()
  });
} catch (e) {
  print('Expected validation error: ' + e.message);
}
