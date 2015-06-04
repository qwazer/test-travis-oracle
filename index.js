console.log('start');

var oracledb = require('oracledb');

oracledb.getConnection(
  {
    user          : "hr",//"SEQUELIZE","hr"
    password      : "welcome",//"test","welcome"
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
