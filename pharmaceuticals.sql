-- phpMyAdmin SQL Dump
-- version 4.8.0.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 16, 2019 at 05:55 PM
-- Server version: 10.1.32-MariaDB
-- PHP Version: 7.2.5

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

CREATE TABLE `user`(
    `id` int(64),
    `email` varchar(64),
    `password` varchar(64),
    `type` varchar(32),
    `name` varchar(64)
);

CREATE TABLE `stock`(
    `batch_num` int(64), 
    `identification` varchar(64),
    `mfg_date` date,
    `expiry_date` date,
    `quantity`int(64),
    `delivery_date`date,
    `buying_price`int(64),
    `selling price`int(64),
    `mfg_company`varchar(64),
    `stock_type`varchar(64)
);

CREATE TABLE `distributor`(
    `distributor_id` int(64),
    `mr_name` varchar(64) NOT NULL,
    `mr_phone` int(128) NOT NULL,
    `mr_email` varchar(64),
    `company_name` varchar(64)
);

CREATE TABLE `medicines`(
    `med_id` int(64),
    `stock_identification` varchar(64), 
    `med_name` varchar(64),
    `med_type` varchar(64),
    `chemical_name` varchar(64),
    `distributor_id` int(64)
);

CREATE TABLE `composition`(
    `med_id` int(64),
    `chemical_name` varchar(64),
    `quantity` int(64)
);

CREATE TABLE `customer`(
    `customer_id` int(64),
    `name` varchar(64) NOT NULL,
    `address` varchar(64),
    `phone` int(128),
    `dob` date NOT NULL,
    `gender` varchar(36) NOT NULL
);

CREATE TABLE `prescription`(
    `prescription_id` int(64) NOT NULL,
    `prescription_number` varchar(64),
    `hospital` varchar(256),
    `doctor_assigned` varchar(128),
    `customer_id` int(64)
);

CREATE TABLE `prescription_meds`(
    `prescription_id` int(64),
    `med_id` int(64),
    `dosage` int(16),
    `refills` int(64)
);

CREATE TABLE `insurance`(
    `insurance_number` varchar(64),
    `company` varchar(64),
    `type` varchar(64),
    `discount` int(64),
    `validity` date,
    `customer_id` int(64)
);

CREATE TABLE `company_details`(
    `name` varchar(64),
    `address` varchar(64),
    `email` varchar(64),
    `phone` int(128)
);

CREATE TABLE `staff`(
    `id` int(64),
    `name` varchar(64),
    `address` varchar(64),
    `gender` varchar(64),
    `phone` int(128),
    `position` varchar(64),
    `joining_date` date,
    `duty_time` time,
    `shift_hour` int(8),
    `dob` timestamp,
    `email` varchar(64)
);

CREATE TABLE `salary`(
    `position` varchar(64),
    `amount` int(64),
    `bonus_percent` int(8),
    `allowance` int(32)
);

CREATE TABLE `assets`(
    `asset_id` int(64),
    `stock_identification` varchar(64),
    `name` varchar(64),
    `quantity` int(64),
    `distributor_id` int(64)
);

CREATE TABLE `prescription_sales`(
    `prescription_id` int(64),
    `amount` int(64),
    `date` date,
    `insurance_number` varchar(64),
    `discount` int(64)
);

CREATE TABLE `non_pres_sales`(
    `customer_id` int(64),
    `sales_id` int(64),
    `amount` int(64),
    `date` date,
    `insurance_number` varchar(64)
);

CREATE TABLE `non_pres_sales_meds`(
    `sales_id` int(64),
    `med_id` int(64)
);

ALTER TABLE `user`
    ADD CONSTRAINT `user_id`
    PRIMARY KEY (`id`),
    ADD CONSTRAINT `userTypeChecker`
    CHECK (`type` = "admin" OR `type` = "seller");

ALTER TABLE `stock`
    ADD CONSTRAINT `batch_number`
    PRIMARY KEY (`batch_num`),
    ADD CONSTRAINT `stockTypeChecker`
    CHECK (`stock_type` = "medicine" OR `stock_type` = "asset");

ALTER TABLE `company_details`
    ADD CONSTRAINT `company_details`
    PRIMARY KEY (`name`); 

ALTER TABLE `distributor`
    ADD CONSTRAINT `distributor_id`
    PRIMARY KEY (`distributor_id`),
    ADD CONSTRAINT `company_name_fkey`
    FOREIGN KEY (`company_name`) REFERENCES `company_details`(`name`);

ALTER TABLE `medicines` 
    ADD CONSTRAINT `med_id` 
    PRIMARY KEY (`med_id`), 
    ADD CONSTRAINT `distributor_id`
    FOREIGN KEY (`distributor_id`) REFERENCES `distributor`(`distributor_id`);

ALTER TABLE `composition`
    ADD CONSTRAINT `composition_med_id`
    FOREIGN KEY (`med_id`) REFERENCES `medicines`(`med_id`);

ALTER TABLE `customer`
    ADD CONSTRAINT `customer_id`
    PRIMARY KEY (`customer_id`),
    ADD CONSTRAINT `customer_gender_check`
    CHECK (`gender` = "male" OR `gender` = "female" OR `gender` = "unspecified");

ALTER TABLE `prescription`
    ADD CONSTRAINT `prescription_number`
    PRIMARY KEY (`prescription_number`, `hospital`),
    ADD CONSTRAINT `prescription_customer_id`
    FOREIGN KEY (`customer_id`) REFERENCES `customer`(`customer_id`),
    ADD CONSTRAINT `prescription_id`
    UNIQUE (`prescription_id`);

ALTER TABLE `prescription_meds`
    ADD CONSTRAINT `meds_prescription_id`
    FOREIGN KEY (`prescription_id`) REFERENCES `prescription`(`prescription_id`),
    ADD CONSTRAINT `prescription_med_id`
    FOREIGN KEY (`med_id`) REFERENCES `medicines`(`med_id`);

ALTER TABLE `insurance`
    ADD CONSTRAINT `insurance_number`
    PRIMARY KEY (`insurance_number`, `company`),
    ADD CONSTRAINT `insurance_customer_id`
    FOREIGN KEY (`customer_id`) REFERENCES `customer`(`customer_id`),
    ADD CONSTRAINT `discount_percentCheck`
    CHECK (`discount` <= 100);

ALTER TABLE `salary`
    ADD CONSTRAINT `staff_position`
    PRIMARY KEY (`position`),
    ADD CONSTRAINT `bonus_percentCheck`
    CHECK (`bonus_percent` <= 100);

ALTER TABLE `staff`
    ADD CONSTRAINT `staff_id`
    PRIMARY KEY (`id`),
    ADD CONSTRAINT `positon_fkey`
    FOREIGN KEY (`position`) REFERENCES `salary`(`position`),
    ADD CONSTRAINT `staff_gender_check`
    CHECK (`gender` = "male" OR `gender` = "female" OR `gender` = "unspecified");

ALTER TABLE `assets`
    ADD CONSTRAINT `asset_id`
    PRIMARY KEY (`asset_id`),
    ADD CONSTRAINT `asset_distributor_id`
    FOREIGN KEY (`distributor_id`) REFERENCES `distributor`(`distributor_id`);

ALTER TABLE `prescription_sales`
    ADD CONSTRAINT `sales_prescription_id`
    FOREIGN KEY (`prescription_id`) REFERENCES `prescription`(`prescription_id`),
    ADD CONSTRAINT `sales_insurance_number`
    FOREIGN KEY (`insurance_number`) REFERENCES `insurance`(`insurance_number`);

ALTER TABLE `non_pres_sales`
    ADD CONSTRAINT `sales_customer_id`
    FOREIGN KEY (`customer_id`) REFERENCES `customer`(`customer_id`),
    ADD CONSTRAINT `np_sales_insurance_number`
    FOREIGN KEY (`insurance_number`) REFERENCES `insurance`(`insurance_number`);

ALTER TABLE `non_pres_sales_meds`
    ADD CONSTRAINT `sales_id`
    PRIMARY KEy (`sales_id`);

ALTER TABLE `user`
MODIFY `id` int(64) NOT NULL AUTO_INCREMENT;

ALTER TABLE `medicines`
MODIFY `med_id` int(64) NOT NULL AUTO_INCREMENT;

ALTER TABLE `stock`
MODIFY `batch_num` int(64) NOT NULL AUTO_INCREMENT;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;