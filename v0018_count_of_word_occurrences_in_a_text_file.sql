-- Question: Determining the Word Occurrence Count in a Text File
Create table If Not Exists Files (file_name varchar(100), content text );
Truncate table Files;
insert into Files (file_name, content) values 
('draft1.txt', 'The stock exchange predicts a bull market which would make many investors happy.')
,('draft2.txt', 'The stock exchange predicts a bull market which would make many investors happy, but analysts warn of possibility of too much optimism and that in fact we are awaiting a bear market.')
,('final.txt', 'The stock exchange predicts a bull market which would make many investors happy, but analysts warn of possibility of too much optimism and that in fact we are awaiting a bear market. As always predicting the future market is an uncertain game and all investors should follow their instincts and best practices.');

-- Regular Function 
with source_data as (
select 'bull' as word 
union all 
select 'bear' as word
union all 
select 'grow' as word
union all 
select 'The' as word)
select s.word, count(distinct f.file_name) as count  
from source_data s 
left join Files f  
on 1 = 1 
and concat(' ',f.content,' ') like concat('% ',s.word,'% ')
group by 1;

-- Regular Expression 
with source_data as (
select 'bull' as word 
union all 
select 'bear' as word
union all 
select 'grow' as word
union all 
select 'The' as word)
SELECT w.word, COUNT(distinct file_name) AS count
FROM source_data w
LEFT JOIN Files f 
ON f.content REGEXP CONCAT('\\b', w.word, '\\b')
GROUP BY w.word;

/*
The \b metacharacter typically represents a word boundary in regular expressions in many programming languages and database systems. However, the exact syntax might differ between systems, and some databases might use different methods to identify word boundaries in regular expressions.
*/ 

/* 
-- Additional data 
 ('file1.txt','bear bull bear bull bear bear bear bear bull bears bullish')
,('file_572.txt','bull bear bear bull bear bears bullish')
,('file_928.txt','bull bull bull bear bear bull bull bull bears bullish')
,('file_840.txt','bull bull bear bear bull bear bull bear bull bull bull bull bear bear bear bears bullish')
,('file_489.txt','bear bull bull bull bear bear bear bear bear bull bear bull bear bear bears bullish')
,('file_381.txt','bull bull bear bear bull bull bull bear bull bear bull bull bull bears bullish')
,('file_183.txt','bear bull bear bear bear bear bears bullish')
,('file_617.txt','bull bear bear bull bear bear bear bear bear bull bull bear bear bull bull bears bullish')
,('file_785.txt','bull bear bear bull bull bull bull bull bears bullish')
,('file_634.txt','bear bull bull bear bear bull bears bullish')
,('file_236.txt','bear bear bear bear bear bull bear bear bull bear bear bear bull bears bullish')
,('file_752.txt','bear bull bull bull bull bear bear bull bull bears bullish')
,('file_206.txt','bear bull bear bull bear bear bull bear bull bear bear bears bullish')
,('file_654.txt','bull bull bull bull bull bull bear bull bear bull bear bears bullish')
,('file_194.txt','bear bear bull bull bear bull bull bear bear bears bullish')
,('file_332.txt','bear bull bull bear bear bull bears bullish')
,('file_778.txt','bear bear bull bull bull bear bear bear bull bull bear bear bull bear bull bears bullish')
,('file_967.txt','bull bear bear bear bull bear bear bull bears bullish')
,('file_529.txt','bear bull bear bear bull bear bear bears bullish')
,('file_805.txt','bull bear bear bear bull bears bullish')
,('file_996.txt','bear bear bull bear bear bear bears bullish')
,('file_648.txt','bull bull bear bull bull bear bear bull bear bears bullish')
,('file_823.txt','bear bear bear bear bear bull bull bear bull bear bears bullish')
,('file_423.txt','bear bear bear bear bear bear bear bull bull bull bear bears bullish')
,('file_113.txt','bull bear bear bull bear bull bull bear bull bears bullish')
,('file_14.txt','bull bull bull bear bull bull bear bears bullish')
,('file_560.txt','bull bear bear bull bear bears bullish')
,('file_101.txt','bull bull bear bear bear bear bear bear bear bull bear bull bull bears bullish')
,('file_504.txt','bull bear bear bear bull bull bear bull bull bull bears bullish')
,('file_434.txt','bull bull bull bull bull bull bears bullish')
,('file_608.txt','bear bull bear bear bear bear bull bear bears bullish')
,('file_90.txt','bear bull bear bull bear bull bear bull bear bull bull bull bull bear bear bears bullish')
,('file_749.txt','bear bear bear bear bear bear bull bear bull bull bears bullish')
,('file_350.txt','bear bull bear bear bear bear bear bull bull bear bull bears bullish')
,('file_372.txt','bull bear bear bear bear bear bear bear bear bull bull bear bull bears bullish')
,('file_963.txt','bear bear bull bear bear bear bear bull bear bull bears bullish')
,('file_855.txt','bull bear bull bear bull bear bull bear bull bear bull bull bull bull bear bears bullish')
,('file_125.txt','bull bull bear bear bear bull bear bear bear bear bear bear bear bull bull bears bullish')
,('file_605.txt','bear bear bear bear bear bull bull bull bear bear bear bear bull bears bullish')
,('file_707.txt','bear bear bull bear bear bear bull bull bull bear bull bear bull bears bullish')
,('file_163.txt','bull bear bear bear bull bull bull bull bears bullish')
,('file_390.txt','bear bear bull bull bull bull bull bear bull bear bull bear bull bears bullish')
,('file_988.txt','bull bear bear bull bear bear bear bear bull bull bear bear bull bear bears bullish')
,('file_425.txt','bull bear bull bear bear bull bear bears bullish')
,('file_418.txt','bear bull bull bear bear bear bear bull bull bears bullish')
,('file_845.txt','bull bull bull bull bull bears bullish')
,('file_806.txt','bull bull bear bull bear bull bull bear bear bear bear bull bear bears bullish')
,('file_769.txt','bear bear bear bull bull bears bullish')
,('file_978.txt','bear bear bear bull bear bears bullish')
,('file_365.txt','bull bear bull bear bear bull bull bear bull bull bears bullish')
,('file_906.txt','bull bull bull bear bear bear bears bullish')
,('file_798.txt','bear bull bear bear bear bears bullish')
,('file_53.txt','bear bear bull bull bull bull bear bear bull bull bear bear bear bull bull bears bullish')
,('file_699.txt','bear bear bull bull bull bear bull bears bullish')
,('file_181.txt','bull bear bear bear bull bear bear bull bull bears bullish')
,('file_986.txt','bull bull bull bull bear bull bull bull bear bear bull bull bull bear bears bullish')
,('file_624.txt','bull bull bear bull bear bull bear bear bull bear bull bear bull bears bullish')
,('file_437.txt','bull bear bull bull bear bull bull bull bull bull bull bear bear bull bears bullish')
,('file_92.txt','bull bull bear bull bull bear bull bear bull bull bull bull bears bullish')
,('file_11.txt','bear bear bear bear bull bull bear bull bear bears bullish')
,('file_844.txt','bear bear bear bull bull bear bear bull bear bear bear bears bullish')
,('file_349.txt','bull bull bear bull bull bears bullish')
,('file_235.txt','bear bear bear bull bull bull bear bull bear bear bear bull bears bullish')
,('file_49.txt','bull bear bear bear bear bears bullish')
,('file_775.txt','bull bull bear bull bull bear bear bears bullish')
,('file_7.txt','bear bear bear bull bear bear bear bull bull bear bears bullish')
,('file_242.txt','bull bull bear bull bull bull bull bear bull bears bullish')
,('file_815.txt','bull bull bear bull bear bull bull bear bull bull bull bear bear bull bull bears bullish')
,('file_643.txt','bear bear bear bull bull bull bear bears bullish')
,('file_456.txt','bull bull bear bull bull bull bears bullish')
,('file_787.txt','bull bear bull bear bear bull bear bull bull bear bears bullish')
,('file_867.txt','bull bull bear bear bear bear bear bear bull bear bear bull bull bull bear bears bullish')
,('file_792.txt','bull bull bear bear bull bull bull bull bull bull bears bullish')
,('file_505.txt','bear bull bear bear bull bull bear bear bear bull bear bull bull bears bullish')
,('file_966.txt','bull bull bear bear bear bear bear bear bear bull bull bull bull bears bullish')
,('file_549.txt','bull bull bull bull bull bull bear bear bear bull bear bear bull bears bullish')
,('file_359.txt','bull bear bull bear bear bears bullish')
,('file_387.txt','bull bear bull bear bull bull bull bull bear bear bull bull bull bears bullish')
,('file_554.txt','bull bull bear bear bear bears bullish')
,('file_126.txt','bear bear bear bull bull bull bear bear bear bull bear bear bull bears bullish')
,('file_210.txt','bear bull bull bull bear bull bear bear bears bullish')
,('file_237.txt','bull bull bear bear bull bear bull bears bullish')
,('file_649.txt','bull bear bear bull bull bears bullish')
,('file_835.txt','bear bull bull bear bear bear bear bull bear bear bull bull bears bullish')
,('file_304.txt','bull bear bear bull bull bull bull bull bull bear bull bear bears bullish')
,('file_873.txt','bull bear bear bear bull bull bears bullish')
,('file_987.txt','bull bear bull bull bull bear bear bear bear bear bear bears bullish')
,('file_130.txt','bull bull bull bull bear bull bull bull bear bears bullish')
,('file_469.txt','bear bear bull bear bull bear bear bears bullish')
,('file_500.txt','bear bear bear bear bear bear bull bear bull bear bear bull bear bull bears bullish')
,('file_428.txt','bear bull bull bear bull bear bull bull bear bear bear bull bull bull bear bears bullish')
,('file_697.txt','bear bull bull bear bear bear bear bear bull bull bear bull bears bullish')
,('file_164.txt','bull bear bear bull bull bear bear bear bear bull bull bull bears bullish')
,('file_747.txt','bear bear bear bear bull bear bear bear bull bull bull bull bear bears bullish')
,('file_169.txt','bull bull bull bear bull bear bull bear bull bear bear bull bull bears bullish')
,('file_348.txt','bear bull bull bear bear bear bear bull bear bear bear bear bull bears bullish')
,('file_32.txt','bear bear bear bear bull bear bear bull bull bear bull bull bear bears bullish')
,('file_540.txt','bull bull bear bull bull bear bull bull bull bears bullish')
,('file_258.txt','bull bull bear bear bear bull bull bear bear bull bear bears bullish')
,('file_373.txt','bull bear bear bull bear bull bear bear bull bull bear bull bear bears bullish')
,('file_318.txt','bull bear bull bear bear bear bull bear bear bears bullish')
,('file_666.txt','bull bear bull bear bull bull bull bear bear bull bears bullish')
,('file_66.txt','bear bull bear bull bear bull bull bear bull bear bear bear bear bears bullish')
,('file_765.txt','bull bear bull bull bull bull bull bear bear bull bears bullish')
,('file_95.txt','bear bear bull bull bear bear bear bear bear bears bullish')
,('file_899.txt','bull bear bull bull bear bears bullish')
,('file_528.txt','bear bull bull bear bull bull bear bull bear bull bull bull bull bear bear bears bullish')
,('file_259.txt','bear bear bear bull bear bull bull bull bull bull bear bear bear bear bears bullish')
,('file_5.txt','bull bull bear bear bull bear bear bear bull bull bear bears bullish')
,('file_790.txt','bull bull bear bear bull bull bull bear bear bull bear bull bears bullish')
,('file_18.txt','bear bear bear bear bull bull bull bears bullish')
,('file_851.txt','bear bull bull bear bull bull bear bear bear bull bear bears bullish')
,('file_148.txt','bear bull bull bull bear bears bullish')
,('file_209.txt','bear bear bull bear bear bull bear bull bull bears bullish')
,('file_308.txt','bull bear bull bear bear bear bull bears bullish')
,('file_278.txt','bear bear bull bear bull bull bears bullish')
,('file_340.txt','bull bull bear bull bear bull bears bullish')
,('file_917.txt','bull bear bear bull bull bear bull bull bull bull bull bear bull bull bull bears bullish')
,('file_473.txt','bear bull bear bull bull bull bear bear bears bullish')
,('file_24.txt','bull bull bear bear bear bear bull bull bull bull bull bear bull bear bull bears bullish')
,('file_637.txt','bull bull bear bear bull bear bull bull bear bear bear bear bull bear bull bears bullish')
,('file_115.txt','bear bear bull bull bear bull bull bull bear bears bullish')
,('file_829.txt','bull bull bull bull bull bear bear bear bear bear bull bears bullish')
,('file_596.txt','bear bear bull bull bull bears bullish')
,('file_784.txt','bear bear bear bear bear bear bears bullish')
,('file_399.txt','bear bull bear bear bear bull bears bullish');

Expected Output
| word | count |
| ---- | ----- |
| bull | 125   |
| bear | 124   |

###### sample data 2
 ('file1.txt','bear bear bear bull bull bull bull bull bears bullish')
,('file_890.txt','bear bull bear bull bear bull bears bullish')
,('file_667.txt','bull bull bull bear bull bull bear bear bull bears bullish')
,('file_180.txt','bull bull bear bull bull bull bear bear bear bear bull bears bullish')
,('file_641.txt','bear bull bull bull bull bears bullish')
,('file_934.txt','bear bear bear bear bear bull bull bull bull bull bull bears bullish')
,('file_82.txt','bull bull bear bear bear bear bull bull bull bull bull bear bear bull bears bullish')
,('file_121.txt','bear bear bear bear bear bears bullish')
,('file_64.txt','bull bear bear bull bear bull bear bear bull bears bullish')
,('file_11.txt','bull bull bull bull bull bull bear bear bear bull bear bull bears bullish')
,('file_928.txt','bull bull bull bear bull bear bears bullish')
,('file_88.txt','bear bear bear bull bear bear bears bullish')
,('file_599.txt','bear bull bull bear bull bear bear bear bear bears bullish')
,('file_357.txt','bear bear bear bull bull bears bullish')
,('file_350.txt','bull bear bull bear bull bear bear bull bear bear bull bear bear bear bear bears bullish')
,('file_504.txt','bull bear bull bear bull bull bears bullish')
,('file_886.txt','bull bear bear bull bull bull bear bear bear bull bear bear bear bears bullish')
,('file_389.txt','bull bear bull bull bear bull bull bull bull bear bull bull bears bullish')
,('file_339.txt','bear bear bull bull bull bull bear bear bull bear bull bull bears bullish')
,('file_154.txt','bear bull bear bear bull bull bull bull bears bullish')
,('file_209.txt','bull bull bear bear bear bear bull bull bull bear bears bullish')
,('file_778.txt','bull bear bear bull bear bears bullish')
,('file_716.txt','bear bear bull bear bear bull bears bullish')
,('file_271.txt','bear bear bear bull bear bull bull bear bear bears bullish')
,('file_970.txt','bull bull bear bear bull bull bull bears bullish')
,('file_260.txt','bull bull bull bull bull bear bull bull bear bear bull bull bear bears bullish')
,('file_763.txt','bear bear bull bear bull bear bear bear bear bears bullish')
,('file_540.txt','bear bull bear bull bull bull bull bear bull bull bull bull bear bears bullish')
,('file_297.txt','bull bull bear bear bull bear bull bull bear bear bull bear bear bull bear bears bullish')
,('file_13.txt','bear bear bear bull bear bear bull bull bull bear bear bull bears bullish')
,('file_60.txt','bull bear bear bull bull bull bull bull bear bear bull bull bears bullish')
,('file_702.txt','bear bear bull bull bull bull bull bear bear bull bear bull bears bullish')
,('file_700.txt','bear bull bear bear bull bull bull bull bears bullish')
,('file_175.txt','bear bear bull bear bear bull bear bull bear bears bullish')
,('file_105.txt','bear bull bull bear bull bear bears bullish')
,('file_659.txt','bull bear bull bear bear bear bull bears bullish')
,('file_318.txt','bear bull bull bull bear bull bull bear bear bull bear bears bullish')
,('file_602.txt','bear bull bull bull bull bull bull bear bull bears bullish')
,('file_509.txt','bear bear bull bull bull bull bear bull bull bear bears bullish')
,('file_164.txt','bull bear bear bear bull bear bull bull bears bullish')
,('file_21.txt','bull bull bear bear bear bull bear bear bull bear bull bear bull bear bear bears bullish')
,('file_149.txt','bull bear bull bear bull bear bears bullish')
,('file_503.txt','bear bull bear bear bear bull bear bears bullish')
,('file_16.txt','bear bear bear bear bull bull bull bull bull bears bullish')
,('file_666.txt','bear bear bull bull bear bear bear bull bear bear bears bullish')
,('file_409.txt','bear bull bull bull bull bear bull bear bear bears bullish');

| word | count |
| ---- | ----- |
| bull | 45    |
| bear | 46    |
*/ 
