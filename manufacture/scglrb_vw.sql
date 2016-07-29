create or replace view scglrb_vw as
with r1 as
(select kq.ygqc,--�������ɳ�������ձ�����ͼ
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
                          '�а�1'
                         when jbsjd = '20:30-24:30' then
                          '�а�2'
                         when jbsjd = '00:30-08:30' then
                          '���'
                         when jbsjd = '08:30-16:30' then
                          '���'
                         when jbsjd = '16:30-24:30' then
                          '�а�'
                          when jbsjd = '16:00-20:00' then
                          '�а�1'
                         when jbsjd = '20:00-24:00' then
                          '�а�2'
                         when jbsjd = '00:00-08:00' then
                          '���'
                         when jbsjd = '08:00-16:00' then
                          '���'
                         when jbsjd = '16:00-24:00' then
                          '�а�'


                         when jbsjd is null then
                          bc
                       end bc
                  from cjkq_tb order by ygqc asc)
         group by rq, bc, bl, lrr,djzt) kq
--��һ��left join֮ǰ�����ݼ� Ϊ�������ݼ�
  left join

 (select cx,
         case
           when CJSCSJ_VW.bc2 in (2, 3) then
            '���'
           when CJSCSJ_VW.bc2 in (0, 1) then
            '���'
           when CJSCSJ_VW.bc2 = 4 then
            '�а�1'
           when CJSCSJ_VW.bc2 = 5 then
            '�а�2'
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
               '���'
              when CJSCSJ_VW.bc2 in (0, 1) then
               '���'
              when CJSCSJ_VW.bc2 = 4 then
               '�а�1'
              when CJSCSJ_VW.bc2 = 5 then
               '�а�2'
            end,
            cx
  union all
  select cx,
         '�а�' bc,
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
--�ڶ���left join ֮ǰ�����ݼ�Ϊ�����������ݼ����ṩ����������Ϣ
  left join (select bt.rq, cx, bt.bc, mx.kjsj, mx.tjsj
               from cjtzbt_tb bt
               left join cjtz_tb mx on bt.id = mx.fid) tz on tz.rq = kq.rq
                                                         and tz.bc = kq.bc
                                                         and tz.cx = sc.cx
--������left join ֮ǰΪ̨����Ϣ��Ҫ�ṩʱ����Ϣ
  left join (select sum(xfp) xfp, sum(cf) cf, sum(cfp) cfp,SUM(FP)FP,max(cfds)cfds ,bc, rq, 'A' cx
               from (select bt.rq,
                            decode(bt.bc,
                                   0,
                                   '���',
                                   1,
                                   '�а�1',
                                   2,
                                   '�а�2',
                                   3,
                                   '���',
                                   4,
                                   '�а�') bc,
                                   bt.cfds,
                            0.04 * mx.xfp xfp,--2016-7-26ϸ��Ƥ����Ϊ40kgÿ��
                            0.035 * mx.cf cf,
                            0.04 * mx.cfp cfp,
                            0.05*MX.FP FP
                       from cjdbclbt_tb bt
                       left join CJDBCL_TB mx on bt.id = mx.fid)
              group by rq, bc) db on db.rq = kq.rq
                                 and db.bc = kq.bc
                                 and db.cx = sc.cx
--���һ�����ݼ�����ͳ�Ƴ����������صĸ���Ʒ�������

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

