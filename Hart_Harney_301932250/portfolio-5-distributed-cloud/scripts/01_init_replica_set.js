// Initialise lcbRS replica set (host ports 27017-27019)
rs.initiate({
  _id: 'lcbRS',
  members: [
    { _id: 0, host: '127.0.0.1:27017', priority: 2 },
    { _id: 1, host: '127.0.0.1:27018', priority: 1 },
    { _id: 2, host: '127.0.0.1:27019', priority: 1 }
  ]
});
