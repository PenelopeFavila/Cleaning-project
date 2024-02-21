--CLEANING TABLE PRODUCTION SCHEDULE
SELECT *
FROM [PRODUCTION SCHEDULE]

--Standarize Date Fromat
SELECT Date , CONVERT (date, Date)
FROM [PRODUCTION SCHEDULE]

UPDATE [PRODUCTION SCHEDULE]
SET Date = CONVERT (date, Date)

ALTER TABLE [PRODUCTION SCHEDULE]
ADD Production_Date Date

UPDATE [PRODUCTION SCHEDULE]
SET Production_Date = CONVERT (date, Date)


--Channge CL or different from X 
SELECT DISTINCT CL, COUNT(CL)
FROM [PRODUCTION SCHEDULE]
GROUP BY CL
ORDER BY 2

SELECT CL
,CASE WHEN  CL= 'cl' THEN 'X'
	  ELSE 'X'
	  END
FROM [PRODUCTION SCHEDULE]

UPDATE [PRODUCTION SCHEDULE]
SET CL = CASE WHEN  CL= 'cl' THEN 'X'
			  ELSE 'X'
			  END
			  FROM [PRODUCTION SCHEDULE]

--Remove Duplicates
WITH T1 AS(
			SELECT *,
				ROW_NUMBER() OVER(PARTITION BY [Client WO/ Internal WO] ORDER BY ID) RN
			FROM [PRODUCTION SCHEDULE]
			)
DELETE
FROM T1 
WHERE RN >1

--Split column

SELECT 
PARSENAME(REPLACE([Client WO/ Internal WO],'-','.'),2)
,PARSENAME(REPLACE([Client WO/ Internal WO],'-','.'),1)
FROM [PRODUCTION SCHEDULE]

ALTER TABLE [PRODUCTION SCHEDULE]
ADD Client_WO NVARCHAR(20)

UPDATE [PRODUCTION SCHEDULE]
SET Client_WO = PARSENAME(REPLACE([Client WO/ Internal WO],'-','.'),2)

ALTER TABLE [PRODUCTION SCHEDULE]
ADD Internal_WO NVARCHAR(20)

UPDATE [PRODUCTION SCHEDULE]
SET Internal_WO = PARSENAME(REPLACE([Client WO/ Internal WO],'-','.'),1)


--Trim column
SELECT [ITEM NUMBER], TRIM([ITEM NUMBER]) AS Item_trim
FROM [PRODUCTION SCHEDULE]

ALTER TABLE [PRODUCTION SCHEDULE]
ADD Item_No NVARCHAR(20)

UPDATE [PRODUCTION SCHEDULE]
SET Item_No = TRIM([ITEM NUMBER])

--Remove Columns
ALTER TABLE [PRODUCTION SCHEDULE]
DROP COLUMN [Client WO/ Internal WO],[ITEM NUMBER],Date, F17,F18,F19,F20,F21,F22,F23,F24,F25,F26


--CLEANING TABLE WASTE REPORT

--Pouplate NULL values in column Tons
SELECT W1.[Client WO/ Internal WO], W1.Tons, W2.[Client WO/ Internal WO], W2.Tons, ISNULL(W1.Tons,W2.Tons)
FROM [WASTE REPORT] W1
JOIN [WASTE REPORT] W2
ON W1.[Client WO/ Internal WO] = W2.[Client WO/ Internal WO]
AND W1.ID <> W2.ID
WHERE W1.Tons IS NULL  

UPDATE W1
SET Tons =  ISNULL(W1.Tons,W2.Tons)
FROM [WASTE REPORT] W1
JOIN [WASTE REPORT] W2
ON W1.[Client WO/ Internal WO] = W2.[Client WO/ Internal WO]
AND W1.ID <> W2.ID
WHERE W1.Tons IS NULL 

--Correct column Waste %
SELECT ROUND(([Waste %]*100),2) Perc_waste
FROM [WASTE REPORT]

ALTER TABLE [WASTE REPORT]
ADD Waste_Percentage FLOAT

UPDATE [WASTE REPORT]
SET Waste_Percentage = ROUND(([Waste %]*100),2) 

--Round column numbers

SELECT ROUND([Tons Produced],2) 
FROM [WASTE REPORT]

ALTER TABLE [WASTE REPORT]
ADD Tons_Prod FLOAT

UPDATE [WASTE REPORT]
SET Tons_Prod = ROUND([Tons Produced],2)


SELECT ROUND([Tons Used],2) 
FROM [WASTE REPORT]

ALTER TABLE [WASTE REPORT]
ADD Tons_Use FLOAT

UPDATE [WASTE REPORT]
SET Tons_Use = ROUND([Tons Used],2)


SELECT ROUND([Tons Wasted],2) 
FROM [WASTE REPORT]

ALTER TABLE [WASTE REPORT]
ADD Waste_tons FLOAT

UPDATE [WASTE REPORT]
SET Waste_tons = ROUND([Tons Wasted],2)

--Pouplate NULL values in column Boxes
SELECT W1.[Client WO/ Internal WO], W1.Boxes, W2.[Client WO/ Internal WO], W2.Boxes, ISNULL(W1.Boxes,W2.Boxes)
FROM [WASTE REPORT] W1
JOIN [WASTE REPORT] W2
ON W1.[Client WO/ Internal WO] = W2.[Client WO/ Internal WO]
AND W1.ID <> W2.ID
WHERE W1.Boxes IS NULL 

UPDATE W1
SET Boxes =  ISNULL(W1.Boxes,W2.Boxes)
FROM [WASTE REPORT] W1
JOIN [WASTE REPORT] W2
ON W1.[Client WO/ Internal WO] = W2.[Client WO/ Internal WO]
AND W1.ID <> W2.ID
WHERE W1.Boxes IS NULL 

--Pouplate 0 values in column Tons Used
SELECT W1.[Client WO/ Internal WO], W1.[Tons Used], W2.[Client WO/ Internal WO], W2.[Tons Used]
FROM [WASTE REPORT] W1
JOIN [WASTE REPORT] W2
ON W1.[Client WO/ Internal WO] = W2.[Client WO/ Internal WO]
AND W1.ID <> W2.ID
WHERE W1.[Tons Used]=0 

UPDATE W1
SET [Tons Used] = W2.[Tons Used]
FROM [WASTE REPORT] W1
JOIN [WASTE REPORT] W2
ON W1.[Client WO/ Internal WO] = W2.[Client WO/ Internal WO]
AND W1.ID <> W2.ID
WHERE W1.[Tons Used]= 0 


--Pouplate 0 values in column Tons Produced
SELECT W1.[Client WO/ Internal WO], W1.[Tons Produced], W2.[Client WO/ Internal WO], W2.[Tons Produced]
FROM [WASTE REPORT] W1
JOIN [WASTE REPORT] W2
ON W1.[Client WO/ Internal WO] = W2.[Client WO/ Internal WO]
AND W1.ID <> W2.ID
WHERE W1.[Tons Produced]=0 

UPDATE W1
SET [Tons Produced] = W2.[Tons Produced]
FROM [WASTE REPORT] W1
JOIN [WASTE REPORT] W2
ON W1.[Client WO/ Internal WO] = W2.[Client WO/ Internal WO]
AND W1.ID <> W2.ID
WHERE W1.[Tons Produced]= 0 


--Breaking out Client WO and Internal WO in individual columns
SELECT [Client WO/ Internal WO]
FROM [WASTE REPORT]

SELECT
SUBSTRING([Client WO/ Internal WO],1,CHARINDEX ('-',[Client WO/ Internal WO])-1) AS ClientWO
,SUBSTRING([Client WO/ Internal WO],CHARINDEX ('-',[Client WO/ Internal WO])+ 1, LEN([Client WO/ Internal WO])) AS InternalWO 
FROM [WASTE REPORT]

ALTER TABLE [WASTE REPORT]
ADD SplitClientWO NVARCHAR(20)

UPDATE [WASTE REPORT]
SET SplitClientWO = SUBSTRING([Client WO/ Internal WO],1,CHARINDEX ('-',[Client WO/ Internal WO])-1) 

ALTER TABLE [WASTE REPORT]
ADD SplitInternalWO NVARCHAR(20)

UPDATE [WASTE REPORT]
SET SplitInternalWO = SUBSTRING([Client WO/ Internal WO],CHARINDEX ('-',[Client WO/ Internal WO])+ 1, LEN([Client WO/ Internal WO])) 


--Alternative method to split

SELECT 
PARSENAME(REPLACE([Client WO/ Internal WO],'-','.'),2)
,PARSENAME(REPLACE([Client WO/ Internal WO],'-','.'),1)
FROM [WASTE REPORT]

ALTER TABLE [WASTE REPORT]
ADD Client_WO NVARCHAR(20)

UPDATE [WASTE REPORT]
SET Client_WO = PARSENAME(REPLACE([Client WO/ Internal WO],'-','.'),2)

ALTER TABLE [WASTE REPORT]
ADD Internal_WO NVARCHAR(20)

UPDATE [WASTE REPORT]
SET Internal_WO = PARSENAME(REPLACE([Client WO/ Internal WO],'-','.'),1)


--Remove duplicate
WITH T1 AS(
			SELECT *,
				ROW_NUMBER() OVER(PARTITION BY [Client WO/ Internal WO] ORDER BY ID) RN
			FROM [WASTE REPORT]
			)
DELETE
FROM T1 
WHERE RN >1

--Trim column ITEM NUMBER
SELECT [ITEM NUMBER], TRIM([ITEM NUMBER]) AS Item_trim
FROM [WASTE REPORT]

ALTER TABLE [WASTE REPORT]
ADD Item_No NVARCHAR(20)

UPDATE [WASTE REPORT]
SET Item_No = TRIM([ITEM NUMBER])


--Remove columns
ALTER TABLE [WASTE REPORT]
DROP COLUMN [ITEM NUMBER],[Client WO/ Internal WO],SplitClientWO, SplitInternalWO,ID1, [Waste %], [Tons Produced],[Tons Used],[Tons Wasted],Tons


SELECT *
FROM [WASTE REPORT]