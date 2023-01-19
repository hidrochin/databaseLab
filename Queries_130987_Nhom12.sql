--Nguyễn Hà Phú Thịnh - 20205131--
---câu 1: Danh sách cầu thủ thuộc CLB có tên là "Manchester City"--

create index idx_club_clubid on club(club_id);

explain
select player.* from player join club using (club_id)
where club.club_name = 'Manchester City'; --14.65...17.86 not use index, 1.11...4.46 using index

--- câu 2: Danh sách các trọng tài trong trận đấu ngày '23-6-2022'--
create index idx_referee_refereeid on referee(referee_id);

explain
select * from referee 
where referee_id in (select referee_id1 from controls join matches using (match_id)
					where time = '2022-06-23')
	or referee_id in (select referee_id2 from controls join matches using (match_id)
					where time = '2022-06-23')
	or referee_id in (select referee_id3 from controls join matches using (match_id)
					where time = '2022-06-23'); --11.89...27.14 not use index, 11.89..13.15 using index--

--- câu 3: Danh sách các cầu thủ vừa là người Brazil vừa là thành viên của đội 'Barcelona'--
create index idx_player_playerid on player(player_id);
create index idx_club_clubname on club(club_name);


explain
select player.* from nation join player using (nation_id) join club using (club_id) 
where nation_name = 'Brazil' and club_name = 'Barcelona'; --1.26...12.76 not using index, the same as using index
--is the best choice--

explain
select player.* from player join nation using (nation_id)
where nation_name = 'Brazil'
intersect
select player.* from player join club using (club_id)
where club_name = 'Barcelona'; --18.29....26.41 not using index and the same as using index--

explain
select player.* from player join nation using (nation_id)
where nation_name = 'Brazil' 
and player_id in (select player_id from player join club using (club_id)
				 where club_name = 'Barcelona'); --4.76....16.25 not using index, the same as using index
				 
--- câu 4: Danh sách các đội có tỉ lệ thắng theo thứ tự giảm dần sau mùa giải
explain
select club.*, round((win * 1.0)/(match_played * 1.0), 3) as winrate
from club join finaltable using (club_id) join round using (roundname)
where roundname = 'Round 8'
order by winrate DESC; --20.74...20.74 

-- câu 5: Danh sách các sân vận động chưa được sử dụng trong giải đấu ở tháng 6-2022--
explain
select * from stadium
except
select distinct stadium.* from stadium join matches using (stadium_id)
where extract('year' from time) = 2022 and extract('month' from time) = 6; --0.00..32.3 not using index

explain
select * from stadium 
where stadium_id not in (select st.stadium_id from stadium st join matches using (stadium_id)
						where extract('year' from time) = 2022 and extract('month' from time) = 6); --10.62..24.49 not using index 

 -- câu 6: Danh sách những trọng tài đã từng điều khiển ít nhất 11 trận đấu trở lên
create index idx_match_matchid on matches(match_id);
create index idx_referee_refereeid on referee(referee_id);

explain
select referee.*, count(match_id)
from referee join controls on (referee_id = referee_id1) join matches using (match_id)
group by referee_id
having count(match_id) >= 11
union
select referee.*, count(match_id)
from referee join controls on (referee_id = referee_id2) join matches using (match_id)
group by referee_id
having count(match_id) >= 11
union
select referee.*, count(match_id)
from referee join controls on (referee_id = referee_id3) join matches using (match_id)
group by referee_id
having count(match_id) >= 11; --18.79...18.94 is the same whether index is used or not

-- câu 7: Danh sách các cầu thủ trên 25 tuổi tại thời điểm hiện tại sắp xếp theo thứ tự tăng dần

explain
select player.*, (extract('year' from current_date) - extract('year' from player.DOB)) as age
from player where (extract('year' from current_date) - extract('year' from player.DOB)) > 25
order by age ASC; --5.92...6.00 

--câu 8: Cho biết sức chứa trung bình của các sân vận động được sử dụng trong tháng 6-2022
explain
with tmp as (
	select distinct stadium.* from stadium join matches using (stadium_id)
	where extract('year' from time) = 2022 and extract('month' from time) = 6
)
select round(avg(capacity), 3) as capacity_avg from tmp;  --35.8...35.9 the same time whether using index or not

-- câu 9: Danh sách các câu lạc bộ thắng ở trong Round 3--
explain
select cl.* from club cl join participation pt on (cl.club_id = pt.club_id1)
							join matches using (match_id)
where matches.roundname = 'Round 3' and (goal_1 > goal_2)
union
select cl.* from club cl join participation pt on (cl.club_id = pt.club_id2)
							join matches using (match_id)
where matches.roundname = 'Round 3' and (goal_1 < goal_2); --8.82...8.86 using index

-- câu 10: Vòng có nhiều thẻ vàng nhất trong giải đấu --

create index idx_matches_matchid on matches(match_id);

explain
select round.roundname, sum(yellow_card1) + sum(yellow_card2) as maxsum
from round join matches using (roundname)
group by roundname
order by maxsum desc
limit 1; --34.2...34.2 not using index, the same as using index


---Lê Trung Hiếu - 20207999---
select * from player;
select * from stadium;
select * from club;
select * from coach;
select * from nation;
select * from matches;
select * from controls;

--1.In ra thông tin các cầu thủ có số áo là 7 chơi ở vị trí tiền đạo
select * from player 
where shirt_number = '7' and role = 'Attacker';

--2.Hiển thị thông tin các cầu thủ đang thi đấu trong CLB có sân nhà là Old Traford
select player.* 
from player join stadium using (club_id)
where stadium_name = 'Old Trafford';

--3. Cho biết mã HLV, họ tên, ngày sinh, vai trò và tên CLB đang làm việc mà CLB đó ở Manchester
select c.coach_id, c.coach_name, c.dob, c.role, cl.club_name
from coach c join club cl using (club_id)
where cl.address like '%Manchester%';

--4.Thống kê số lượng cầu thủ có quốc tịch khác England của mỗi CLB
select c.club_id, count(c.club_id) as so_luong_cau_thu
from club as c, player as p, nation as n
where c.club_id = p.club_id and p.nation_id = n.nation_id and n.nation_name not like '%England%'
group by c.club_id;

--5. Cho biết mã huấn luyện viên, họ tên, ngày sinh những HLV Tây Ban Nha có tuổi nằm trong khoảng 35-45
select c.coach_id, c.coach_name, c.dob
from coach c, nation n
where c.nation_id = n.nation_id
and n.nation_name = 'Spain'
and(extract('year' from current_date)-extract('year' from dob))between 35 and 45;

--6. Cho biết mã CLB, tên CLB, tên SVĐ địa chỉ và số lượng cầu thủ có quốc tịch khác 'England'
-- tương ứng với CLB có nhiều hơn 8 cầu thủ

select c.club_id, c.club_name, s.stadium_name, s.address, count(c.club_id) as So_cau_thu
from club as c, stadium as s, player as p, nation as n
where p.nation_id = n.nation_id and n.nation_name not like '%England%'
and c.club_id = p.club_id and c.club_id = s.club_id
group by c.club_id, c.club_name, s.stadium_name, s.address
having count(c.club_id) > 8;

--7 Thống kê số lượng cầu thủ mỗi CLB
select c.club_name, count(c.club_id) as so_cau_thu
from club c , player p
where c.club_id = p.club_id
group by c.club_id;

--8. Cho biết mã cầu thủ, họ tên, ngày sinh, và vị trí của các cầu thủ thuộc đội bóng 
-- 'Paris Saint German' có quốc tịch Argentina
select p.player_id, p.player_name, p.dob, p.role
from player p join club c using(club_id)
			  join nation n using(nation_id)
where c.club_name = 'Paris Saint German'
and n.nation_name = 'Argentina'

--9. Cho biết đội đứng cuối xong 8 vòng
select * from finaltable
where point = (select min(point) from finaltable);

--10. Đếm số trận bắt chính của trọng tài chính
select referee_name, count(match_id) as sotranbatchinh
from controls join referee on (referee_id1 = referee_id)
group by referee_id
order by sotranbatchinh asc

-- Lê Duy Quý--

-- Câu 1: Đưa ra danh sách những CLB ở Tây Ban Nha
SELECT * from club
	where address ilike '%Spain%'

-- Câu 2: Đưa ra danh sách tên, số áo, vị trí, mã câu lạc bộ, mã quốc gia những cầu thủ thi đấu ở vị trí 'Midfielder' và mặc áo số '10'
SELECT p.player_name, p.shirt_number, p. role, p.club_id, p.nation_id
	from player as p
	where p.role ='Midfielder' and p.shirt_number ='10'


-- Câu 3: Đưa ra danh sách tên, dob, số áo, vị trí, sđt, mã clb, mã quốc gia những cầu thủ sinh từ năm 1990 trở lại đây và sắp xếp theo tuổi giảm dần
SELECT p.player_name, p.dob, p.shirt_number, p.role, p.phone, p.club_id, p.nation_id
	from player as p
	where p.dob between '1990-01-01' and current_date
	order by p.dob ASC

-- Câu 4: Đưa ra danh sách mã cầu thủ, tên, dob, số áo, vị trí những cầu thủ người Đức đang thi đấu cho câu lạc bộ Real Madrid
SELECT p.player_id, p.player_name, p.dob, p.shirt_number, p.role 
	from player as p
	join nation using (nation_id) 
	join club using (club_id)
	where nation_name = 'Germany' and club_name = 'Real Madrid'

-- Câu 5: Đưa ra danh sách thống kê số lượng cầu thủ có quốc tịch không phải Pháp của mỗi CLB
SELECT c.club_id, count(c.club_id) as so_luong_cau_thu
	from club as c, player as p, nation as n
	where c.club_id = p.club_id 
	and p.nation_id = n.nation_id 
	and n.nation_name not like '%France%'
	group by c.club_id

-- Câu 6: Đưa ra danh sách mã trận đấu, đội thi đấu 1, đội thi đấu 2, bàn thắng 1, bàn thắng 2, thẻ đỏ 1, thẻ đỏ 2 những trận đấu có ít nhất 1 thẻ đỏ
SELECT m.match_id, p.club_id1, p.club_id2, m.goal_1, m.goal_2, m.red_card1, m.red_card2
	from matches as m 
	join participation as p using (match_id)
	where m.red_card1 >= '1' or m.red_card2 >= '1'

-- Câu 7: Đưa ra danh sách thông tin match_id, đội thi đấu, roundname, svđ, bàn thắng những trận đấu mà trọng tài chính có id là 'A1'
SELECT m.match_id, p.club_id1, p.club_id2, m.roundname, m.stadium_id, m.goal_1, m.goal_2
	from matches as m
	join participation as p using (match_id)
	join controls as c using (match_id)
	where c.referee_id1 = 'A1'

-- Câu 8: Đưa ra danh sách mã huấn luyện viên, tên, ngày sinh, role, mã CLB, mã quốc gia những HLV người Anh có role là 'Fitness Coach' và tuổi nằm trong khoảng 40-60
SELECT c.coach_id, c.coach_name, c.dob, c.role, c.club_id, c.nation_id
	from coach as c, nation as n
	where c.nation_id = n.nation_id 
		and n.nation_name = 'England'
		and c.role = 'Fitness Coach'
		and (extract('year' from current_date)-extract('year' from dob))between 40 and 60

-- Câu 9: Đưa ra thông tin đội đứng đầu sau 8 vòng (nếu có nhiều hơn 1 đội thì sắp xếp theo thứ tự giảm dần của goal_difference)
SELECT * from finaltable
	where point = (SELECT max(point) from finaltable)
	order by goal_difference DESC

-- Câu 10: Đưa ra thống kê số lượng cầu thủ thi đấu ở vị trí "Attacker" của mỗi clb
SELECT c.club_name, count(c.club_id) as so_luong_thu_mon
	from club as c, player as p
	where c.club_id = p.club_id and p.role = 'Attacker'
	group by c.club_id