var express = require('express');
var router = express.Router();
const {OAuth2Client} = require('google-auth-library');
const db = require('../database/database');
const { gentoken } = require('../helper/helper');
var client = new OAuth2Client(
  '801994355249-rh2uutocrbjpco0e6kb5o3psluf23lu3.apps.googleusercontent.com' // web app client id
)

/* GET users listing. */
router.get('/', function(req, res, next) {
  res.send('respond with a resource');
});

router.post('/login', async function(req, res, next){
  var {google_token} = req.body;
  const ticket = await client.verifyIdToken({
    idToken: google_token,
    audience: '801994355249-rh2uutocrbjpco0e6kb5o3psluf23lu3.apps.googleusercontent.com'
  });
  const payload = ticket.getPayload();
  const username = payload.name;
  const email = payload.email;
  db.query(
    'SELECT * FROM users WHERE email = ?',
    email,
    (err, result) =>{
      if(err) return res.status(400).send({'message' : 'failed'});

      const token = gentoken(10);
      if(result.length == 0){
        db.query(
          'INSERT INTO users (username, email, password, token) VALUES (?, ?, ?, ?)',
          [username, email, null, token],
          (err2, result2) =>{
            if(err2) return res.status(400).send({'message' : 'google register failed'});
            return res.status(200).send(result2);
          }
        )
      } else{
        db.query(
          'UPDATE users SET token = ? WHERE email = ?',
          [token, email],
          (err3, result3) => {
            if(err3) return res.status(400).send({'message' : 'failed to login'});
            return res.status(200).send(result3);
          }
        )
      }
    }
  )
});

module.exports = router;
