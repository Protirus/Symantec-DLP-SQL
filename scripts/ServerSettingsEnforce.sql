SELECT sett.NAME monname
,attr.NAME
,attr.VALUE
,attr.SETTINGID
FROM SETTING sett
LEFT JOIN ATTRIBUTE attr ON attr.SETTINGID = sett.SETTINGID
WHERE sett.SETTINGID = '18'
ORDER BY attr.SETTINGID
;