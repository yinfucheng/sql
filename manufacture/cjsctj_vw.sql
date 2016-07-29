create or replace view cjsctj_vw as
select

       CJSCSJ_VW.BC as BC,
       ---CJSCSJ_VW.DATETIME as DATETIME,
       CJSCSJ_VW.RQ2 as RQ,
       sum(CJSCSJ_VW.B1) as B1,
       sum(CJSCSJ_VW.F1) as F1,
       sum(CJSCSJ_VW.F2) as F2,
       sum(CJSCSJ_VW.F3) as F3,
       sum(CJSCSJ_VW.XFP) as XFP,
       sum(CJSCSJ_VW.CFP) as CFP,
       sum(CJSCSJ_VW.CF) as CF,
       sum(CJSCSJ_VW.ZF) as ZF,
       sum(CJSCSJ_VW.FFZL) as FFZL,
      -- round(avg(CJSCSJ_VW.ZCFL),2) as ZCFL,
       sum(CJSCSJ_VW.MJDH) as MJDH,
       sum(CJSCSJ_VW.FJDH) as FJDH,
       sum(CJSCSJ_VW.MFJDH) as MFJDH,
       sum(CJSCSJ_VW.GYJDH) as GYJDH,
       sum(CJSCSJ_VW.KYJDH) as KYJDH,
       sum(CJSCSJ_VW.ZDH) as ZDH,
       --round(avg(CJSCSJ_VW.DFDH),2) as DFDH,
       sum(CJSCSJ_VW.YXGS) as YXGS
  FROM CJSCSJ_VW
  where CJSCSJ_VW.ZF<>0
 group by rq2,bc
 --order by rq desc, decode(bc, '¼×°à', 0, 'ÒÒ°à', 1, 2)

