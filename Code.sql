-- Create the user table
CREATE TABLE `inventory`.`user` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `email` VARCHAR(100) NOT NULL UNIQUE,
  `createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
);

-- Create the order table
CREATE TABLE `inventory`.`order` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `userId` BIGINT NOT NULL,
  `totalAmount` DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
  `orderDate` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` VARCHAR(50) NOT NULL DEFAULT 'PENDING',
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_order_user`
    FOREIGN KEY (`userId`)
    REFERENCES `inventory`.`user` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- Create the product table
CREATE TABLE `inventory`.`product` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `description` TEXT NULL,
  `price` DECIMAL(10, 2) NOT NULL,
  `stock` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
);

-- Create the transaction table (your existing table)
CREATE TABLE `inventory`.`transaction` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `userId` BIGINT NOT NULL,
  `orderId` BIGINT NOT NULL,
  `code` VARCHAR(100) NOT NULL,
  `type` SMALLINT(6) NOT NULL DEFAULT 0,
  `mode` SMALLINT(6) NOT NULL DEFAULT 0,
  `status` SMALLINT(6) NOT NULL DEFAULT 0,
  `createdAt` DATETIME NOT NULL,
  `updatedAt` DATETIME NULL DEFAULT NULL,
  `content` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `idx_transaction_user` (`userId` ASC),
  CONSTRAINT `fk_transaction_user`
    FOREIGN KEY (`userId`)
    REFERENCES `inventory`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

ALTER TABLE `inventory`.`transaction` 
ADD INDEX `idx_transaction_order` (`orderId` ASC);
ALTER TABLE `inventory`.`transaction` 
ADD CONSTRAINT `fk_transaction_order`
  FOREIGN KEY (`orderId`)
  REFERENCES `inventory`.`order` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

-- Create transaction_item table to link transactions and products
CREATE TABLE `inventory`.`transaction_item` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `transactionId` BIGINT NOT NULL,
  `productId` BIGINT NOT NULL,
  `quantity` INT NOT NULL,
  `price` DECIMAL(10, 2) NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_transaction_item_transaction`
    FOREIGN KEY (`transactionId`)
    REFERENCES `inventory`.`transaction` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_transaction_item_product`
    FOREIGN KEY (`productId`)
    REFERENCES `inventory`.`product` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);
