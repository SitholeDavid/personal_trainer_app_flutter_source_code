CREATE TABLE workouts(
    id INTEGER PRIMARY KEY,
    title TEXT,
    summary TEXT
);

CREATE TABLE packages(
    id INTEGER PRIMARY KEY,
    packageID TEXT,
    title TEXT,
    summary TEXT,
    price FLOAT,
    noSessions INT,
    expiryDate TEXT,
    datePurchased TEXT
);