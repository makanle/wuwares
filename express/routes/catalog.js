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
    const {id, name, description, item_type, stock, price} = req.body;
    db.query(
        `INSERT INTO item (id, name, description, item_type, stock, price) VALUES ("${id}, ${name}", "${description}", "${item_type}", "${stock}", "${price}")`, 
        (err, result) => {
            if(err){
                return res.status(501).send({"message": "add item failed :("})
            }
            return res.status(200).send(result)
        }
    )
});

router.delete('/remove/:id', function(req, res, next){
    const {id} = parseInt(req.params.id);
    db.query(
        'DELETE FROM item WHERE id = ? RETURNING *;',
        [id],
        (err, result) => {
            if(err){
                return res.status(501).send({"message": "failed delete"})
            }
            if(result.rowCount == 0){
                return res.status(404).send({"message": "item not found"});
            }
        
            return res.status(200).send({"message": "item deleted", "deletedItem": result.rows[0]});
        }
    )
});

router.put('/edit/:id', function(req,res,next){
    const {id} = req.params.id;
    const {name, description, item_type, stock, price} = req.body;
    db.query(
        `UPDATE item SET
        name = ?,
        description = ?,
        item_type = ?,
        stock = ?,
        price = ?,
        WHERE id = ?`,
        [name, description, item_type, stock, price, id],
        (err, result) => {
            if(err){
                return res.status(501).send({"message" : "edit failed"})
            }
            return res.status(200).send({"message": "item edited successfully", result})
        }
    )

});

module.exports = router;