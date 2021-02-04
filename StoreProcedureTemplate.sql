-- LOGGING VARIABLES

DECLARE @Success BIT = 0, --0 = fail, 1 = pass
             @SPID INT = @@SPID,
             @Login VARChAR(128) = SYSTEM_USER, -- Sysstem user during a batch process
             @User VARCHAR(128) = USER, -- general user
             @StartTime DATETIME = GETDATE(),
             @Error XML,
             @ID BIGINT;

 
       BEGIN TRY
		   --Logging being inserted into log table
		   INSERT INTO dbo.App_Process_Logs
		   SELECT OBJECT_NAME(@@PROCID), @SPID, NULL, @StartTime, NULL, @Success, NULL, @Login, @User
		   
		   SET @ID = (SELECT SCOPE_IDENTITY());
		   
		--******Stored Procedure Code here*******

 
			SET @Success = 1 -- EXECUTION SUCCESFUL

             --ON SUCCESSFUL EXECUTION ADD TO LOG

             UPDATE dbo.App_Process_Logs

                SET EndTime = GETDATE(), Success = @Success

             WHERE LogID = @ID

       END TRY

 

       BEGIN CATCH


             --Stored Procedure code here if needed

             --Catch Error Message
             WITH [Error] AS
            (

                    SELECT  ERROR_NUMBER() AS [ErrNumber], ERROR_SEVERITY() AS [ErrServerity], ERROR_STATE() AS [ErrState],
                            ERROR_PROCEDURE() AS [ErrProc], ERROR_LINE() AS [ErrLine], ERROR_MESSAGE() AS [ErrMessage]

             )

             SELECT @Error = (SELECT [ErrNumber],[ErrServerity],[ErrState],[ErrProc],[ErrLine],[ErrMessage] FROM [Error] FOR XML PATH(''),TYPE)   
            
			UPDATE dbo.App_Process_Logs

                           SET EndTime = GETDATE(), Success = @Success, ErrorDetails = @Error

             WHERE LogID = @ID

 
       END CATCH