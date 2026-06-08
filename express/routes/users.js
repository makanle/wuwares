var express = require('express');
var router = express.Router();
const {OAuth2Client} = require('google-auth-library');
const db = require('../database/database');
const { gentoken } = require('../helper/helper');
var client = new OAuth2Client(
  process.env.WEB_GOOGLE_AUTH
)

function auth_middleware(req, res, next){
  const headers = req.headers.authorization;
  if(!headers) return res.status(400).send({message : "no headers"});
  let parts = headers.split(" ");
  const bearer = parts[0];
  const token = parts[1];
  if(bearer != "Bearer") return res.status(400).send({message : "invalid header"});
  db.query(
    'SELECT * FROM users WHERE token = ?', token,
    (err, result) => {
      if (err) return res.status(400).send({message : err});
      if(result.length == 0){
        return res.status(400).send({message : "no user found"});
      }
      req.user = result[0];
      next();
    }
  )
}

/* GET users listing. */
router.get('/', function(req, res, next) {
  res.send('respond with a resource');
});

router.post('/login', async function(req, res, next){
  var {google_token, role} = req.body;
  const ticket = await client.verifyIdToken({
    idToken: google_token,
    audience: process.env.WEB_GOOGLE_AUTH
  });
  const payload = ticket.getPayload();
  const username = payload.name;
  const role = payload.role;
  const email = payload.email;
  db.query(
    'SELECT * FROM users WHERE email = ?',
    email,
    (err, result) =>{
      if(err) return res.status(400).send({'message' : 'failed'});

      const token = gentoken(20);
      if(result.length == 0){
        db.query(
          'INSERT INTO users (username, email, role, auth_provider, token) VALUES (?, ?, ?, ?, ?)',
          [username, email, role, 'google', token],
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
