--Variable can be changed or ignored as needed
DEF DATE_TIME = 'sysdate-90'

-- 
set @start = dateadd(day, datediff(day, 0, getdate()-1), 0) + '12:00:00'
set @end = dateadd(day, datediff(day, 0, getdate()), 0) + '12:01:00'

set @start = cast(datepart(day,@start) as varchar(4))+'-'+left(cast(datename(month,@start) as varchar(12)),3)+'-'+cast(datepart(year,@start) as varchar(4))+' '+cast('12' as varchar(4))+':'+cast('00' as varchar(4))+':'+cast('00' as varchar(4))--+cast('AM' as varchar(2))
set @end = cast(datepart(day,@end) as varchar(4))+'-'+left(cast(datename(month,@end) as varchar(12)),3)+'-'+cast(datepart(year,@end) as varchar(4))+' '+cast('12' as varchar(4))+':'+cast('00' as varchar(4))+':'+cast('00' as varchar(4))--+cast('AM' as varchar(2))
--
SELECT
  B.NAME Scanner_Name
  ,C.STATE
  ,A.STARTDATE Start_Date
  ,A.INCIDENTCOUNT
  --
  
   ,TO_CHAR(TRUNC(A.ELAPSEDTIME/3600000),'FM9900') || ':' ||
   TO_CHAR(TRUNC(MOD(A.ELAPSEDTIME/60000,60),2),'FM00') 
  Time_Taken_hh_mm
  --,A.ELAPSEDTIME
  ,TRUNC((TRUNC(A.BYTESSCANNED*1e-9,2) ) / NULLIF(A.ELAPSEDTIME, 0) * 3600000,2) GBS_PER_HOUR
  ,A.NUMBERRETRIEVEDFILES Number_Of_Retrieved_Files
  ,A.LASTSTATECHANGEDATE Last_State_Change_Date
  ,TRUNC(A.BYTESSCANNED*1e-12, 2) TB_Scanned
  ,TRUNC(A.BYTESSCANNED*1e-9,2) GB_Scanned
  ,A.ERRORCOUNT Error_Count
  --,A.CURRENTROOT Current_Root
  --,A.CURRENTFILE Current_File
    
FROM 
  WALK A
LEFT OUTER JOIN SCANASSIGNMENT B ON B.COURSEID = A.COURSEID
LEFT OUTER JOIN DI_DATAREFRESH_TRK C ON C.STATEID = A.STATE


--Uncomment or add to as needed

--WHERE
   --A.STARTDATE BETWEEN &&DATE_TIME AND SYSDATE
  --&&DATE_TIME >= '31-JAN-19%' 
  --WHERE &&DATE_TIME <= '31-JAN-19%' 
  --WHERE &&DATE_TIME BETWEEN :startdate AND '1-FEB-19'
  --WHERE &&DATE_TIME BETWEEN '14-JAN-19' AND SYSDATE
  --WHERE &&DATE_TIME BETWEEN '14-JAN-19' AND SYSDATE-6
  --WHERE &&DATE_TIME >= SYSDATE-1
  
ORDER BY Start_Date DESC;s
