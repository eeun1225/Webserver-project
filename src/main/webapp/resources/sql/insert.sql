INSERT INTO member (id, password, name, birth, mail, phone, address, coin)
VALUES ('user123', 'password123', '홍길동', '1990/05/15', 'hong@naver.com', '010-1234-5678', '서울시 강남구', 10000);

INSERT INTO member (id, password, name, birth, mail, phone, address, coin)
VALUES ('user02', 'password456', '김영희', '1985/08/21', 'kim@naver.com', '010-1300-4555', '서울시 종로구', 2000);

INSERT INTO member (id, password, name, birth, mail, phone, address, coin)
VALUES ('user03', 'password789', '박철수', '1995/03/10', 'park@naver.com', '010-1111-2222', '서울시 마포구', 1500);


INSERT INTO challenge (title, description, period, due_date, frequency, coin, capacity, category, certification, user_id)
VALUES ('운동 챌린지', '매일 최소 30분씩 걷거나 조깅하여 건강을 유지하세요. 건강한 습관은 긍정적인 생활에 기여합니다.', '1개월', '2024-06-30', 7, 500, 15, '운동', '이미지', 'user123');

INSERT INTO challenge (title, description, period, due_date, frequency, coin, capacity, category, certification, user_id)
VALUES ('독서 챌린지', '매일 1시간 독서하여 지식을 습득하고 창의성을 향상시키세요. 독서는 끊임없는 성장을 도모합니다.', '3개월', '2024-07-12', 7, 500, 10,'공부', '텍스트', 'user02');

INSERT INTO challenge (title, description, period, due_date, frequency, coin, capacity, category, certification, user_id)
VALUES ('명상 챌린지', '매일 15분씩 명상하여 마음의 안정을 취하고 스트레스를 해소하세요. 명상은 내적 평화를 찾는 데 도움이 됩니다.', '2주일', '2024-06-15', 7, 700, 8, '규칙적인 생활', '이미지', 'user03');

INSERT INTO challenge (title, description, period, due_date, frequency, coin, capacity, category, certification, user_id)
VALUES ('요리 챌린지', '매주 다른 나라의 요리를 시도하여 다양한 문화를 경험하세요. 요리는 즐거움과 만족을 주는 창작 활동입니다.', '1주일', '2024-06-30', 2, 1500, 20, '식습관', '이미지', 'user123');

INSERT INTO challenge (title, description, period, due_date, frequency, coin, capacity, category, certification, user_id)
VALUES ('코딩 챌린지', '매일 1시간씩 코딩 문제를 해결하여 프로그래밍 기술을 향상시키세요. 코딩은 논리적 사고와 문제 해결 능력을 강화합니다.', '3일', '2024-07-10', 1, 1000, 10, '공부', '이미지', 'user02');


INSERT INTO product (name, description, price, stock, image) VALUES
('키보드', '키보드입니다.', 150000, 0, 'Keyboard.jpeg');

INSERT INTO product (name, description, price, stock, image) VALUES
('필통', '필통입니다.', 2000, 500, 'pencilcase.png'),
('헤드셋', '헤드폰입니다.', 300000, 10, 'headset.png'),
('커피', '커피입니다.', 3000, 1000, 'coffee.png');
 


SELECT * FROM challenge;
SELECT * FROM member;
SELECT * FROM participation;
SELECT * FROM certifications;
SELECT * FROM post;
SELECT * FROM attendance;