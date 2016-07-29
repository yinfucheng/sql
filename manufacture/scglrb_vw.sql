create or replace view scglrb_vw as
with r1 as
(select kq.ygqc,--用于生成车间管理日报的视图
       kq.ygrs,
       kq.rq,
       kq.bc,
       kq.bl,
       kq.bz,
       kq.djzt,
       sc.cx,
       sc.zf,
       sc.ffzl,
       sc.cfp,
       sc.xfp,
       sc.cf,
       sc.f1,
       sc.f2,
       sc.f3,
       sc.zdh,
       tz.kjsj,
       tz.tjsj,
       nvl(db.xfp, 0) + nvl(db.cf, 0) + nvl(db.cfp, 0)+NVL(DB.FP,0) fcpdbcl,
       db.cfds
  from (select rq,
               bc,
               bl,
               lrr bz,
               djzt,
               replace(wmsys.wm_concat(ygqc), ',', '/ ') ygqc,
               count(ygqc) ygrs
          from (select ygqc,
                       rq,
                       bl,
                       lrr,
                       NVL(djzt,0) DJZT,
                       case
                         when jbsjd = '16:30-20:30' then
                          '中班1'
                         when jbsjd = '20:30-24:30' then
                          '中班2'
                         when jbsjd = '00:30-08:30' then
                          '晚班'
                         when jbsjd = '08:30-16:30' then
                          '早班'
                         when jbsjd = '16:30-24:30' then
                          '中班'
                          when jbsjd = '16:00-20:00' then
                          '中班1'
                         when jbsjd = '20:00-24:00' then
                          '中班2'
                         when jbsjd = '00:00-08:00' then
                          '晚班'
                         when jbsjd = '08:00-16:00' then
                          '早班'
                         when jbsjd = '16:00-24:00' then
                          '中班'


                         when jbsjd is null then
                          bc
                       end bc
                  from cjkq_tb order by ygqc asc)
         group by rq, bc, bl, lrr,djzt) kq
--第一个left join之前的数据集 为考勤数据集
  left join

 (select cx,
         case
           when CJSCSJ_VW.bc2 in (2, 3) then
            '早班'
           when CJSCSJ_VW.bc2 in (0, 1) then
            '晚班'
           when CJSCSJ_VW.bc2 = 4 then
            '中班1'
           when CJSCSJ_VW.bc2 = 5 then
            '中班2'
         end bc,
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
         sum(CJSCSJ_VW.ZDH) as ZDH
    FROM CJSCSJ_VW
   group by rq2,
            case
              when CJSCSJ_VW.bc2 in (2, 3) then
               '早班'
              when CJSCSJ_VW.bc2 in (0, 1) then
               '晚班'
              when CJSCSJ_VW.bc2 = 4 then
               '中班1'
              when CJSCSJ_VW.bc2 = 5 then
               '中班2'
            end,
            cx
  union all
  select cx,
         '中班' bc,
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
         sum(CJSCSJ_VW.ZDH) as ZDH
    FROM CJSCSJ_VW
   where CJSCSJ_VW.bc2 in (4, 5)
   group by rq2, cx) sc on to_char(kq.rq, 'yyyymmdd') = sc.rq
                       and kq.bc = sc.bc
--第二个left join 之前的数据集为生产数据数据集，提供各种生产信息
  left join (select bt.rq, cx, bt.bc, mx.kjsj, mx.tjsj
               from cjtzbt_tb bt
               left join cjtz_tb mx on bt.id = mx.fid) tz on tz.rq = kq.rq
                                                         and tz.bc = kq.bc
                                                         and tz.cx = sc.cx
--第三个left join 之前为台帐信息主要提供时产信息
  left join (select sum(xfp) xfp, sum(cf) cf, sum(cfp) cfp,SUM(FP)FP,max(cfds)cfds ,bc, rq, 'A' cx
               from (select bt.rq,
                            decode(bt.bc,
                                   0,
                                   '早班',
                                   1,
                                   '中班1',
                                   2,
                                   '中班2',
                                   3,
                                   '晚班',
                                   4,
                                   '中班') bc,
                                   bt.cfds,
                            0.04 * mx.xfp xfp,--2016-7-26细麸皮规格改为40kg每包
                            0.035 * mx.cf cf,
                            0.04 * mx.cfp cfp,
                            0.05*MX.FP FP
                       from cjdbclbt_tb bt
                       left join CJDBCL_TB mx on bt.id = mx.fid)
              group by rq, bc) db on db.rq = kq.rq
                                 and db.bc = kq.bc
                                 and db.cx = sc.cx
--最后一个数据集用于统计车间操作工相关的副产品打包产量

)
select r1."YGQC",r1."YGRS",r1."RQ",r1."BC",r1."BL",r1."BZ",r1."DJZT",r1."CX",r1."ZF",r1."FFZL",r1."CFP",r1."XFP",r1."CF",r1."F1",r1."F2",r1."F3",r1."ZDH",r1."KJSJ",r1."TJSJ",r1."FCPDBCL", t.rjcl,r1.cfds
  from r1
  left join (select rq,
                    bc,
                    round(((nvl(sum(zf), 0) + nvl(sum(fcpdbcl), 0))+nvl(sum(cfds),0)) /
                          avg(ygrs),
                          2) rjcl
               from r1
              group by rq, bc) t on r1.rq = t.rq
                                and r1.bc = t.bc --order by r1.rq desc

