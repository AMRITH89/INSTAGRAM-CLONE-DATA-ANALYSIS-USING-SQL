--2. We want to reward the user who has been around the longest, Find the 5 oldest users.

with oldestcust as
(select username as Name, date(created_at) as Id_created_date
from users)
select * from oldestcust
order by Id_created_date
limit 5;

--3. To target inactive users in an email ad campaign, find the users who have never posted a photo.

with active_user as
(select u.username, u.id
from users u
inner join photos p
on u.id=p.user_id)
select u.username as Inactive_usernames, u.id
from users u
where id not in (select au.id from active_user au);

--4.Suppose you are running a contest to find out who got the most likes on a photo. Find out who won?

with active_user as
(select u.username, u.id as userid, p.id as photo_id
from users u
inner join photos p
on u.id=p.user_id),
maxlike as
(select photo_id, count(photo_id) as total_likes
from likes
group by photo_id
order by total_likes desc
limit 1)
select au.userid,au.username as Winner_Username,m.photo_id, m.total_likes
from active_user au
inner join maxlike m
on m.photo_id=au.photo_id;

--5. The investors want to know how many times does the average user post.

with user_post as
(select user_id,count(user_id) as total_comments_by_user
from comments
group by user_id),
avg_user_post as
(
select avg(total_comments_by_user) as average_user_comments
from user_post)
select * from avg_user_post;

--6. A brand wants to know which hashtag to use on a post, and find the top 5 most used hashtags.

with tag_counts as
(select tag_id, count(tag_id) as No_of_times_used
from photo_tags
group by tag_id
order by No_of_times_used desc
)
select tag_id, No_of_times_used as Top5_Tags from tag_counts
limit 5;

--7. To find out if there are bots, find users who have liked every single photo on the site.

with total_photos as
(select count(id) from photos),
bot_user_id as
( select user_id as Bot_ID, count(user_id)
from likes
group by user_id
having count(user_id)=(select * from total_photos))
select * from bot_user_id;

--8. Find the users who have created instagramid in may and select top 5 newest joinees from it?

with user_may as
(select username, date(created_at) as users_from_MAY
from users
where monthname(created_at)="May"
order by users_from_MAY desc)
select username, users_from_MAY as 5_new_users_from_May from user_may
limit 5; 

--9. Can you help me find the users whose name starts with c and ends with any number and have posted the photos as well as liked the photos?

with username_c_and_num as
(select id, username
from users
where username regexp '^C.*[0-9]{1}$'),
posted_photos as
(select p.user_id, ucn.username
from photos p
inner join username_c_and_num ucn
on ucn.id=p.user_id),
name_post_liked_photos as
(select distinct l.user_id, pp.username
from likes l
inner join posted_photos pp
on pp.user_id=l.user_id)
select * from name_post_liked_photos;

-- 10. Demonstrate the top 30 usernames to the company who have posted photos in the range of 3 to 5.

with post_btwn_3to5 as
(select user_id, count(user_id) as no_of_photos_posted
from photos
group by user_id having no_of_photos_posted between 3 and 5 
order by no_of_photos_posted),
user_post_3to5 as
(select u.username, pb.user_id, pb.no_of_photos_posted
from users u
inner join post_btwn_3to5 pb
on u.id=pb.user_id
order by pb.no_of_photos_posted 
)
select * from user_post_3to5;
