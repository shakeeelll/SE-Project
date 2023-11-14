const jwt = require("jsonwebtoken");
// Middleware function to validate JWT tokens
// ya har API k andar same use ho ga . bs variable s change karna ho ga

function validateToken(req, res, next) {
  var token = req.headers.authorization;
  token=token.split(' ')[1];
  if (!token) {
    return res.status(401).json({ message: "No token provided" });
  }
  jwt.verify(token, "ssdfj$sdanh%dmnvnsd@", (err, decoded) => {
    if (err) {
      return res.status(403).json({ message: "Failed to authenticate token" });
    }

    // If the token is valid, save the decoded information for later use

    req.user = decoded;

    next();
  });
}

module.exports = {validateToken,};
