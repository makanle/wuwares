var express = require('express');
var router = express.Router();
var db = require('../database/database');

router.get('/', function (req, res){
    db.query(
        'SELECT * FROM item',
        (err, result) => {
            if(err){
                return res.status(501).send({"message": "failed to fetch items"});
            }
            return res.status(200).send(result);
        }
    ) 
});

router.post('/add', function(req, res, next){
    var data = req.body;
    db.query(
        `INSERT INTO item (name, price) VALUES ("${data.name}", "${data.prices}")`,
        (err, result) => {
            if(err){
                return res.status(501).send({"message": "add item failed :("})
            }
            return res.status(200).send(result)
        }
    )
});

module.exports = router;