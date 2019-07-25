exports.viewMedicines = async (req, res) => {
    try {
        var data = await poolQuery("SELECT meds.*, stock.* FROM medicines INNER JOIN stock ON medicines.stock_identification=stock,identification", [req.params.id]);
        
        if (data.length < 1) throw "Invalid link was followed.";

        res.render('medicine', {
            medicine: data[0]
        });
    } catch (err) {
        req.flash('error', err)
        res.redirect('/');
    }
};

exports.placeOrder = async (req, res) => {
    try {
        var data = await poolQuery("INSERT INTO customer (customer_id, name, address, phone, dob, gender) VALUES (?, ?, ?, ?, ?, ?)", [req.body.customer_id, req.body.customer_name, req.body.customer_address, req.body.customer_phone, Date.now(), req.body.gender]);
        res.redirect('google.com');
    } catch (err) {
        req.flash('error', err)
        res.redirect('/');
    }
};

