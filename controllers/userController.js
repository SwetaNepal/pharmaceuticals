const jwt = require('jwt-then');

exports.loginPage = (req, res) => {
    if (req.query.target === "register") {
        console.log("hello");
        res.render('login', {
            register: true
        });
    } else {
        res.render('login', {
            register: false
        });
    }
};

exports.login = async (req, res) => {
    var email = req.body.email;
    var password = req.body.password;

    var id = "";

    try {
        data = await poolQuery("SELECT id, type FROM user WHERE email=? AND password=?", [email, password]);
        if (data.length < 1) throw "Email and password did not match.";
        id = data[0].id;

        jwt.sign({ id: id, type: data[0].type }, process.env.SECRET).then(token => {
            res.cookie('token', token, { maxAge: 2592000000 });
            req.flash('success', "Logged in successfully.");
            res.redirect('/');
        });
    } catch (err) {
        req.flash('error', err)
        res.render('login', {
            register: false,
            logBody: req.body
        });
    }
}

exports.register = async (req, res) => {
    var type = req.body.type;
    var name = req.body.name;
    var email = req.body.email;
    var password = req.body.password;
    var password2 = req.body.password2;

    var emailRegEx = /@gmail.com|@yahoo.com|@hotmail.com|@ymail.com|@live.com|@microsoft.com|@googlemail.com|@rocketmail.com|@outlook.com/;

    try {
        if (!(type === "admin" || type === "seller")) throw "Select the type of account you're trying to create.";
        if (!emailRegEx.test(email)) throw "We do not support emails from the domain you've provided.";
        if (name.length < 3) throw "Insert a valid name";
        if (password.length < 5) throw "Enter password of at least five characters.";
        if (password !== password2) throw "Confirmed password didn't match.";

        var insertId = "";

        data = await poolQuery("SELECT COUNT(*) as num FROM user WHERE email=?", [email]);
        if (data[0].num > 0) throw "Email already associated to another account.";
        result = await poolQuery("INSERT INTO user (email, password, type, name) VALUES (?,?,?,?)", [email, password, type, name]);
        insertId = result.insertId;

        jwt.sign({ id: insertId, type: type }, process.env.SECRET).then(token => {
            res.cookie('token', token, { maxAge: 2592000000 });
            req.flash('success', "Registration was successful. Now complete the profile to get started.");
            res.redirect('/');
        });
    } catch (err) {
        req.flash('error', err)
        res.render('login', {
            register: true,
            regBody: req.body
        });
    }
};

exports.logout = (req, res) => {
    res.clearCookie('token');
    res.redirect('/')
};