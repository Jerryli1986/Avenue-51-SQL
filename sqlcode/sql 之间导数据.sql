use Jerry_DB

SELECT  * into Shipment 
FROM OPENDATASOURCE('TradewiseFromCN','Data Source=92.53.244.68;User ID=Jerry;Password=CE1C6733@A3D1').[TradewiseFromCN].dbo.Shipment



use test

SELECT  * into temp
FROM OPENDATASOURCE('Jerry_DB','Data Source=192.168.0.192;User ID=sa;Password=sas').Jerry_DB.dbo.temp1111

