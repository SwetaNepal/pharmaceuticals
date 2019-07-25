const router = require('express').Router();
const adminController = require('../controllers/adminController');
const auth = require('../middlewares/auth');
const adminAuth = require('../middlewares/adminAuth');
const moment = require('moment');

router.get('/stock', auth, adminAuth, adminController.addStockPage);

router.post('/stock', auth, adminAuth, adminController.insertMedicine);

router.get('/medicines/:id/delete', auth, adminAuth, async (req, res) => {
    const result = await poolQuery("DELETE FROM medicines WHERE med_id=?", [req.params.id]);
    req.flash("info", "Medicine was deleted from website.");
    res.redirect("back");
});

module.exports = router;