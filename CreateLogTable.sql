USE [App]

 

CREATE TABLE dbo.App_Process_Logs

(
--
	[LogID] BIGINT IDENTITY(1,1) PRIMARY KEY,
       [ProcessName] SYSNAME NOT NULL,
       [SPID] INT NOT NULL,
       [Parameters] XML NULL,
       [StartTime] DATETIME NOT NULL,
       [EndTime] DATETIME NULL,
       [Success] BIT NOT NULL,
       [ErrorDetails] XML NULL,
       [Login] VARCHAR(128) NULL,
       [USER] VARCHAR(128) NULL

)

ON [PRIMARY]


EXEC sys.sp_addextendedproperty @name = 'SPL',       -- sysname
                                @value = 'Holds Logs for the Stored Procedure Process',      -- sql_variant
                                @level0type = 'Schema',   -- varchar(128)
                                @level0name = 'dbo', -- sysname
                                @level1type = 'Table',   -- varchar(128)
                                @level1name = 'App_Process_Logs'