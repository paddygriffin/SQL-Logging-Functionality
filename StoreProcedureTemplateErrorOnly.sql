CREATE PROCEDURE usp_Example
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Code that might generate an error
        
    END TRY

    BEGIN CATCH
    -- LOGGING VARIABLES
    DECLARE -- @Success BIT = 0,  no need for this variable if only used on failed execution of sproc
             @SPID INT = @@SPID,
             @Login VARChAR(128) = SYSTEM_USER, -- Sysstem user during a batch process
             @User VARCHAR(128) = USER, -- general user
             @StartTime DATETIME = GETDATE(),
             @Error XML,
             @ID BIGINT;

        IF XACT_STATE() <> 0 --does not equal 0 so there is an active transaction to rollback
           BEGIN
             ROLLBACK TRANSACTION;
           END

        ELSE
           BEGIN
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
           END 
    END CATCH
END
GO
