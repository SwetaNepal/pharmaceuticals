exports.addStockPage = async(req, res) => {

    res.render('admin/addStock', {
    });
};

exports.insertJob = async (req, res) => {
    try {
        if (req.body.title.length < 1) throw "Please fill up the title field.";
        if (req.body.no_of_vacancies.length < 1) throw "Please fill up the number of vacancies field.";
        if (req.body.city.length < 1) throw "Please select a city.";
        if (req.body.category.length < 1) throw "Please select a category.";
        if (req.body.salary.length < 1) throw "Please fill up the salary field.";
        if (req.body.contact_email.length < 1) throw "Please fill up the contact email field.";
        if (req.body.description.length < 1) req.body.description = "N/A";
        if (req.body.keywords.length < 1) throw "Please fill up the job tags field.";
        if (req.body.expiry_date.length < 1) throw "Please select an expiry date.";

        poolQuery("INSERT INTO jobs (title, company_id, city, no_of_vacancies, category, keywords, description, contact_email, salary, posted_on, expiry_date) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", [req.body.title, req.userData.id, req.body.city, req.body.no_of_vacancies, req.body.category, req.body.keywords, req.body.description, req.body.contact_email, req.body.salary, Date.now(), Date.now() + (parseInt(req.body.expiry_date) * 86400000)])

        req.flash("success", "Job was posted. You can view it in My Jobs section.");
        res.redirect('/');
    } catch (err) {
        try {
            const categories = await poolQuery("SELECT * FROM categories", []);
            const cities = await poolQuery("SELECT * FROM cities", []);
            req.flash('error', err);
            res.render('company/postJob', {
                categories,
                cities,
                body: req.body
            });
        } catch (err) {
            req.flash('error', err);
            res.redirect('back');
        }
    }
};