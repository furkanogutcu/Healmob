SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

CREATE DATABASE IF NOT EXISTS `healmob` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `healmob`;

CREATE TABLE `tblanabilim_dali` (
  `anabilim_dali_no` int(11) NOT NULL,
  `anabilim_dali_adi` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `tblanabilim_dali` (`anabilim_dali_no`, `anabilim_dali_adi`) VALUES
(35, 'Acil Tıp'),
(36, 'Adli Tıp'),
(39, 'Aile Hekimliği'),
(40, 'Anatomi'),
(22, 'Anesteziyoloji ve Reanimasyon'),
(32, 'Askeri Sahra Hekimliği'),
(15, 'Beyin ve Sinir Cerrahisi'),
(12, 'Çocuk Cerrahisi'),
(8, 'Çocuk Psikiyatrisi'),
(7, 'Çocuk Sağlığı ve Hastalıkları'),
(9, 'Dermatoloji'),
(41, 'Embriyoloji ve Histoloji'),
(4, 'Enfeksiyon Hastalıkları'),
(10, 'Fiziksel Tıp ve Rehabilitasyon'),
(38, 'Fizyoloji'),
(11, 'Genel Cerrahi'),
(13, 'Göğüs Cerrahisi'),
(3, 'Göğüs Hastalıkları'),
(20, 'Göz Hastalıkları'),
(37, 'Halk Sağlığı'),
(33, 'Hava ve Uzay Hekimliği'),
(1, 'İç Hastalıkları'),
(21, 'Kadın Hastalıkları ve Doğum'),
(14, 'Kalp ve Damar Cerrahisi'),
(2, 'Kardiyoloji'),
(19, 'Kulak-Burun-Boğaz Hastalıkları'),
(5, 'Nöroloji'),
(25, 'Nükleer Tıp'),
(17, 'Ortopedi ve Travmatoloji'),
(16, 'Plastik, Rekonstrüktif ve Estetik Cerrahi'),
(6, 'Psikiyatri'),
(23, 'Radyasyon Onkolojisi'),
(24, 'Radyoloji'),
(31, 'Spor Hekimliği'),
(34, 'Sualtı Hekimliği ve Hiperbarik Tıp'),
(28, 'Tıbbi Biyokimya'),
(42, 'Tıbbi Ekoloji ve Hidroklimatoloji'),
(30, 'Tıbbi Farmakoloji'),
(27, 'Tıbbi Genetik'),
(29, 'Tıbbi Mikrobiyoloji'),
(26, 'Tıbbi Patoloji'),
(18, 'Üroloji');
DELIMITER $$
CREATE TRIGGER `trg_tblanabilim_dali_before_update` BEFORE UPDATE ON `tblanabilim_dali` FOR EACH ROW BEGIN
	IF LENGTH(`NEW`.anabilim_dali_adi) < 5 THEN
    		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Anabilim dali adi 5 karakterden az olamaz";
	END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_tblanabilimdali_before_insert` BEFORE INSERT ON `tblanabilim_dali` FOR EACH ROW BEGIN
	IF LENGTH(`NEW`.anabilim_dali_adi) < 5 THEN
    		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Anabilim dali adi 5 karakterden az olamaz";
	END IF;
END
$$
DELIMITER ;

CREATE TABLE `tbldoktor` (
  `doktor_no` int(11) NOT NULL,
  `anabilim_dali_no` int(11) NOT NULL,
  `email` varchar(50) NOT NULL,
  `sifre` varchar(50) NOT NULL,
  `ad` varchar(50) NOT NULL,
  `soyad` varchar(50) NOT NULL,
  `telefon` varchar(50) NOT NULL,
  `cinsiyet` tinyint(1) NOT NULL,
  `aktif_durum` tinyint(1) NOT NULL,
  `resim_yolu` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
DELIMITER $$
CREATE TRIGGER `trg_tbldoktor_before_insert` BEFORE INSERT ON `tbldoktor` FOR EACH ROW BEGIN

	IF(EXISTS(SELECT 1 FROM tbldoktor WHERE email = `NEW`.email))THEN
    		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "E-mail adresi zaten kayıtlı";
       	END IF;

	IF (`NEW`.email NOT LIKE '_%@__%.__%') THEN
     		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Geçersiz email adresi";    		
    	END IF;

	IF (LENGTH(`NEW`.sifre) < 6) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Sifre 6 karakterden az olamaz";   
	END IF;

	IF (LENGTH(`NEW`.ad) < 3) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Ad 3 karakterden az olamaz";   
	END IF;

	IF (LENGTH(`NEW`.soyad) < 3) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Soyad 3 karakterden az olamaz";   
	END IF;

	IF (LENGTH(`NEW`.telefon) < 10) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Telefon numarasi 10 karakterden az olamaz";   
	END IF;

	IF (`NEW`.telefon REGEXP '[A-Z]') THEN
     		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Geçersiz telefon numarasi";    		
    	END IF;

	IF (`NEW`.resim_yolu = "" OR `NEW`.resim_yolu = "null" OR `NEW`.resim_yolu = "NULL") THEN
		SET `NEW`.resim_yolu = NULL;
	END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_tbldoktor_before_update` BEFORE UPDATE ON `tbldoktor` FOR EACH ROW BEGIN

	IF (`NEW`.email != `OLD`.email) THEN
		IF(EXISTS(SELECT * FROM tbldoktor WHERE email = `NEW`.email))THEN
    			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "E-mail adresi zaten kayıtlı";
		END IF;
	END IF;

	IF (`NEW`.email NOT LIKE '_%@__%.__%') THEN
     		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Geçersiz email adresi";    		
    	END IF;

	IF (LENGTH(`NEW`.sifre) < 6) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Sifre 6 karakterden az olamaz";   
	END IF;

	IF (LENGTH(`NEW`.ad) < 3) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Ad 3 karakterden az olamaz";   
	END IF;

	IF (LENGTH(`NEW`.soyad) < 3) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Soyad 3 karakterden az olamaz";   
	END IF;

	IF (LENGTH(`NEW`.telefon) < 10) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Telefon numarasi 10 karakterden az olamaz";   
	END IF;

	IF (`NEW`.telefon REGEXP '[A-Z]') THEN
     		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Geçersiz telefon numarasi";    		
    	END IF;

	IF (`NEW`.resim_yolu = "" OR `NEW`.resim_yolu = "null" OR `NEW`.resim_yolu = "NULL") THEN
		SET `NEW`.resim_yolu = NULL;
	END IF;
END
$$
DELIMITER ;

CREATE TABLE `tbldoktor_uzmanlik_alani` (
  `id` int(11) NOT NULL,
  `doktor_no` int(11) NOT NULL,
  `uzmanlik_alani_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
DELIMITER $$
CREATE TRIGGER `trg_tbldoktor_uzmanlik_alani_before_insert` BEFORE INSERT ON `tbldoktor_uzmanlik_alani` FOR EACH ROW BEGIN
	IF EXISTS(SELECT * FROM tbldoktor_uzmanlik_alani WHERE tbldoktor_uzmanlik_alani.doktor_no = `NEW`.doktor_no AND tbldoktor_uzmanlik_alani.uzmanlik_alani_id = `NEW`.uzmanlik_alani_id) THEN
    		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Kayit zaten var";
    	END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_tbldoktor_uzmanlik_alani_before_update` BEFORE UPDATE ON `tbldoktor_uzmanlik_alani` FOR EACH ROW BEGIN
	IF EXISTS(SELECT * FROM tbldoktor_uzmanlik_alani WHERE tbldoktor_uzmanlik_alani.doktor_no = `NEW`.doktor_no AND tbldoktor_uzmanlik_alani.uzmanlik_alani_id = `NEW`.uzmanlik_alani_id) THEN
    		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Kayit zaten var";
    	END IF;
END
$$
DELIMITER ;

CREATE TABLE `tblhasta` (
  `hasta_no` int(11) NOT NULL,
  `email` varchar(50) NOT NULL,
  `sifre` varchar(50) NOT NULL,
  `ad` varchar(50) NOT NULL,
  `soyad` varchar(50) NOT NULL,
  `telefon` varchar(50) NOT NULL,
  `cinsiyet` tinyint(1) NOT NULL,
  `aktif_durum` tinyint(1) NOT NULL,
  `resim_yolu` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
DELIMITER $$
CREATE TRIGGER `trg_tblhasta_before_insert` BEFORE INSERT ON `tblhasta` FOR EACH ROW BEGIN
	IF(EXISTS(SELECT 1 FROM tblhasta WHERE email = `NEW`.email))THEN
    	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "E-mail adresi zaten kayıtlı";
       END IF;

	IF (`NEW`.email NOT LIKE '_%@__%.__%') THEN
     		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Geçersiz email adresi";    		
    	END IF;

	IF (LENGTH(`NEW`.sifre) < 6) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Sifre 6 karakterden az olamaz";   
	END IF;

	IF (LENGTH(`NEW`.ad) < 3) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Ad 3 karakterden az olamaz";   
	END IF;

	IF (LENGTH(`NEW`.soyad) < 3) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Soyad 3 karakterden az olamaz";   
	END IF;

	IF (LENGTH(`NEW`.telefon) < 10) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Telefon numarasi 10 karakterden az olamaz";   
	END IF;

	IF (`NEW`.telefon REGEXP '[A-Z]') THEN
     		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Geçersiz telefon numarasi";    		
    	END IF;

	IF (`NEW`.resim_yolu = "" OR `NEW`.resim_yolu = "null" OR `NEW`.resim_yolu = "NULL") THEN
		SET `NEW`.resim_yolu = NULL;
	END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_tblhasta_before_update` BEFORE UPDATE ON `tblhasta` FOR EACH ROW BEGIN
	IF (`NEW`.email != `OLD`.email) THEN
		IF (EXISTS(SELECT * FROM tblhasta WHERE email = `NEW`.email))THEN
    			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "E-mail adresi zaten kayıtlı";
	       	END IF;
	END IF;

	IF (`NEW`.email NOT LIKE '_%@__%.__%') THEN
     		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Geçersiz email adresi";    		
    	END IF;

	IF (LENGTH(`NEW`.sifre) < 6) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Sifre 6 karakterden az olamaz";   
	END IF;

	IF (LENGTH(`NEW`.ad) < 3) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Ad 3 karakterden az olamaz";   
	END IF;

	IF (LENGTH(`NEW`.soyad) < 3) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Soyad 3 karakterden az olamaz";   
	END IF;

	IF (LENGTH(`NEW`.telefon) < 10) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Telefon numarasi 10 karakterden az olamaz";   
	END IF;

	IF (`NEW`.telefon REGEXP '[A-Z]') THEN
     		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Geçersiz telefon numarasi";    		
    	END IF;

	IF (`NEW`.resim_yolu = "" OR `NEW`.resim_yolu = "null" OR `NEW`.resim_yolu = "NULL") THEN
		SET `NEW`.resim_yolu = NULL;
	END IF;
END
$$
DELIMITER ;

CREATE TABLE `tblmesaj` (
  `mesaj_id` int(11) NOT NULL,
  `hasta_no` int(11) NOT NULL,
  `doktor_no` int(11) NOT NULL,
  `hasta_mesaj` varchar(6000) DEFAULT NULL,
  `doktor_yanit` varchar(6000) DEFAULT NULL,
  `hasta_ek_yolu` varchar(200) DEFAULT NULL,
  `gonderim_tarihi` timestamp NOT NULL DEFAULT current_timestamp(),
  `yanitlanma_tarihi` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
DELIMITER $$
CREATE TRIGGER `trg_tblmesaj_before_insert` BEFORE INSERT ON `tblmesaj` FOR EACH ROW BEGIN
	IF EXISTS(SELECT * FROM tblmesaj WHERE hasta_no = `NEW`.hasta_no AND doktor_no = `NEW`.doktor_no) THEN
    		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Zaten bir mesaj gönderilmis";
    	END IF;

	IF LENGTH(`NEW`.doktor_yanit) < 5 THEN
    		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Doktor yaniti 5 karakterden az olamaz";
	END IF;

	IF LENGTH(`NEW`.hasta_mesaj) < 5 THEN
    		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Hasta mesaji 5 karakterden az olamaz";
    	END IF;
        
        SET `NEW`.gonderim_tarihi = CURRENT_TIMESTAMP;
        
        SET `NEW`.yanitlanma_tarihi = NULL;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_tblmesaj_before_update` BEFORE UPDATE ON `tblmesaj` FOR EACH ROW BEGIN
	IF LENGTH(`NEW`.doktor_yanit) < 5 THEN
    		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Doktor yaniti 5 karakterden az olamaz";
	END IF;

	IF LENGTH(`NEW`.hasta_mesaj) < 5 THEN
    		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Hasta mesaji 5 karakterden az olamaz";
    	END IF;
        
        SET `NEW`.gonderim_tarihi = `OLD`.gonderim_tarihi;
        
        SET `NEW`.yanitlanma_tarihi = CURRENT_TIMESTAMP;
END
$$
DELIMITER ;

CREATE TABLE `tbluzmanlik_alani` (
  `uzmanlik_alani_id` int(11) NOT NULL,
  `uzmanlik_alani_adi` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `tbluzmanlik_alani` (`uzmanlik_alani_id`, `uzmanlik_alani_adi`) VALUES
(1, 'Bel fıtığı'),
(2, 'Boyun fıtğı'),
(4, 'Göz kapağı hastalıkları'),
(6, 'Gözyaşı sistemi hastalıkları'),
(5, 'Kuru göz hastalığı'),
(3, 'Omurilik felci');
DELIMITER $$
CREATE TRIGGER `trg_tbluzmanlik_alani_before_insert` BEFORE INSERT ON `tbluzmanlik_alani` FOR EACH ROW BEGIN
	IF LENGTH(`NEW`.uzmanlik_alani_adi) < 5 THEN
    		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Uzmanlik alani adi 5 karakterden az olamaz";
    	END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_tbluzmanlik_alani_before_update` BEFORE UPDATE ON `tbluzmanlik_alani` FOR EACH ROW BEGIN
	IF LENGTH(`NEW`.uzmanlik_alani_adi) < 5 THEN
    		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Uzmanlik alani adi 5 karakterden az olamaz";
    	END IF;
END
$$
DELIMITER ;


ALTER TABLE `tblanabilim_dali`
  ADD PRIMARY KEY (`anabilim_dali_no`),
  ADD UNIQUE KEY `anabilim_dali_adi` (`anabilim_dali_adi`);

ALTER TABLE `tbldoktor`
  ADD PRIMARY KEY (`doktor_no`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `anabilim_dali_no` (`anabilim_dali_no`);

ALTER TABLE `tbldoktor_uzmanlik_alani`
  ADD PRIMARY KEY (`id`),
  ADD KEY `doktor_no` (`doktor_no`,`uzmanlik_alani_id`),
  ADD KEY `uzmanlik_alani_id` (`uzmanlik_alani_id`);

ALTER TABLE `tblhasta`
  ADD PRIMARY KEY (`hasta_no`),
  ADD UNIQUE KEY `email` (`email`);

ALTER TABLE `tblmesaj`
  ADD PRIMARY KEY (`mesaj_id`),
  ADD KEY `hasta_no` (`hasta_no`,`doktor_no`),
  ADD KEY `doktor_no` (`doktor_no`);

ALTER TABLE `tbluzmanlik_alani`
  ADD PRIMARY KEY (`uzmanlik_alani_id`),
  ADD UNIQUE KEY `uzmanlik_alani_adi` (`uzmanlik_alani_adi`);


ALTER TABLE `tblanabilim_dali`
  MODIFY `anabilim_dali_no` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

ALTER TABLE `tbldoktor`
  MODIFY `doktor_no` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `tbldoktor_uzmanlik_alani`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `tblhasta`
  MODIFY `hasta_no` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `tblmesaj`
  MODIFY `mesaj_id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `tbluzmanlik_alani`
  MODIFY `uzmanlik_alani_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;


ALTER TABLE `tbldoktor`
  ADD CONSTRAINT `tbldoktor_ibfk_1` FOREIGN KEY (`anabilim_dali_no`) REFERENCES `tblanabilim_dali` (`anabilim_dali_no`);

ALTER TABLE `tbldoktor_uzmanlik_alani`
  ADD CONSTRAINT `tbldoktor_uzmanlik_alani_ibfk_1` FOREIGN KEY (`doktor_no`) REFERENCES `tbldoktor` (`doktor_no`),
  ADD CONSTRAINT `tbldoktor_uzmanlik_alani_ibfk_2` FOREIGN KEY (`uzmanlik_alani_id`) REFERENCES `tbluzmanlik_alani` (`uzmanlik_alani_id`);

ALTER TABLE `tblmesaj`
  ADD CONSTRAINT `tblmesaj_ibfk_1` FOREIGN KEY (`doktor_no`) REFERENCES `tbldoktor` (`doktor_no`),
  ADD CONSTRAINT `tblmesaj_ibfk_2` FOREIGN KEY (`hasta_no`) REFERENCES `tblhasta` (`hasta_no`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
