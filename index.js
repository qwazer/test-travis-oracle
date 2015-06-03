console.log('start');

var oracledb = require('oracledb');

oracledb.getConnection(
  {
    user          : "SEQUELIZE",
    password      : "test",
    connectString : "localhost/XE"
  },
  function(err, connection)
  {
    if (err) {
      console.error(err.message);
      return;
    }
    connection.execute(
      "SELECT 1, :did as id "
    + "FROM dual ",
      [180],
      function(err, result)
      {
        if (err) {
          console.error(err.message);
          return;
        }
        console.log(result.rows);
      });
  });
