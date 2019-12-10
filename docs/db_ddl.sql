-- 찬송가
CREATE TABLE `hymns` (
  `_id` integer primary key,
  `version` varchar(100) NOT NULL,
  `type` varchar(100) NOT NULL,
  `number` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  `bookmarked` boolean NOT NULL default false
);
CREATE INDEX "hymns_index" on `hymns` (`version`, `number` ASC);
CREATE INDEX "hymns_search_index" on `hymns` (`title` ASC);
CREATE INDEX "hymns_bookmark_index" on `hymns` (`version`, `number` ASC, `bookmarked` ASC);

-- 성경 버전
CREATE TABLE `versions` (
  `_id` integer primary key,
  `vcode` varchar(100) NOT NULL,
  `name` varchar(100) NOT NULL
);

-- 성경 책
CREATE TABLE `bibles` (
  `_id` integer primary key,
  `vcode` varchar(100) NOT NULL,
  `bcode` int(11) NOT NULL,
  `type` varchar(10) NOT NULL,
  `name` varchar(100) NOT NULL,
  `chapter_count` int(11) NOT NULL
);
CREATE INDEX "bibles_index" on bibles (vcode ASC);

-- 성경 구절
CREATE TABLE `verses` (
  `_id` integer primary key,
  `vcode` varchar(100) NOT NULL,
  `bcode` int(11) NOT NULL,
  `cnum` int(11) NOT NULL,
  `vnum` int(11) NOT NULL,
  `content` text NOT NULL,
  `bookmarked` boolean NOT NULL default false
);
CREATE INDEX "verses_index" on verses (vcode ASC, bcode ASC, cnum ASC);
CREATE INDEX "verses_bookmark_index" on verses (vcode ASC, bookmarked ASC);
