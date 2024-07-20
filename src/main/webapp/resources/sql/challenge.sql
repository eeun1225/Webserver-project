DROP TABLE IF EXISTS certifications;
DROP TABLE IF EXISTS participation;
DROP TABLE IF EXISTS comments;
DROP TABLE IF EXISTS post;
DROP TABLE IF EXISTS challenge;
DROP TABLE IF EXISTS attendance;
DROP TABLE IF EXISTS member;

CREATE TABLE IF NOT EXISTS member(
   id VARCHAR(20) NOT NULL,
   password VARCHAR(50) NOT NULL,
   name VARCHAR(100) NOT NULL,
   birth VARCHAR(100),
   mail VARCHAR(50) NOT NULL,
   phone VARCHAR(100),
   address VARCHAR(100),
   coin INTEGER NOT NULL,
   PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS challenge(
	c_id INTEGER NOT NULL AUTO_INCREMENT,
	title VARCHAR(100) NOT NULL,
	description TEXT NOT NULL,
	period VARCHAR(20) NOT NULL,
    due_date DATE NOT NULL,
	frequency INTEGER NOT NULL,
	coin INTEGER,
	capacity INTEGER,
	count INTEGER,
	category VARCHAR(20) NOT NULL,
	certification VARCHAR(10) NOT NULL,
	user_id VARCHAR(20) NOT NULL,
	PRIMARY KEY(c_id),
	FOREIGN KEY (user_id) REFERENCES member(id)
)default CHARSET=utf8mb4;


CREATE TABLE IF NOT EXISTS participation (
    challenge_id INTEGER NOT NULL,
    participant_id VARCHAR(20) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status VARCHAR(10) NOT NULL,
    PRIMARY KEY (challenge_id, participant_id),
    FOREIGN KEY (challenge_id) REFERENCES challenge(c_id),
    FOREIGN KEY (participant_id) REFERENCES member(id)
) DEFAULT CHARSET=utf8mb4;

CREATE TABLE certifications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    challenge_id INT NOT NULL,
    participant_id VARCHAR(20) NOT NULL,
    file_path TEXT,
    file_type VARCHAR(50),
    upload_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(10),
    FOREIGN KEY (challenge_id) REFERENCES challenge(c_id),
    FOREIGN KEY (participant_id) REFERENCES member(id)
) DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS post (
    id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    author VARCHAR(20) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (author) REFERENCES member(id)
);

CREATE TABLE IF NOT EXISTS attendance (
    id INT AUTO_INCREMENT PRIMARY KEY,
    participant_id VARCHAR(20) NOT NULL,
    attendance_date DATE NOT NULL,
    FOREIGN KEY (participant_id) REFERENCES member(id)
) DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS comments (
    id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    post_id INT NOT NULL,
    author VARCHAR(20) NOT NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES post(id),
    FOREIGN KEY (author) REFERENCES member(id)
);

